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

      link.parent().parent().parent().remove()
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

  $('#end-of-internet').delay(3000).fadeOut('slow')

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
