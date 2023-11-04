#!/usr/bin/env bashio

bashio::log.info "Preparing to start..."

# Check if HA supervisor started
# Workaround for:
# - https://github.com/home-assistant/supervisor/issues/3884
# - https://github.com/zigbee2mqtt/hassio-zigbee2mqtt/issues/387
bashio::config.require 'data_path'

export VALETUDOPNG_DATA="$(bashio::config 'data_path')"
if ! bashio::fs.file_exists "$VALETUDOPNG_DATA/config.yaml"; then
    bashio::exit.nok "Could not find $VALETUDOPNG_DATA/config.yaml. Please ensure it exists"
fi

bashio::log.info "Starting valetudopng..."
cd /app
exec valetudo
