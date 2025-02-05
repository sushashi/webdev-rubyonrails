import { Controller } from "@hotwired/stimulus";

export default class extends Controller {

	select_all() {
		console.log("Select All changed")
		const status = document.getElementById("check_all").checked

		const checkboxes = document.querySelectorAll('input[name="ratings[]"]');
		checkboxes.forEach(c => {
			c.checked = status;
		})
	}

	destroy() {
		// Confirmation dialog for the user
		const confirmDelete = confirm(
			"Are you sur you want to delete these selected ratings?"
		);
		if (!confirmDelete) {
			return;
		};

		//Retrieve the selected rating IDs from the checkboxes
		const selectedRatingsIDs = Array.from(
			document.querySelectorAll('input[name="ratings[]"]:checked'),
			(checkbox) => checkbox.value
		);

    // Include the CSRF token in the request headers so that Rails recognizes us as the logged in user
    const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
    const headers = { "X-CSRF-Token": csrfToken };

		// Send a DELETE request to the ratings controller with the selected rating IDs
    fetch("/ratings", {
      method: "DELETE",
      headers: headers,
      body: selectedRatingsIDs.join(","),
    })
      .then((response) => {
        if (response.ok) {
          response.text().then((html) => {
            document.querySelector("div.ratings").innerHTML = html;
          });
        } else {
          throw new Error("Something went wrong");
        }
      })
      .catch((error) => {
        console.log(error);
      });
	}


	
   // We'll talk about the connect in a second... 
   connect() {
      console.log("Hello, Stimulus!");
   }
}