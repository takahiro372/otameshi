// 状態管理
let timerInterval = null;
let seconds = 0;
let isRunning = false;

// DOM要素
const timerDisplay = document.getElementById('timer');
const startBtn = document.getElementById('startBtn');
const pauseBtn = document.getElementById('pauseBtn');
const stopBtn = document.getElementById('stopBtn');
const resetBtn = document.getElementById('resetBtn');
const manualMinutes = document.getElementById('manualMinutes');
const saveManualBtn = document.getElementById('saveManualBtn');
const historyList = document.getElementById('historyList');

// 統計要素
const todayTotalEl = document.getElementById('todayTotal');
const weekTotalEl = document.getElementById('weekTotal');
const allTimeTotalEl = document.getElementById('allTimeTotal');
const streakEl = document.getElementById('streak');

// LocalStorage キー
const STORAGE_KEY = 'meditationRecords';

// データ取得
function getRecords() {
    const data = localStorage.getItem(STORAGE_KEY);
    return data ? JSON.parse(data) : [];
}

// データ保存
function saveRecords(records) {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(records));
}

// 記録を追加
function addRecord(minutes) {
    if (minutes <= 0) return;

    const records = getRecords();
    const now = new Date();

    records.push({
        id: Date.now(),
        date: now.toISOString(),
        minutes: minutes,
        timestamp: now.getTime()
    });

    saveRecords(records);
    updateUI();
}

// 記録を削除
function deleteRecord(id) {
    const records = getRecords();
    const filtered = records.filter(record => record.id !== id);
    saveRecords(filtered);
    updateUI();
}

// 時間フォーマット
function formatTime(totalSeconds) {
    const hours = Math.floor(totalSeconds / 3600);
    const minutes = Math.floor((totalSeconds % 3600) / 60);
    const secs = totalSeconds % 60;

    return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(secs).padStart(2, '0')}`;
}

// タイマー更新
function updateTimer() {
    timerDisplay.textContent = formatTime(seconds);
}

// タイマー開始
function startTimer() {
    if (isRunning) return;

    isRunning = true;
    startBtn.disabled = true;
    pauseBtn.disabled = false;
    stopBtn.disabled = false;

    timerInterval = setInterval(() => {
        seconds++;
        updateTimer();
    }, 1000);
}

// タイマー一時停止
function pauseTimer() {
    if (!isRunning) return;

    isRunning = false;
    startBtn.disabled = false;
    pauseBtn.disabled = true;

    clearInterval(timerInterval);
}

// タイマー停止（記録保存）
function stopTimer() {
    if (seconds === 0) return;

    pauseTimer();

    const minutes = Math.round(seconds / 60);
    if (minutes > 0) {
        addRecord(minutes);
    }

    // リセット
    seconds = 0;
    updateTimer();
    startBtn.disabled = false;
    pauseBtn.disabled = true;
    stopBtn.disabled = true;
}

// タイマーリセット
function resetTimer() {
    pauseTimer();
    seconds = 0;
    updateTimer();
    startBtn.disabled = false;
    pauseBtn.disabled = true;
    stopBtn.disabled = true;
}

// 今日の日付を取得（YYYY-MM-DD形式）
function getDateString(date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
}

// 今日の合計を計算
function getTodayTotal() {
    const records = getRecords();
    const today = getDateString(new Date());

    return records
        .filter(record => getDateString(new Date(record.date)) === today)
        .reduce((sum, record) => sum + record.minutes, 0);
}

// 今週の合計を計算
function getWeekTotal() {
    const records = getRecords();
    const now = new Date();
    const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

    return records
        .filter(record => new Date(record.date) >= weekAgo)
        .reduce((sum, record) => sum + record.minutes, 0);
}

// 累計時間を計算
function getAllTimeTotal() {
    const records = getRecords();
    return records.reduce((sum, record) => sum + record.minutes, 0);
}

// 連続日数を計算
function getStreak() {
    const records = getRecords();
    if (records.length === 0) return 0;

    // 日付ごとにグループ化
    const dateMap = new Map();
    records.forEach(record => {
        const dateStr = getDateString(new Date(record.date));
        dateMap.set(dateStr, true);
    });

    let streak = 0;
    let currentDate = new Date();

    // 今日から過去に遡って連続日数をカウント
    while (true) {
        const dateStr = getDateString(currentDate);
        if (dateMap.has(dateStr)) {
            streak++;
            currentDate.setDate(currentDate.getDate() - 1);
        } else {
            break;
        }
    }

    return streak;
}

// 統計を更新
function updateStats() {
    const todayTotal = getTodayTotal();
    const weekTotal = getWeekTotal();
    const allTimeTotal = getAllTimeTotal();
    const streak = getStreak();

    todayTotalEl.textContent = `${todayTotal}分`;
    weekTotalEl.textContent = `${weekTotal}分`;
    allTimeTotalEl.textContent = `${allTimeTotal}分`;
    streakEl.textContent = `${streak}日`;
}

// 履歴を表示
function displayHistory() {
    const records = getRecords();

    if (records.length === 0) {
        historyList.innerHTML = '<p class="no-data">まだ記録がありません</p>';
        return;
    }

    // 日付でグループ化
    const groupedByDate = {};
    records.forEach(record => {
        const dateStr = getDateString(new Date(record.date));
        if (!groupedByDate[dateStr]) {
            groupedByDate[dateStr] = [];
        }
        groupedByDate[dateStr].push(record);
    });

    // 日付順にソート（新しい順）
    const sortedDates = Object.keys(groupedByDate).sort().reverse();

    let html = '';
    sortedDates.forEach(dateStr => {
        const dayRecords = groupedByDate[dateStr];
        const dayTotal = dayRecords.reduce((sum, record) => sum + record.minutes, 0);

        const date = new Date(dateStr);
        const dateFormatted = `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`;

        html += `
            <div class="history-item">
                <div>
                    <div class="history-date">${dateFormatted}</div>
                    <div style="font-size: 0.85rem; color: #666; margin-top: 4px;">
                        ${dayRecords.length}回の瞑想
                    </div>
                </div>
                <div class="history-time">${dayTotal}分</div>
                <button class="history-delete" onclick="deleteRecordsForDate('${dateStr}')">削除</button>
            </div>
        `;
    });

    historyList.innerHTML = html;
}

// 特定の日の記録を削除
function deleteRecordsForDate(dateStr) {
    if (!confirm('この日の記録を削除しますか？')) return;

    const records = getRecords();
    const filtered = records.filter(record =>
        getDateString(new Date(record.date)) !== dateStr
    );

    saveRecords(filtered);
    updateUI();
}

// UI全体を更新
function updateUI() {
    updateStats();
    displayHistory();
}

// 手動記録を保存
function saveManual() {
    const minutes = parseInt(manualMinutes.value);

    if (isNaN(minutes) || minutes <= 0) {
        alert('有効な分数を入力してください');
        return;
    }

    addRecord(minutes);
    manualMinutes.value = '';
}

// イベントリスナー
startBtn.addEventListener('click', startTimer);
pauseBtn.addEventListener('click', pauseTimer);
stopBtn.addEventListener('click', stopTimer);
resetBtn.addEventListener('click', resetTimer);
saveManualBtn.addEventListener('click', saveManual);

// Enterキーで手動記録を保存
manualMinutes.addEventListener('keypress', (e) => {
    if (e.key === 'Enter') {
        saveManual();
    }
});

// グローバル関数として公開（HTML内のonclickから呼ばれるため）
window.deleteRecordsForDate = deleteRecordsForDate;

// 初期化
updateUI();
