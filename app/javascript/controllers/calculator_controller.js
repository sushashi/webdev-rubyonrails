import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
	static targets = ["amount", "custom_amount", "abv", "price"];
	static values = { vat: Number };

	custom(event) {
		event.preventDefault();
		const amount = this.amountTarget.value
		const div = document.getElementById("custom_amount");

		if (amount === "custom") {
			div.style.display = 'block';
		} else {
			div.style.display = 'none';
		}
	}

	reset(event) {
		event.preventDefault();
		this.amountTarget.value = 0.33;
		this.abvTarget.value = 0.00;
		this.priceTarget.value	= 0.00;
		const div = document.getElementById("custom_amount");
		div.style.display = 'none';
	}

	calculate(event) {
		event.preventDefault();
		let amount = parseFloat(this.amountTarget.value);
		const custom_amount = parseFloat(this.custom_amountTarget.value)
		const abv = parseFloat(this.abvTarget.value);
		const price = parseFloat(this.priceTarget.value);

		console.log(custom_amount)
		amount = isNaN(amount) ? custom_amount : amount

		// Amounts of alcohol tax per liter of pure alcohol for beers.
		let alcoholTax = 0;
		switch (true) {
			case (abv < 0.5):
				alcoholTax = 0;
			case (abv <= 3.5):
				alcoholTax = 0.2835;
			case (abv > 3.5):
				alcoholTax = 0.3805;
		}

		const beerTax = (amount * abv * alcoholTax)
		const vatAmount = (price - price / (1.0 + this.vatValue));
		const taxPercentage = ((beerTax + vatAmount) / price * 100);

		// Search for the element where the result is shown
		const result = document.getElementById("result")
		result.innerHTML = `
			<p>Beer has ${beerTax.toFixed(2)}€ of alcohol tax and $ ${vatAmount.toFixed(2)} € of value added tax.</p>
			<p> ${taxPercentage.toFixed(1)} % of the price is taxes.</p>`

		console.log(amount, abv, price)
	}


}