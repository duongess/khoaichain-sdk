#!/bin/bash

# --- CẤU HÌNH ---
VERSION="1.0.0"
REPO="duongess/khoaichain-sdk"
BINARY_NAME="khoai"
INSTALL_DIR="/usr/local/bin"
# ----------------

# Màu sắc cho đẹp
ORANGE='\033[0;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${ORANGE}"
echo "    __ __ __  ______  ___    ____"
echo "   / //_// / / / __ \/   |  /   /"
echo "  / ,<  / /_/ / / / / /| |  / /  "
echo " / /| |/ __  / /_/ / ___ |_/ /   "
echo "/_/ |_/_/ /_/\____/_/  |_/___/   "
echo -e "${NC}"
echo "      🚀 KHOAI CHAIN INSTALLER      "
echo "===================================="

echo "🔎 Checking system..."

OS="$(uname -s)"

case "${OS}" in
    Linux*)     
        FILE_NAME="khoai-builder-linux" 
        ;;
    Darwin*)    
        FILE_NAME="khoai-builder-darwin" 
        ;;
    CYGWIN*|MINGW*|MSYS*) 
        echo -e "${RED}❌ Error: This script is for Linux/macOS.${NC}"
        echo "👉 For Windows, please run the PowerShell command instead."
        exit 1
        ;;
    *)          
        echo -e "${RED}❌ Error: Unsupported OS: ${OS}${NC}"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILE_NAME}"

echo "⬇ Downloading ${FILE_NAME}..."
curl -L -o "${BINARY_NAME}" "${DOWNLOAD_URL}"

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ Error: Download failed.${NC}"
    exit 1
fi

chmod +x "${BINARY_NAME}"

echo "📦 Installing to ${INSTALL_DIR}..."

# Kiểm tra quyền ghi vào /usr/local/bin
if [ -w "${INSTALL_DIR}" ]; then
    mv "${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
    echo "🔑 Password required to move binary to ${INSTALL_DIR}"
    sudo mv "${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Installation successful!${NC}"
    echo "🚀 You can now run 'khoai' from anywhere."
    echo "   Try: khoai version"
else
    echo -e "${RED}❌ Installation failed.${NC}"
    exit 1
fi