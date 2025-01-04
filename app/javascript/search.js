// app/javascript/search.js
document.addEventListener('DOMContentLoaded', function() {
    const searchInput = document.querySelector('[name="query"]');
    const resultsContainer = document.createElement('div');
    resultsContainer.className = 'absolute w-full bg-white mt-1 rounded-lg shadow-lg z-50 max-h-96 overflow-y-auto';
    searchInput.parentNode.appendChild(resultsContainer);
  
    searchInput.addEventListener('input', debounce(async function() {
      const query = this.value;
      if (query.length < 2) {
        resultsContainer.style.display = 'none';
        return;
      }
  
      const response = await fetch(`/usermodule/products/search.json?query=${encodeURIComponent(query)}`);
      const products = await response.json();
      
      resultsContainer.innerHTML = products.map(product => `
        <a href="${product.url}" class="block p-3 hover:bg-gray-100">
          <div class="font-medium">${product.name}</div>
          <div class="text-sm text-gray-600">${product.category_name} > ${product.subcategory_name}</div>
          <div class="text-sm text-gray-800">₹${product.price}</div>
        </a>
      `).join('');
      
      resultsContainer.style.display = products.length ? 'block' : 'none';
    }, 300));
  
    document.addEventListener('click', function(e) {
      if (!searchInput.contains(e.target) && !resultsContainer.contains(e.target)) {
        resultsContainer.style.display = 'none';
      }
    });
  });
  
  function debounce(fn, delay) {
    let timeoutId;
    return function(...args) {
      clearTimeout(timeoutId);
      timeoutId = setTimeout(() => fn.apply(this, args), delay);
    };
  }