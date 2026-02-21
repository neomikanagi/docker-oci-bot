FROM eclipse-temurin:21-jre-jammy

# 获取构建架构
ARG TARGETARCH

# 将核心程序存放在 /opt/bot 中
WORKDIR /opt/bot

# 下载并提取可执行文件
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
    # 赋予二进制文件执行权限（作者的文件名就叫 r_client，没有后缀）
    chmod +x r_client && \
    # 清理垃圾减小镜像体积
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 将工作目录切换到 /app（用于挂载配置）
WORKDIR /app

# 直接启动二进制文件，并指定配置文件路径为挂载的目录
CMD ["/opt/bot/r_client", "--configPath=/app/client_config"]
