function goChat() {
    window.location.href = "chat.html";
}

function logout() {
    alert("Đăng xuất thành công!");
    window.location.href = "login.html";
}

document.querySelector(".save-btn").onclick = () => {
    alert("Đã lưu thay đổi!");
};
