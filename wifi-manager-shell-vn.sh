#!/bin/bash

# Show current connection
echo "📶  Mạng Wi-Fi hiện tại đang kết nối:"
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
if [ -n "$current_ssid" ]; then
    echo "🔗 Đã kết nối đến: $current_ssid"
    
    read -p "❓ Hủy kết nối khỏi mạng '$current_ssid'? [c/k]: " confirm
    if [[ "$confirm" == "c" ]]; then
        nmcli connection down "$current_ssid"
        echo "❌ Đã hủy kết nối từ mạng '$current_ssid'"
    else
        echo "✅ Mạng đã không bị ngắt do lựa chọn của người dùng '$current_ssid'"
        exit 0
    fi
else
    echo "🚫 Không có mạng không dây nào đã kết nối."
fi

# List available networks
echo "📡 Tất cả Wifi khả dụng:"
nmcli device wifi list | cat

# Prompt for reconnection
read -p "🔎 Nhập SSID để kết nối (hoặc nhấn Enter để bỏ qua): " new_ssid
if [ -n "$new_ssid" ]; then
    read -s -p "🔐 Nhập mật khẩu cho '$new_ssid': " password
    echo ""
    nmcli device wifi connect "$new_ssid" password "$password"
    
    if [ $? -eq 0 ]; then
        echo "✅  Đã kết nối thành công đến '$new_ssid'"
    else
        echo "❌ Thất bại khi kết nối đến '$new_ssid'"
    fi
fi

