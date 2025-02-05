import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["name", "year", "active", "brewery_name"];

	clear() {
		console.log("Clearing ..")
		this.nameTarget.value = "";
		this.yearTarget.value = "";
		this.activeTarget.checked = false;
	}

	clear_submit(event) {
		console.log("clear_submit ..")
		if (event.detail.success) {
			this.clear()
		}
	}

	autofill() {
		this.nameTarget.value = this.brewery_nameTarget.selectedOptions[0].innerText
		this.yearTarget.value = this.brewery_nameTarget.selectedOptions[0].value
	}
}