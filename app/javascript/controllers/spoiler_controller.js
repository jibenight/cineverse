import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "overlay"]

  reveal() {
    this.contentTarget.classList.remove("blur-sm", "select-none")
    this.overlayTarget.classList.add("hidden")
  }
}
