// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
//= require jquery3
//= require popper
//= require bootstrap-sprockets
import "@hotwired/turbo-rails"
import "controllers"
import "popper"
import "bootstrap"
import { beers } from "custom/utils";
import { breweries } from "custom/utils_breweries";

beers();
breweries();