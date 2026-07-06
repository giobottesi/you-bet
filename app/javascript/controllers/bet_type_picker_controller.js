import { Controller } from "@hotwired/stimulus"

// #54 bet type picker — multi-select paper-checkbox slider.
// Enforces "pick at least one" and pages the slider with the edge arrows.
// User-facing strings come in as values so they stay in the i18n locale files.
export default class extends Controller {
  static targets = ["carousel", "checkbox", "count", "prev", "next"]
  static values = { countNone: String, countSelected: String, validityMessage: String }

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
    this.countTarget.textContent =
      selected === 0 ? this.countNoneValue : this.countSelectedValue.replace("%{count}", selected)
    this.countTarget.dataset.empty = selected === 0
    this.checkboxTargets[0].setCustomValidity(selected === 0 ? this.validityMessageValue : "")
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
    this.prevTarget.disabled = carousel.scrollLeft <= 4
    this.nextTarget.disabled = carousel.scrollLeft >= maxScroll - 4
  }

  get pageDistance() {
    const card = this.carouselTarget.querySelector(".bet-card")
    return card ? (card.offsetWidth + 16) * 2 : 300
  }
}
