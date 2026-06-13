SHELL := /bin/bash

.SHELLFLAGS := -euo pipefail -c
.DELETE_ON_ERROR:
.SUFFIXES:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

TOOLS := codex copilot gemini
TOOL ?=
ZSH_FUNCTION_DIR ?= $(HOME)/.zfunc
SOURCE_FUNCTION_DIR ?= $(HOME)/.local/share/containerized-cli-tooling

help: ## Show available targets
	@awk 'BEGIN {FS = ":.*## "}; /^[a-zA-Z0-9_-]+:.*## / {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

check-tool:
	@case " $(TOOLS) " in *" $(TOOL) "*) ;; *) printf 'Set TOOL to one of: $(TOOLS)\nExample: make build TOOL=codex\n' >&2; exit 2 ;; esac

build: check-tool ## Build one image: make build TOOL=codex
	./$(TOOL)-build.sh

build-all: ## Build every supported image
	@for tool in $(TOOLS); do ./"$${tool}-build.sh"; done

install-zsh: check-tool ## Install one Zsh autoload function
	install -d "$(ZSH_FUNCTION_DIR)"
	install -m 0644 "zsh-autoload-funcs/$(TOOL)" "$(ZSH_FUNCTION_DIR)/$(TOOL)"
	@printf 'Installed %s\nAdd this to ~/.zshrc if needed:\n  fpath=("$(ZSH_FUNCTION_DIR)" $$fpath)\n  autoload -Uz $(TOOL)\n' "$(ZSH_FUNCTION_DIR)/$(TOOL)"

install-source: check-tool ## Install one sourceable Bash/Zsh function
	install -d "$(SOURCE_FUNCTION_DIR)"
	install -m 0644 "shell-functions/$(TOOL).sh" "$(SOURCE_FUNCTION_DIR)/$(TOOL).sh"
	@printf 'Installed %s\nAdd this to your shell startup file:\n  source "$(SOURCE_FUNCTION_DIR)/$(TOOL).sh"\n' "$(SOURCE_FUNCTION_DIR)/$(TOOL).sh"

.PHONY: help check-tool build build-all install-zsh install-source
