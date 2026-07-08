import { Controller } from "@hotwired/stimulus"

// Wires the custom row: typing an amount claims its radio, stores cents, and blocks submission below zero.
export default class extends Controller {
  static targets = ["customRadio", "customInput"]
  static values = { customInvalid: String }

  // Typing a custom amount selects the custom radio and stores the amount in cents.
  selectCustom() {
    const reais = parseFloat(this.customInputTarget.value)
    this.customRadioTarget.value = Number.isFinite(reais) ? Math.round(reais * 100) : ""
    this.customRadioTarget.checked = true
    this.validate()
  }

  // The custom amount must be above zero, but only when the custom row is the choice.
  validate() {
    const reais = parseFloat(this.customInputTarget.value)
    const invalid = this.customRadioTarget.checked && !(Number.isFinite(reais) && reais > 0)
    this.customInputTarget.setCustomValidity(invalid ? this.customInvalidValue : "")
  }
}
