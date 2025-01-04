// app/javascript/controllers/search_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "results" ]
  
  connect() {
    this.resultsTarget.style.display = "none"
  }

  search() {
    const query = this.inputTarget.value
    
    if (query.length >= 2) {  // Only search if 2 or more characters
      fetch(`/usermodule/products/search.json?query=${query}`)
        .then(response => response.json())
        .then(data => {
          this.showResults(data)
        })
    } else {
      this.resultsTarget.style.display = "none"
    }
  }

  showResults(data) {
    if (data.length > 0) {
      this.resultsTarget.innerHTML = data.map(product => `
        <a href="${product.url}" class="block px-4 py-2 hover:bg-gray-100">
          ${product.name}
        </a>
      `).join('')
      this.resultsTarget.style.display = "block"
    } else {
      this.resultsTarget.innerHTML = `
        <div class="px-4 py-2 text-gray-500">No results found</div>
      `
      this.resultsTarget.style.display = "block"
    }
  }

  hideResults(event) {
    // Small delay to allow clicking on results
    setTimeout(() => {
      this.resultsTarget.style.display = "none"
    }, 200)
  }
}