# 🎓 EDUBOT AI - Hệ Thống Tư Vấn Giáo Dục Thông Minh

## 📋 Mô Tả Dự Án

**EduBot AI** là một hệ thống chatbot tư vấn giáo dục thông minh sử dụng các kỹ thuật AI:

- **Production Rules (Expert System)** - Hệ thống suy luận dựa trên luật IF-THEN
- **CSP (Constraint Satisfaction Problem)** - Giải bài toán thỏa mãn ràng buộc với Backtracking + Forward Checking
- **Web Scraping** - Tự động thu thập và mở rộng dữ liệu từ web

### ✨ Tính Năng Chính

✅ **Tư vấn ngành học phù hợp** - Dựa trên sở thích, năng lực, tính cách  
✅ **Đề xuất trường đại học** - Theo khu vực, học phí, điểm chuẩn  
✅ **Cung cấp thông tin chi tiết** - Về trường, ngành, điểm chuẩn, học phí  
✅ **Chatbot thông minh** - Chỉ trả lời câu hỏi về giáo dục  

---

## 🚀 Hướng Dẫn Cài Đặt

### 1️⃣ Yêu Cầu Hệ Thống

- **Python 3.8+**
- **MySQL/XAMPP** (hoặc MariaDB)
- **Trình duyệt web** hiện đại (Chrome, Firefox, Edge)

### 2️⃣ Cài Đặt Database

1. **Khởi động XAMPP** (Apache + MySQL)

2. **Import database:**
   ```bash
   # Mở phpMyAdmin: http://localhost/phpmyadmin
   # Import file: database/edu.sql
   ```

   Hoặc dùng command line:
   ```bash
   mysql -u root -p < database/edu.sql
   ```

3. **Kiểm tra database `edu` đã được tạo thành công**

### 3️⃣ Cài Đặt Backend (Python)

1. **Di chuyển vào thư mục backend:**
   ```powershell
   cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend
   ```

2. **Cài đặt dependencies:**
   ```powershell
   pip install -r requirements.txt
   ```

   Nếu gặp lỗi, cài thủ công:
   ```powershell
   pip install flask flask-cors mysql-connector-python requests beautifulsoup4 lxml python-dotenv
   ```

3. **Kiểm tra kết nối database:**
   - Mở file `backend/db.py`
   - Đảm bảo thông tin MySQL đúng:
     ```python
     host="localhost"
     user="root"
     password=""  # Thay password nếu có
     database="edu"
     ```

### 4️⃣ Chạy Ứng Dụng

1. **Khởi động Backend Server:**
   ```powershell
   cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend
   python app.py
   ```

   Server sẽ chạy tại: `http://127.0.0.1:5000`

2. **Mở Frontend:**
   - Mở file: `view/login/login.html` trong trình duyệt
   - Hoặc dùng Live Server (VSCode extension)

3. **Đăng ký tài khoản và bắt đầu sử dụng!**

---

## 📁 Cấu Trúc Dự Án

```
TTNT-DA/
├── backend/                    # Backend Python/Flask
│   ├── app.py                 # Main Flask app - CHẠY FILE NÀY
│   ├── db.py                  # Database connection & queries
│   ├── production_rules.py    # Production Rules Engine (AI)
│   ├── csp_solver.py          # CSP Solver (Backtracking)
│   ├── web_scraper.py         # Web Scraper (Auto data collection)
│   ├── chatbot.py             # Main Chatbot logic
│   ├── chatbot_api.py         # REST API endpoints
│   ├── signup.py              # Authentication
│   └── requirements.txt       # Python dependencies
│
├── database/
│   └── edu.sql                # Database schema + sample data
│
└── view/                      # Frontend HTML/CSS/JS
    ├── login/                 # Login page
    ├── signup/                # Signup page
    ├── home/                  # Home page
    ├── chat/                  # Main chat interface
    └── profile/               # User profile
```

---

## 🧠 Kiến Trúc AI

### 1. Production Rules (Hệ Luật Suy Diễn)

**File:** `backend/production_rules.py`

- **Inference Engine** - Bộ máy suy luận Forward Chaining
- **Working Memory** - Lưu trữ facts từ người dùng
- **Rules Base** - Các luật IF-THEN từ database

**Ví dụ luật:**
```
IF thích Toán AND thích máy tính AND muốn thu nhập cao
THEN ngành gợi ý = Công nghệ Thông tin (confidence: 95%)
```

### 2. CSP Solver (Giải Bài Toán Ràng Buộc)

**File:** `backend/csp_solver.py`

- **Variables:** university_id, major_id, city, tuition_fee, admission_score
- **Domains:** Các giá trị có thể của từng biến
- **Constraints:** Điều kiện từ người dùng
- **Algorithm:** Backtracking + Forward Checking

**Ví dụ:**
```
Constraints:
- City = "Hà Nội"
- Tuition <= 20 triệu
- Score >= 25

→ Tìm tất cả trường-ngành thỏa mãn
```

### 3. Web Scraper (Thu Thập Dữ Liệu)

**File:** `backend/web_scraper.py`

- Tự động tìm kiếm thông tin trên web
- Lưu vào `knowledge_base` table
- Sử dụng cache để tránh tìm lại

**Flow:**
```
User hỏi → Tìm trong DB → Không có? → Search web → Extract info → Save DB → Trả lời
```

---

## 🔄 Workflow Hoạt Động

```
1. User: Bắt đầu tư vấn
   ↓
2. Bot: Hỏi bộ câu hỏi (Survey)
   - Sở thích
   - Môn học mạnh/yếu
   - Tính cách
   - Kỹ năng
   - Khu vực
   - Học phí
   - Điểm thi
   ↓
3. Production Rules Engine
   → Suy luận ngành phù hợp
   → Top 3 ngành + confidence score
   ↓
4. CSP Solver
   → Apply constraints
   → Backtracking + Forward Checking
   → Top 3 trường phù hợp
   ↓
5. Bot: Trả kết quả chi tiết
   ↓
6. User: Hỏi thêm thông tin
   ↓
7. Bot: Tìm DB → Không có? → Web Scraper
   ↓
8. Bot: Trả lời + Lưu vào DB
```

---

## 🎯 API Endpoints

### Chatbot API (`/api/chat`)

| Endpoint | Method | Mô tả |
|----------|--------|-------|
| `/start` | POST | Bắt đầu session chat mới |
| `/message` | POST | Gửi tin nhắn |
| `/recommend` | POST | Lấy gợi ý trực tiếp (skip survey) |
| `/search` | POST | Tìm kiếm thông tin |
| `/session/:id` | GET | Lấy thông tin session |
| `/session/:id` | DELETE | Kết thúc session |

### Authentication API

| Endpoint | Method | Mô tả |
|----------|--------|-------|
| `/signup` | POST | Đăng ký tài khoản |
| `/login` | POST | Đăng nhập |

---

## 📊 Database Schema

### Tables Chính:

1. **users** - Người dùng
2. **majors** - Ngành học
3. **universities** - Trường đại học
4. **university_majors** - Quan hệ ngành-trường (điểm chuẩn, học phí)
5. **production_rules** - Luật suy diễn (JSON)
6. **consultation_profiles** - Hồ sơ tư vấn
7. **chat_logs** - Lịch sử chat
8. **knowledge_base** - Kiến thức tự động thu thập
9. **chat_sessions** - Quản lý session
10. **feedback** - Đánh giá người dùng

---

## 🧪 Testing

### Test Production Rules Engine:
```powershell
cd backend
python production_rules.py
```

### Test CSP Solver:
```python
from csp_solver import CSPSolver

solver = CSPSolver()
solver.add_constraints({
    'preferred_city': 'Hà Nội',
    'max_tuition_fee': 20000000,
    'entrance_score': 25.0
})
results = solver.solve()
print(results)
```

### Test Web Scraper:
```python
from web_scraper import quick_search

result = quick_search(
    "Điểm chuẩn ngành CNTT ĐHBK Hà Nội 2024",
    ["điểm chuẩn", "CNTT", "ĐHBK"]
)
print(result)
```

---

## 🐛 Troubleshooting

### Lỗi: "Import mysql.connector could not be resolved"
```powershell
pip install mysql-connector-python
```

### Lỗi: "Can't connect to MySQL server"
- Kiểm tra XAMPP đã bật MySQL chưa
- Kiểm tra port 3306 có bị chiếm không
- Kiểm tra username/password trong `db.py`

### Lỗi: "CORS policy blocked"
- Đảm bảo backend đang chạy tại `127.0.0.1:5000`
- Kiểm tra `flask-cors` đã được cài đặt

### Bot không trả lời:
- Kiểm tra database đã import đầy đủ
- Kiểm tra có Production Rules trong DB không:
  ```sql
  SELECT * FROM production_rules;
  ```

---

## 📝 Notes

- **Database** đã có sẵn 10 ngành, 10 trường, 19 tổ hợp ngành-trường, 10 luật mẫu
- **Bot chỉ trả lời** câu hỏi về giáo dục (ngành, trường, điểm chuẩn, học phí)
- **Web Scraper** cần kết nối internet để hoạt động
- **Session** được lưu trong memory, restart server sẽ mất (có thể nâng cấp dùng Redis)

---

## 👨‍💻 Tác Giả

**Đồ Án Cơ Sở 4 - Trí Tuệ Nhân Tạo**

---

## 📄 License

MIT License - Free to use for educational purposes.

---

## 🎉 Enjoy!

Nếu có lỗi hoặc câu hỏi, vui lòng tạo issue hoặc liên hệ!
