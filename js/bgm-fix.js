(function () {
  if (window.__BGM_FIXED__) return;
  window.__BGM_FIXED__ = true;

  document.addEventListener('pjax:complete', function () {
    const ap = document.querySelector('.aplayer');
    if (ap && ap.aplayer) {
      window._bgm_aplayer = ap.aplayer;
    }
  });
})();
