function uploadAttachment(attachment) {
  const file = attachment.file;
  const form = new FormData;

  form.append('Content-Type', file.type);
  form.append('recipe_medium[file]', file);

  const xhr = new XMLHttpRequest;
  xhr.open('POST', '/recipe_media.json', true);
  xhr.setRequestHeader('X-CSRF-Token', Rails.csrfToken());

  xhr.upload.onprogress = function(event) {
    const progress = event.loaded / event.total * 100;
    attachment.setUploadProgress(progress);
  }

  xhr.onload = function() {
    if (xhr.status === 201) {
      const data = JSON.parse(xhr.responseText);
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
  const attachment = event.attachment;

  if (attachment.file) {
    return uploadAttachment(attachment);
  }
});
