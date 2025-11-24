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
                {
                    name: "Heal The World",
                    artist: "Michael Jackson",
                    url: "http://music.163.com/song/media/outer/url?id=21177655.mp3",
                    cover: "https://p1.music.126.net/R9da4JvRAhwM3JWfNegySg==/632219185982051.jpg?param=90y90",

                },
                {
                    name:"The Lady in My Life",
                    artist:"Michael Jackson",
                    url:"http://music.163.com/song/media/outer/url?id=21178265.mp3",
                    cover:"https://p2.music.126.net/U7pqYhbbgxjPx1NYUGOGQQ==/109951165958551789.jpg?param=90y90",
                },
                {
                    name:"You Are Not Alone",
                    artist:"Michael Jackson",
                    url:"http://music.163.com/song/media/outer/url?id=27674443.mp3",
                    cover:"https://p2.music.126.net/1d4ohVbbsL6sPLBVNF8xtA==/6636652185905875.jpg?param=90y90",
                },
                {
                    name:"We Are The World(Demo)",
                    artist:"Michael Jackson",
                    url:"http://music.163.com/song/media/outer/url?id=27505451.mp3",
                    cover:"https://p2.music.126.net/nGFJF1DBUNUSvGHLkub8YQ==/2535473814012575.jpg?param=90y90",
                }
                {
                    name:"Man In The Mirror",
                    artist:"Michael Jackson",
                    url:"http://music.163.com/song/media/outer/url?id=1699483.mp3",
                    cover:"https://p2.music.126.net/PpasATnY_8tvtkHAjNQMcg==/109951163016449902.jpg?param=90y90",
                }
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
