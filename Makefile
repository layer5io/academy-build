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

## Build site using Layer5 Cloud Staging as the baseURL
stg-build:
	 hugo --cleanDestinationDir --gc --minify --baseURL "https://staging-cloud.layer5.io/academy"

## Build site using Layer5 Cloud as the baseURL
prod-build:
	 hugo  --cleanDestinationDir --gc --minify --baseURL "https://cloud.layer5.io/academy"


## ------------------------------------------------------------
----MAINTENANCE: Show help for available targets

check-go:
	@echo "Checking if Go is installed..."
	@command -v go > /dev/null || (echo "Go is not installed. Please install it before proceeding."; exit 1)
	@echo "Go is installed."

## Update the academy-theme package to latest version
theme-update:
	echo "Updating to latest academy-theme..." && \
	hugo mod get github.com/layer5io/academy-theme


## Update a specific Hugo module to a specific version.
update-module:
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


## Publish Academy build to Layer5 Cloud.
## Copy built site from public/ to 
## ../meshery-cloud/academy directory
sync-with-cloud:
	rm -rf ../meshery-cloud/academy
	mkdir -p ../meshery-cloud/academy
	rsync -av --delete public/ ../meshery-cloud/academy/ 
	cp academy_config.json ../meshery-cloud/academy/
	@echo "Academy site synced with Layer5 Cloud." 
