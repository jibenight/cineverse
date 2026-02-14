import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  connect() {
    this.element.addEventListener("dragover", this.dragOver.bind(this))
  }

  dragStart(event) {
    event.dataTransfer.setData("text/plain", event.target.dataset.id)
    event.target.classList.add("opacity-50")
  }

  dragEnd(event) {
    event.target.classList.remove("opacity-50")
  }

  dragOver(event) {
    event.preventDefault()
    const dragging = this.element.querySelector(".opacity-50")
    const target = event.target.closest("[data-sortable-target='item']")
    if (target && target !== dragging) {
      const rect = target.getBoundingClientRect()
      const midY = rect.top + rect.height / 2
      if (event.clientY < midY) {
        target.parentNode.insertBefore(dragging, target)
      } else {
        target.parentNode.insertBefore(dragging, target.nextSibling)
      }
    }
  }

  drop(event) {
    event.preventDefault()
    const itemIds = Array.from(this.itemTargets).map(el => el.dataset.id)
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content

    fetch("/watchlist/reorder", {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({ item_ids: itemIds })
    })
  }
}
