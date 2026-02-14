import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["badge", "list"]

  connect() {
    this.consumer = createConsumer()
    this.channel = this.consumer.subscriptions.create("NotificationsChannel", {
      received: (data) => this.handleNotification(data)
    })
  }

  disconnect() {
    if (this.channel) this.channel.unsubscribe()
  }

  handleNotification(data) {
    if (data.type === "notification") {
      // Update badge count
      if (this.hasBadgeTarget) {
        this.badgeTarget.textContent = data.unread_count
        this.badgeTarget.classList.remove("hidden")
      }

      // Show toast notification
      this.showToast(data.message)
    }
  }

  showToast(message) {
    const toast = document.createElement("div")
    toast.className = "fixed top-4 right-4 z-50 bg-white dark:bg-neutral-800 rounded-lg shadow-lg border border-neutral-200 dark:border-neutral-700 p-4 text-sm animate-slide-in max-w-sm"
    toast.textContent = message
    document.body.appendChild(toast)

    setTimeout(() => {
      toast.classList.add("opacity-0", "translate-y-[-10px]", "transition-all", "duration-300")
      setTimeout(() => toast.remove(), 300)
    }, 5000)
  }
}
