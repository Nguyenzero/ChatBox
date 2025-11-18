# 🧪 TESTING GUIDE - EduBot AI System

## ✅ System Status

### Code Quality
- ✅ **All indentation errors fixed** in `chatbot.py`
- ✅ **All Python modules load successfully** (verified by `quick_test.py`)
- ✅ **All dependencies installed**: Flask, Flask-CORS, MySQL Connector, BeautifulSoup4, Requests
- ✅ **No syntax errors** in backend code

### Current State
- **Backend**: Ready to run
- **Frontend**: HTML/CSS/JS files ready
- **Database**: Schema and test data available in `database/edu.sql`

---

## 🚀 Quick Start Testing

### Step 1: Start MySQL Server
Ensure MySQL is running on your machine:
```powershell
# Check if MySQL is running
Get-Service -Name "*mysql*"

# If not running, start it (adjust service name as needed)
Start-Service MySQL80
```

### Step 2: Import Database
```powershell
# Navigate to database folder
cd d:\CoTuong_DoAnCoSo4\TTNT-DA\database

# Import schema and data
mysql -u root -p < edu.sql

# Import test users
mysql -u root -p < insert_test_users.sql
```

### Step 3: Start Backend Server
```powershell
# Navigate to backend folder
cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend

# Start Flask server
python app.py
```

You should see:
```
============================================================
🎓 EDUBOT AI - HỆ THỐNG TƯ VẤN GIÁO DỤC
============================================================
🚀 Server đang khởi động...
📡 API: http://127.0.0.1:5000
🤖 Chatbot: http://127.0.0.1:5000/api/chat
============================================================
```

### Step 4: Test Frontend
Open your browser and navigate to:
```
file:///d:/CoTuong_DoAnCoSo4/TTNT-DA/view/login/login.html
```

---

## 🧪 Test Cases

### Test Account 1: Admin User
- **Email**: `admin@edubot.com`
- **Username**: `admin`
- **Password**: `admin123`

### Test Account 2: Student 1
- **Email**: `student1@example.com`
- **Username**: `student1`
- **Password**: `pass123`

### Test Account 3: Student 2
- **Email**: `student2@example.com`
- **Username**: `student2`
- **Password**: `pass123`

---

## 📋 Complete Testing Workflow

### 1. Login Test
1. Open `view/login/login.html` in browser
2. Enter test credentials
3. Click "Đăng nhập"
4. Should redirect to chat interface

### 2. Chat Survey Test
The bot will ask 9 questions. Here are sample answers:

**Q1: Môn học yêu thích?**
```
a, c, d
(Toán, Tin học, Vật lý)
```

**Q2: Môn học yếu?**
```
b, e
(Văn, Anh văn)
```

**Q3: Tính cách?**
```
a
(Hướng ngoại)
```

**Q4: Kỹ năng?**
```
a, b, c
(Giải quyết vấn đề, Lập trình, Tư duy logic)
```

**Q5: Sở thích?**
```
a, c
(Công nghệ, Sáng tạo)
```

**Q6: Mục tiêu nghề nghiệp?**
```
a
(Kỹ sư phần mềm)
```

**Q7: Thành phố ưa thích?**
```
Hà Nội
```

**Q8: Học phí tối đa? (triệu VNĐ/năm)**
```
30
```

**Q9: Điểm thi đầu vào dự kiến?**
```
25
```

### 3. Recommendation Test
After answering all questions, the system will:
1. **Run Production Rules Engine** → Recommend top 3 majors
2. **Run CSP Solver** → Find top 3 universities
3. **Display Results** with:
   - Major names, codes, confidence scores
   - University names, cities, tuition fees
   - Admission scores and match scores

### 4. QA Mode Test
Try asking questions like:
- "Điểm chuẩn ngành CNTT của ĐHBK Hà Nội?"
- "Học phí trường FPT?"
- "Ngành CNTT có triển vọng không?"

The system will:
1. Check if question is education-related
2. Search knowledge_base table in database
3. If not found, use Web Scraper to get info from DuckDuckGo
4. Cache result in database for future queries

---

## 🔧 API Testing (Optional)

### Using PowerShell (Invoke-RestMethod)

**Test Health Endpoint:**
```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:5000/health" -Method Get
```

**Test Login:**
```powershell
$body = @{
    identifier = "admin@edubot.com"
    password = "admin123"
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:5000/login" -Method Post -Body $body -ContentType "application/json"
```

**Test Start Chat:**
```powershell
$body = @{
    user_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:5000/api/chat/start" -Method Post -Body $body -ContentType "application/json"
```

**Test Send Message:**
```powershell
$body = @{
    session_id = "your-session-id-here"
    message = "Xin chào"
    user_id = 1
} | ConvertTo-Json

Invoke-RestMethod -Uri "http://127.0.0.1:5000/api/chat/message" -Method Post -Body $body -ContentType "application/json"
```

### Using cURL (if available)

**Test Health:**
```bash
curl http://127.0.0.1:5000/health
```

**Test Login:**
```bash
curl -X POST http://127.0.0.1:5000/login \
  -H "Content-Type: application/json" \
  -d '{"identifier":"admin@edubot.com","password":"admin123"}'
```

---

## 🐛 Troubleshooting

### Issue: Flask Import Errors in VS Code
**Symptom**: VS Code shows "Import 'flask' could not be resolved"
**Solution**: This is a VS Code Pylance issue. The code works fine at runtime.
```powershell
# Verify Flask is installed
pip list | Select-String flask

# Should show:
# Flask                  3.0.0
# Flask-Cors             4.0.0
```

### Issue: Database Connection Failed
**Symptom**: "❌ Lỗi khi kết nối MySQL"
**Solutions**:
1. Check MySQL is running: `Get-Service MySQL80`
2. Verify credentials in `backend/db.py`:
   ```python
   host="localhost"
   user="root"
   password=""  # Update if you have a password
   database="edu"
   ```
3. Ensure database exists: `mysql -u root -p -e "SHOW DATABASES;"`

### Issue: API Returns 500 Error
**Check**:
1. Backend console for error messages
2. Verify user_id exists in database
3. Check all survey questions are answered
4. Review browser console for JavaScript errors

### Issue: No Recommendations
**Possible Causes**:
1. Not enough majors in database
2. Constraints too strict (e.g., very low budget, high score requirements)
3. CSP solver returns no matches
**Solution**: Check `recommended_majors` in console output

---

## 📊 Verification Commands

### Check All Tests Pass
```powershell
cd d:\CoTuong_DoAnCoSo4\TTNT-DA\backend
python test_system.py
```

### Quick Import Test
```powershell
python quick_test.py
```

### Check Database Status
```powershell
python check_db.py
```

---

## ✨ What to Expect

### Successful Flow:
1. **Login** → Redirect to chat
2. **Greeting** → Bot introduces itself
3. **Survey** → 9 questions, one at a time
4. **Processing** → "Đang phân tích..."
5. **Recommendations** → Top 3 majors + top 3 universities
6. **QA Mode** → Ask follow-up questions
7. **Chat History** → Saved in database

### AI Components in Action:
1. **Production Rules Engine**: Matches your profile to majors using forward chaining
2. **CSP Solver**: Finds universities using backtracking + forward checking
3. **Web Scraper**: Fetches missing data from DuckDuckGo when needed

---

## 📝 Next Steps After Testing

1. **Review Results**: Check if recommendations make sense
2. **Test Edge Cases**: 
   - Very low/high entrance scores
   - Extreme budget constraints
   - Obscure city preferences
3. **Improve Rules**: Add more production rules in database
4. **Add Universities**: Expand university_majors combinations
5. **Enhance UI**: Improve chat interface styling
6. **Add Features**:
   - Password reset
   - Profile editing
   - Chat history view
   - Feedback system

---

## 🎯 Success Criteria

✅ Backend server starts without errors
✅ Login with test accounts works
✅ Survey completes successfully
✅ Production Rules returns 3 majors with confidence scores
✅ CSP Solver finds matching universities
✅ QA mode answers education questions
✅ Chat history saves to database
✅ No 500 errors in console

---

**System is ready for testing! Good luck! 🚀**
