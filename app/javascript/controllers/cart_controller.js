document.addEventListener("DOMContentLoaded", function () {
    const quantityInput = document.getElementById("quantity-input");
    const decrementButton = document.getElementById("decrement-btn");
    const incrementButton = document.getElementById("increment-btn");
    const addToCartButton = document.getElementById("add-to-cart-btn");
    const selectedSizeInput = document.getElementById("selected-size");
    const sizeButtons = document.querySelectorAll(".size-button");

    // Initialize selected size
    sizeButtons.forEach(button => {
        button.addEventListener("click", function () {
            selectedSizeInput.value = button.getAttribute("data-size");
            checkFormCompletion();
        });
    });

    // Decrement quantity
    decrementButton.addEventListener("click", function () {
        const quantity = parseInt(quantityInput.value, 10);
        if (quantity > 1) quantityInput.value = quantity - 1;
        checkFormCompletion();
    });

    // Increment quantity
    incrementButton.addEventListener("click", function () {
        const quantity = parseInt(quantityInput.value, 10);
        quantityInput.value = quantity + 1;
        checkFormCompletion();
    });

    // Enable Add to Cart button if both size and quantity are selected
    function checkFormCompletion() {
        const size = selectedSizeInput.value.trim();
        const quantity = parseInt(quantityInput.value, 10);
        addToCartButton.disabled = !(size && quantity > 0);
    }

    // Handle Add to Cart button click
    addToCartButton.addEventListener("click", function () {
        const size = selectedSizeInput.value.trim();
        const quantity = parseInt(quantityInput.value, 10);
        const productId = addToCartButton.getAttribute("data-product-id");
        const variantId = addToCartButton.getAttribute("data-variant-id");

        if (size && quantity > 0) {
            fetch('/add_to_cart', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
                },
                body: JSON.stringify({
                    product_id: productId,
                    variant_id: variantId,
                    size: size,
                    quantity: quantity
                })
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Item added to cart!');
                    updateCartCount(data.cart_count || 0);
                } else {
                    alert(data.message || 'Failed to add item to cart.');
                }
            })
            .catch(error => {
                console.error('Error adding to cart:', error);
                alert('Something went wrong. Please try again.');
            });
        } else {
            alert("Please select a size and quantity.");
        }
    });

    // Update the cart count displayed on the page
    function updateCartCount(count) {
        const cartCountElement = document.getElementById("cart-count");
        if (cartCountElement) cartCountElement.textContent = count;
    }
});
