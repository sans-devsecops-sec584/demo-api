REGISTRY := docker.io/controlplane
NAME := demo-api
BUILD_DATE := $(shell date -u +%Y-%m-%dT%H:%M:%SZ)
GIT_SHA := $(shell git log -1 --format=%h)
GIT_TAG ?= $(shell bash -c 'TAG=$$(git tag | tail -n1); echo "$${TAG:-none}"')
GIT_MESSAGE := $(shell git -c log.showSignature=false log --max-count=1 --pretty=format:"%H")
GIT_UNTRACKED_CHANGES := $(shell git status --porcelain)
ifneq ($(GIT_UNTRACKED_CHANGES),)
    GIT_COMMIT := $(GIT_COMMIT)-dirty
    ifneq ($(GIT_TAG),dev)
        GIT_TAG := $(GIT_TAG)-dirty
    endif
endif
CONTAINER_TAG ?= $(GIT_SHA)
# TODO(ajm) should this always tag SHA and latest?
CONTAINER_TAG = latest
CONTAINER_NAME_BASE := $(REGISTRY)/$(NAME):$(CONTAINER_TAG)

export NAME REGISTRY BUILD_DATE GIT_SHA GIT_TAG GIT_MESSAGE CONTAINER_NAME CONTAINER_TAG

# ---

define build_image
	set -x;

	docker run --rm -i hadolint/hadolint < $(2) | grep --color=always '.*' || true

	docker build \
		--pull \
		--tag "$(1)" \
		--rm=true \
		--file=$(2) \
		--build-arg BASE_IMAGE_TAG="$${BASE_IMAGE_TAG}" \
		$(3)
endef

define push_image
		set -x
		docker push $(1)
endef

# ---

.PHONY: build
build: ## build demo-api image
	@echo "+ $@"
	$(call build_image,$(CONTAINER_NAME_BASE),docker/Dockerfile,.)

.PHONY: push
push: ## push demo-api image
	@echo "+ $@"
	$(call push_image,$(CONTAINER_NAME_BASE))

# ---

.PHONY: help
help: ## parse jobs and descriptions from this Makefile
	@grep -E '^[ a-zA-Z0-9_-]+:([^=]|$$)' $(MAKEFILE_LIST) \
    | grep -Ev '^help\b[[:space:]]*:' \
    | sort \
    | awk 'BEGIN {FS = ":.*?##"}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'