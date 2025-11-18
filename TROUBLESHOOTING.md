# 🔧 TROUBLESHOOTING GUIDE - EDUBOT AI

## ❌ Lỗi Thường Gặp và Cách Sửa

### 1. Login trả về 401 (Unauthorized)

**Nguyên nhân:**
- Sai username/email hoặc password
- Chưa có tài khoản trong database
- Backend chưa chạy

**Cách sửa:**
```sql
-- Kiểm tra user trong database
SELECT * FROM users;

-- Nếu chưa có, tạo user test:
INSERT INTO users (username, email, password, full_name) 
VALUES ('test', 'test@example.com', '123456', 'Test User');
```

---

### 2. Lỗi 500 Internal Server Error

**Nguyên nhân:**
- Lỗi trong code Python
- Database không kết nối được
- Thiếu dữ liệu trong bảng

**Cách sửa:**

1. **Xem log chi tiết trong terminal:**
   ```
   Tìm dòng có traceback hoặc error message
   ```

2. **Kiểm tra database:**
   ```sql
   -- Đảm bảo có dữ liệu
   SELECT COUNT(*) FROM majors;          -- Phải > 0
   SELECT COUNT(*) FROM universities;     -- Phải > 0
   SELECT COUNT(*) FROM production_rules; -- Phải > 0
   ```

3. **Test import modules:**
   ```powershell
   cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend
   python quick_test.py
   ```

---

### 3. Cannot connect to MySQL

**Cách sửa:**

1. **Kiểm tra XAMPP:**
   - Mở XAMPP Control Panel
   - Start MySQL (phải có status "Running")
   - Port 3306 không bị chiếm

2. **Kiểm tra credentials trong `db.py`:**
   ```python
   host="localhost"
   user="root"
   password=""  # Thay nếu bạn đặt password
   database="edu"
   ```

3. **Test connection:**
   ```powershell
   python -c "from db import get_db_connection; conn = get_db_connection(); print('OK' if conn else 'FAIL')"
   ```

---

### 4. Module not found errors

**Lỗi:**
```
ModuleNotFoundError: No module named 'flask'
```

**Cách sửa:**
```powershell
cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend
pip install -r requirements.txt

# Hoặc cài thủ công:
pip install flask flask-cors mysql-connector-python requests beautifulsoup4
```

---

### 5. CORS errors (Browser console)

**Lỗi:**
```
Access to fetch blocked by CORS policy
```

**Cách sửa:**

1. **Đảm bảo backend đang chạy tại đúng địa chỉ:**
   - Server: `http://127.0.0.1:5000`
   - Không được dùng `localhost` hoặc `0.0.0.0`

2. **Kiểm tra file JavaScript có đúng API URL:**
   ```javascript
   const API_BASE_URL = 'http://127.0.0.1:5000';
   ```

---

### 6. Chat không phản hồi (Error 500 khi gửi message)

**Nguyên nhân:**
- Lỗi trong logic chatbot
- Dữ liệu user_profile không đầy đủ

**Cách sửa:**

1. **Xem error trong terminal backend**

2. **Thử flow đơn giản:**
   - Bắt đầu chat mới
   - Trả lời đầy đủ tất cả câu hỏi
   - Không skip hoặc nhập sai format

3. **Debug mode:**
   ```python
   # Thêm vào chatbot.py để debug
   print(f"DEBUG: user_profile = {self.user_profile}")
   ```

---

### 7. Recommendations trả về rỗng

**Nguyên nhân:**
- Không có Production Rules nào match
- Không có trường nào thỏa mãn constraints

**Cách sửa:**

1. **Kiểm tra Production Rules:**
   ```sql
   SELECT * FROM production_rules WHERE is_active = 1;
   ```

2. **Nới lỏng constraints:**
   - Nhập học phí cao hơn
   - Nhập điểm thấp hơn
   - Chọn "Khác" cho city nếu không có trường

---

### 8. Web Scraper không hoạt động

**Nguyên nhân:**
- Không có internet
- Website bị block
- Rate limiting

**Giải pháp:**
- Web scraper là tính năng bổ sung
- Hệ thống vẫn hoạt động bình thường với dữ liệu có sẵn trong DB
- Nếu cần, có thể disable web scraping

---

## 🧪 Test Commands

```powershell
# Test database connection
python -c "from db import get_db_connection; print('OK' if get_db_connection() else 'FAIL')"

# Test Production Rules
python -c "from production_rules import ProductionRulesEngine; e = ProductionRulesEngine(); print(f'Loaded {len(e.rules)} rules')"

# Test full system
python test_system.py

# Run server
python app.py
```

---

## 📞 Quick Fixes

### Reset Everything:

```powershell
# 1. Stop server (Ctrl+C)

# 2. Re-import database
# Mở phpMyAdmin → Drop database 'edu' → Import edu.sql lại

# 3. Clear Python cache
Remove-Item -Recurse -Force __pycache__

# 4. Restart server
python app.py
```

---

## 🎯 Kiểm Tra Flow Hoàn Chỉnh:

1. ✅ XAMPP MySQL đang chạy
2. ✅ Database `edu` đã import
3. ✅ Backend chạy tại `http://127.0.0.1:5000`
4. ✅ Mở `view/login/login.html`
5. ✅ Đăng ký/đăng nhập
6. ✅ Vào chat → Click "Bắt đầu tư vấn mới"
7. ✅ Trả lời tất cả câu hỏi (9 câu)
8. ✅ Nhận recommendations

---

## 💡 Tips:

- **Luôn xem terminal backend** để thấy log real-time
- **Mở Browser Console (F12)** để xem lỗi JavaScript
- **Dùng Postman** để test API trực tiếp nếu cần
- **Đọc README.md** để hiểu kiến trúc hệ thống

---

Nếu vẫn gặp lỗi, hãy:
1. Copy error message đầy đủ
2. Chụp màn hình
3. Kiểm tra logs trong terminal backend
