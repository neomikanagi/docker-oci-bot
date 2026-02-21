FROM eclipse-temurin:21-jre-alpine

# 将程序存放在 /opt/bot 中
WORKDIR /opt/bot

# 下载并智能提取核心 jar 包
RUN apk add --no-cache curl tar && \
    echo "Fetching latest release from semicons/java_oci_manage..." && \
    # 使用 -f 参数，如果链接失效(404)会立刻报错，而不是下载一个假网页
    curl -fL -o gz_client_bot.tar.gz \
      https://github.com/semicons/java_oci_manage/releases/latest/download/gz_client_bot.tar.gz && \
    # 提取整个压缩包
    tar -xzf gz_client_bot.tar.gz && \
    # 自动在当前目录及子目录寻找 jar 包，并移动重命名为 r_client.jar
    find . -type f -name "*.jar" -exec mv {} r_client.jar \; && \
    # 清理多余文件
    rm gz_client_bot.tar.gz && \
    apk del curl tar && \
    chmod 644 r_client.jar

# 将工作目录切换到 /app
WORKDIR /app

# 启动命令
CMD ["java", "-jar", "/opt/bot/r_client.jar"]
