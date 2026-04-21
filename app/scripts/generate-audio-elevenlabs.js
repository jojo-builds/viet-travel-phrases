const { spawnSync } = require('node:child_process');
const path = require('node:path');

const appRoot = path.join(__dirname, '..');
const scriptPath = path.join(__dirname, 'generate-audio-elevenlabs.ts');
const result = spawnSync(process.execPath, ['--import', 'tsx', scriptPath, ...process.argv.slice(2)], {
  cwd: appRoot,
  stdio: 'inherit',
});

if (result.error) {
  throw result.error;
}

process.exitCode = typeof result.status === 'number' ? result.status : 1;
