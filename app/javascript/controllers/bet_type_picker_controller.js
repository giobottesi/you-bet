import { Controller } from "@hotwired/stimulus"

// #54 bet type picker — a horizontal, multi-select paper-checkbox slider.
// Two jobs: (1) require at least one bet type, and (2) drive the edge arrows
// that page the slider. User-facing strings arrive as values so the copy lives
// in the i18n locale files, never hard-coded here.
export default class extends Controller {
  static targets = ["carousel", "checkbox", "count", "prev", "next"]
  static values = { countNone: String, countSelected: String, validityMessage: String }

  connect() {
    // The arrows' disabled state depends on the carousel's width, which changes
    // on any layout reflow — window resize, late font load, a sibling expanding —
    // not just window resizes. A ResizeObserver on the carousel catches them all;
    // a window "resize" listener would miss the non-window ones.
    this.resizeObserver = new ResizeObserver(() => this.updateArrows())
    this.resizeObserver.observe(this.carouselTarget)
    this.validate()
    this.updateArrows()
  }

  disconnect() {
    this.resizeObserver.disconnect()
  }

  // Reflect the current selection: update the "N selected" badge, and block form
  // submission through the constraint-validation API until at least one box is
  // checked (native `required` can't express "≥1 of a checkbox group").
  validate() {
    const selected = this.checkboxTargets.filter((box) => box.checked).length
    this.countTarget.textContent =
      selected === 0 ? this.countNoneValue : this.countSelectedValue.replace("%{count}", selected)
    this.countTarget.dataset.empty = selected === 0
    this.checkboxTargets[0].setCustomValidity(selected === 0 ? this.validityMessageValue : "")
  }

  // Page the slider left / right by the edge chevrons.
  scrollPrev() {
    this.carouselTarget.scrollBy({ left: -this.pageDistance, behavior: "smooth" })
  }

  scrollNext() {
    this.carouselTarget.scrollBy({ left: this.pageDistance, behavior: "smooth" })
  }

  // Disable an arrow once the carousel is scrolled to that end (the 4px slack
  // absorbs sub-pixel scroll rounding). CSS hides the disabled arrow.
  updateArrows() {
    const carousel = this.carouselTarget
    const maxScroll = carousel.scrollWidth - carousel.clientWidth
    this.prevTarget.disabled = carousel.scrollLeft <= 4
    this.nextTarget.disabled = carousel.scrollLeft >= maxScroll - 4
  }

  // One "page" is two cards: card width plus the 16px (1rem) flex gap between
  // them. Falls back to 300px before the first card has laid out.
  get pageDistance() {
    const card = this.carouselTarget.querySelector(".bet-card")
    return card ? (card.offsetWidth + 16) * 2 : 300
  }
}
