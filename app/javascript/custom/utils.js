// const hello = () => {
//     document.getElementById("beers").innerText = "Hello from JS";
//     console.log("Hello console!")
// }

// export {hello};
const BEERS = {}

BEERS.reverse = () => {
    BEERS.list.reverse()
}

const handleResponse = (beers) => {
    BEERS.list = beers;
    BEERS.show();
}

const createTableRow = (beer) => {
    const tr = document.createElement('tr');
    tr.classList.add("tablerow")

    const beername = tr.appendChild(document.createElement('td'));
    beername.innerHTML = beer.name;
    const style = tr.appendChild(document.createElement('td'));
    style.innerHTML = beer.style.name;
    const brewery = tr.appendChild(document.createElement('td'));
    brewery.innerHTML = beer.brewery.name;
    
    return tr;
};

BEERS.show = () => {
    document.querySelectorAll(".tablerow").forEach((el) => el.remove());
    const table = document.getElementById('beertable');

    BEERS.list.forEach((beer) => {
        const tr = createTableRow(beer);
        table.appendChild(tr);
    })

    // const beerList = BEERS.list.map((beer) => `<li>${beer.name}</li>`);
    // document.getElementById("beers").innerHTML = `<ul> ${beerList.join("")} </ul>`;
};

BEERS.sortByName = () => {
    BEERS.list.sort((a,b) => {
        return a.name.toUpperCase().localeCompare(b.name.toUpperCase());
    });
}

BEERS.sortByStyle = () => {
    BEERS.list.sort((a,b) => {
        return a.style.name.toUpperCase().localeCompare(b.style.name.toUpperCase());
    });
}

BEERS.sortByBrewery = () => {
    BEERS.list.sort((a,b) => {
        return a.brewery.name.toUpperCase().localeCompare(b.brewery.name.toUpperCase());
    });
}

const beers = () => {
    if (document.querySelectorAll("#beertable").length < 1) return;

    document.getElementById('name').addEventListener("click", (e) => {
        e.preventDefault;
        BEERS.sortByName();
        BEERS.show();
    });

    document.getElementById('style').addEventListener("click", (e) => {
        e.preventDefault;
        BEERS.sortByStyle();
        BEERS.show();
    });

    document.getElementById('brewery').addEventListener("click", (e) => {
        e.preventDefault;
        BEERS.sortByBrewery();
        BEERS.show();
    });

    fetch("beers.json")
        .then((response) => response.json())
        .then(handleResponse);

    // var request = new XMLHttpRequest();

    // request.onload = handleResponse;
    
    // request.open("get", "beers.json", true);
    // request.send();
};

export { beers };