# Phone Build Playbook

Use when Jojo asks to build latest on his phone.

Default target is `main`.

## Preflight

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family
git status --short --branch
git rev-parse --short HEAD
```

If Jojo asked for latest from lanes, run the merge sweep first. Do not build a stale feature lane to the phone unless explicitly asked.

## Build

```sh
cd /Users/jojolim/Developer/products/speaklocal/app-family/orchestrator
./scripts/build-phone.sh
```

The wrapper calls the local device-build skill script with `SPEAKLOCAL_REPO_ROOT` set to the repo root.

## Report

Always report:

- branch and commit installed;
- install result;
- launch result;
- if launch failed because the phone was locked;
- whether signing stayed local.

Do not paste device IDs, Team IDs, provisioning IDs, or certificate details into final answers.
