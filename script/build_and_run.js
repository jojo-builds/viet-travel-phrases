#!/usr/bin/env node

const { spawn } = require("child_process");
const fs = require("fs");
const path = require("path");

const mode = (process.argv[2] || "build").toLowerCase();
const rootDir = path.resolve(__dirname, "..");
const nativeDir = path.join(rootDir, "native-ios");
const projectPath = path.join(nativeDir, "SpeakLocalNative.xcodeproj");
const defaultDestination =
  process.env.SPEAKLOCAL_SIM_DESTINATION || "platform=iOS Simulator,name=iPhone 17 Pro,OS=latest";

function ensureNativeProject() {
  if (!fs.existsSync(projectPath)) {
    console.error(`Missing native Xcode project: ${projectPath}`);
    process.exit(1);
  }
}

function runProcess(command, args, options = {}) {
  const child = spawn(command, args, {
    cwd: options.cwd || nativeDir,
    env: { ...process.env, ...(options.env || {}) },
    stdio: "inherit",
  });

  child.on("exit", (code, signal) => {
    if (signal) {
      process.kill(process.pid, signal);
      return;
    }
    process.exit(code ?? 0);
  });

  child.on("error", (error) => {
    console.error(`Failed to run ${command}: ${error.message}`);
    process.exit(1);
  });
}

function showUsage() {
  console.log("Usage: node script/build_and_run.js [build|test|xcodegen|doctor|help]");
  console.log("");
  console.log("  build    Build the native SwiftUI app for the default simulator");
  console.log("  test     Run the focused native test suite on the default simulator");
  console.log("  xcodegen Regenerate the native Xcode project from project.yml");
  console.log("  doctor   Print native project status and available schemes");
  console.log("  help     Show this help");
}

function xcodebuildArgs(action) {
  return [
    "-project",
    "SpeakLocalNative.xcodeproj",
    "-scheme",
    "SpeakLocalNative",
    "-destination",
    defaultDestination,
    action,
    "CODE_SIGNING_ALLOWED=NO",
  ];
}

switch (mode) {
  case "build":
  case "run": {
    ensureNativeProject();
    console.log(`Building native iOS app from ${nativeDir}`);
    console.log(`Destination: ${defaultDestination}`);
    runProcess("xcodebuild", xcodebuildArgs("build"));
    break;
  }

  case "test": {
    ensureNativeProject();
    console.log(`Testing native iOS app from ${nativeDir}`);
    console.log(`Destination: ${defaultDestination}`);
    runProcess("xcodebuild", xcodebuildArgs("test"));
    break;
  }

  case "xcodegen": {
    ensureNativeProject();
    console.log(`Regenerating native Xcode project from ${path.join(nativeDir, "project.yml")}`);
    runProcess("xcodegen", ["generate"], { cwd: nativeDir });
    break;
  }

  case "doctor": {
    ensureNativeProject();
    console.log(`Native app root: ${nativeDir}`);
    console.log(`Project: ${projectPath}`);
    runProcess("xcodebuild", ["-project", "SpeakLocalNative.xcodeproj", "-list"], {
      cwd: nativeDir,
    });
    break;
  }

  case "help":
  case "--help": {
    showUsage();
    break;
  }

  default:
    console.error(`Unknown mode: ${mode}`);
    console.error("");
    showUsage();
    process.exit(2);
}
