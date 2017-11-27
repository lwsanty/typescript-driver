-include .sdk/Makefile

$(if $(filter true,$(sdkloaded)),,$(error You must install bblfsh-sdk))

test-native-internal:
	cd native; \
	yarn test

build-native-internal:
	cd native; \
	yarn --production=false && yarn build && \
	cp lib/index.js $(BUILD_PATH)/bin/native && \
	chmod +x $(BUILD_PATH)/bin/native
