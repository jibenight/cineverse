import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["results"]

  connect() {
    this.timeout = null
  }

  search() {
    clearTimeout(this.timeout)
    const query = this.element.value.trim()

    if (query.length < 2) {
      this.hideResults()
      return
    }

    this.timeout = setTimeout(() => {
      fetch(`/search?q=${encodeURIComponent(query)}`, {
        headers: { "Accept": "text/vnd.turbo-stream.html" }
      })
    }, 300)
  }

  hideResults() {
    if (this.hasResultsTarget) {
      this.resultsTarget.innerHTML = ""
    }
  }

  disconnect() {
    clearTimeout(this.timeout)
  }
}
