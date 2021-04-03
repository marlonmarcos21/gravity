function uploadAttachment(attachment) {
  var file = attachment.file;
  var form = new FormData;
  var csrfToken = $('input[name="authenticity_token"]').val();

  form.append('Content-Type', file.type);
  form.append('recipe_medium[file]', file);

  var xhr = new XMLHttpRequest;
  xhr.open('POST', '/recipe_media.json', true);
  xhr.setRequestHeader('X-CSRF-Token', csrfToken);

  xhr.upload.onprogress = function(event) {
    var progress = event.loaded / event.total * 100;
    attachment.setUploadProgress(progress);
  }

  xhr.onload = function() {
    if (xhr.status === 201) {
      var data = JSON.parse(xhr.responseText);
      return attachment.setAttributes({
        url: data.url,
        href: data.url,
        src: data.url,
      })
    }
  }

  return xhr.send(form);
}

document.addEventListener('trix-attachment-add', function(event) {
  var attachment = event.attachment;

  if (attachment.file) {
    return uploadAttachment(attachment);
  }
});
