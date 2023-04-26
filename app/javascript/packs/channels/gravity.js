import consumer from './consumer'

const channelSubscription = consumer.subscriptions.create({channel: 'GravityChannel'}, {
  // received(data) {
  //   // new Gravity(data["title"], { body: data["body"] })
  //   console.log('tae ka');
  // },

  received(data) {
    this.appendLine(data)
  },

  appendLine(data) {
    const html = this.createLine(data)
    const element = document.querySelector("[id='users']")
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

// setTimeout(
//   () => channelSubscription.send({sent_by: "Paul", body: "This is a cool chat app."}),
//   5000
// );

// window.sendMessage = (sent_by, body) => {
//   channelSubscription.send({sent_by: sent_by, body: body})
// }

const sendMessage = (sentBy, body) => {
  channelSubscription.send({sent_by: sentBy, body: body})
}

export default sendMessage
