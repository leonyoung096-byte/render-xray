FROM alpine:3.20
RUN apk add --no-cache curl unzip ca-certificates
WORKDIR /app
RUN curl -fL -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
    && unzip -o xray.zip xray geoip.dat geosite.dat \
    && chmod +x xray \
    && rm xray.zip
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
