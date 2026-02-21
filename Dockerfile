FROM eclipse-temurin:21-jre-alpine

# 将程序存放在 /opt/bot 中（避免被后续的 /app 挂载卷覆盖）
WORKDIR /opt/bot

# 下载并提取核心 jar 包
RUN apk add --no-cache curl tar && \
    echo "Fetching latest release from semicons/java_oci_manage..." && \
    curl -L -o gz_client_bot.tar.gz \
      https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot.tar.gz && \
    tar -xzf gz_client_bot.tar.gz r_client.jar && \
    rm gz_client_bot.tar.gz && \
    apk del curl tar && \
    chmod 644 r_client.jar

# 将工作目录切换到 /app，程序启动时会默认在这里寻找 client_config
WORKDIR /app

# 启动命令（使用绝对路径调用程序）
CMD ["java", "-jar", "/opt/bot/r_client.jar"]
