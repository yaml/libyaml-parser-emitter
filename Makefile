LIBYAML_DIR ?= libyaml
LIBYAML_REPO ?= https://github.com/yaml/libyaml
LIBYAML_BRANCH ?= master
DOCKER_NAME ?= libyaml-parser-emitter
DOCKER_USER ?= $(USER)
DOCKER_TAG ?= latest
DOCKER_IMAGE ?= $(DOCKER_USER)/$(DOCKER_NAME):$(DOCKER_TAG)

define HELP
This Makefile supports the following targets:

    build    - Build ./libyaml-parser and ./libyaml-emitter
    test     - Run tests
    docker   - Build Docker image

endef
export HELP

help:
	@echo "$$HELP"

build: libyaml-parser libyaml-emitter

libyaml-%: $(LIBYAML_DIR)/tests/.libs/run-%
	cp $< $@

$(LIBYAML_DIR)/tests/.libs/%: $(LIBYAML_DIR)/tests/%.c $(LIBYAML_DIR)/Makefile
	make -C $(LIBYAML_DIR)
	(cd $(LIBYAML_DIR) && git checkout $(<:$(LIBYAML_DIR)/%=%))

$(LIBYAML_DIR)/tests/run-%: libyaml-% $(LIBYAML_DIR)
	# cp $< $@
	cp libyaml-parser.c $(LIBYAML_DIR)/tests/run-parser.c
	cp libyaml-emitter.c $(LIBYAML_DIR)/tests/run-emitter.c

$(LIBYAML_DIR)/Makefile: $(LIBYAML_DIR)
	( cd $< && ./bootstrap && ./configure )
	touch $@

libyaml:
	git clone $(LIBYAML_REPO) $@
	rm libyaml/tests/run-parser.c libyaml/tests/run-emitter.c

.PHONY: test
test: build
	prove -lv test/

docker:
	docker build --tag $(DOCKER_IMAGE) .

push: docker
	docker push $(DOCKER_IMAGE)

shell: docker
	docker run -it --entrypoint=/bin/sh $(DOCKER_IMAGE)

clean:
	rm -fr libyaml libyaml-parser libyaml-emitter
