# TypeScript driver for [Babelfish](https://github.com/bblfsh/bblfshd) ![Driver Status](https://img.shields.io/badge/status-alpha-db975c.svg) [![Build Status](https://travis-ci.org/bblfsh/typescript-driver.svg?branch=master)](https://travis-ci.org/bblfsh/typescript-driver) ![Native Version](https://img.shields.io/badge/typescript%20version-2.2.1-aa93ea.svg) ![Go Version](https://img.shields.io/badge/go%20version-1.12-63afbf.svg)

typescript driver for [babelfish](https://github.com/bblfsh/server).


Development Environment
-----------------------

Requirements:
- `docker`
- Go 1.12+

To initialize the build system execute: `go test ./driver`, at the root of the project. This will generate the `Dockerfile` for this driver.

To run the tests just execute `go run test.go`, this will start the test over the native and the Go components of the driver using Docker.

The build is done executing `go run build.go`. To evaluate the result using a docker container, execute:
`go run build.go test-driver && docker run -it test-driver`.

If the project is located under `$GOPATH`, run all the above with `GO111MODULE=on` environment variable,
or move the project to any other directory outside of `$GOPATH`.

License
-------

GPLv3, see [LICENSE](LICENSE)



