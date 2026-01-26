# Git Workflow - Hướng dẫn làm việc với nhánh

## Cấu trúc nhánh

- **`main`**: Nhánh sạch, đồng bộ với upstream (repo gốc).
  - ❌ KHÔNG commit trực tiếp
  - ❌ KHÔNG dev/test ở đây
  - ❌ KHÔNG cần `bun install`
  - ✅ Chỉ sync với upstream và để yên

- **`my`**: Nhánh phát triển - nơi bạn làm mọi thứ.
  - ✅ Dev, test, commit thoải mái
  - ✅ Chạy `bun install` và build ở đây
  - ✅ Tất cả tính năng custom của bạn

## Thiết lập ban đầu (chỉ làm 1 lần)

```bash
# Thêm remote upstream (repo gốc)
git remote add upstream https://github.com/lukilabs/craft-agents-oss.git

# Kiểm tra
git remote -v
```

## Cập nhật nhánh `main` từ code gốc (upstream)

**Cách 1: Chạy script tự động**

```bash
./update-main.sh
```

**Cách 2: Chạy từng bước thủ công**

```bash
# Bước 1: Chuyển về nhánh main
git checkout main

# Bước 2: Bỏ thay đổi tự động của bun.lock (nếu có)
git checkout -- bun.lock bun.lockb 2>/dev/null || true

# Bước 3: Tải code mới từ upstream
git fetch upstream

# Bước 4: Cập nhật main theo upstream
git rebase upstream/main

# Bước 5: Đẩy lên fork của bạn
git push origin main
```

**Hoàn tất!** Nhánh `main` của bạn đã đồng bộ với code gốc.

**Lưu ý:** Không cần `bun install` hay dev/test ở `main`. Chỉ sync và để yên!

```bash
# Chuyển sang nhánh my
git checkout my
**Cách 1: Chạy script tự động**

```bash
./sync-my.sh
```

**Cách 2: Chạy từng bước thủ công**


# Code, chỉnh sửa thoải mái...

# Commit thay đổi
git add .
git commit -m "Mô tả ngắn gọn"

# Đẩy lên fork
git push origin my
```

## Đồng bộ nhánh `my` với `main` mới nhất

Sau khi cập nhật `main`, đồng bộ `my` để có code mới:

```bash
# Chuyển sang nhánh my
git checkout my

# Rebase my lên main mới
git rebase main

# Đẩy lên (cần force vì đã rebase)
git push -f origin my
```

## Chia sẻ tính năng về repo gốc (Pull Request)

### Tạo feature branch cho tính năng mới

```bash
# Từ nhánh my, tạo feature branch
git checkout -b feature-ten-tinh-nang

# Code và commit tính năng
git add .
git commit -m "feat: mô tả tính năng"

# Đẩy lên fork
git push origin feature-ten-tinh-nang
```

### Tạo Pull Request

1. Vào GitHub fork của bạn
2. Tạo Pull Request: `origin/feature-ten-tinh-nang` → `upstream/main`
3. Mô tả rõ tính năng và cách test

### ❓ Main đã update, feature branch có cần update không?

**KHÔNG cần!** Giữ nguyên version code lúc tạo feature.

**Chỉ update feature khi:**
- ❗ Maintainer yêu cầu rebase (có conflict)
- ❗ Feature phát triển lâu (>1 tháng) → nên test với code mới
- ❗ Feature phụ thuộc code mới trong main

**Cách update feature với main mới (khi cần):**

```bash
git checkout feature-ten-tinh-nang
git fetch origin
git rebase origin/main
git push -f origin feature-ten-tinh-nang
```

---

## Xử lý lỗi thường gặp

### ❌ Lỗi: "cannot rebase: You have unstaged changes"

**Nguyên nhân:** Có thay đổi chưa commit (thường là `bun.lock`)

**Giải pháp:**

```bash
# Kiểm tra thay đổi gì
git status

# Nếu chỉ là bun.lock/bun.lockb:
git checkout -- bun.lock bun.lockb
git rebase upstream/main
bun install

# Nếu có thay đổi code quan trọng:
git stash                    # Ẩn tạm
git rebase upstream/main
bun install
git stash pop               # Lấy lại thay đổi
```

### ❌ Lỗi: Conflict khi rebase

```bash
# Sửa file conflict thủ công, sau đó:
git add <file-đã-sửa>: `git checkout -b feature-name main`

---

## Scripts hỗ trợ

- **`./update-main.sh`**: Tự động cập nhật nhánh main từ upstream
- **`./sync-my.sh`**: Tự động đồng bộ nhánh my với main
- Luôn chạy `bun install` sau khi rebase/merge
- Trước khi rebase, nên reset lock file: `git checkout -- bun.lock bun.lockb`

---

## Quy tắc

- ✅ Commit vào `my` thoải mái
- ❌ KHÔNG commit trực tiếp vào `main`
- ✅ Luôn chạy `bun install` sau khi rebase/merge
- ✅ Thường xuyên đồng bộ `my` với `main` để tránh conflict lớn
- ✅ Tạo nhánh tính năng mới từ `main`
- ✅ Commit vào `my` thoải mái
- ❌ KHÔNG commit vào `main`
- ✅ Luôn chạy `bun install` sau khi rebase/merge
```

## Quy tắc

- ✅ Commit vào `my` thoải mái
- ❌ KHÔNG commit vào `main`
- ✅ Thường xuyên rebase `my` lên `main` để tránh conflict lớn
- ✅ Tạo nhánh tính năng mới từ `main` nếu cần: `git checkout -b feature-name main`
