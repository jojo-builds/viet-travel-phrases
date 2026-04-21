import path from 'node:path';
import { fileURLToPath } from 'node:url';

export function resolveScriptRoots(metaUrl: string, cwd = process.cwd()) {
  const scriptDir = path.dirname(fileURLToPath(metaUrl));
  const normalizedCwd = path.resolve(cwd);

  if (path.basename(normalizedCwd).toLowerCase() === 'app') {
    return {
      scriptDir,
      appRoot: normalizedCwd,
      repoRoot: path.resolve(normalizedCwd, '..'),
    };
  }

  const appRoot = path.resolve(scriptDir, '..');
  return {
    scriptDir,
    appRoot,
    repoRoot: path.resolve(appRoot, '..'),
  };
}
