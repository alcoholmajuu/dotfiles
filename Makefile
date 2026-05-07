.PHONY: help apply apply-work diff diff-work status update update-work init bootstrap bootstrap-work edit edit-work add doctor

CHEZMOI := chezmoi
WORK_REPO ?=
WORK_SOURCE := $(HOME)/dotfiles-work
LINUX_BREW := $(HOME)/.linuxbrew
PERSONAL_SOURCE := $(CURDIR)
SOURCE_DIR := $(shell chezmoi source-path 2>/dev/null || echo "$(HOME)/dotfiles")

help: ## Show this help
	@rg '^[a-zA-Z_-]+: .*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

# -- Bootstrap --

bootstrap: _ensure-brew _ensure-chezmoi ## Install dotfiles from this repo
	$(CHEZMOI) init --apply --source $(PERSONAL_SOURCE)

bootstrap-work: _ensure-brew _ensure-chezmoi ## Install personal + work dotfiles (WORK_REPO=...)
ifndef WORK_REPO
	@echo "Usage: make bootstrap-work WORK_REPO=<git-url>"; exit 1
endif
	$(CHEZMOI) init --apply --source $(PERSONAL_SOURCE)
	@if [ ! -d "$(WORK_SOURCE)" ]; then \
		git clone $(WORK_REPO) $(WORK_SOURCE); \
	fi
	$(CHEZMOI) apply -v --source $(WORK_SOURCE)

# -- Apply --

apply: ## Apply personal dotfiles
	$(CHEZMOI) apply -v

apply-work: ## Apply work dotfiles (overlay)
	$(CHEZMOI) apply -v --source $(WORK_SOURCE)

# -- Diff --

diff: ## Show diff of personal dotfiles
	$(CHEZMOI) diff

diff-work: ## Show diff of work dotfiles
	$(CHEZMOI) diff --source $(WORK_SOURCE)

# -- Status --

status: ## Show status of dotfiles
	$(CHEZMOI) status

# -- Update --

update: ## Pull and apply personal dotfiles
	$(CHEZMOI) update -v

update-work: ## Pull and apply work dotfiles
	git -C $(WORK_SOURCE) pull
	$(CHEZMOI) apply -v --source $(WORK_SOURCE)

# -- Init --

init: ## chezmoi init --apply (first time setup)
	$(CHEZMOI) init --apply

# -- Edit --

edit: ## Open personal dotfiles in $$EDITOR
	$(EDITOR) $(SOURCE_DIR)

edit-work: ## Open work dotfiles in $$EDITOR
	$(EDITOR) $(WORK_SOURCE)

# -- Add --

add: ## Add file to chezmoi management (make add FILE=~/.your_file)
ifndef FILE
	@echo "Usage: make add FILE=~/.your_file"
	@exit 1
endif
	$(CHEZMOI) add $(FILE)

# -- Doctor --

doctor: ## Run chezmoi doctor
	$(CHEZMOI) doctor

# -- Ensure dependencies --

_ensure-brew:
	@bash -c '\
		set -euo pipefail; \
		OS="$$(uname -s)"; \
		if [ "$$OS" = "Darwin" ]; then \
			if ! command -v brew &>/dev/null; then \
				/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
			fi; \
			eval "$$(brew shellenv)"; \
		elif [ "$$OS" = "Linux" ]; then \
			if ! command -v git &>/dev/null || ! command -v curl &>/dev/null; then \
				sudo apt-get update && sudo apt-get install -y git curl build-essential; \
			fi; \
			BREW_PREFIX="$(LINUX_BREW)"; \
			if [ ! -x "$$BREW_PREFIX/bin/brew" ]; then \
				git clone https://github.com/Homebrew/brew "$$BREW_PREFIX/Homebrew"; \
				mkdir -p "$$BREW_PREFIX/bin"; \
				ln -sf "$$BREW_PREFIX/Homebrew/bin/brew" "$$BREW_PREFIX/bin/brew"; \
			fi; \
			eval "$$($$BREW_PREFIX/bin/brew shellenv)"; \
			brew update --quiet; \
		else \
			echo "ERROR: Unknown OS: $$OS"; exit 1; \
		fi; \
	'

_ensure-chezmoi:
	@command -v chezmoi &>/dev/null || brew install chezmoi
