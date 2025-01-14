import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  
  connect() {
    this.timeout = null
    document.addEventListener("click", this.handleClickOutside.bind(this))
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside.bind(this))
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideResults()
    }
  }

  perform() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value

    if (query.length < 2) {
      this.hideResults()
      return
    }

    this.timeout = setTimeout(() => {
      fetch(`/usermodule/search?query=${encodeURIComponent(query)}`, {
        headers: { 'Accept': 'application/json' }
      })
      .then(response => response.json())
      .then(data => {
        if (data.length > 0) {
          this.showResults(data)
        } else {
          this.hideResults()
        }
      })
    }, 300)
  }

  showResults(products) {
    this.resultsTarget.innerHTML = products.map(product => `
      <a href="${product.url}" class="block px-4 py-2 hover:bg-gray-100">
        <div class="text-sm font-medium text-gray-900">${product.name}</div>
      </a>
    `).join('')
    this.resultsTarget.classList.remove('hidden')
  }

  hideResults() {
    this.resultsTarget.classList.add('hidden')
  }
}