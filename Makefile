.PHONY: build get deb

VERSION ?= 2.3.6
LOCAL_IMAGE ?= unixodbc
ARCH = amd64
DEB = unixODBC_$(VERSION)_$(ARCH).deb

default: help

build: ## build the package
	docker build . --tag $(LOCAL_IMAGE) --build-arg VERSION=$(VERSION)

# unixODBC_$(VERSION)_$(ARCH).deb: build
deb: build
deb: ## build and download the package
	docker run --rm -d --name unixodbc-tmp $(LOCAL_IMAGE) bash
	docker cp unixodbc-tmp:/opt/unixodbc/unixODBC-$(VERSION)/$(DEB) .
	docker stop unixodbc-tmp

# Check http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Print this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
