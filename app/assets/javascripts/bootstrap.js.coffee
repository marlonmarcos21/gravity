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
)
