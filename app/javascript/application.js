// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "channels"

// app/javascript/packs/application.js

// Import required libraries
import 'bootstrap'
import Cropper from 'cropperjs'
import 'cropperjs/dist/cropper.css'

document.addEventListener("DOMContentLoaded", function() {
  // Initialize Bootstrap components
  const tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
  tooltipTriggerList.map(function (tooltipTriggerEl) {
    return new bootstrap.Tooltip(tooltipTriggerEl)
  })

  // Price calculation logic
  const setupPriceCalculation = () => {
    const basePriceInput = document.getElementById("base_price");
    const discountInput = document.getElementById("discount_percentage");
    const finalPriceInput = document.getElementById("final_price");

    if (!basePriceInput || !discountInput || !finalPriceInput) return;

    const calculateFinalPrice = () => {
      const basePrice = parseFloat(basePriceInput.value) || 0;
      const discountPercentage = parseFloat(discountInput.value) || 0;
      const finalPrice = basePrice - (basePrice * (discountPercentage / 100));
      finalPriceInput.value = finalPrice.toFixed(2);
    };

    basePriceInput.addEventListener("input", calculateFinalPrice);
    discountInput.addEventListener("input", calculateFinalPrice);
  };

  // Image cropper logic
  const setupImageCropper = () => {
    let cropper = null;
    let currentImageInput = null;
    const modalElement = document.getElementById('cropperModal');
    
    if (!modalElement) return;
    
    const cropperModal = new bootstrap.Modal(modalElement, {
      backdrop: 'static',
      keyboard: false
    });
    
    const cropperImage = document.getElementById('cropperImage');
    const cropButton = document.getElementById('cropButton');

    if (!cropperImage || !cropButton) return;

    const initCropper = () => {
      return new Cropper(cropperImage, {
        aspectRatio: 1,
        viewMode: 2,
        autoCropArea: 1,
        responsive: true,
        restore: false,
        guides: true,
        center: true,
        highlight: false,
        cropBoxMovable: true,
        cropBoxResizable: true,
        toggleDragModeOnDblclick: false,
      });
    };

    // Handle file selection
    document.querySelectorAll('.image-input').forEach(input => {
      input.addEventListener('change', (e) => {
        const file = e.target.files[0];
        if (!file) return;

        if (!file.type.startsWith('image/')) {
          alert('Please select an image file');
          input.value = '';
          return;
        }

        currentImageInput = input;
        const reader = new FileReader();
        
        reader.onload = (e) => {
          cropperImage.src = e.target.result;
          
          if (cropper) {
            cropper.destroy();
          }
          
          setTimeout(() => {
            cropper = initCropper();
            cropperModal.show();
          }, 100);
        };
        
        reader.readAsDataURL(file);
      });
    });

    // Handle crop action
    cropButton.addEventListener('click', () => {
      if (!cropper || !currentImageInput) return;

      const croppedCanvas = cropper.getCroppedCanvas({
        width: 800,
        height: 800,
        fillColor: '#fff'
      });

      croppedCanvas.toBlob((blob) => {
        // Create File object
        const fileName = currentImageInput.files[0].name;
        const croppedFile = new File([blob], fileName, { 
          type: 'image/jpeg',
          lastModified: new Date().getTime()
        });

        // Update file input
        const dataTransfer = new DataTransfer();
        dataTransfer.items.add(croppedFile);
        currentImageInput.files = dataTransfer.files;

        // Update preview
        const previewImage = currentImageInput.parentElement.querySelector('.preview-image');
        const croppedImageInput = currentImageInput.parentElement.querySelector('.cropped-image-input');
        
        previewImage.src = URL.createObjectURL(blob);
        previewImage.style.display = 'block';

        // Store cropped image data
        const reader = new FileReader();
        reader.readAsDataURL(blob);
        reader.onloadend = () => {
          croppedImageInput.value = reader.result;
        };

        cropperModal.hide();
        
      }, 'image/jpeg', 0.9);
    });

    // Modal cleanup
    modalElement.addEventListener('hidden.bs.modal', () => {
      if (cropper) {
        cropper.destroy();
        cropper = null;
      }
      
      if (currentImageInput) {
        const previewImage = currentImageInput.parentElement.querySelector('.preview-image');
        if (!previewImage.src || previewImage.src === '') {
          currentImageInput.value = '';
        }
      }
    });

    // Modal close button
    const closeButton = modalElement.querySelector('.btn-close, .btn-secondary');
    if (closeButton) {
      closeButton.addEventListener('click', () => cropperModal.hide());
    }
  };

  // Initialize all components
  setupPriceCalculation();
  setupImageCropper();
});

