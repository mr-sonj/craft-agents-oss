#!/bin/bash
# Script tự động đồng bộ nhánh my với main mới nhất

set -e  # Dừng nếu có lỗi

echo "🔄 Bắt đầu đồng bộ nhánh my với main..."

# Bước 1: Chuyển sang nhánh my
echo "📍 Chuyển sang nhánh my..."
git checkout my

# Bước 2: Rebase my lên main
echo "🔀 Rebase my lên main..."
git rebase main

# Bước 3: Đẩy lên fork (force push)
echo "⬆️  Đẩy lên origin/my (force push)..."
git push -f origin my

echo "✅ Hoàn tất! Nhánh my đã được đồng bộ với main."
