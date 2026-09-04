#!/bin/bash
# 开启严格错误模式 make image失败脚本直接退出，CI步骤变红
set -euo pipefail

cd "$(dirname "$0")"

make image PROFILE=generic PACKAGES="$(cat packages.list)" V=s

