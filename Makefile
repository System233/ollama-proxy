# 项目名称
APP_NAME := ollama-proxy
# VERSION := $(shell git describe --tags --always --dirty)

# 构建目标平台
PLATFORMS := \
	windows-amd64 \
	windows-arm64 \
	linux-amd64 \
	linux-arm64 \
	darwin-amd64 \
	darwin-arm64

# 默认构建当前平台
build:
	go build -o $(APP_NAME)

# 构建所有平台
build-all: $(foreach platform,$(PLATFORMS),build-$(platform))

# 构建特定平台
build-%: tidy
	$(eval OS = $(word 1,$(subst -, ,$*)))
	$(eval ARCH = $(word 2,$(subst -, ,$*)))
	GOOS=$(OS) GOARCH=$(ARCH) go build -o dist/$(APP_NAME)-$(OS)-$(ARCH)$(if $(findstring windows,$(OS)),.exe,)

# 清理构建文件
clean:
	rm -rf bin
	rm -f $(APP_NAME) $(APP_NAME).exe

# 运行应用
run:
	go run main.go

# 测试
test:
	go test ./...

# 安装依赖
tidy:
	go mod tidy

.PHONY: build build-all clean run test tidy
