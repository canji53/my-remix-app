BUILD_DIR=${PWD}

install:
	rm -rf node_modules
	npm ci

build:
	npm run build

artifacts:
	# Production packages installed
	npm ci --omit=dev

	cp package.json $(ARTIFACTS_DIR)
	cp -r node_modules/. $(ARTIFACTS_DIR)/node_modules
	cp -r build/. $(ARTIFACTS_DIR)/build
	cp -r public/. ${ARTIFACTS_DIR}/public
	cp run.sh $(ARTIFACTS_DIR)

	cd $(ARTIFACTS_DIR) && zip -ry ${BUILD_DIR}/lambdaFunctionSrc.zip .
	rm -rf "$(ARTIFACTS_DIR)"
	mv ${BUILD_DIR}/lambdaFunctionSrc.zip "$(ARTIFACTS_DIR)"

build-RemixFunction: install build artifacts