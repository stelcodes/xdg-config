#!/usr/bin/env bash

sudo openvpn --config "$@" --auth-user-pass /secrets/protonvpn
