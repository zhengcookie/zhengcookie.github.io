var ap;
function initPlayer() {
    if (!ap) {
        ap = new APlayer({
            container: document.getElementById('aplayer'),
            fixed: true,
            lrcType: 0,  // 禁用字幕
            audio: [
                {
                    name: 'Deadman（爱坤版）',
                    artist: '木子轩 / 七七丫',
                    url: 'http://music.163.com/song/media/outer/url?id=2719626532.mp3',
                    cover: 'https://p2.music.126.net/HfwxTYIDNxgZNa-w4r6fmg==/109951170835101706.jpg?param=90y90',
                },
            ]
        });
    }
}

// 页面加载时初始化播放器
window.onload = initPlayer;
// 保存播放进度
ap.on('play', function () {
    localStorage.setItem('currentTime', ap.audio.currentTime);
});

// 恢复播放进度
window.onload = function() {
    if (localStorage.getItem('currentTime')) {
        ap.audio.currentTime = localStorage.getItem('currentTime');
    }
};
window.onbeforeunload = function() {
    localStorage.setItem('currentTime', ap.audio.currentTime);
};
