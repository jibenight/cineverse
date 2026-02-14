import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "stars"]

  setRating(event) {
    const value = parseFloat(event.params.value)
    this.inputTarget.value = value
    this.updateStars(value)
  }

  hover(event) {
    const value = parseFloat(event.params.star)
    this.updateStars(value)
  }

  resetHover() {
    const currentValue = parseFloat(this.inputTarget.value) || 0
    this.updateStars(currentValue)
  }

  updateStars(value) {
    const buttons = this.starsTarget.querySelectorAll("button svg")
    buttons.forEach((svg, index) => {
      const starValue = (index + 1) * 0.5
      if (value >= starValue) {
        svg.classList.remove("text-neutral-300", "dark:text-neutral-600")
        svg.classList.add("text-amber-500")
      } else {
        svg.classList.remove("text-amber-500")
        svg.classList.add("text-neutral-300", "dark:text-neutral-600")
      }
    })
  }
}
