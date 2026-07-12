import { Controller } from "@hotwired/stimulus"

// Copies the permalink to the clipboard and flashes a localized confirmation on the button.
export default class extends Controller {
  static targets = ["button"]
  static values = { url: String, copied: String }

  // Writes the permalink to the clipboard, then swaps the label to "copied!" until the reset fires.
  async copy() {
    await navigator.clipboard.writeText(this.urlValue)
    this.originalLabel ??= this.buttonTarget.textContent
    this.buttonTarget.textContent = this.copiedValue
    clearTimeout(this.resetTimeout)
    this.resetTimeout = setTimeout(() => { this.buttonTarget.textContent = this.originalLabel }, 2000)
  }

  disconnect() {
    clearTimeout(this.resetTimeout)
  }
}
