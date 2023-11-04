# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM as base

RUN apk add --no-cache tini

#############
FROM base as build
ARG VALETUDOPNG_VERSION BUILD_ARCH
RUN set -eux \
    && apk add --no-cache wget \
    && mkdir -p /app \
    && case "${BUILD_ARCH}" in \
        aarch64) \
            VALETUDOPNG_FILENAME="valetudopng_v${VALETUDOPNG_VERSION}_linux_arm64" \
            ;; \
        amd64) \
            VALETUDOPNG_FILENAME="valetudopng_v${VALETUDOPNG_VERSION}_linux_amd64" \
            ;; \
        armv7) \
            VALETUDOPNG_FILENAME="valetudopng_v${VALETUDOPNG_VERSION}_linux_armv7" \
            ;; \
        *) \
            echo "Unsupported build architecture: ${BUILD_ARCH}" >&2 \
            exit 1 \
            ;; \
    esac \
    && wget "https://github.com/erkexzcx/valetudopng/releases/download/v${VALETUDOPNG_VERSION}/${VALETUDOPNG_FILENAME}.tar.gz" \
    && tar -xvzf "${VALETUDOPNG_FILENAME}.tar.gz" \
    && mv "${VALETUDOPNG_FILENAME}" /app/valetudopng

#############

FROM base as release

COPY rootfs /
COPY --from=build /app ./app
RUN chmod +x /docker_entrypoint.sh

ENTRYPOINT [ "/sbin/tini", "--", "/docker_entrypoint.sh"]
