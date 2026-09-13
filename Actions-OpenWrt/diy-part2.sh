#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
#sed -i 's/192.168.1.1/192.168.50.5/g' package/base-files/files/bin/config_generate

# Modify default theme
#sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# Modify hostname
#sed -i 's/OpenWrt/P3TERX-Router/g' package/base-files/files/bin/config_generate

# Force disable Passwall2 Rust dependencies to prevent build failure
sed -i 's/default y if aarch64||x86_64/default n/g' feeds/passwall2/luci-app-passwall2/Makefile
sed -i 's/default y if aarch64||arm||i386||x86_64/default n/g' feeds/passwall2/luci-app-passwall2/Makefile

# Disable Rust CI LLVM download to fix build failures
# This prevents Rust from trying to download unavailable CI artifacts
if [ -d "feeds/packages/lang/rust" ]; then
  echo "Configuring Rust to disable CI LLVM download..."
  sed -i 's/download-ci-llvm = true/download-ci-llvm = false/g' feeds/packages/lang/rust/Makefile 2>/dev/null || true
  # Also try config.toml if it exists
  if [ -f "feeds/packages/lang/rust/config.toml" ]; then
    sed -i 's/download-ci-llvm = true/download-ci-llvm = false/g' feeds/packages/lang/rust/config.toml
  fi
  echo "✅ Rust CI LLVM download disabled"
fi
