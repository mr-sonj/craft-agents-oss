#!/bin/bash
# Script tự động đồng bộ nhánh my với main mới nhất

echo "🔄 Bắt đầu đồng bộ nhánh my với main..."

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
    
    # Tiếp tục rebase với commit message mặc định
    GIT_EDITOR=true git rebase --continue
fi

# Bước 4: Cập nhật dependencies
echo "📦 Cập nhật dependencies..."
bun install

# Bước 5: Đẩy lên fork (force push)
echo "⬆️  Đẩy lên origin/my (force push)..."
git push -f origin my

echo "✅ Hoàn tất! Nhánh my đã được đồng bộ với main."
