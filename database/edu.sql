-- ========================================
-- 🎓 HỆ THỐNG TƯ VẤN GIÁO DỤC AI CHATBOX
-- ========================================
-- Sử dụng: Production Rules + CSP + Web Scraping
-- Mục đích: Tư vấn ngành học và trường đại học phù hợp

CREATE DATABASE IF NOT EXISTS edu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE edu;

-- ==========================
-- 1️⃣ BẢNG NGƯỜI DÙNG
-- ==========================
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    full_name VARCHAR(100),
    phone VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- 2️⃣ BẢNG NGÀNH HỌC
-- ==========================
CREATE TABLE IF NOT EXISTS majors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    major_name VARCHAR(200) NOT NULL,
    major_code VARCHAR(50),
    description TEXT,
    category VARCHAR(100), -- Công nghệ, Kinh tế, Y dược, Xã hội, Nghệ thuật...
    required_subjects VARCHAR(200), -- Toán, Lý, Hóa, Văn, Sử, Địa...
    career_prospects TEXT, -- Triển vọng nghề nghiệp
    salary_range VARCHAR(100), -- Mức lương trung bình
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- 3️⃣ BẢNG TRƯỜNG ĐẠI HỌC
-- ==========================
CREATE TABLE IF NOT EXISTS universities (
    id INT AUTO_INCREMENT PRIMARY KEY,
    university_name VARCHAR(200) NOT NULL,
    university_code VARCHAR(50),
    address TEXT,
    city VARCHAR(100), -- Hà Nội, TP.HCM, Đà Nẵng...
    region VARCHAR(50), -- Miền Bắc, Miền Trung, Miền Nam
    phone VARCHAR(20),
    email VARCHAR(100),
    website VARCHAR(200),
    university_type VARCHAR(50), -- Công lập, Dân lập, Tư thục
    ranking INT, -- Xếp hạng (nếu có)
    description TEXT,
    facilities TEXT, -- Cơ sở vật chất
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- 4️⃣ BẢNG NGÀNH - TRƯỜNG (Quan hệ nhiều-nhiều)
-- ==========================
CREATE TABLE IF NOT EXISTS university_majors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    university_id INT NOT NULL,
    major_id INT NOT NULL,
    admission_score DECIMAL(4,2), -- Điểm chuẩn
    tuition_fee DECIMAL(10,2), -- Học phí (VNĐ/năm)
    duration INT, -- Thời gian đào tạo (năm)
    training_system VARCHAR(100), -- Chính quy, Liên thông, Từ xa...
    quota INT, -- Chỉ tiêu tuyển sinh
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (university_id) REFERENCES universities(id) ON DELETE CASCADE,
    FOREIGN KEY (major_id) REFERENCES majors(id) ON DELETE CASCADE,
    UNIQUE KEY unique_university_major (university_id, major_id)
);

-- ==========================
-- 5️⃣ BẢNG PRODUCTION RULES (Luật suy diễn)
-- ==========================
CREATE TABLE IF NOT EXISTS production_rules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rule_name VARCHAR(200) NOT NULL,
    conditions TEXT NOT NULL, -- JSON: {"subject": "math", "personality": "logical", "goal": "high_income"}
    conclusion_major_ids TEXT, -- JSON: [1, 3, 5] - Danh sách ID ngành phù hợp
    confidence_score DECIMAL(3,2), -- Độ tin cậy (0-1)
    priority INT DEFAULT 1, -- Độ ưu tiên
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- 6️⃣ BẢNG HỒ SƠ TƯ VẤN (Lưu câu trả lời của user)
-- ==========================
CREATE TABLE IF NOT EXISTS consultation_profiles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_id VARCHAR(100) NOT NULL,
    
    -- Thông tin sở thích và năng lực
    favorite_subjects TEXT, -- JSON: ["math", "physics", "computer"]
    weak_subjects TEXT, -- JSON: ["literature", "history"]
    personality_type VARCHAR(50), -- Hướng nội, Hướng ngoại, Phân tích, Sáng tạo...
    skills TEXT, -- JSON: ["logical_thinking", "communication", "creativity"]
    interests TEXT, -- JSON: ["technology", "business", "art"]
    
    -- Thông tin ràng buộc CSP
    preferred_city VARCHAR(100), -- Thành phố muốn học
    preferred_region VARCHAR(50), -- Miền Bắc, Miền Trung, Miền Nam
    max_tuition_fee DECIMAL(10,2), -- Học phí tối đa
    entrance_score DECIMAL(4,2), -- Điểm thi của user
    career_goal TEXT, -- Mục tiêu nghề nghiệp
    
    -- Kết quả tư vấn
    recommended_majors TEXT, -- JSON: [{"major_id": 1, "confidence": 0.95, "reason": "..."}]
    recommended_universities TEXT, -- JSON: [{"university_id": 1, "major_id": 1, "match_score": 0.9}]
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ==========================
-- 7️⃣ BẢNG LƯU HỘI THOẠI CHATBOT
-- ==========================
CREATE TABLE IF NOT EXISTS chat_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_id VARCHAR(100) NOT NULL,
    user_message TEXT NOT NULL,
    bot_reply TEXT NOT NULL,
    intent VARCHAR(100), -- survey, recommend, info_request, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ==========================
-- 8️⃣ BẢNG KIẾN THỨC TỰ ĐỘNG THU THẬP (Web Scraping Cache)
-- ==========================
CREATE TABLE IF NOT EXISTS knowledge_base (
    id INT AUTO_INCREMENT PRIMARY KEY,
    entity_type VARCHAR(50), -- university, major, admission_info, etc.
    entity_id INT, -- ID của trường hoặc ngành (nếu có)
    keyword VARCHAR(200), -- Từ khóa tìm kiếm
    question TEXT, -- Câu hỏi gốc của user
    answer TEXT NOT NULL, -- Câu trả lời
    source_url TEXT, -- Nguồn thông tin
    reliability_score DECIMAL(3,2), -- Độ tin cậy (0-1)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ==========================
-- 9️⃣ BẢNG SESSION CHAT
-- ==========================
CREATE TABLE IF NOT EXISTS chat_sessions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_token VARCHAR(100) NOT NULL UNIQUE,
    status VARCHAR(50) DEFAULT 'active', -- active, completed, abandoned
    current_step VARCHAR(100), -- survey_interests, survey_constraints, recommend, etc.
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_active TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ==========================
-- 🔟 BẢNG FEEDBACK (Đánh giá của người dùng)
-- ==========================
CREATE TABLE IF NOT EXISTS feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    session_id VARCHAR(100),
    rating INT, -- 1-5 sao
    comment TEXT,
    recommendation_helpful BOOLEAN, -- Gợi ý có hữu ích không?
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- ========================================
-- 📊 DỮ LIỆU MẪU
-- ========================================

-- ============ NGÀNH HỌC MẪU ============
INSERT INTO majors (major_name, major_code, description, category, required_subjects, career_prospects, salary_range) VALUES
('Công nghệ Thông tin', 'CNTT', 'Đào tạo chuyên gia về phần mềm, mạng máy tính, AI, bảo mật', 'Công nghệ', 'Toán, Lý, Anh', 'Lập trình viên, Kỹ sư phần mềm, Data Scientist, AI Engineer', '10-50 triệu/tháng'),
('Khoa học Dữ liệu', 'KHĐL', 'Phân tích dữ liệu lớn, Machine Learning, Business Intelligence', 'Công nghệ', 'Toán, Lý, Anh', 'Data Analyst, Data Scientist, BI Developer', '15-60 triệu/tháng'),
('Kỹ thuật Phần mềm', 'KTPM', 'Thiết kế và phát triển phần mềm chuyên nghiệp', 'Công nghệ', 'Toán, Lý, Anh', 'Software Engineer, Solution Architect', '12-55 triệu/tháng'),
('Quản trị Kinh doanh', 'QTKD', 'Quản lý doanh nghiệp, marketing, nhân sự, tài chính', 'Kinh tế', 'Toán, Văn, Anh', 'Quản lý doanh nghiệp, Marketing Manager, HR Manager', '8-40 triệu/tháng'),
('Marketing', 'MKT', 'Nghiên cứu thị trường, quảng cáo, thương hiệu', 'Kinh tế', 'Văn, Anh, Toán', 'Marketing Specialist, Brand Manager, Content Creator', '8-35 triệu/tháng'),
('Kế toán - Kiểm toán', 'KTKT', 'Kế toán doanh nghiệp, kiểm toán, thuế', 'Kinh tế', 'Toán, Văn, Anh', 'Kế toán viên, Kiểm toán viên, CFO', '7-30 triệu/tháng'),
('Y khoa', 'YK', 'Đào tạo bác sĩ đa khoa', 'Y dược', 'Hóa, Sinh, Lý', 'Bác sĩ, Chuyên gia y tế', '15-100 triệu/tháng'),
('Dược học', 'DH', 'Đào tạo dược sĩ, nghiên cứu thuốc', 'Y dược', 'Hóa, Sinh, Lý', 'Dược sĩ, Nghiên cứu dược phẩm', '10-40 triệu/tháng'),
('Luật', 'L', 'Đào tạo luật sư, tư vấn pháp lý', 'Xã hội', 'Văn, Sử, Anh', 'Luật sư, Tư vấn pháp lý, Thẩm phán', '10-50 triệu/tháng'),
('Thiết kế Đồ họa', 'TKĐH', 'Thiết kế hình ảnh, UI/UX, đồ họa sáng tạo', 'Nghệ thuật', 'Vẽ, Anh, Văn', 'Graphic Designer, UI/UX Designer', '8-35 triệu/tháng');

-- ============ TRƯỜNG ĐẠI HỌC MẪU ============
INSERT INTO universities (university_name, university_code, address, city, region, website, university_type, ranking, description) VALUES
('Đại học Bách khoa Hà Nội', 'ĐHBKHN', '1 Đại Cồ Việt, Hai Bà Trưng, Hà Nội', 'Hà Nội', 'Miền Bắc', 'https://www.hust.edu.vn', 'Công lập', 1, 'Trường kỹ thuật hàng đầu Việt Nam'),
('Đại học Quốc gia Hà Nội', 'ĐHQGHN', '144 Xuân Thủy, Cầu Giấy, Hà Nội', 'Hà Nội', 'Miền Bắc', 'https://www.vnu.edu.vn', 'Công lập', 2, 'Đại học đa ngành, nghiên cứu mạnh'),
('Đại học Bách khoa TP.HCM', 'ĐHBK-HCM', '268 Lý Thường Kiệt, Quận 10, TP.HCM', 'TP.HCM', 'Miền Nam', 'https://www.hcmut.edu.vn', 'Công lập', 3, 'Trường kỹ thuật lớn nhất miền Nam'),
('Đại học Kinh tế TP.HCM', 'UEH', '59C Nguyễn Đình Chiểu, Quận 3, TP.HCM', 'TP.HCM', 'Miền Nam', 'https://www.ueh.edu.vn', 'Công lập', 5, 'Đại học kinh tế hàng đầu'),
('Đại học FPT', 'FPT', 'Khu Công nghệ cao Hòa Lạc, Hà Nội', 'Hà Nội', 'Miền Bắc', 'https://www.fpt.edu.vn', 'Tư thục', 10, 'Đại học công nghệ thực hành'),
('Đại học Đà Nẵng', 'ĐHĐ', '41 Lê Duẩn, Hải Châu, Đà Nẵng', 'Đà Nẵng', 'Miền Trung', 'https://www.udn.vn', 'Công lập', 8, 'Đại học lớn nhất miền Trung'),
('Đại học Y Hà Nội', 'ĐHYHN', '1 Tôn Thất Tùng, Đống Đa, Hà Nội', 'Hà Nội', 'Miền Bắc', 'https://www.hmu.edu.vn', 'Công lập', 1, 'Đại học Y dược hàng đầu'),
('Đại học Luật Hà Nội', 'ĐHLHN', '87 Nguyễn Chí Thanh, Đống Đa, Hà Nội', 'Hà Nội', 'Miền Bắc', 'https://www.hlu.edu.vn', 'Công lập', 1, 'Đại học Luật uy tín nhất'),
('Đại học Kiến trúc Hà Nội', 'ĐHKTHN', 'Km 10, Nguyễn Trãi, Hà Đông, Hà Nội', 'Hà Nội', 'Miền Bắc', 'https://www.hau.edu.vn', 'Công lập', 1, 'Đào tạo kiến trúc sư hàng đầu'),
('Đại học Tôn Đức Thắng', 'TDTU', '19 Nguyễn Hữu Thọ, Quận 7, TP.HCM', 'TP.HCM', 'Miền Nam', 'https://www.tdtu.edu.vn', 'Công lập', 12, 'Đại học đa ngành năng động');

-- ============ NGÀNH - TRƯỜNG (ĐIỂM CHUẨN & HỌC PHÍ) ============
INSERT INTO university_majors (university_id, major_id, admission_score, tuition_fee, duration, training_system, quota) VALUES
-- ĐHBK Hà Nội
(1, 1, 27.50, 15000000, 4, 'Chính quy', 500),
(1, 2, 28.00, 16000000, 4, 'Chính quy', 100),
(1, 3, 27.00, 15000000, 4, 'Chính quy', 300),
-- ĐHQG Hà Nội
(2, 1, 26.50, 12000000, 4, 'Chính quy', 400),
(2, 4, 24.00, 11000000, 4, 'Chính quy', 300),
-- ĐHBK TP.HCM
(3, 1, 28.00, 14000000, 4, 'Chính quy', 600),
(3, 3, 27.50, 14000000, 4, 'Chính quy', 400),
-- UEH
(4, 4, 25.00, 13000000, 4, 'Chính quy', 800),
(4, 5, 24.50, 12500000, 4, 'Chính quy', 500),
(4, 6, 23.50, 12000000, 4, 'Chính quy', 600),
-- FPT
(5, 1, 22.00, 30000000, 4, 'Chính quy', 1000),
(5, 3, 21.50, 29000000, 4, 'Chính quy', 500),
(5, 10, 20.00, 28000000, 4, 'Chính quy', 200),
-- ĐH Đà Nẵng
(6, 1, 24.00, 10000000, 4, 'Chính quy', 300),
(6, 4, 22.50, 9500000, 4, 'Chính quy', 250),
-- ĐH Y Hà Nội
(7, 7, 29.00, 20000000, 6, 'Chính quy', 500),
(7, 8, 27.50, 18000000, 5, 'Chính quy', 300),
-- ĐH Luật Hà Nội
(8, 9, 26.00, 11000000, 4, 'Chính quy', 600),
-- ĐH Kiến trúc Hà Nội
(9, 10, 25.50, 13000000, 5, 'Chính quy', 200),
-- ĐH Tôn Đức Thắng
(10, 1, 23.00, 17000000, 4, 'Chính quy', 400),
(10, 4, 22.00, 16000000, 4, 'Chính quy', 350);

-- ============ PRODUCTION RULES MẪU ============
INSERT INTO production_rules (rule_name, conditions, conclusion_major_ids, confidence_score, priority) VALUES
('Thích Toán + Công nghệ → CNTT', '{"favorite_subjects": ["math", "computer"], "interests": ["technology"]}', '[1, 2, 3]', 0.95, 10),
('Thích Toán + Kinh doanh → QTKD', '{"favorite_subjects": ["math"], "interests": ["business"], "personality_type": "extrovert"}', '[4, 5]', 0.90, 8),
('Hướng nội + Phân tích → Data Science', '{"personality_type": "introvert", "skills": ["logical_thinking", "analysis"]}', '[2]', 0.92, 9),
('Sáng tạo + Nghệ thuật → Thiết kế', '{"personality_type": "creative", "interests": ["art", "design"]}', '[10]', 0.88, 7),
('Thích Hóa + Sinh → Y Dược', '{"favorite_subjects": ["chemistry", "biology"]}', '[7, 8]', 0.94, 10),
('Giao tiếp tốt + Kinh doanh → Marketing', '{"skills": ["communication"], "interests": ["business", "marketing"]}', '[5]', 0.87, 7),
('Thích Lý + Toán → Kỹ thuật', '{"favorite_subjects": ["physics", "math"]}', '[1, 3]', 0.90, 8),
('Quan tâm pháp luật → Luật', '{"interests": ["law", "justice"], "skills": ["critical_thinking"]}', '[9]', 0.93, 9),
('Thích Toán + Tài chính → Kế toán', '{"favorite_subjects": ["math"], "interests": ["finance"], "personality_type": "detail-oriented"}', '[6]', 0.89, 7),
('Thu nhập cao + Công nghệ → CNTT/DS', '{"career_goal": "high_income", "interests": ["technology"]}', '[1, 2]', 0.91, 9);

-- ============ DỮ LIỆU KIẾN THỨC MẪU ============
INSERT INTO knowledge_base (entity_type, entity_id, keyword, question, answer, source_url, reliability_score) VALUES
('university', 1, 'ĐHBK Hà Nội cơ sở vật chất', 'Cơ sở vật chất của ĐHBK Hà Nội như thế nào?', 'ĐHBK Hà Nội có hệ thống phòng thí nghiệm hiện đại, thư viện lớn, ký túc xá cho sinh viên, sân thể thao đạt chuẩn.', 'https://www.hust.edu.vn', 0.95),
('major', 1, 'Công nghệ thông tin triển vọng', 'Ngành CNTT có triển vọng không?', 'Ngành CNTT là một trong những ngành hot nhất hiện nay với nhu cầu tuyển dụng cao, lương khởi điểm từ 10-15 triệu, cơ hội thăng tiến nhanh.', 'https://vietnamnet.vn', 0.90),
('admission', 1, 'điểm chuẩn CNTT 2024', 'Điểm chuẩn ngành CNTT các trường năm 2024?', 'ĐHBK HN: 27.5, ĐHQG HN: 26.5, ĐHBK HCM: 28.0, FPT: 22.0', 'https://tuyensinh247.com', 0.92);

-- ========================================
-- ✅ HOÀN TẤT THIẾT KẾ DATABASE
-- ========================================

