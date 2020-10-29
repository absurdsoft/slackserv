PROJECT_NAME := "slackserv"
PKG := "github.com/absurdsoft/$(PROJECT_NAME)"
PKG_LIST := $(shell go list ${PKG}/... | grep -v /vendor/)
GO_FILES := $(shell find . -name '*.go' | grep -v /vendor/ | grep -v _test.go)

.PHONY: all dep build clean test coverage coverhtml lint

all: build

lint: ## Lint the files
	@golint -set_exit_status ${PKG_LIST}

test: ## Run unittests
	@go test -short ${PKG_LIST}

race: dep ## Run data race detector
	@go test -race -short ${PKG_LIST}

msan: dep ## Run memory sanitizer
	@go test -msan -short ${PKG_LIST}
	@go get -u golang.org/x/lint/golint

coverage: ## Generate global code coverage report
	tools/coverage.sh;

coverageshort: ## Generate global code coverage report
	tools/coverage.sh -short;

coverhtml: ## Generate global code coverage report in HTML
	tools/coverage.sh html;

dep: ## Get the dependencies
	@go get -v -d ./...

build: dep ## Build the binary file
	@go build -i -v $(PKG)

clean: ## Remove previous build
	@rm -f $(PROJECT_NAME)

vet: # Run vet on code
	@go vet $(go list ./... | grep -v /vendor/)

fmt: # Run fmt on code
	@go fmt $(go list ./... | grep -v /vendor/)

watch: # Run on save, used during dev
	@nodemon --legacy-watch . -e go --exec "make tdd"

tdd: # Runs multiple commands for tdd
	@make coverageshort
	@make lint
	@make test

help: ## Display this help screen
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

