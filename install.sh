#!/bin/bash

VERSION="1.0.0"
REPO="duongess/khoaichain-sdk"

echo "🔎 Checking system..."

OS="$(uname -s)"
BINARY_NAME="khoai"
INSTALL_DIR="/usr/local/bin"

case "${OS}" in
    Linux*)     
        FILE_NAME="khoai-builder-linux" 
        ;;
    Darwin*)    
        FILE_NAME="khoai-builder-darwin" 
        ;;
    CYGWIN*|MINGW*|MSYS*) 
        FILE_NAME="khoai-builder-windows.exe" 
        BINARY_NAME="khoai.exe"
        INSTALL_DIR="/usr/bin"
        ;;
    *)          
        echo "❌ Error: Unsupported OS: ${OS}"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION}/${FILE_NAME}"

echo "⬇ Downloading ${FILE_NAME}..."

ORANGE='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${ORANGE}"
echo "    __ __ __  ______  ___    ____"
echo "   / //_// / / / __ \/   |  /  _/"
echo "  / ,<  / /_/ / / / / /| |  / /  "
echo " / /| |/ __  / /_/ / ___ |_/ /   "
echo "/_/ |_/_/ /_/\____/_/  |_/___/   "
echo -e "${NC}"
echo "      🚀 KHOAI CHAIN INSTALLER      "
echo "===================================="

curl -L -o "${BINARY_NAME}" "${DOWNLOAD_URL}"

if [ $? -ne 0 ]; then
    echo "Error: Download failed. Please check your network or version."
    exit 1
fi

# Cấp quyền thực thi (Linux/Mac)
if [[ "${OS}" != *"MINGW"* ]] && [[ "${OS}" != *"CYGWIN"* ]] && [[ "${OS}" != *"MSYS"* ]]; then
    chmod +x "${BINARY_NAME}"
fi

echo "📦 Installing to ${INSTALL_DIR}..."

# Di chuyển vào thư mục hệ thống (Cần quyền sudo nếu là Linux/Mac)
if [[ -w "${INSTALL_DIR}" ]]; then
    # Nếu có quyền ghi, move luôn
    mv "${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
else
    # Nếu không có quyền (ví dụ Linux), hỏi sudo
    echo "🔑 Password required to move binary to ${INSTALL_DIR}"
    sudo mv "${BINARY_NAME}" "${INSTALL_DIR}/${BINARY_NAME}"
fi

if [ $? -eq 0 ]; then
    echo "✅ Installation successful!"
    echo "🚀 You can now run 'khoai' from anywhere."
    echo "   Try: khoai version"
else
    echo "Installation failed. Could not move file to ${INSTALL_DIR}"
    exit 1
fi