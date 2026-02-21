FROM eclipse-temurin:21-jre-alpine

# 引入 Docker Buildx 内置的架构变量
ARG TARGETARCH

# 将程序存放在 /opt/bot 中
WORKDIR /opt/bot

# 智能判断架构并下载对应的核心 jar 包
RUN apk add --no-cache curl tar && \
    echo "Current build architecture is: $TARGETARCH" && \
    if [ "$TARGETARCH" = "arm64" ]; then \
        DOWNLOAD_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot_aarch.tar.gz"; \
    else \
        DOWNLOAD_URL="https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot_x86.tar.gz"; \
    fi && \
    echo "Fetching from $DOWNLOAD_URL ..." && \
    curl -fL -o bot.tar.gz "$DOWNLOAD_URL" && \
    tar -xzf bot.tar.gz && \
    find . -type f -name "*.jar" -exec mv {} r_client.jar \; && \
    rm bot.tar.gz && \
    apk del curl tar && \
    chmod 644 r_client.jar

# 将工作目录切换到 /app
WORKDIR /app

# 启动命令
CMD ["java", "-jar", "/opt/bot/r_client.jar"]
