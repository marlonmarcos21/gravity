$ ->
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
