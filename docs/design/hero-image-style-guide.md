# SpeakLocal Hero Image Style Guide

Hero images are a premium product surface. They must feel like the homepage and Xin chào mastheads: realistic, atmospheric Vietnam travel photography with a soft fade into the page.

## Style Reference

Use these committed assets as the current baseline:

- `HeroVietnamMasthead`
- `HeroXinChao`
- `HeroCityHanoi`
- `HeroCityHcmc`
- `HeroCityDanang`
- `HeroCityHoian`
- `HeroCityHue`
- `HeroDragonBridge`
- `HeroBaNaHills`

The shared qualities are:

- photo-like or hyper-realistic travel scene
- natural light, mist, water, city texture, or recognizable public landmark context
- no readable generated text, logos, UI, watermarks, or fake signs
- important subject visible in the upper third because the native masthead is a shallow crop
- enough calm sky/negative space for status bar, back button, title fade, and Liquid Glass chrome

## Hard No

Do not ship these as hero mastheads:

- flat vector art
- cartoon scenes
- simple geometric or procedural shape scenes
- icon collages
- fake kindergarten-style landmarks
- abstract gradients pretending to be place imagery
- web-sourced restaurant photos or unlicensed commercial imagery

An asset is not approved just because it is app-owned. App-owned procedural artwork still fails if it does not match the premium photo-style masthead direction.

## Fallback Rule

If a specific page does not have a production-ready photo-style masthead yet:

- city-library place pages should use that city's approved realistic masthead
- compact phrase pages can use `HeroVietnamMasthead` or `HeroXinChao`
- category hubs can temporarily use the nearest premium realistic masthead while a specific owned photo-style category image is queued

This fallback is temporary, but it is preferable to shipping a flat/cartoon placeholder.

## Validation Rule

Validators should fail active hero references to retired procedural assets such as `HeroCity*Place*`, `HeroHanMarket`, `HeroLinhUngPagoda`, `HeroMarbleMountains`, `HeroMyKheBeach`, and `HeroNguyenVanLinhStreet` until those names are replaced with real photo-style assets.

Do not reintroduce a bulk procedural hero generator. New bulk generation must use an image-model/photo-style production workflow with simulator screenshot proof.
