#!/usr/bin/env node

const { applyRepairs } = require("./lib/apply-viet-premium-batch");

const repairs = [
  {
    id: "viet-how-are-you-em",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/how-are-you-em.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/small-talk/how-are-you-em.json",
    summary: "For checking in with someone younger when the moment is friendly enough for a small personal question.",
    bodies: {
      "at-glance": "A gentle Em khỏe không? fits after a greeting, not as the first words at a rushed counter.",
      "standard-way": "Use em only when the person is clearly younger than you or the relationship already feels informal and kind.",
      breakdown: "Em names the younger person; khỏe asks about being well; không? turns it into a soft check-in.",
      "relationship-forms": "Move to bạn, anh, or chị when the age relationship is unclear or the person is older.",
      "when-to-use": "Best with a younger server you have already greeted, a homestay host's child, a guide, or someone helping in a relaxed moment.",
      "good-to-know": "This can feel warm in the right relationship. If you are unsure, Chào bạn or Cảm ơn is safer.",
      "explore-next": "Younger-person hello, friendly hello, and thank-you cards keep the conversation polite if the check-in lands well."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Em", english: "younger person", keepTogetherReason: "relationship pronoun" },
      { id: "chunk-2", vietnamese: "khỏe", english: "well / healthy", keepTogetherReason: "wellness word" },
      { id: "chunk-3", vietnamese: "không?", english: "yes or no?", keepTogetherReason: "soft question ending" }
    ],
    value: "replaces repeated greeting scaffold with relationship-aware advice while preserving relationship-form and explore-next cards"
  },
  {
    id: "viet-how-are-you-anh",
    source: "content-draft/viet/canonical-pages/catalog-promoted/social-small-talk/how-are-you-anh.json",
    audit: "content-draft/viet/breakdown-audit/pages/catalog-promoted/small-talk/how-are-you-anh.json",
    summary: "For a friendly check-in with an older man after the greeting has already opened the exchange.",
    bodies: {
      "at-glance": "Anh khỏe không? works when the tone is already warm and the man is clearly older than you.",
      "standard-way": "Say it after Dạ, chào anh or Chào anh, then pause for the short answer before adding a request.",
      breakdown: "Anh names an older man; khỏe asks about being well; không? makes it a gentle yes-or-no question.",
      "relationship-forms": "Switch to chị, em, or bạn when the person in front of you is not an older man.",
      "when-to-use": "Good with a host, guide, driver, shop owner, or familiar helper when the exchange has room for warmth.",
      "good-to-know": "This is friendlier than a transaction phrase. Skip it if the line is moving fast or you need help immediately.",
      "explore-next": "Respectful hello, plain hello, and thank-you cards sit nearby for the same polite first-contact moment."
    },
    breakdown: [
      { id: "chunk-1", vietnamese: "Anh", english: "older man", keepTogetherReason: "relationship pronoun" },
      { id: "chunk-2", vietnamese: "khỏe", english: "well / healthy", keepTogetherReason: "wellness word" },
      { id: "chunk-3", vietnamese: "không?", english: "yes or no?", keepTogetherReason: "soft question ending" }
    ],
    value: "replaces repeated small-talk scaffold with specific relationship guidance while preserving all related phrase cards"
  }
];

console.log(JSON.stringify(applyRepairs("46", repairs), null, 2));
