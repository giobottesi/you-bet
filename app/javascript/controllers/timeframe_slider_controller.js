import { Controller } from "@hotwired/stimulus"

// Maps the index-based range onto real timeframe weeks: stores the value in the hidden field and lights the active tick.
export default class extends Controller {
  static targets = ["range", "weeks", "tick"]
  static values = { weeks: Array }

  connect() {
    this.applySlot()
  }

  // Read the slider index, write its week count to the form, mark the matching tick, and tint the thumb + fill to the slot's accent.
  applySlot() {
    const index = Number(this.rangeTarget.value)
    const activeTick = this.tickTargets[index]
    this.weeksTarget.value = this.weeksValue[index]
    this.tickTargets.forEach((tick, i) => tick.classList.toggle("is-active", i === index))
    this.element.style.setProperty("--bet-accent", getComputedStyle(activeTick).getPropertyValue("--bet-accent"))
    this.element.style.setProperty("--fill-percent", `${(index / (this.tickTargets.length - 1)) * 100}%`)
    this.rangeTarget.setAttribute("aria-valuetext", activeTick.textContent)
  }
}
