import { Controller } from "@hotwired/stimulus"

// Maps the index-based range onto real timeframe weeks: stores the value in the hidden field and lights the active tick.
export default class extends Controller {
  static targets = ["range", "weeks", "tick"]
  static values = { weeks: Array }

  connect() {
    this.applySlot()
  }

  // Read the slider index, write its week count to the form, and mark the matching tick.
  applySlot() {
    const index = Number(this.rangeTarget.value)
    this.weeksTarget.value = this.weeksValue[index]
    this.tickTargets.forEach((tick, i) => tick.classList.toggle("is-active", i === index))
  }
}
