// ========================================
// 🤖 EDUBOT AI - Chat Interface
// ========================================

const API_BASE_URL = 'http://127.0.0.1:5000/api/chat';

const chatBox = document.getElementById("chatBox");
const historyList = document.getElementById("historyList");
const input = document.getElementById("messageInput");
const sendBtn = document.getElementById("sendBtn");
const newChatBtn = document.getElementById("newChatBtn");
const typingIndicator = document.getElementById("typingIndicator");
const loadingOverlay = document.getElementById("loadingOverlay");
const statusText = document.getElementById("statusText");

let currentSessionId = null;
let isWaitingForResponse = false;
let history = JSON.parse(localStorage.getItem("chatHistory")) || [];

/* ===== INITIALIZATION ===== */
document.addEventListener('DOMContentLoaded', () => {
    loadHistory();
    setupEventListeners();
    checkUserLogin();
});

function setupEventListeners() {
    sendBtn.onclick = sendMessage;
    newChatBtn.onclick = startNewChat;
    
    input.addEventListener('keydown', (e) => {
        if (e.key === 'Enter' && !e.shiftKey) {
            e.preventDefault();
            sendMessage();
        }
    });
    
    // Auto-resize textarea
    input.addEventListener('input', () => {
        input.style.height = 'auto';
        input.style.height = input.scrollHeight + 'px';
    });
    
    document.getElementById("profileBtn").onclick = () => {
        window.location.href = "../profile/profile.html";
    };
    
    document.getElementById("logoutBtn").onclick = () => {
        localStorage.removeItem('currentUser');
        localStorage.removeItem('chatHistory');
        window.location.href = "../login/login.html";
    };
}

function checkUserLogin() {
    const currentUser = localStorage.getItem('currentUser');
    if (!currentUser) {
        alert('Vui lòng đăng nhập trước!');
        window.location.href = "../login/login.html";
        return false;
    }
    return true;
}

/* ===== CHAT SESSION MANAGEMENT ===== */
async function startNewChat() {
    try {
        showLoading('Đang khởi tạo session...');
        
        const currentUser = JSON.parse(localStorage.getItem('currentUser') || '{}');
        const userId = currentUser.id || null;
        
        const response = await fetch(`${API_BASE_URL}/start`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ user_id: userId })
        });
        
        const data = await response.json();
        
        if (data.status === 'success') {
            currentSessionId = data.session_id;
            
            // Clear chat box
            chatBox.innerHTML = '';
            
            // Display greeting
            addMessage(data.message, 'ai');
            
            // Save to history
            saveToHistory('Bắt đầu tư vấn mới', data.message);
            
            hideLoading();
            input.focus();
        } else {
            throw new Error(data.message || 'Không thể bắt đầu chat');
        }
    } catch (error) {
        console.error('Error starting chat:', error);
        hideLoading();
        alert('Lỗi khi bắt đầu chat: ' + error.message);
    }
}

/* ===== MESSAGE HANDLING ===== */
async function sendMessage() {
    if (isWaitingForResponse) {
        return;
    }
    
    const text = input.value.trim();
    if (text === "") {
        return;
    }
    
    // Check if session exists
    if (!currentSessionId) {
        await startNewChat();
        // Wait a bit then send message
        setTimeout(() => {
            input.value = text;
            sendMessage();
        }, 500);
        return;
    }
    
    // Clear input
    input.value = "";
    input.style.height = 'auto';
    
    // Add user message to UI
    addMessage(text, 'me');
    
    // Show typing indicator
    showTyping();
    isWaitingForResponse = true;
    
    try {
        const response = await fetch(`${API_BASE_URL}/message`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                session_id: currentSessionId,
                message: text
            })
        });
        
        const data = await response.json();
        
        hideTyping();
        isWaitingForResponse = false;
        
        if (data.status === 'success') {
            // Add bot reply
            addMessage(data.reply, 'ai');
            
            // Save to history
            saveToHistory(text, data.reply);
            
            // If recommendations available, display them
            if (data.recommendations && data.recommendations.majors) {
                displayRecommendations(data.recommendations);
            }
        } else {
            throw new Error(data.message || 'Không nhận được phản hồi');
        }
    } catch (error) {
        console.error('Error sending message:', error);
        hideTyping();
        isWaitingForResponse = false;
        addMessage('❌ Lỗi: Không thể kết nối đến server. Vui lòng thử lại!', 'ai');
    }
    
    input.focus();
}

/* ===== UI FUNCTIONS ===== */
function addMessage(text, type) {
    const messageDiv = document.createElement('div');
    messageDiv.className = `message ${type}`;
    
    // Format text with line breaks
    const formattedText = text.replace(/\n/g, '<br>');
    messageDiv.innerHTML = formattedText;
    
    // Add timestamp
    const timeDiv = document.createElement('div');
    timeDiv.className = 'message-time';
    timeDiv.textContent = new Date().toLocaleTimeString('vi-VN', { 
        hour: '2-digit', 
        minute: '2-digit' 
    });
    messageDiv.appendChild(timeDiv);
    
    chatBox.appendChild(messageDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
    
    // Remove welcome message if exists
    const welcomeMsg = chatBox.querySelector('.welcome-message');
    if (welcomeMsg) {
        welcomeMsg.remove();
    }
}

function displayRecommendations(recommendations) {
    if (!recommendations.majors || recommendations.majors.length === 0) {
        return;
    }
    
    const recDiv = document.createElement('div');
    recDiv.className = 'message ai';
    
    let html = '<div style="margin-top: 20px;"><strong>📊 THỐNG KÊ KẾT QUẢ:</strong><br><br>';
    
    // Display majors
    html += '<strong>🎓 Ngành học được đề xuất:</strong><br>';
    recommendations.majors.forEach((major, idx) => {
        html += `<div class="recommendation-card">`;
        html += `<h4>${idx + 1}. ${major.major_name}</h4>`;
        html += `<p>📊 Độ phù hợp: <strong>${major.confidence}%</strong></p>`;
        html += `<p>💡 ${major.explanation}</p>`;
        html += `</div>`;
    });
    
    // Display universities
    if (recommendations.universities && recommendations.universities.length > 0) {
        html += '<br><strong>🏫 Trường đại học được đề xuất:</strong><br>';
        recommendations.universities.forEach((uni, idx) => {
            html += `<div class="recommendation-card">`;
            html += `<h4>${idx + 1}. ${uni.university_name}</h4>`;
            html += `<p>📍 ${uni.city || 'N/A'}</p>`;
            html += `<p>🎓 Ngành: ${uni.major_name}</p>`;
            html += `<p>📊 Điểm chuẩn: ${uni.admission_score || 'N/A'}</p>`;
            html += `<p>💰 Học phí: ${(uni.tuition_fee / 1000000).toFixed(1)} triệu/năm</p>`;
            html += `</div>`;
        });
    }
    
    html += '</div>';
    recDiv.innerHTML = html;
    chatBox.appendChild(recDiv);
    chatBox.scrollTop = chatBox.scrollHeight;
}

function showTyping() {
    typingIndicator.style.display = 'flex';
}

function hideTyping() {
    typingIndicator.style.display = 'none';
}

function showLoading(message = 'Đang xử lý...') {
    loadingOverlay.querySelector('p').textContent = message;
    loadingOverlay.style.display = 'flex';
}

function hideLoading() {
    loadingOverlay.style.display = 'none';
}

/* ===== HISTORY MANAGEMENT ===== */
function saveToHistory(question, answer) {
    const historyItem = {
        id: Date.now(),
        question: question.substring(0, 50) + (question.length > 50 ? '...' : ''),
        answer: answer,
        timestamp: new Date().toISOString(),
        sessionId: currentSessionId
    };
    
    history.unshift(historyItem);
    
    // Keep only last 20 items
    if (history.length > 20) {
        history = history.slice(0, 20);
    }
    
    localStorage.setItem("chatHistory", JSON.stringify(history));
    loadHistory();
}

function loadHistory() {
    historyList.innerHTML = "";
    
    if (history.length === 0) {
        historyList.innerHTML = '<p style="color: rgba(255,255,255,0.5); font-size: 13px; text-align: center; padding: 20px;">Chưa có lịch sử</p>';
        return;
    }
    
    history.forEach((item, index) => {
        const div = document.createElement("div");
        div.className = "history-item";
        div.innerHTML = `
            <div style="font-weight: 600; margin-bottom: 5px;">${item.question}</div>
            <div style="font-size: 11px; opacity: 0.7;">${new Date(item.timestamp).toLocaleDateString('vi-VN')}</div>
        `;
        div.onclick = () => loadConversation(index);
        historyList.appendChild(div);
    });
}

function loadConversation(index) {
    const item = history[index];
    chatBox.innerHTML = "";
    
    addMessage(item.question, "me");
    addMessage(item.answer, "ai");
}

/* ===== AUTO START CHAT ON LOAD ===== */
window.addEventListener('load', () => {
    // Don't auto-start, let user click "Bắt đầu tư vấn mới"
});
