SHELL := /bin/bash

.SHELLFLAGS := -euo pipefail -c
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

TOOLS := codex copilot gemini rovo
TOOL ?=
ZSH_FUNCTION_DIR ?= $(HOME)/.zfunc
SOURCE_FUNCTION_DIR ?= $(HOME)/.local/share/containerized-cli-tooling

DOCKER_OPTS ?=

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-tool:
	@case " $(TOOLS) " in *" $(TOOL) "*) ;; *) printf 'Set TOOL to one of: $(TOOLS)\nExample: make build TOOL=codex\n' >&2; exit 2 ;; esac

build: check-tool ## Build one image: make build TOOL=codex
	@docker build --file "./dockerfiles/$(TOOL).Dockerfile" --tag $(TOOL)-sandbox .

build-all: ## Build every supported image
	@for tool in $(TOOLS); do \
		docker build $(DOCKER_OPTS) --file "./dockerfiles/$${tool}.Dockerfile" --tag "$${tool}-sandbox" .; \
	done

check-source-function:
	@test -f "shell-functions/ai-cli.sh" || { printf 'No sourceable shell function exists for ai-cli\n' >&2; exit 2; }

check-zsh-function:
	@test -f "zsh-autoload-funcs/ai-cli" || { printf 'No Zsh autoload function exists for ai-cli\n' >&2; exit 2; }

install-zsh: check-zsh-function ## Install the ai-cli Zsh autoload function
	install -d "$(ZSH_FUNCTION_DIR)"
	install -m 0644 "zsh-autoload-funcs/ai-cli" "$(ZSH_FUNCTION_DIR)/ai-cli"
	@printf 'Installed %s\nAdd this to ~/.zshrc if needed:\n  fpath=("$(ZSH_FUNCTION_DIR)" $$fpath)\n  autoload -Uz ai-cli\n' "$(ZSH_FUNCTION_DIR)/ai-cli"

install-source: check-source-function ## Install the sourceable ai-cli Bash/Zsh function
	install -d "$(SOURCE_FUNCTION_DIR)"
	install -m 0644 "shell-functions/ai-cli.sh" "$(SOURCE_FUNCTION_DIR)/ai-cli.sh"
	@printf 'Installed %s\nAdd this to your shell startup file:\n  source "$(SOURCE_FUNCTION_DIR)/ai-cli.sh"\n' "$(SOURCE_FUNCTION_DIR)/ai-cli.sh"

.PHONY: help check-tool check-source-function check-zsh-function build build-all install-zsh install-source
