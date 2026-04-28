#!/usr/bin/env node

const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const mode = (process.argv[2] || 'web').toLowerCase();
const rootDir = path.resolve(__dirname, '..');
const appDir = path.join(rootDir, 'app');

function commandName(base) {
  return process.platform === 'win32' ? `${base}.cmd` : base;
}

function exists(file) {
  try {
    return fs.existsSync(file);
  } catch {
    return false;
  }
}

function resolveExpoCommand() {
  if (process.env.EXPO_CLI && process.env.EXPO_CLI.trim().length > 0) {
    const tokens = process.env.EXPO_CLI.trim().split(/\s+/);
    return { command: tokens[0], args: tokens.slice(1) };
  }

  if (exists(path.join(appDir, 'pnpm-lock.yaml'))) {
    return { command: commandName('pnpm'), args: ['exec', 'expo'] };
  }

  if (exists(path.join(appDir, 'yarn.lock'))) {
    return { command: commandName('yarn'), args: ['expo'] };
  }

  if (exists(path.join(appDir, 'bun.lock')) || exists(path.join(appDir, 'bun.lockb'))) {
    return { command: commandName('bunx'), args: ['expo'] };
  }

  return { command: commandName('npx'), args: ['expo'] };
}

function resolveDoctorCommand() {
  if (exists(path.join(appDir, 'pnpm-lock.yaml'))) {
    return { command: commandName('pnpm'), args: ['exec', 'expo-doctor'] };
  }

  if (exists(path.join(appDir, 'yarn.lock'))) {
    return { command: commandName('yarn'), args: ['expo-doctor'] };
  }

  if (exists(path.join(appDir, 'bun.lock')) || exists(path.join(appDir, 'bun.lockb'))) {
    return { command: commandName('bunx'), args: ['expo-doctor'] };
  }

  return { command: commandName('npx'), args: ['expo-doctor'] };
}

function showUsage() {
  console.log('Usage: node script/build_and_run.js [run|web|doctor|help]');
  console.log('');
  console.log('  run     Start the Expo dev server');
  console.log('  web     Start the Expo web preview on port 19008');
  console.log('  doctor  Run Expo Doctor');
  console.log('  help    Show this help');
}

function quoteForCmd(value) {
  if (!/[\s"&<>|^]/.test(value)) {
    return value;
  }

  return `"${value.replace(/(["^])/g, '^$1')}"`;
}

function runProcess(command, args, extraEnv = {}) {
  const options = {
    cwd: appDir,
    env: { ...process.env, ...extraEnv },
    stdio: 'inherit',
  };

  const child =
    process.platform === 'win32'
      ? spawn('cmd.exe', ['/d', '/s', '/c', [command, ...args].map(quoteForCmd).join(' ')], options)
      : spawn(command, args, options);

  child.on('exit', (code, signal) => {
    if (signal) {
      process.kill(process.pid, signal);
      return;
    }
    process.exit(code ?? 0);
  });

  child.on('error', (error) => {
    console.error(`Failed to run ${command}: ${error.message}`);
    process.exit(1);
  });
}

switch (mode) {
  case 'run':
  case 'start': {
    const expo = resolveExpoCommand();
    console.log(`Starting Expo from ${appDir}`);
    runProcess(expo.command, [...expo.args, 'start']);
    break;
  }

  case 'web':
  case '--web':
  case 'dashboard': {
    const expo = resolveExpoCommand();
    console.log(`Starting Expo web preview from ${appDir}`);
    console.log('Local preview: http://127.0.0.1:19008');
    console.log('Dashboard preview: https://dashboard.jayopsai.com/design/viet');
    runProcess(expo.command, [...expo.args, 'start', '--web', '--port', '19008', '--clear'], {
      EXPO_PUBLIC_APP_VARIANT: process.env.EXPO_PUBLIC_APP_VARIANT || 'viet',
      BROWSER: 'none',
    });
    break;
  }

  case 'doctor':
  case '--doctor': {
    const doctor = resolveDoctorCommand();
    console.log(`Running Expo Doctor from ${appDir}`);
    runProcess(doctor.command, doctor.args);
    break;
  }

  case 'help':
  case '--help': {
    showUsage();
    break;
  }

  default:
    console.error(`Unknown mode: ${mode}`);
    console.error('');
    showUsage();
    process.exit(2);
}
