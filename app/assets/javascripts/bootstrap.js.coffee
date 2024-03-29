$ ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  $('.container').on('click', '.li-comment-section', ->
    newCommentForm = $(this).parent().siblings('.new-comment-form')
    newCommentForm.toggle()
    newCommentForm.find('textarea').focus()
    return
  )

  $('.container').on('click', '.comment-new', ->
    newCommentForm = $(this).parent().parent().parent().siblings('.new-comment-form')
    newCommentForm.toggle()
    newCommentForm.find('textarea').focus()
    $(this).parent().siblings('.reply-form').hide()
    return
  )

  $('.container').on('click', '.comment-reply', ->
    replyForm = $(this).parent().next('.reply-form')
    replyForm.toggle()
    replyForm.find('textarea').focus()
    $(this).parent().parent().parent().siblings('.new-comment-form').hide()
    return
  )

  $('body').on('click', '.modal-backdrop', ->
    $('.btn-modal-close').click()
  )

  $('.alert .close').remove();
  $('.alert').delay(3000).fadeOut('slow')

  $.fn.editable.defaults.mode = 'inline'
  $('.editable-post-body').editable(
    ajaxOptions:
      type: 'patch'
      dataType: 'json'
  )
  $('.editable-comment-body').editable(
    ajaxOptions:
      type: 'patch'
      dataType: 'json'
  )

  $('.end-of-internet').delay(3000).fadeOut('slow')

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
        return (el.tagName && el.tagName.toUpperCase() == 'DIV')
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

  $('.container').on('submit', '.new_comment', (e) ->
    e.preventDefault()
    if ($(this).find('.new-comment-body').val().trim() == '')
      html = '<div class="modal" id="confirmationDialog"><a data-dismiss="modal" class="blank-post btn btn-modal-close btn-xs">×</a><div class="modal-body"><p>Comment is blank, it defeats its purpose in life!</p></div></div>'
      $(html).modal()
      return false
  )

  $('.log-me-in').click(->
    $(this).hide()
    $('.forgot-password').hide()
    $('.sign-in-form').removeClass('hidden')
    $('#user_email').focus()
  )

  $('.container').on('click', '.comments-header', ->
    $('.log-me-in').hide()
    $('.forgot-password').hide()
    $('.forgot-password-form').addClass('hidden')
    $('.sign-in-form').removeClass('hidden')
    if $('.navbar-toggle').is(':visible')
      $('.navbar-toggle').click()
    $('#user_email').focus()
    return
  )

  $('.cancel-log-in').click(->
    $('.sign-in-form').addClass('hidden')
    $('.log-me-in').show()
    $('.forgot-password').show()
  )

  $('.forgot-password').click(->
    $(this).hide()
    $('.log-me-in').hide()
    $('.sign-in-form').addClass('hidden')
    $('.forgot-password-form').removeClass('hidden')
    $('#user_email_forgot_pw').focus()
  )

  $('.cancel-forgot-password').click(->
    $('.forgot-password-form').addClass('hidden')
    $('.log-me-in').show()
    $('.forgot-password').show()
  )

  $('form#new_user').submit((e) ->
    email = $('input#user_email').val().trim()
    pass = $('input#user_password').val().trim()
    if (email == '' || pass == '')
      e.preventDefault()
      html = '<div class="modal" id="confirmationDialog"><a data-dismiss="modal" class="blank-post btn btn-modal-close btn-xs">×</a><div class="modal-body"><p>Email and Password required!</p></div></div>'
      $(html).modal()
      return false
  )

  $('form#new_user_forgot_pw').submit((e) ->
    email = $('input#user_email_forgot_pw').val().trim()
    if (email == '')
      e.preventDefault()
      html = '<div class="modal" id="confirmationDialog"><a data-dismiss="modal" class="blank-post btn btn-modal-close btn-xs">×</a><div class="modal-body"><p>Email required!</p></div></div>'
      $(html).modal()
      return false
  )

  $('.desktop-search-form').submit((e) ->
    if ($(this).find('#search_search').val().trim() == '')
      e.preventDefault();
      html = '<div class="modal" id="confirmationDialog"><a data-dismiss="modal" class="blank-post btn btn-modal-close btn-xs">×</a><div class="modal-body"><p>Search is blank, it defeats its purpose in life!</p></div></div>'
      $(html).modal()
      return false
  )

  $('.mobile-search-form').submit((e) ->
    if ($(this).find('#search_search').val().trim() == '')
      e.preventDefault();
      html = '<div class="modal" id="confirmationDialog"><a data-dismiss="modal" class="blank-post btn btn-modal-close btn-xs">×</a><div class="modal-body"><p>Search is blank, it defeats its purpose in life!</p></div></div>'
      $(html).modal()
      return false
  )

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
      $('#post-'+link.attr('data-id')).remove()
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

  $('.end-of-internet').delay(3000).fadeOut('slow')

  $('textarea').each(->
    $(this).val('')
  )

  if (request.responseJSON)
    if (request.responseJSON.message == 'Comment deleted!')
      totalComments = parseInt(request.responseJSON.total_comments)
      if totalComments == 0
        text = 'Comment'
      else if totalComments == 1
        text = '1 Comment'
      else
        text = totalComments + ' Comments'

      elementId = request.responseJSON.element_id
      elTarget = $('#' + elementId + ' .li-comment-section h6')
      elTarget.html(text)
      if totalComments == 0
        elTarget.parent().parent().next('.comments-container').children().remove()

    if (request.responseJSON.content && request.responseJSON.post_id)
      html = '<i class="fa fa-edit"></i> ' + request.responseJSON.content
      if request.responseJSON.private == true
        html = '<i class="fa fa-lock"></i> ' + html
      $('.post-body-' + request.responseJSON.post_id).html(html)

    if (request.responseJSON.content && request.responseJSON.comment_id)
      html = '<i class="fa fa-edit"></i> ' + request.responseJSON.content
      $('.comment-body-' + request.responseJSON.comment_id).html(html)

    if (request.responseJSON.key == 'post_like_unlike')
      postId = request.responseJSON.post_id
      action = request.responseJSON.action
      totalLikes = request.responseJSON.total_likes
      parent = $('#thumbs-up-' + postId).parent('a')
      if (action == 'like')
        $('#thumbs-up-' + postId).attr('class', 'fa fa-thumbs-up')
        parent.attr('href', '/posts/' + postId + '/unlike')
      else
        $('#thumbs-up-' + postId).attr('class', 'fa fa-thumbs-o-up')
        parent.attr('href', '/posts/' + postId + '/like')

      if (totalLikes == 0)
        $('#thumbs-up-text-' + postId).text('Like |')
      else
        text = 'Likes'
        if (totalLikes == 1)
          text = 'Like'
        $('#thumbs-up-text-' + postId).text(totalLikes + ' ' + text + ' |')

    if (request.responseJSON.key == 'blog_like_unlike')
      blogId = request.responseJSON.blog_id
      action = request.responseJSON.action
      totalLikes = request.responseJSON.total_likes
      parent = $('#thumbs-up-' + blogId).parent('a')
      if (action == 'like')
        $('#thumbs-up-' + blogId).attr('class', 'fa fa-thumbs-up')
        parent.attr('href', '/blogs/' + blogId + '/unlike')
      else
        $('#thumbs-up-' + blogId).attr('class', 'fa fa-thumbs-o-up')
        parent.attr('href', '/blogs/' + blogId + '/like')

      if (totalLikes == 0)
        $('#thumbs-up-text-' + blogId).text('Like |')
      else
        text = 'Likes'
        if (totalLikes == 1)
          text = 'Like'
        $('#thumbs-up-text-' + blogId).text(totalLikes + ' ' + text + ' |')


  $.fn.editable.defaults.mode = 'inline'
  $('.editable-post-body').editable(
    ajaxOptions:
      type: 'patch'
      dataType: 'json'
  )
  $('.editable-comment-body').editable(
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
        return (el.tagName && el.tagName.toUpperCase() == 'DIV')
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
