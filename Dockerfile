FROM eclipse-temurin:21-jre-jammy

ARG TARGETARCH

WORKDIR /opt/bot

RUN apt-get update && apt-get install -y curl tar && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        DOWNLOAD_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot_aarch.tar.gz"; \
    else \
        DOWNLOAD_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot_x86.tar.gz"; \
    fi && \
    echo "Fetching from $DOWNLOAD_URL ..." && \
    curl -fL -o bot.tar.gz "$DOWNLOAD_URL" && \
    tar -xzf bot.tar.gz && \
    rm bot.tar.gz && \
    chmod +x r_client && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

CMD ["/opt/bot/r_client", "--configPath=/app/client_config"]
