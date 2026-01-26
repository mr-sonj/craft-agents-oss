#!/bin/bash
# Script tự động cập nhật nhánh main từ upstream

set -e  # Dừng nếu có lỗi

echo "🔄 Bắt đầu cập nhật nhánh main từ upstream..."

# Bước 1: Chuyển về nhánh main
echo "📍 Chuyển về nhánh main..."
git checkout main

# Bước 2: Lưu tạm thay đổi quan trọng (như .gitignore)
echo "💾 Lưu tạm các thay đổi..."
git stash push -m "auto-stash before update"

# Bước 3: Tải code mới từ upstream
echo "⬇️  Tải code mới từ upstream..."
git fetch upstream

# Bước 4: Cập nhật main theo upstream
echo "🔀 Rebase main lên upstream/main..."
git rebase upstream/main

# Bước 5: Đẩy lên fork
echo "⬆️  Đẩy lên origin/main..."
git push origin main

# Bước 6: Lấy lại thay đổi đã stash (nếu có)
echo "♻️  Khôi phục lại thay đổi..."
if git stash list | grep -q "auto-stash before update"; then
    git stash pop || echo "⚠️  Có conflict khi apply stash, vui lòng kiểm tra git stash list"
fi

# Bước 7: Cập nhật dependencies
echo "📦 Cập nhật dependencies..."
bun install

echo "✅ Hoàn tất! Nhánh main đã được cập nhật từ upstream."
