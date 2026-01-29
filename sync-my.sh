#!/bin/bash
# Script tự động đồng bộ nhánh my với main mới nhất

set -e  # Exit on error

echo "🔄 Bắt đầu đồng bộ nhánh my với main..."

# Kiểm tra xem có đang trong rebase không
if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
    echo "⚠️  Phát hiện rebase đang dở, hủy bỏ trước..."
    git rebase --abort
fi

# Bước 1: Chuyển sang nhánh my
echo "📍 Chuyển sang nhánh my..."
git checkout my

# Bước 2: Bỏ thay đổi tự động của lock files (nếu có)
echo "🧹 Dọn dẹp lock files..."
git checkout -- bun.lock bun.lockb 2>/dev/null || true

# Bước 3: Rebase my lên main
echo "🔀 Rebase my lên main..."
if ! git rebase main; then
    echo "⚠️  Phát hiện conflict, tự động xử lý..."
    
    # Xử lý conflict bun.lock nếu có
    if [ -f bun.lock ] && git status | grep -q "bun.lock"; then
        echo "🔧 Xử lý conflict bun.lock..."
        git checkout --theirs bun.lock
        git add bun.lock
    fi
    
    # Xử lý conflict bun.lockb nếu có
    if [ -f bun.lockb ] && git status | grep -q "bun.lockb"; then
        echo "🔧 Xử lý conflict bun.lockb..."
        git checkout --theirs bun.lockb
        git add bun.lockb
    fi
    
    # Kiểm tra và xử lý conflict markers trong các file còn lại
    echo "🔍 Kiểm tra conflict markers..."
    if grep -r "<<<<<<< HEAD" . --exclude-dir=.git --exclude-dir=node_modules 2>/dev/null; then
        echo "❌ Còn conflict markers chưa giải quyết! Vui lòng xử lý thủ công:"
        echo "   1. Sửa các file có conflict"
        echo "   2. Chạy: git add <file>"
        echo "   3. Chạy: git rebase --continue"
        echo "   4. Sau đó chạy lại script này"
        git rebase --abort
        exit 1
    fi
    
    # Tiếp tục rebase
    while [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; do
        if ! git rebase --continue; then
            echo "❌ Không thể tự động tiếp tục rebase. Vui lòng xử lý thủ công."
            exit 1
        fi
    done
fi

# Kiểm tra rebase đã hoàn tất
if [ -d ".git/rebase-merge" ] || [ -d ".git/rebase-apply" ]; then
    echo "❌ Rebase chưa hoàn tất. Vui lòng kiểm tra và xử lý thủ công."
    exit 1
fi

# Bước 4: Cập nhật dependencies
echo "📦 Cập nhật dependencies..."
bun install

# Bước 5: Đẩy lên fork (force push an toàn)
echo "⬆️  Đẩy lên origin/my (force push)..."
git push --force-with-lease origin my

echo "✅ Hoàn tất! Nhánh my đã được đồng bộ với main."
