$ ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  $('.comment-reply').click(->
    $('.reply-form').each(->
      $(this).hide()
    )
    $(this).parent().next('.reply-form').show()

    $('#new-comment-toggle').show()
    $('.new-comment-form').hide()
    return
  )

  $('#new-comment-toggle').click(->
    $('.reply-form').each(->
      $(this).hide()
    )
    $(this).hide()
    $('.new-comment-form').show()
    return
  )

  if ($('.new-comment-body').val() == '')
    $('.submit-new-comment').attr('disabled', true)

  $('.new-comment-body').keyup(->
    if ($('.new-comment-body').val() != '')
      $('.submit-new-comment').attr('disabled', false)
    else
      $('.submit-new-comment').attr('disabled', true)
  )

  $('.reply-comment-body').each(->
    if ($(this).val() == '')
      $(this).parent().next('.submit-reply-comment').attr('disabled', true)

    $(this).keyup(->
      if ($(this).val() != '')
        $(this).parent().next('.submit-reply-comment').attr('disabled', false)
      else
        $(this).parent().next('.submit-reply-comment').attr('disabled', true)
    )
  )

  $('.alert .close').remove();
  $('.alert').delay(3000).fadeOut('slow')

  imgLoader = 'data:image/gif;base64,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'

  $("#posts #posts-container").infinitescroll
    navSelector: 'nav.pagination'
    nextSelector: 'nav.pagination a[rel=next]'
    itemSelector: '#posts div.post-preview'
    loading:
      img: imgLoader
      msgText: ''

  $("#blogs .blogs-container").infinitescroll
    navSelector: 'nav.pagination'
    nextSelector: 'nav.pagination a[rel=next]'
    itemSelector: '#blogs div.blog-preview'
    loading:
      img: imgLoader
      msgText: ''

  $.fn.editable.defaults.mode = 'inline'
  $('.editable-post-body').editable(
    ajaxOptions:
      type: 'patch'
      dataType: 'json'
  )

  initPhotoSwipeFromDOM = (gallerySelector) ->
    parseThumbnailElements = (el) ->
      thumbElements = el.childNodes
      numNodes = thumbElements.length
      items = []

      for i in [0..numNodes - 1]
        figureEl = thumbElements[i]

        if (figureEl.nodeType != 1)
          continue

        linkEl = figureEl.children[0]
        size = linkEl.getAttribute('data-size').split('x')

        item = {
          src: linkEl.getAttribute('href'),
          w: parseInt(size[0], 10),
          h: parseInt(size[1], 10)
        }

        if (figureEl.children.length > 1)
          item.title = figureEl.children[1].innerHTML

        if (linkEl.children.length > 0)
          item.msrc = linkEl.children[0].getAttribute('src')

        item.el = figureEl
        items.push(item)

      return items

    closest = (el, fn) ->
      if el
        if fn(el)
          el
        else
          closest(el.parentNode, fn)

    onThumbnailsClick = (e) ->
      e = e || window.event

      if e.preventDefault
        e.preventDefault()
      else
        e.returnValue = false

      eTarget = e.target || e.srcElement
      clickedListItem = closest(eTarget, (el) ->
        return (el.tagName && el.tagName.toUpperCase() == 'FIGURE')
      )

      if (!clickedListItem)
        return

      clickedGallery = clickedListItem.parentNode
      childNodes = clickedListItem.parentNode.childNodes
      numChildNodes = childNodes.length
      nodeIndex = 0

      for i in [0..numChildNodes - 1]
        if (childNodes[i].nodeType != 1)
          continue

        if (childNodes[i] == clickedListItem)
          index = nodeIndex
          break

        nodeIndex++

      if (index >= 0)
        openPhotoSwipe(index, clickedGallery)

      return false

    photoswipeParseHash = ->
      hash = window.location.hash.substring(1)
      params = {}

      if (hash.length < 5)
        return params

      vars = hash.split('&')
      for i in [0..vars.length -1]
        if (!vars[i])
          continue

        pair = vars[i].split('=')
        if (pair.length < 2)
          continue

        params[pair[0]] = pair[1]

      if (params.gid)
        params.gid = parseInt(params.gid, 10)

      return params

    openPhotoSwipe = (index, galleryElement, disableAnimation, fromURL) ->
      pswpElement = document.querySelectorAll('.pswp')[0]

      items = parseThumbnailElements(galleryElement)

      options = {
        galleryUID: galleryElement.getAttribute('data-pswp-uid'),
        getThumbBoundsFn: (index) ->
          thumbnail = items[index].el.getElementsByTagName('img')[0]
          pageYScroll = window.pageYOffset || document.documentElement.scrollTop
          rect = thumbnail.getBoundingClientRect()

          return {x:rect.left, y:rect.top + pageYScroll, w:rect.width}
      }

      if (fromURL)
        if (options.galleryPIDs)
          for j in [0..items.length -1]
              if(items[j].pid == index)
                options.index = j
                break
        else
          options.index = parseInt(index, 10) - 1
      else
        options.index = parseInt(index, 10)

      if (isNaN(options.index))
        return

      if (disableAnimation)
        options.showAnimationDuration = 0

      gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options)
      gallery.init()

    galleryElements = document.querySelectorAll(gallerySelector)

    for i in [0..galleryElements.length-1]
      galleryElements[i].setAttribute('data-pswp-uid', i+1)
      galleryElements[i].onclick = onThumbnailsClick

    hashData = photoswipeParseHash()
    if (hashData.pid && hashData.gid)
      openPhotoSwipe(hashData.pid, galleryElements[hashData.gid - 1], true, true)

  if ($('.my-gallery').length)
    initPhotoSwipeFromDOM('.my-gallery')

$.rails.allowAction = (link) ->
  return true unless link.attr('data-confirm')
  $.rails.showConfirmDialog(link)
  false

$.rails.confirmed = (link) ->
  ajax = link.attr('data-ajax')
  link.removeAttr('data-confirm')
  if (ajax == 'true')
    $.ajax({
      url: link.attr('href'),
      method: 'delete',
      dataType: 'json'
    }).done((data) ->
      if link.attr('data-parent') == 'true'
        link.parent().parent().siblings().remove()
        link.parent().parent().parent().next('#comment-reply-form').remove()

      link.parent().parent().remove()
    )
  else
    link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
  message = link.attr 'data-confirm'
  html = """
         <div class="modal" id="confirmationDialog">
           <div class="modal-body">
             <p>#{message}</p>
           </div>
           <div class="modal-footer">
             <a data-dismiss="modal" class="btn btn-default">Cancel</a>
             <a data-dismiss="modal" class="btn btn-danger confirm">Confirm</a>
           </div>
         </div>
         """
  $(html).modal()
  $('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)


fadeFlash = ->
  $('#flash-notice').delay(3000).fadeOut('slow')
  $('#flash-alert').delay(3000).fadeOut('slow')

showAjaxMessage = (msg, type) ->
  $('#ajax-flash-msg').html('<div id="flash-'+type+'">'+msg+'</div>')
  fadeFlash()

$(document).ajaxComplete((event, request) ->
  msg = request.getResponseHeader('X-Message')
  type = request.getResponseHeader('X-Message-Type')
  if (msg != null)
    showAjaxMessage(msg, type)

  $('#comment-reply-form .reply-form').each(->
    $(this).css('display', 'none');
  )

  $('textarea').each(->
    $(this).val('')
  )

  if (request.responseJSON)
    if (request.responseJSON.message == 'Comment deleted!')
      totalComments = request.responseJSON.total_comments
      $('.comments-header h4').html(totalComments + ' Comments')

    if (request.responseJSON.content && request.responseJSON.post_id)
      $('.post-body-' + request.responseJSON.post_id).html(request.responseJSON.content)

  $.fn.editable.defaults.mode = 'inline'
  $('.editable-post-body').editable(
    ajaxOptions:
      type: 'patch'
      dataType: 'json'
  )

  initPhotoSwipeFromDOM = (gallerySelector) ->
    parseThumbnailElements = (el) ->
      thumbElements = el.childNodes
      numNodes = thumbElements.length
      items = []

      for i in [0..numNodes - 1]
        figureEl = thumbElements[i]

        if (figureEl.nodeType != 1)
          continue

        linkEl = figureEl.children[0]
        size = linkEl.getAttribute('data-size').split('x')

        item = {
          src: linkEl.getAttribute('href'),
          w: parseInt(size[0], 10),
          h: parseInt(size[1], 10)
        }

        if (figureEl.children.length > 1)
          item.title = figureEl.children[1].innerHTML

        if (linkEl.children.length > 0)
          item.msrc = linkEl.children[0].getAttribute('src')

        item.el = figureEl
        items.push(item)

      return items

    closest = (el, fn) ->
      if el
        if fn(el)
          el
        else
          closest(el.parentNode, fn)

    onThumbnailsClick = (e) ->
      e = e || window.event

      if e.preventDefault
        e.preventDefault()
      else
        e.returnValue = false

      eTarget = e.target || e.srcElement
      clickedListItem = closest(eTarget, (el) ->
        return (el.tagName && el.tagName.toUpperCase() == 'FIGURE')
      )

      if (!clickedListItem)
        return

      clickedGallery = clickedListItem.parentNode
      childNodes = clickedListItem.parentNode.childNodes
      numChildNodes = childNodes.length
      nodeIndex = 0

      for i in [0..numChildNodes - 1]
        if (childNodes[i].nodeType != 1)
          continue

        if (childNodes[i] == clickedListItem)
          index = nodeIndex
          break

        nodeIndex++

      if (index >= 0)
        openPhotoSwipe(index, clickedGallery)

      return false

    photoswipeParseHash = ->
      hash = window.location.hash.substring(1)
      params = {}

      if (hash.length < 5)
        return params

      vars = hash.split('&')
      for i in [0..vars.length -1]
        if (!vars[i])
          continue

        pair = vars[i].split('=')
        if (pair.length < 2)
          continue

        params[pair[0]] = pair[1]

      if (params.gid)
        params.gid = parseInt(params.gid, 10)

      return params

    openPhotoSwipe = (index, galleryElement, disableAnimation, fromURL) ->
      pswpElement = document.querySelectorAll('.pswp')[0]

      items = parseThumbnailElements(galleryElement)

      options = {
        galleryUID: galleryElement.getAttribute('data-pswp-uid'),
        getThumbBoundsFn: (index) ->
          thumbnail = items[index].el.getElementsByTagName('img')[0]
          pageYScroll = window.pageYOffset || document.documentElement.scrollTop
          rect = thumbnail.getBoundingClientRect()

          return {x:rect.left, y:rect.top + pageYScroll, w:rect.width}
      }

      if (fromURL)
        if (options.galleryPIDs)
          for j in [0..items.length -1]
              if(items[j].pid == index)
                options.index = j
                break
        else
          options.index = parseInt(index, 10) - 1
      else
        options.index = parseInt(index, 10)

      if (isNaN(options.index))
        return

      if (disableAnimation)
        options.showAnimationDuration = 0

      gallery = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options)
      gallery.init()

    galleryElements = document.querySelectorAll(gallerySelector)

    for i in [0..galleryElements.length-1]
      galleryElements[i].setAttribute('data-pswp-uid', i+1)
      galleryElements[i].onclick = onThumbnailsClick

    hashData = photoswipeParseHash()
    if (hashData.pid && hashData.gid)
      openPhotoSwipe(hashData.pid, galleryElements[hashData.gid - 1], true, true)

  if ($('.my-gallery').length)
    initPhotoSwipeFromDOM('.my-gallery')
)
