document.addEventListener('DOMContentLoaded', () => {
    const categorySelect = document.querySelector('#product_category_id');
    const subcategorySelect = document.querySelector('#product_subcategory_id');
  
    categorySelect.addEventListener('change', (event) => {
      const categoryId = event.target.value;
      fetch(`/admin/products/subcategories?category_id=${categoryId}`)
        .then(response => response.json())
        .then(data => {
          subcategorySelect.innerHTML = '';
          data.subcategories.forEach(subcategory => {
            const option = document.createElement('option');
            option.value = subcategory.id;
            option.textContent = subcategory.name;
            subcategorySelect.appendChild(option);
          });
        });
    });
  });
  