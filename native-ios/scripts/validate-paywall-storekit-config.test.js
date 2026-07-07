#!/usr/bin/env node

const assert = require("assert");
const fs = require("fs");
const os = require("os");
const path = require("path");
const { spawnSync } = require("child_process");
const test = require("node:test");

const scriptPath = path.join(__dirname, "validate-paywall-storekit-config.js");

function writeConfig(root, overrides = {}) {
  const config = {
    subscriptionGroups: [
      {
        name: "SpeakLocal Vietnam",
        subscriptions: [
          {
            productID: "app.speaklocal.vietnam.subscription.monthly",
            displayPrice: "4.99",
            recurringSubscriptionPeriod: "P1M",
            referenceName: "SpeakLocal Vietnam Monthly",
            introductoryOffer: {
              displayPrice: "0.00",
              paymentMode: "free",
              subscriptionPeriod: "P1W",
            },
            ...overrides,
          },
        ],
      },
    ],
  };
  const configPath = path.join(root, "SpeakLocalPaywall.storekit");
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2));
  return configPath;
}

test("paywall StoreKit validator accepts the launch monthly trial config", () => {
  const fixtureRoot = fs.mkdtempSync(path.join(os.tmpdir(), "speaklocal-paywall-storekit-"));
  const configPath = writeConfig(fixtureRoot);

  const result = spawnSync(process.execPath, [scriptPath, configPath], {
    cwd: path.resolve(__dirname, "../.."),
    encoding: "utf8",
  });

  assert.strictEqual(result.status, 0, result.stderr || result.stdout);
  assert.match(result.stdout, /Paywall StoreKit config passed/);
  assert.match(result.stdout, /app\.speaklocal\.vietnam\.subscription\.monthly/);
  assert.match(result.stdout, /P1W/);
});

test("paywall StoreKit validator rejects a missing one-week free trial", () => {
  const fixtureRoot = fs.mkdtempSync(path.join(os.tmpdir(), "speaklocal-paywall-storekit-"));
  const configPath = writeConfig(fixtureRoot, { introductoryOffer: undefined });

  const result = spawnSync(process.execPath, [scriptPath, configPath], {
    cwd: path.resolve(__dirname, "../.."),
    encoding: "utf8",
  });

  assert.notStrictEqual(result.status, 0, result.stdout);
  assert.match(result.stderr, /expected introductoryOffer\.paymentMode=free/);
  assert.match(result.stderr, /expected introductoryOffer\.subscriptionPeriod=P1W/);
});
