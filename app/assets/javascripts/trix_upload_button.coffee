buttonAction = "x-attach"
buttonSelector = "button[data-trix-action='#{buttonAction}']"
buttonHTML = """<button type="button" class="icon attach" data-trix-action="#{buttonAction}">Attach Files</button>"""

$(Trix.config.toolbar.content).find(".button_group.block_tools").append(buttonHTML)

$(document).on "trix-initialize", ($event) ->
  editorElement = $event.target
  {toolbarElement} = editorElement

  $(toolbarElement).find(buttonSelector).on "click", ->
    editorElement.focus()

    pickFiles (files) ->
      for file in files
        editorElement.editor.insertFile(file)

    false

pickFiles = (callback) ->
  $fileInput = $("""<input type="file" multiple>""")
  $fileInput.hide().appendTo("body")

  uninstall = ->
    if $fileInput
      $fileInput.remove()
      $fileInput = null

  $fileInput.on "change", (event) ->
    callback(@files)
    uninstall()

  $fileInput.click()

  requestAnimationFrame ->
    $(document).one("click", uninstall)
