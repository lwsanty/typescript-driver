# This file can be used directly with Docker.
#
# Prerequisites:
#   go mod vendor
#   bblfsh-sdk release
#
# However, the preferred way is:
#   go run ./build.go driver:tag
#
# This will regenerate all necessary files before building the driver.

#==============================
# Stage 1: Native Driver Build
#==============================
FROM node:8-alpine as native

# install build dependencies
RUN npm install -g typescript


ADD native /native
WORKDIR /native

# build native driver
RUN yarn && yarn build


#================================
# Stage 1.1: Native Driver Tests
#================================
FROM native as native_test
# run native driver tests
RUN yarn test


#=================================
# Stage 2: Go Driver Server Build
#=================================
FROM golang:1.10-alpine as driver

ENV DRIVER_REPO=github.com/bblfsh/typescript-driver
ENV DRIVER_REPO_PATH=/go/src/$DRIVER_REPO

ADD go.* $DRIVER_REPO_PATH/
ADD vendor $DRIVER_REPO_PATH/vendor
ADD driver $DRIVER_REPO_PATH/driver

WORKDIR $DRIVER_REPO_PATH/

ENV GO111MODULE=on GOFLAGS=-mod=vendor

# build server binary
RUN go build -o /tmp/driver ./driver/main.go
# build tests
RUN go test -c -o /tmp/fixtures.test ./driver/fixtures/

#=======================
# Stage 3: Driver Build
#=======================
FROM node:8-alpine



LABEL maintainer="source{d}" \
      bblfsh.language="typescript"

WORKDIR /opt/driver

# copy static files from driver source directory
ADD ./native/native.sh ./bin/native


# copy build artifacts for native driver
COPY --from=native /native/lib/index.js ./bin/index.js
COPY --from=native /native/node_modules ./bin/node_modules


# copy driver server binary
COPY --from=driver /tmp/driver ./bin/

# copy tests binary
COPY --from=driver /tmp/fixtures.test ./bin/
# move stuff to make tests work
RUN ln -s /opt/driver ../build
VOLUME /opt/fixtures

# copy driver manifest and static files
ADD .manifest.release.toml ./etc/manifest.toml

ENTRYPOINT ["/opt/driver/bin/driver"]