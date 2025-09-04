# Ollama Proxy

Ollama Proxy 是一个转换代理，用于在GitHub copilot中提供类似OpenAI兼容的端口。
它将多个 OpenAI 兼容的 API 端点转换为一个统一的 Ollama API 端点。这使得原生支持 Ollama API 的应用程序能够与各种符合 OpenAI 标准的模型服务进行交互。

**问题背景**
* **Copilot** 迟迟不提供通用OpenAI端口
* **Copilot测试版** 中的通用OpenAI端口根本无法使用, 甚至模型列表都不能显示（microsoft/vscode-copilot-release#13662）.
* **Copilot** 经常出现`no auth credentials found`，模型丢失等问题，且迟迟不修复([microsoft/vscode#issue](https://github.com/microsoft/vscode/issues?q=is%3Aissue%20%22No%20auth%20credentials%20found%22))。

## 功能

- **端点聚合**: 将多个 OpenAI 模型服务合并到单个Ollama接入点。
- **动态路由**: 根据模型前缀（例如 `some-provider/model-name`）自动将请求路由到正确的后端服务。
- **动态配置**: 修改配置文件后可自动重新加载，无需重启服务。

## 安装与使用

1.  **创建配置文件**:
    将 [config.exp.yaml](config.exp.yaml) 模板复制为 `config.yaml` 并进行自定义，以定义您的后端 API 端点。
    
    配置格式如下：
    ```yaml
    server:
      listen: localhost:11434
      mode: release # debug、test或 release
      version: "1.0.0"

    endpoints:
      - id: "provider1" # 这将作为模型的前缀
        base_url: "https://api.example.com/v1"
        api_key: "YOUR_API_KEY"
        # model_trim: # 可选: 从模型名称中剥离前缀/后缀
        #   prefix: "stable-"
        #   suffix: "stable-"
    ```

2.  **运行服务**:
    你可以直接运行服务，或者构建一个二进制文件。

    ```bash
    ./ollama-proxy [config.yaml]
    ```

3.  **发起请求**:
    代理运行后，可以通过 Ollama 风格接口与 OpenAI API 交互，解决某些插件不提供OpenAI兼容端口配置的问题。

    ```bash
    # 列出所有聚合的模型
    curl http://localhost:8080/v1/models

    # 向特定提供商发送聊天补全请求
    curl http://localhost:8080/v1/chat/completions \
      -H "Content-Type: application/json" \
      -d \
      '{
        "model": "provider1/some-model-name",
        "messages": [
          {
            "role": "user",
            "content": "你好！"
          }
        ]
      }'
    ```

## 许可证

本项目采用 [MIT 许可证](./LICENSE)。
