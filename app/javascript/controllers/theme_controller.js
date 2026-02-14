import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle() {
    const html = document.documentElement
    const isDark = html.classList.contains("dark")

    if (isDark) {
      html.classList.remove("dark")
      document.cookie = "theme=light;path=/;max-age=31536000"
    } else {
      html.classList.add("dark")
      document.cookie = "theme=dark;path=/;max-age=31536000"
    }

    // Sync with server if logged in
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    if (csrfToken) {
      fetch("/settings", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken,
          "Accept": "application/json"
        },
        body: JSON.stringify({ user: { theme_preference: isDark ? "light" : "dark" } })
      }).catch(() => {})
    }
  }
}
