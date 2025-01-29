const BREWERIES = {}

const breweries = () => {
    if (document.querySelectorAll('#brewerytable').length < 1 ) return;

    addListener('name')
    addListener('year')
    addListener('active')
    addListener('beernumber')

    fetch("breweries.json")
        .then( (res) => res.json())
        .then(handleResponse);
}

const handleResponse = (breweries) => {
    BREWERIES.list = breweries;
    BREWERIES.show();
}

BREWERIES.show = () => {
    document.querySelectorAll(".tablerow").forEach((e) => e.remove());

    const table = document.getElementById("brewerytable");

    BREWERIES.list.forEach((brewery) => {
        const tr = createTableRow(brewery);
        table.appendChild(tr);
    })
}

const createTableRow = (brewery) => {
    const tr = document.createElement('tr');
    tr.classList.add("tablerow")

    const breweryname = tr.appendChild(document.createElement('td'));
    breweryname.innerHTML = brewery.name
    const foundingyear = tr.appendChild(document.createElement('td'))
    foundingyear.innerHTML = brewery.year
    const beerscount = tr.appendChild(document.createElement('td'));
    beerscount.innerHTML = brewery.beers_count;
    const active = tr.appendChild(document.createElement('td'))
    active.innerHTML = brewery.active
    
    return tr
}

const addListener = (element) => {
    document.getElementById(element).addEventListener("click", (e) => {
        e.preventDefault;
        BREWERIES.sortByThing(element);
        BREWERIES.show();
    });
}

BREWERIES.sortByThing = (element) => {
    console.log(BREWERIES.list)
    if (element == "beernumber") {element = "beers_count"}

    BREWERIES.list.sort((a,b) => {
        return (a[element]).toString().toUpperCase().localeCompare((b[element]).toString().toUpperCase());
    });
}

export { breweries };