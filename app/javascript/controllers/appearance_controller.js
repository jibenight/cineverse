import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  connect() {
    this.consumer = createConsumer()
    this.channel = this.consumer.subscriptions.create("AppearanceChannel", {
      connected: () => this.appear(),
      received: (data) => this.handlePresence(data)
    })

    this.heartbeat = setInterval(() => this.appear(), 30000)
    document.addEventListener("visibilitychange", this.handleVisibility.bind(this))
  }

  disconnect() {
    clearInterval(this.heartbeat)
    if (this.channel) this.channel.unsubscribe()
  }

  appear() {
    if (this.channel) this.channel.perform("appear")
  }

  handlePresence(data) {
    if (data.type === "presence") {
      const indicators = document.querySelectorAll(`[data-user-id="${data.user_id}"] .online-indicator`)
      indicators.forEach(el => {
        el.classList.toggle("bg-green-500", data.online)
        el.classList.toggle("bg-neutral-400", !data.online)
      })
    }
  }

  handleVisibility() {
    if (document.hidden) {
      if (this.channel) this.channel.perform("away")
    } else {
      this.appear()
    }
  }
}
