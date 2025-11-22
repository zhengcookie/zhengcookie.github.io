const ap = new APlayer({
    container: document.getElementById('aplayer'),
    fixed: true,
    lrcType: 3,
    audio: [
        {
            name: 'Deadman（爱坤版）',
            artist: '木子轩 / 七七丫',
            url: 'https://music.163.com/#/song?id=2719626532',
            cover: 'https://p2.music.126.net/HfwxTYIDNxgZNa-w4r6fmg==/109951170835101706.jpg?param=90y90',
        },
        {
            name: '花の塔',
            artist: 'さユり',
            url: 'http://music.163.com/song/media/outer/url?id=1956534872.mp3',
            cover: 'https://p2.music.126.net/fS_5RbP_4qg-RYreqp2tGg==/109951167558017839.jpg?param=130y130',
            lrc: 'https://moechun.fun/music/lrc/さユり - 花の塔.lrc'
        },
    ]
});