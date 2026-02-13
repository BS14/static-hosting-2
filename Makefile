LT_NAME  ?= fivexl-dev-web-launch-template
ASG_NAME ?= fivexl-dev-web-asg
GIT_SHA  ?= local-$(shell date +%Y%m%d-%H%M)

.PHONY: build lt-update asg-refresh clean

# 1. Build the script (Local verification)
build:
	@echo "Injecting index.html into user_data.sh..."
	@sed -e '/{{CONTENT}}/{r code/index.html' -e 'd}' code/scripts/user_data.sh > final_script.sh

lt-update: build
	@echo "Encoding to Base64 and creating JSON..."
	@ENCODED=$$(base64 -w 0 < final_script.sh); \
	echo "{\"UserData\":\"$$ENCODED\"}" > lt-data.json
	@echo "Creating new Launch Template version..."
	@NEW_VER=$$(aws ec2 create-launch-template-version \
		--launch-template-name "$(LT_NAME)" \
		--version-description "Commit: $(GIT_SHA)" \
		--source-version '$$Latest' \
		--launch-template-data file://lt-data.json \
		--query 'LaunchTemplateVersion.VersionNumber' \
		--output text) && \
	echo "SUCCESS: Created Version $$NEW_VER" && \
	echo "$$NEW_VER" > .lt_version

asg-refresh:
	@if [ ! -f .lt_version ]; then echo "Error: .lt_version file not found. Run 'make lt-update' first."; exit 1; fi
	@VERSION=$$(cat .lt_version); \
	echo "Updating ASG $(ASG_NAME) to Version $$VERSION..."; \
	aws autoscaling update-auto-scaling-group \
		--auto-scaling-group-name "$(ASG_NAME)" \
		--launch-template "LaunchTemplateName=$(LT_NAME),Version=$$VERSION"; \
	echo "Starting Instance Refresh..."; \
	aws autoscaling start-instance-refresh \
		--auto-scaling-group-name "$(ASG_NAME)"

clean:
	rm -f final_script.sh lt-data.json .lt_version
