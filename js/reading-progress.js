// source/js/reading-progress.js
(function() {
    const bar = document.createElement('div');
    bar.id = 'reading-progress';
    document.body.appendChild(bar);
    document.body.classList.add('has-progressbar');


    const set = () => {
        const doc = document.documentElement;
        const scrolled = (doc.scrollTop || document.body.scrollTop);
        const height = (doc.scrollHeight - doc.clientHeight);
        const percent = height > 0 ? (scrolled / height) * 100 : 0;
        bar.style.width = percent + '%';
    };
    window.addEventListener('scroll', set, { passive: true });
    window.addEventListener('resize', set);
    document.addEventListener('DOMContentLoaded', set);
    set();
})();