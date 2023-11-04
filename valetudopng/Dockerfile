# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM as base

RUN apk add --no-cache tini

#############
FROM base as build
ARG VALETUDOPNG_VERSION BUILD_ARCH
RUN set -eux \
    && apk add --no-cache wget \
    && mkdir -p /app/bin \
    && case "${BUILD_ARCH}" in \
        aarch64) \
            VALETUDO_ARCH="arm64" \
            ;; \
        amd64) \
            VALETUDO_ARCH="amd64" \
            ;; \
        armv7) \
            VALETUDO_ARCH="armv7" \
            ;; \
        *) \
            echo "Unsupported build architecture: ${BUILD_ARCH}" >&2 \
            exit 1 \
            ;; \
    esac \
    && wget -O "/tmp/valetudopng.tar.gz" "https://github.com/erkexzcx/valetudopng/releases/download/v${VALETUDOPNG_VERSION}/valetudopng_v${VALETUDOPNG_VERSION}_linux_${VALETUDO_ARCH}.tar.gz" \
    && tar -xvzf "/tmp/valetudopng.tar.gz" -C "/app/bin"

#############

FROM base as release

WORKDIR /app
COPY rootfs /
COPY --from=build /app/bin ./bin

ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh"]
