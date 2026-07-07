#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const expected = {
  productID: "app.speaklocal.vietnam.subscription.monthly",
  recurringSubscriptionPeriod: "P1M",
  displayPrice: "4.99",
  introductoryPaymentMode: "free",
  introductorySubscriptionPeriod: "P1W",
};

const repoRoot = path.resolve(__dirname, "../..");
const defaultConfigPath = path.join(
  repoRoot,
  "native-ios",
  "Config",
  "StoreKit",
  "SpeakLocalPaywall.storekit",
);
const configPath = path.resolve(process.argv[2] || defaultConfigPath);

function readConfig(filePath) {
  try {
    return JSON.parse(fs.readFileSync(filePath, "utf8"));
  } catch (error) {
    throw new Error(`could not read StoreKit config at ${filePath}: ${error.message}`);
  }
}

function findSubscription(config, productID) {
  for (const group of config.subscriptionGroups || []) {
    for (const subscription of group.subscriptions || []) {
      if (subscription.productID === productID) {
        return { group, subscription };
      }
    }
  }
  return null;
}

function validate(config) {
  const failures = [];
  const match = findSubscription(config, expected.productID);

  if (!match) {
    failures.push(`expected productID=${expected.productID}`);
    return failures;
  }

  const { group, subscription } = match;
  const intro = subscription.introductoryOffer || {};

  if (!group.name) {
    failures.push("expected subscription group name");
  }
  if (subscription.recurringSubscriptionPeriod !== expected.recurringSubscriptionPeriod) {
    failures.push(`expected recurringSubscriptionPeriod=${expected.recurringSubscriptionPeriod}`);
  }
  if (subscription.displayPrice !== expected.displayPrice) {
    failures.push(`expected displayPrice=${expected.displayPrice}`);
  }
  if (intro.paymentMode !== expected.introductoryPaymentMode) {
    failures.push(`expected introductoryOffer.paymentMode=${expected.introductoryPaymentMode}`);
  }
  if (intro.subscriptionPeriod !== expected.introductorySubscriptionPeriod) {
    failures.push(`expected introductoryOffer.subscriptionPeriod=${expected.introductorySubscriptionPeriod}`);
  }

  return failures;
}

const config = readConfig(configPath);
const failures = validate(config);

if (failures.length > 0) {
  console.error("Paywall StoreKit config failed:");
  for (const failure of failures) {
    console.error(`- ${failure}`);
  }
  process.exit(1);
}

console.log(
  [
    "Paywall StoreKit config passed:",
    expected.productID,
    expected.recurringSubscriptionPeriod,
    expected.displayPrice,
    expected.introductoryPaymentMode,
    expected.introductorySubscriptionPeriod,
  ].join(" "),
);
