# Copyright Layer5, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include .github/build/Makefile.core.mk
include .github/build/Makefile.show-help.mk

# ---------------------------------------------------------------------------
# SHARED TEMPLATE — PROPAGATE CHANGES
#
# Any change to a STANDARD recipe below must be mirrored in the corresponding
# Makefile of each repository listed here:
#
#   - https://github.com/layer5io/docs
#   - https://github.com/meshery/meshery/tree/master/docs
#   - https://github.com/topics/meshery-academy
#
# Target names, prerequisites, and the npm scripts they call form the shared
# contract; keep them identical across repositories. Recipes under the
# "REPO-SPECIFIC" section exist only in this repo and must NOT be propagated.
#
# MAIN TARGETS
#
#   setup              Install site dependencies (npm install).
#   build              Build locally with draft, future, and expired content.
#   build-preview      Build for a deploy preview (uses DEPLOY_PRIME_URL).
#   build-production   Build for production using the Layer5 Cloud baseURL.
#   site               Serve locally with live reload.
#   serve              Serve locally once, file watcher off (no live reload).
#   clean              Empty the build cache, reinstall dependencies, run 'site'.
#   lint / lint-fix    Check or auto-fix Markdown linting issues.
#   check-links        Check internal links in the built site.
#   check-deps         Verify required commands and local dependencies.
#   check-go           Verify Go is installed (required by Hugo Modules).
#
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# MAINTENANCE (standard)
# ---------------------------------------------------------------------------

## Verify required commands and local dependencies are present.
check-deps:
	@echo "Checking if 'npm' and local 'hugo' binary are present..."
	@command -v npm > /dev/null || { echo "Error: 'npm' not found. Please install Node.js and npm."; exit 1; }
	@test -x node_modules/.bin/hugo || { echo "Error: Hugo binary not found in node_modules. Please run 'make setup' first."; exit 1; }
	@echo "Dependencies check passed."

## Validate Go is installed
check-go:
	@echo "Checking if Go is installed..."
	@command -v go > /dev/null || { echo "Go is not installed. Please install it before proceeding."; exit 1; }
	@echo "Go is installed."

## Check internal links in the built site.
check-links: check-go check-deps
	npm run check:links

## Check Markdown for linting issues.
lint: check-deps
	npm run lint

## Fix Markdown linting issues.
lint-fix: check-deps
	npm run lint:fix

## Update the academy-theme package to latest version
theme-update: check-go check-deps
	@echo "Updating to latest academy-theme..."
	npm run theme:update

# ---------------------------------------------------------------------------
# LOCAL BUILDS (standard)
# ---------------------------------------------------------------------------

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
serve: check-go check-deps
	npm run serve

## Empty the build cache, reinstall dependencies, and run the site locally.
clean:
	npm run clean
	$(MAKE) setup
	$(MAKE) site

# ===========================================================================
# REPO-SPECIFIC RECIPES
# NOT part of the shared 'meshery-academy' standard. These depend on Layer5
# Cloud infrastructure (academy_config.json, the ../meshery-cloud sibling, a
# staging URL) and exist only in this repository. Do NOT propagate them to the
# other academy repos.
# ===========================================================================

## Build the site using the Layer5 Cloud Staging baseURL.
build-staging: check-go check-deps
	npm run build:production -- --baseURL "https://staging-cloud.layer5.io/academy"

## Update a specific Hugo module to a specific version.
update-module: check-go check-deps
	@if [ -z "$(module)" ] || [ -z "$(version)" ]; then \
		echo "Usage: make update-module module=<module-path> version=<version>"; \
		exit 1; \
	fi && \
	echo "Updating Hugo module: $(module) to version $(version)" && \
	npm run update:module -- $(module)@$(version)

## [Set an org's module version in academy_config.json.
update-org-to-module-version:
	@if [ -z "$(orgId)" ] || [ -z "$(version)" ]; then \
		echo "Usage: make update-org-to-module-version orgId=<org-id> version=<version>"; \
		exit 1; \
	fi && \
	echo "Setting org $(orgId) to module version $(version)" && \
	jq --arg orgId "$(orgId)" --arg version "$(version)" \
	'.orgToModuleMapping[$$orgId].version = $$version' \
	academy_config.json > tmp.json && mv tmp.json academy_config.json

## Publish the built site to the Layer5 Cloud (../meshery-cloud/academy).
sync-with-cloud:
	@test -d ../meshery-cloud || { echo "Error: ../meshery-cloud sibling checkout not found."; exit 1; }
	rm -rf ../meshery-cloud/academy
	mkdir -p ../meshery-cloud/academy
	rsync -av --delete public/ ../meshery-cloud/academy/
	cp academy_config.json ../meshery-cloud/academy/
	@echo "Academy site synced with Layer5 Cloud."

.PHONY: \
	setup \
	build \
	build-preview \
	build-production \
	site \
	serve \
	clean \
	check-links \
	lint \
	lint-fix \
	check-deps \
	check-go \
	theme-update \
	build-staging \
	update-module \
	update-org-to-module-version \
	sync-with-cloud