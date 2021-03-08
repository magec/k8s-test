UNAME=$(shell uname)
mkfile_path := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
DEPENDENCY_FILES := $(mkfile_path)/Dockerfile $(mkfile_path)/Gemfile
ifeq ($(UNAME), Linux)
  DEPENDENCY_CHECKSUM=$(shell cat $(DEPENDENCY_FILES) | md5sum | cut -f1 -d ' ')
endif

ifeq ($(UNAME), Darwin)
  DEPENDENCY_CHECKSUM=$(shell cat $(DEPENDENCY_FILES) | md5)
endif

base:
	@ if ! docker images | grep $(DEPENDENCY_CHECKSUM) |grep 'magec/cli-base' -q ; then \
		docker build -f $(mkfile_path)/Dockerfile $(mkfile_path)../.. \
		  --target cli-base \
		  --build-arg arch=$(DOCKER_ARCH) \
		  -t magec/cli-base:$(DEPENDENCY_CHECKSUM); \
	fi
	@docker tag magec/cli-base:$(DEPENDENCY_CHECKSUM) magec/cli-base:latest

build:
	@docker build -f $(mkfile_path)/Dockerfile $(mkfile_path)../.. --target cli \
	--build-arg arch=$(DOCKER_ARCH) \
	-t magec/cli:$(DEPENDENCY_CHECKSUM) \
	-t ${REPOSITORY}:latest \
	-t ${REPOSITORY}:$(DEPENDENCY_CHECKSUM)
	@[ -z ${IMAGE_TAG} ] || docker tag magec/cli:$(DEPENDENCY_CHECKSUM) ${REPOSITORY}:${IMAGE_TAG}

push:
	@[ -z ${IMAGE_TAG} ] || docker push ${REPOSITORY}:${IMAGE_TAG}
	@docker push ${REPOSITORY}:latest

.PHONY: build base push
