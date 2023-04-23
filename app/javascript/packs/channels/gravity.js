import consumer from './consumer'

consumer.subscriptions.create('GravityChannel', {
  // received(data) {
  //   // new Gravity(data["title"], { body: data["body"] })
  //   console.log('tae ka');
  // },

  received(data) {
    this.appendLine(data)
  },

  appendLine(data) {
    const html = this.createLine(data)
    const element = document.querySelector("[id='posts-container']")
    element.insertAdjacentHTML("beforebegin", html)
  },

  createLine(data) {
    return `
      <article class="chat-line">
        <span class="speaker">${data["sent_by"]}</span>
        <span class="body">${data["body"]}</span>
      </article>
    `
  },

  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the room!");
  }
})
