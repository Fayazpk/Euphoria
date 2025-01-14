// document.addEventListener("DOMContentLoaded", () => {
//     const countrySelect = document.getElementById("countrySelect");
//     const stateSelect = document.getElementById("stateSelect");
//     const citySelect = document.getElementById("citySelect");
  
 
//     countrySelect.addEventListener("change", async (event) => {
//       const countryId = event.target.value;
  
 
//       stateSelect.innerHTML = '<option value="">Select State</option>';
//       citySelect.innerHTML = '<option value="">Select City</option>';
//       citySelect.disabled = true;
  
//       if (countryId) {
//         try {
//           const response = await fetch(`/usermodule/addresses/get_states?country_id=${countryId}`);
//           const states = await response.json();

//           if (states.length > 0) {
//             stateSelect.disabled = false;
//             states.forEach((state) => {
//               const option = document.createElement("option");
//               option.value = state.id;
//               option.textContent = state.name;
//               stateSelect.appendChild(option);
//             });
//           }
//         } catch (error) {
//           console.error("Error loading states:", error);
//         }
//       } else {
//         stateSelect.disabled = true;
//       }
//     });
  
//     stateSelect.addEventListener("change", async (event) => {
//       const stateId = event.target.value;
  
    
//       citySelect.innerHTML = '<option value="">Select City</option>';
  
//       if (stateId) {
//         try {
//           const response = await fetch(`/usermodule/addresses/get_cities?state_id=${stateId}`);
//           const cities = await response.json();
//           if (cities.length > 0) {
//             citySelect.disabled = false;
//             cities.forEach((city) => {
//               const option = document.createElement("option");
//               option.value = city.id;
//               option.textContent = city.name;
//               citySelect.appendChild(option);
//             });
//           }
//         } catch (error) {
//           console.error("Error loading cities:", error);
//         }
//       } else {
//         citySelect.disabled = true;
//       }
//     });
//   });
  