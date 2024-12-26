// app/javascript/controllers/location_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["country", "state", "city"]

  connect() {
    console.log("Location controller connected")
  }

  async updateStates(event) {
    console.log("Updating states for country:", event.target.value)
    const countryId = event.target.value
    if (!countryId) return

    try {
      const response = await fetch(`/usermodule/addresses/get_states?country_id=${countryId}`)
      const states = await response.json()
      console.log("Received states:", states)
      
      this.stateTarget.innerHTML = '<option value="">Select State</option>'
      this.cityTarget.innerHTML = '<option value="">Select City</option>'
      
      states.forEach(state => {
        this.stateTarget.insertAdjacentHTML('beforeend', 
          `<option value="${state.id}">${state.name}</option>`
        )
      })
    } catch (error) {
      console.error("Error fetching states:", error)
    }
  }

  async updateCities(event) {
    console.log("Updating cities for state:", event.target.value)
    const stateId = event.target.value
    if (!stateId) return

    try {
      const response = await fetch(`/usermodule/addresses/get_cities?state_id=${stateId}`)
      const cities = await response.json()
      console.log("Received cities:", cities)
      
      this.cityTarget.innerHTML = '<option value="">Select City</option>'
      cities.forEach(city => {
        this.cityTarget.insertAdjacentHTML('beforeend',
          `<option value="${city.id}">${city.name}</option>`
        )
      })
    } catch (error) {
      console.error("Error fetching cities:", error)
    }
  }
}