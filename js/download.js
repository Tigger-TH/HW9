/* =========================================================
   download.js
   Forces links marked with [download] to actually save a file,
   even in cases where the browser would otherwise just open
   the file inline (e.g. plain-text files, or some file://
   / local-server setups where the native `download` attribute
   is ignored).
   ========================================================= */
(function () {
  function triggerBlobDownload(url, filename) {
    fetch(url)
      .then(function (response) {
        if (!response.ok) throw new Error('ไม่พบไฟล์: ' + url);
        return response.blob();
      })
      .then(function (blob) {
        var blobUrl = URL.createObjectURL(blob);
        var tempLink = document.createElement('a');
        tempLink.href = blobUrl;
        tempLink.download = filename;
        document.body.appendChild(tempLink);
        tempLink.click();
        tempLink.remove();
        setTimeout(function () { URL.revokeObjectURL(blobUrl); }, 1000);
      })
      .catch(function () {
        /* Fallback: just navigate to the file so the user can
           save it manually (e.g. Ctrl+S) if fetch is blocked. */
        window.location.href = url;
      });
  }

  document.addEventListener('DOMContentLoaded', function () {
    var links = document.querySelectorAll('a[download]');
    links.forEach(function (link) {
      link.addEventListener('click', function (e) {
        e.preventDefault();
        var url = link.getAttribute('href');
        var filename = link.getAttribute('download') || url.split('/').pop();
        triggerBlobDownload(url, filename);
      });
    });
  });
})();
