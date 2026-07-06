import { Controller } from "@hotwired/stimulus"

// FE-02 bet type picker — multi-select paper-checkbox slider.
// Enforces "pick at least one", drives arrow scrolling + the edge-fade scroll affordance.
export default class extends Controller {
  static targets = ["carousel", "checkbox", "count", "viewport", "prev", "next"]

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

  scrollPrev() {
    this.carouselTarget.scrollBy({ left: -this.pageDistance, behavior: "smooth" })
  }

  scrollNext() {
    this.carouselTarget.scrollBy({ left: this.pageDistance, behavior: "smooth" })
  }

  sync() {
    const carousel = this.carouselTarget
    const maxScroll = carousel.scrollWidth - carousel.clientWidth
    const position = carousel.scrollLeft
    this.viewportTarget.style.setProperty("--fade-left", position > 4 ? 1 : 0)
    this.viewportTarget.style.setProperty("--fade-right", position < maxScroll - 4 ? 1 : 0)
    this.prevTarget.disabled = position <= 4
    this.nextTarget.disabled = position >= maxScroll - 4
  }

  get pageDistance() {
    const card = this.carouselTarget.querySelector(".bet-card")
    return card ? (card.offsetWidth + 16) * 2 : 300
  }
}
