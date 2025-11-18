const API_BASE_URL = 'http://127.0.0.1:5000';

document.getElementById("btnLogin").onclick = async () => {
    const email = document.getElementById("email")?.value || document.querySelector('input[type="email"]')?.value;
    const username = document.getElementById("username")?.value || document.querySelector('input[type="text"]')?.value;
    const password = document.getElementById("password")?.value || document.querySelector('input[type="password"]')?.value;

    // Validation
    if ((!email && !username) || !password) {
        alert("Vui lòng nhập đầy đủ thông tin!");
        return;
    }

    try {
        const response = await fetch(`${API_BASE_URL}/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                email: email,
                username: username,
                password: password
            })
        });

        const data = await response.json();

        if (data.status === 'success') {
            // Lưu thông tin user vào localStorage
            localStorage.setItem('currentUser', JSON.stringify(data.user));
            
            alert('Đăng nhập thành công! 🎉');
            
            // Redirect to chat
            window.location.href = "../chat/chat.html";
        } else {
            alert('Lỗi: ' + (data.message || 'Đăng nhập thất bại!'));
        }
    } catch (error) {
        console.error('Login error:', error);
        alert('Không thể kết nối đến server! Vui lòng kiểm tra backend đã chạy chưa.');
    }
};

document.getElementById("btnSignup").onclick = () => {
    window.location.href = "../signup/signup.html";
};

document.getElementById("btnGoogle").onclick = () => {
    alert("Google OAuth chưa được kết nối!");
};

document.getElementById("reset").onclick = () => {
    alert("Trang reset password chưa tạo!");
};

// Hỗ trợ Enter để login
document.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        document.getElementById("btnLogin").click();
    }
});
