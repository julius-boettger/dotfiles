# self-hosted alternative to chatgpt with ollama + open-webui
args@{ config, lib, pkgs, ... }:
let
  frontendPort = 3210;
   backendPort = 11434; # ollama default
in
lib.mkModule "ai-chatbot" config {

  services.ollama = {
    enable = true;
    port = backendPort;
    package = pkgs.unstable.ollama;
    loadModels = [
      "deepseek-r1:8b"
          "qwen2.5:7b"
          "mistral:7b"
           "gemma3:4b"
          "qwen2.5:0.5b"
    ];
    environmentVariables = {
      # only keep last x models in ram
      OLLAMA_MAX_LOADED_MODELS = "2";
      # only keep last x conversations in ram
      OLLAMA_NUM_PARALLEL = "1";
      # dont auto-unload models
      OLLAMA_KEEP_ALIVE = "-1";
    };
  };

  services.open-webui = {
    enable = true;
    port = frontendPort;
    package = pkgs.unstable.open-webui;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:${toString backendPort}";
      TASK_MODEL = "qwen2.5:0.5b"; # model for generating chat titles, ...
      ENABLE_TAGS_GENERATION = "False";
      ENABLE_RETRIEVAL_QUERY_GENERATION = "False";
      ENABLE_SEARCH_QUERY_GENERATION = "False";
      ENABLE_AUTOCOMPLETE_GENERATION = "False";
    };
  };

  local.website.extraConfig = ''
    chat.juliusboettger.com {
      reverse_proxy :${toString frontendPort}
    }
  '';
}