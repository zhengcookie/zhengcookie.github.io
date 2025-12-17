if (!window._aplayer_inited) {
  window._aplayer_inited = true;

  document.addEventListener('DOMContentLoaded', function () {
    const el = document.querySelector('.aplayer');
    if (el && el.aplayer) {
      window.globalAPlayer = el.aplayer;
    }
  });
}
