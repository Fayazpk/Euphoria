// app/javascript/packs/address_form.js
document.addEventListener('DOMContentLoaded', function() {
    const countrySelect = document.querySelector('.country-select');
    const stateSelect = document.querySelector('.state-select');
    const citySelect = document.querySelector('.city-select');
  
    countrySelect.addEventListener('change', function() {
      const countryId = countrySelect.value;
      fetch(`/states?country_id=${countryId}`)
        .then(response => response.json())
        .then(data => {
          stateSelect.innerHTML = `<option value="">Select State</option>`;
          data.states.forEach(state => {
            stateSelect.innerHTML += `<option value="${state.id}">${state.name}</option>`;
          });
          citySelect.innerHTML = `<option value="">Select City</option>`;
        });
    });
  
    stateSelect.addEventListener('change', function() {
      const stateId = stateSelect.value;
      fetch(`/cities?state_id=${stateId}`)
        .then(response => response.json())
        .then(data => {
          citySelect.innerHTML = `<option value="">Select City</option>`;
          data.cities.forEach(city => {
            citySelect.innerHTML += `<option value="${city.id}">${city.name}</option>`;
          });
        });
    });
  });
  