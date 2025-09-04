# Ollama Proxy

Ollama Proxy is a conversion proxy that provides OpenAI-compatible endpoints for GitHub Copilot.
It transforms multiple OpenAI-compatible API endpoints into a unified Ollama API endpoint. This enables applications that natively support the Ollama API to interact with various OpenAI-compliant model services.

**Issue Background**
* Copilot has been slow to release a universal OpenAI port
* The universal OpenAI port in the Copilot beta version is completely unusable (microsoft/vscode-copilot-release#13662)
* Copilot frequently encounters issues like "no auth credentials found" and model loss, and no fix has been forthcoming ([microsoft/vscode#issue](https://github.com/microsoft/vscode/issues?q=is%3Aissue%20%22No%20auth%20credentials%20found%22))

[English](./README.EN.md), [中文](./README.md)

## Features

- **Endpoint Aggregation**: Combine multiple OpenAI model services into a single Ollama access point.
- **Dynamic Routing**: Automatically routes requests to the correct backend service based on model prefixes (e.g., `some-provider/model-name`).
- **Dynamic Configuration**: Automatically reloads the configuration file upon modification without requiring a server restart.

## Installation & Usage

1.  **Create Configuration File**:
    Copy the [config.exp.yaml](config.exp.yaml) template to `config.yaml` and customize it to define your backend API endpoints.
    
    Configuration format:
    ```yaml
    server:
      listen: localhost:11434
      mode: release # debug, test or release
      version: "1.0.0"

    endpoints:
      - id: "provider1" # This will be the prefix for models
        base_url: "https://api.example.com/v1"
        api_key: "YOUR_API_KEY"
        # model_trim: # Optional: trim prefix/suffix from model names
        #   prefix: "stable-"
        #   suffix: "stable-"
    ```

2.  **Run the Service**:
    You can run the service directly or build a binary.

    ```bash
    ./ollama-proxy [config.yaml]
    ```

3.  **Make Requests**:
    Once the proxy is running, you can interact with it through the Ollama-style interface to communicate with OpenAI APIs, solving the issue where some plugins don't provide OpenAI-compatible endpoint configuration.

    ```bash
    # List all aggregated models
    curl http://localhost:8080/v1/models

    # Send a chat completion request to a specific provider
    curl http://localhost:8080/v1/chat/completions \
      -H "Content-Type: application/json" \
      -d \
      '{
        "model": "provider1/some-model-name",
        "messages": [
          {
            "role": "user",
            "content": "Hello!"
          }
        ]
      }'
    ```

## License

This project is licensed under the [MIT License](./LICENSE).
