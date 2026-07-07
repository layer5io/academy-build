# Copyright Layer5, Inc.
#
# Licensed under the GNU Affero General Public License, Version 3.0
# (the # "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#    https://www.gnu.org/licenses/agpl-3.0.en.html
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

include .github/build/Makefile.core.mk
include .github/build/Makefile-show-help.mk

# ---------------------------------------------------------------------------
# Academy
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
	@command -v go > /dev/null || { echo "Go is not installed. Please install it before proceeding."; exit 1; }
	@echo "Go is installed."

## Update the academy-theme package to latest version
theme-update: check-go check-deps
	@echo "Updating to latest academy-theme..."
	npm run update:theme

## Update a specific Hugo module to a specific version.
update-module: check-go check-deps
	@if [ -z "$(module)" ] || [ -z "$(version)" ]; then \
		echo "Usage: make update-module module=<module-path> version=<version>"; \
		exit 1; \
	fi && \
	echo "Updating Hugo module: $(module) to version $(version)" && \
	hugo mod get $(module)@$(version)

update-org-to-module-version:
	@if [ -z "$(orgId)" ] || [ -z "$(version)" ]; then \
		echo "Usage: make update-org-to-module-mapping orgId=<org-id> version=<version>"; \
		exit 1; \
	fi && \
	jq --arg orgId "$(orgId)" --arg version "$(version)" \
	'.orgToModuleMapping[$$orgId].version = $$version' \
	academy_config.json > tmp.json && mv tmp.json academy_config.json

## ------------------------------------------------------------
----LOCAL_BUILDS: Show help for available targets

## Install site dependencies
setup:
	npm install

## Build site for local consumption
build: check-go check-deps
	npm run build:production

## Build site for local consumption
build-preview: check-go check-deps
	npm run build:preview

## Build and run site locally with draft and future content enabled.
site: check-go check-deps
	npm run site

## Build and run site locally
serve: check-go check-deps
	npm run serve

## Empty build cache and run on your local machine.
clean:
	npm run clean

## Format code using Prettier
format:
	npm run format

## Fix Markdown linting issues
lint-fix:
	npm run lint:fix

## ------------------------------------------------------------
----REMOTE_BUILDS: Show help for available targets

## Build site using Layer5 Cloud Staging as the baseURL
stg-build: check-go check-deps
	npm run _hugo -- --gc --minify --baseURL "https://staging-cloud.layer5.io/academy"

## Build site using Layer5 Cloud as the baseURL
prod-build: check-go check-deps
	npm run _hugo -- --gc --minify --baseURL "https://cloud.layer5.io/academy"

## Publish Academy build to Layer5 Cloud.
## Copy built site from public/ to 
## ../meshery-cloud/academy directory
sync-with-cloud:
	rm -rf ../meshery-cloud/academy
	mkdir -p ../meshery-cloud/academy
	rsync -av --delete public/ ../meshery-cloud/academy/ 
	cp academy_config.json ../meshery-cloud/academy/
	@echo "Academy site synced with Layer5 Cloud." 

.PHONY: \
	setup \
	build \
	build-preview \
	serve \
	site \
	clean \
	format \
	lint-fix \
	stg-build \
	prod-build \
	theme-update \
	sync-with-cloud \
	check-deps \
	check-go \
	update-module \
	update-org-to-module-version
