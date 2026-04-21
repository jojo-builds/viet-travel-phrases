import fs from 'node:fs';
import path from 'node:path';
import { chromium } from 'playwright';

type CaptureSurface = 'device' | 'page';

type CaptureOptions = {
  app: string;
  route: string;
  device: string;
  dashboardUrl: string;
  outputPath?: string;
  surface: CaptureSurface;
  waitMs: number;
  authToken?: string;
};

function readFlag(name: string) {
  const flag = `--${name}`;
  const index = process.argv.indexOf(flag);
  if (index === -1) {
    return undefined;
  }

  return process.argv[index + 1];
}

function hasFlag(name: string) {
  return process.argv.includes(`--${name}`);
}

function normalizeRoute(route?: string) {
  const trimmed = (route ?? '/').trim();
  if (!trimmed) {
    return '/';
  }

  return trimmed.startsWith('/') ? trimmed : `/${trimmed}`;
}

function slugifyRoute(route: string) {
  return route
    .replace(/^\//, '')
    .replace(/[^a-zA-Z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '') || 'home';
}

function resolveBrowserExecutable() {
  const candidates = [
    process.env.PLAYWRIGHT_CHROME_PATH,
    'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Program Files\\Microsoft\\Edge\\Application\\msedge.exe',
    'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe',
  ].filter(Boolean) as string[];

  return candidates.find((candidate) => fs.existsSync(candidate));
}

function buildOutputPath(route: string, device: string) {
  const timestamp = new Date().toISOString().replace(/[:.]/g, '-');
  const capturesDir = path.join(process.cwd(), 'artifacts', 'design-captures');
  const filename = `${timestamp}-${slugifyRoute(route)}-${device}.png`;
  return path.join(capturesDir, filename);
}

function resolveOptions(): CaptureOptions {
  const route = normalizeRoute(readFlag('route') ?? process.env.DESIGN_CAPTURE_ROUTE ?? '/');
  const surfaceFlag = readFlag('surface') ?? process.env.DESIGN_CAPTURE_SURFACE ?? 'device';
  const surface: CaptureSurface = surfaceFlag === 'page' ? 'page' : 'device';

  return {
    app: readFlag('app') ?? process.env.DESIGN_CAPTURE_APP ?? 'viet',
    route,
    device: readFlag('device') ?? process.env.DESIGN_CAPTURE_DEVICE ?? 'iphone-15-pro',
    dashboardUrl: readFlag('dashboard-url') ?? process.env.DESIGN_CAPTURE_DASHBOARD_URL ?? 'https://dashboard.jayopsai.com',
    outputPath: readFlag('out'),
    surface,
    waitMs: Number(readFlag('wait-ms') ?? process.env.DESIGN_CAPTURE_WAIT_MS ?? 1200),
    authToken: readFlag('token') ?? process.env.DASHBOARD_AUTH_TOKEN ?? process.env.OPENCLAW_AUTH_TOKEN,
  };
}

async function main() {
  const options = resolveOptions();
  const captureUrl = new URL(`/design/${options.app}`, options.dashboardUrl);
  captureUrl.searchParams.set('route', options.route);
  captureUrl.searchParams.set('device', options.device);
  if (options.authToken) {
    captureUrl.searchParams.set('token', options.authToken);
  }

  const executablePath = resolveBrowserExecutable();
  if (!executablePath) {
    throw new Error(
      'No local Chrome or Edge executable was found. Set PLAYWRIGHT_CHROME_PATH to a browser executable path.',
    );
  }

  const outputPath = path.resolve(options.outputPath ?? buildOutputPath(options.route, options.device));
  fs.mkdirSync(path.dirname(outputPath), { recursive: true });
  const reportedUrl = new URL(captureUrl.toString());
  reportedUrl.searchParams.delete('token');

  const browser = await chromium.launch({
    executablePath,
    headless: !hasFlag('headed'),
  });

  try {
    const context = await browser.newContext({
      viewport: { width: 1600, height: 1400 },
      deviceScaleFactor: 1,
    });
    const page = await context.newPage();

    await page.goto(captureUrl.toString(), {
      waitUntil: 'domcontentloaded',
      timeout: 45000,
    });

    if (page.url().includes('/login')) {
      throw new Error(
        'Dashboard authentication failed. Pass --token <dashboard token> or set DASHBOARD_AUTH_TOKEN.',
      );
    }

    await page.waitForSelector('#device-frame', { state: 'visible', timeout: 30000 });
    await page.waitForFunction(
      () => {
        const status = document.getElementById('load-status')?.textContent?.toLowerCase() ?? '';
        return status.includes('loaded');
      },
      undefined,
      { timeout: 30000 },
    );

    const previewFrameHandle = await page.waitForSelector('#preview-frame', { state: 'attached', timeout: 30000 });
    const previewFrame = await previewFrameHandle.contentFrame();
    if (previewFrame) {
      await previewFrame.waitForLoadState('domcontentloaded', { timeout: 30000 }).catch(() => undefined);
    }

    if (options.waitMs > 0) {
      await page.waitForTimeout(options.waitMs);
    }

    if (options.surface === 'page') {
      await page.screenshot({
        path: outputPath,
        fullPage: true,
      });
    } else {
      await page.locator('#device-frame').screenshot({
        path: outputPath,
      });
    }

    console.log(
      JSON.stringify(
        {
          ok: true,
          outputPath,
          surface: options.surface,
          url: reportedUrl.toString(),
        },
        null,
        2,
      ),
    );
  } finally {
    await browser.close();
  }
}

void main().catch((error: unknown) => {
  const message = error instanceof Error ? error.message : String(error);
  console.error(message);
  process.exitCode = 1;
});
