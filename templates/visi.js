// Function to get the count from localStorage or initialize it
function getVisitorCount() {
  // Retrieve the count from localStorage and convert it to an integer
  return parseInt(localStorage.getItem('visitorCount')) || 0;
}

// Function to increment and save the count
function incrementVisitorCount() {
  let count = getVisitorCount() + 1; // Increment the count
  localStorage.setItem('visitorCount', count); // Save the updated count
  return count; // Return the new count
}

// Function to display the count
function displayVisitorCount() {
  const counterElement = document.querySelector('.website-counter'); // Select the counter element
  const count = incrementVisitorCount(); // Increment the count
  counterElement.textContent = count; // Display the updated count
}

// Call the display function when the page loads
document.addEventListener('DOMContentLoaded', displayVisitorCount);

