import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    setTimeout(() => {
      this.dismiss()
    }, 5000)
  }

  dismiss() {
    this.element.classList.add("opacity-0", "translate-y-[-10px]", "transition-all", "duration-300")
    setTimeout(() => {
      this.element.remove()
    }, 300)
  }
}
