jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

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
)

$(document).ready(->
  imgLoader = 'data:image/gif;base64,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'

  $("#posts .posts-container").infinitescroll
    navSelector: 'nav.pagination'
    nextSelector: 'nav.pagination a[rel=next]'
    itemSelector: '#posts div.post-preview'
    loading:
      img: imgLoader
      msgText: '<em>Loading...</em>'

  $("#blogs .blogs-container").infinitescroll
    navSelector: 'nav.pagination'
    nextSelector: 'nav.pagination a[rel=next]'
    itemSelector: '#blogs div.blog-preview'
    loading:
      img: imgLoader
      msgText: '<em>Loading...</em>'
)
