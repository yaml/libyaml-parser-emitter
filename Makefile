LIBYAML_DIR ?= libyaml
LIBYAML_REPO ?= https://github.com/yaml/libyaml
LIBYAML_BRANCH ?= master
DOCKER_NAME ?= libyaml-parser-emitter
DOCKER_USER ?= yamlio
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

build: touch libyaml-parser libyaml-emitter

touch:
ifneq ($(LIBYAML_DIR),libyaml)
	touch *.c
endif

libyaml-%: $(LIBYAML_DIR)/tests/.libs/run-%
	cp $< $@

$(LIBYAML_DIR)/tests/.libs/%: $(LIBYAML_DIR)/tests/%.c $(LIBYAML_DIR)/Makefile
	make -C $(LIBYAML_DIR)
ifneq ($(LIBYAML_DIR),libyaml)
	(cd $(LIBYAML_DIR) && git checkout tests/run-parser.c tests/run-emitter.c)
endif

$(LIBYAML_DIR)/tests/run-%: libyaml-% $(LIBYAML_DIR)
	cp $< $@
.SECONDARY: \
	$(LIBYAML_DIR)/tests/run-parser.c \
	$(LIBYAML_DIR)/tests/run-emitter.c \
	$(LIBYAML_DIR)/tests/.libs/run-parser \
	$(LIBYAML_DIR)/tests/.libs/run-emitter

$(LIBYAML_DIR)/Makefile: $(LIBYAML_DIR)
	( cd $< && ./bootstrap && ./configure )
	touch $@

$(LIBYAML_DIR):
	git clone $(LIBYAML_REPO) $@
	sleep 1
	touch *.c

.PHONY: test
test: build
	prove -lv test/

docker:
	docker build --tag $(DOCKER_IMAGE) .

push: docker
	docker push $(DOCKER_IMAGE)

shell: docker
	docker run -it -v $$PWD:/docker --entrypoint=/bin/sh $(DOCKER_IMAGE)

clean:
	rm -fr libyaml libyaml-parser libyaml-emitter
