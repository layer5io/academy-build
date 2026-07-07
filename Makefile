# Copyright Layer5, Inc.
#
# Licensed under the GNU Affero General Public License, Version 3.0
# (the # "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.gnu.org/licenses/agpl-3.0.en.html
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
@@ -13,83 +13,145 @@
# limitations under the License.

include .github/build/Makefile.core.mk
include .github/build/Makefile-show-help.mk

#----------------------------------------------------------------------------
# Academy
# ---------------------------------------------------------------------------
.PHONY: setup build stg-build prod-build theme-update sync-with-cloud site check-go update-module update-org-to-module-version

## ------------------------------------------------------------
----LOCAL_BUILDS: Show help for available targets
	
## Local: Install site dependencies
setup:
	 npm i

## Local: Build site for local consumption
build:
	hugo build

## Local: Build site for local consumption remove files from destination not found in static directories
build-clean:
	hugo build --cleanDestinationDir

## Local: Build and run site locally with draft and future content enabled.
site: check-go
	hugo server -D -F

## ------------------------------------------------------------
----REMOTE_BUILDS: Show help for available targets
# Changes to any STANDARD recipe below require a corresponding change in all other
# repositories subscribed to the 'meshery-academy' topic. Recipes under the
# "REPO-SPECIFIC" section exist only in this repo and must NOT be propagated.

## Build site using Layer5 Cloud Staging as the baseURL
stg-build:
	 hugo --cleanDestinationDir --gc --minify --baseURL "https://staging-cloud.layer5.io/academy"

## Build site using Layer5 Cloud as the baseURL
prod-build:
	 hugo  --cleanDestinationDir --gc --minify --baseURL "https://cloud.layer5.io/academy"
# htmltest is fetched and run on demand via 'go run' (no install step). Pin it for
# reproducible link checks; leave as 'latest' to always use the newest release.
HTMLTEST_VERSION ?= latest
export HTMLTEST_VERSION

# ---------------------------------------------------------------------------
# MAINTENANCE (standard)
# ---------------------------------------------------------------------------

## ------------------------------------------------------------
----MAINTENANCE: Show help for available targets
## Verify required commands and local dependencies are present.
check-deps:
	@echo "Checking if 'npm' and local 'hugo' binary are present..."
	@command -v npm > /dev/null || { echo "Error: 'npm' not found. Please install Node.js and npm."; exit 1; }
	@test -x node_modules/.bin/hugo || { echo "Error: Hugo binary not found in node_modules. Please run 'make setup' first."; exit 1; }
	@echo "Dependencies check passed."

## Validate Go is installed
check-go:
@echo "Checking if Go is installed..."
	@command -v go > /dev/null || (echo "Go is not installed. Please install it before proceeding."; exit 1)
	@command -v go > /dev/null || { echo "Go is not installed. Please install it before proceeding."; exit 1; }
@echo "Go is installed."

## Update the academy-theme package to latest version
theme-update:
	echo "Updating to latest academy-theme..." && \
	hugo mod get github.com/layer5io/academy-theme
theme-update: check-go check-deps
	@echo "Updating to latest academy-theme..."
	npm run update:theme

# ---------------------------------------------------------------------------
# LOCAL BUILDS (standard)
# ---------------------------------------------------------------------------

## Update a specific Hugo module to a specific version.
update-module:
## Install site dependencies
setup:
	npm install

## Build the site locally with draft and future content enabled.
build: check-go check-deps
	npm run build

## Build the site for a deploy preview.
build-preview: check-go check-deps
	npm run build:preview

## Build site using Layer5 Cloud as the baseURL.
build-production: check-go check-deps
	npm run build:production -- --baseURL "https://cloud.layer5.io/academy"

## Build and run the site locally with live reload (draft and future content enabled).
site: check-go check-deps
	npm run site

## Build and serve the site once with the file-watcher off (no live reload).
site-no-watch: check-go check-deps
	npm run site:no-watch

## Empty the build cache, reinstall dependencies, and run the site locally.
clean:
	npm run clean
	$(MAKE) setup
	$(MAKE) site

## Check internal links in the built site (htmltest is fetched on demand via 'go run').
check-links: check-go check-deps
	npm run check:links

## Format code using Prettier
format:
	npm run format

## Check formatting without writing changes.
format-check:
	npm run format:check

## Fix Markdown linting issues
lint-fix:
	npx --yes markdownlint-cli2 --fix "content/**/*.md"

# ===========================================================================
# REPO-SPECIFIC RECIPES
# NOT part of the shared 'meshery-academy' standard. These depend on Layer5
# Cloud infrastructure (academy_config.json, the ../meshery-cloud sibling, a
# staging URL) and exist only in this repository. Do NOT propagate them to the
# other academy repos.
# ===========================================================================

## [repo-specific] Build the site using the Layer5 Cloud Staging baseURL.
build-staging: check-go check-deps
	npm run build:production -- --baseURL "https://staging-cloud.layer5.io/academy"

## [repo-specific] Update a specific Hugo module to a specific version.
update-module: check-go
@if [ -z "$(module)" ] || [ -z "$(version)" ]; then \
echo "Usage: make update-module module=<module-path> version=<version>"; \
exit 1; \
fi && \
echo "Updating Hugo module: $(module) to version $(version)" && \
hugo mod get $(module)@$(version)

## [repo-specific] Set an org's module version in academy_config.json.
update-org-to-module-version:
@if [ -z "$(orgId)" ] || [ -z "$(version)" ]; then \
		echo "Usage: make update-org-to-module-mapping orgId=<org-id> version=<version>"; \
		echo "Usage: make update-org-to-module-version orgId=<org-id> version=<version>"; \
exit 1; \
fi && \
	echo "Setting org $(orgId) to module version $(version)" && \
jq --arg orgId "$(orgId)" --arg version "$(version)" \
'.orgToModuleMapping[$$orgId].version = $$version' \
academy_config.json > tmp.json && mv tmp.json academy_config.json


## Publish Academy build to Layer5 Cloud.
## Copy built site from public/ to 
## ../meshery-cloud/academy directory
## [repo-specific] Publish the built site to the Layer5 Cloud (../meshery-cloud/academy).
sync-with-cloud:
	@test -d ../meshery-cloud || { echo "Error: ../meshery-cloud sibling checkout not found."; exit 1; }
rm -rf ../meshery-cloud/academy
mkdir -p ../meshery-cloud/academy
	rsync -av --delete public/ ../meshery-cloud/academy/ 
	rsync -av --delete public/ ../meshery-cloud/academy/
cp academy_config.json ../meshery-cloud/academy/
	@echo "Academy site synced with Layer5 Cloud." 
	@echo "Academy site synced with Layer5 Cloud."

.PHONY: \
	setup \
	build \
	build-preview \
	build-production \
	site \
	site-no-watch \
	clean \
	check-links \
	format \
	format-check \
	lint-fix \
	check-deps \
	check-go \
	theme-update \
	build-staging \
	update-module \
	update-org-to-module-version \
	sync-with-cloud