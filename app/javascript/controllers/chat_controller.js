import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["messages", "input", "form"]
  static values = { conversationId: Number }

  connect() {
    this.consumer = createConsumer()
    this.channel = this.consumer.subscriptions.create(
      { channel: "ConversationChannel", id: this.conversationIdValue },
      {
        received: (data) => this.handleReceived(data)
      }
    )
    this.scrollToBottom()
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  handleReceived(data) {
    if (data.type === "new_message" && data.html) {
      this.messagesTarget.insertAdjacentHTML("beforeend", data.html)
      this.scrollToBottom()
    }
  }

  send(event) {
    event.preventDefault()
    const body = this.inputTarget.value.trim()
    if (!body) return

    this.channel.send({ body: body, message_type: "text" })
    this.inputTarget.value = ""
    this.inputTarget.focus()
  }

  scrollToBottom() {
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight
  }

  keydown(event) {
    if (event.key === "Enter" && !event.shiftKey) {
      event.preventDefault()
      this.send(event)
    }
  }
}
