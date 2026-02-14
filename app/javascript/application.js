import "@hotwired/turbo-rails"
import "./controllers"
import * as ActionCable from "@rails/actioncable"

// Initialize theme from cookie
const theme = document.cookie.match(/theme=(dark|light)/)?.[1]
if (theme === "dark" || (!theme && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
  document.documentElement.classList.add("dark")
} else {
  document.documentElement.classList.remove("dark")
}
