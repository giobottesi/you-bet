import { Controller } from "@hotwired/stimulus"

// FE-02 bet type picker — multi-select paper-checkbox slider.
// Enforces "pick at least one" and drives the scroll affordances (edge fades + progress bar).
export default class extends Controller {
  static targets = ["carousel", "checkbox", "count", "viewport", "progress"]

  connect() {
    this.syncBound = () => this.sync()
    window.addEventListener("resize", this.syncBound)
    this.validate()
    this.sync()
  }

  disconnect() {
    window.removeEventListener("resize", this.syncBound)
  }

  validate() {
    const selected = this.checkboxTargets.filter((box) => box.checked).length
    this.countTarget.textContent = selected === 0 ? "None selected" : `${selected} selected`
    this.countTarget.dataset.empty = selected === 0
    this.checkboxTargets[0].setCustomValidity(selected === 0 ? "Pick at least one bet type." : "")
  }

  sync() {
    const carousel = this.carouselTarget
    const maxScroll = carousel.scrollWidth - carousel.clientWidth
    const position = maxScroll > 0 ? carousel.scrollLeft / maxScroll : 0
    const visibleRatio = Math.min(1, carousel.clientWidth / carousel.scrollWidth)

    this.viewportTarget.style.setProperty("--fade-left", carousel.scrollLeft > 4 ? 1 : 0)
    this.viewportTarget.style.setProperty("--fade-right", carousel.scrollLeft < maxScroll - 4 ? 1 : 0)

    this.progressTarget.style.width = `${visibleRatio * 100}%`
    this.progressTarget.style.left = `${position * (100 - visibleRatio * 100)}%`
  }
}
