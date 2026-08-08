.DEFAULT_GOAL := show-help
# See <https://gist.github.com/klmr/575726c7e05d8780505a> for explanation.
# Modified to support multi-line comments and preserve target order
.PHONY: show-help
show-help:
	@echo "$$(tput bold)Please specify a build target. The choices are:$$(tput sgr0)";echo; \
	awk ' \
	/^##/ { \
		gsub(/^## ?/, ""); \
		if (buffer == "") buffer = $$0; \
		else buffer = buffer " " $$0; \
		next; \
	} \
	/^[a-zA-Z_-]+:/ && $$0 !~ /:=/ && $$0 !~ /^\\./ { \
		split($$0, parts, ":"); \
		target = parts[1]; \
		if (target != "" && target !~ /^\./ && !(target in seen)) { \
			if (buffer != "") { \
				targets[++count] = target; \
				comments[target] = buffer; \
				seen[target] = 1; \
			} \
			buffer = ""; \
		} \
	} \
	!/^##/ && !/^[a-zA-Z_-]+:/ { \
		buffer = ""; \
	} \
	END { \
		for (i = 1; i <= count; i++) { \
			target = targets[i]; \
			comment = comments[target]; \
			printf "\033[36m%-19s\033[0m %s\n", target, comment; \
		} \
	}' ${MAKEFILE_LIST}
