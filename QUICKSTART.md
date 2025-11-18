# 🚀 HƯỚNG DẪN CHẠY NHANH - EDUBOT AI

## ⚡ Chạy trong 3 bước:

### Bước 1: Chuẩn bị Database
```
1. Mở XAMPP
2. Start Apache + MySQL
3. Mở phpMyAdmin: http://localhost/phpmyadmin
4. Import file: database/edu.sql
```

### Bước 2: Cài đặt Python Libraries
```powershell
cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend
pip install -r requirements.txt
```

### Bước 3: Chạy Server
```powershell
python app.py
```

Server sẽ chạy tại: http://127.0.0.1:5000

### Bước 4: Mở Giao Diện
```
Mở file: view/login/login.html trong trình duyệt
```

---

## 🧪 Test Hệ Thống

```powershell
python test_system.py
```

---

## 📝 Nếu Gặp Lỗi:

### Lỗi: "No module named 'flask'"
```powershell
pip install flask flask-cors
```

### Lỗi: "No module named 'mysql'"
```powershell
pip install mysql-connector-python
```

### Lỗi: "Can't connect to MySQL"
- Kiểm tra XAMPP MySQL đã chạy chưa
- Kiểm tra file `backend/db.py`:
  - host="localhost"
  - user="root"
  - password=""
  - database="edu"

---

## 🎯 Các Endpoint Quan Trọng:

- **API Base:** http://127.0.0.1:5000
- **Start Chat:** POST http://127.0.0.1:5000/api/chat/start
- **Send Message:** POST http://127.0.0.1:5000/api/chat/message
- **Health Check:** GET http://127.0.0.1:5000/health

---

## 📞 Hỗ Trợ

Nếu cần hỗ trợ, xem file README.md hoặc tạo issue!

---

✅ **Chúc bạn thành công!**
