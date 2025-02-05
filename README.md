# Server-side Web Development with Ruby on Rails, [5 ECTS](https://studies.helsinki.fi/courses/course-implementation/otm-7c59477c-a0f6-47ce-9de0-1bc6669a2523/TKT21003)

This repository is used for the [Server-side Web Development with Ruby on Rails](https://github.com/mluukkai/WebPalvelinohjelmointi2023/tree/main?tab=readme-ov-file) course offered by the University of Helsinki.

It contains a single application, "Ratebeer", built step by step following the course material.

## Week 1
The application is deployed on render.com with this [guide](https://render.com/docs/deploy-rails#use-renderyaml-to-deploy).

### Note
The application deployed on render starts in the production environment and uses PostgreSQL. In order to have a working development/test using sqlite3 and a production environment using PostgreSQL, the [config/database.yml](/config/database.yml) file has to be adapted (contrary to what the guide says) by:
  - adding an `ENV` variable, the PostgreSQL `DATABASE_URL` managed by Render
  - adding parameters for queue and cache otherwise it crashes (not sure to understand what this is yet)

### Links:
May take a while to launch, It's on a free plan.
- https://ratebeer-b037.onrender.com//breweries
- https://ratebeer-b037.onrender.com//beers

## Week 2
- https://ratebeer-b037.onrender.com/

## Week 3
- I reinitialized the web service and the database on render, there was a problem with the database migration. I also changed the region.
- Comment/Uncomment database seed [here](/bin/render-build.sh) if needed, otherwise we get double entries.
- Link updated: https://ratebeer-b037.onrender.com/
- Passwords used to signin on diverse accounts: `passworD*`

## Week 4
- Ex11, use `visit user_path(user1.id)` instead of `visit user_path(1)` for tests of Ex7-8.
- Ex12, `andrewmcodes-archive/rubocop-linter-action@v3.3.0` GitHub Action doesn't work. Add `bundle exec rubocop` to [`rubyonrail.yml`](/.github/workflows/rubyonrails.yml) instead
- Ex13, deactivate auto deployment in render and add the deployment hook URL in [`rubyonrail.yml`](/.github/workflows/rubyonrails.yml)

- Ex14, [![Maintainability](https://api.codeclimate.com/v1/badges/b599a0be33fab8a8acc3/maintainability)](https://codeclimate.com/github/sushashi/webdev-rubyonrails/maintainability)

## Week 5

- WeatherstackApi is limited to 100 calls per month (exceeding limit is not handled)
- added `require 'ostruct'` in [place model](/app/models/place.rb) (Does not work in render otherwise)
- `WEATHERSTACK_APIKEY` set in render.com
- URL changed

## Week 6

- Bootstrap installation in the course material does not work, here is a working solution:
  - Add these gems to `Gemfile`
    ```
    gem 'bootstrap', '~> 5.3.3'
    gem 'dartsass-rails'
    ```
  - Run `bundle install`
  - Rename `app/assets/stylesheets/application.css` to `app/assets/stylesheets/application.scss` and add `@import "bootstrap";`
  - In `app/javascript/application.js` add
    ```
    import "popper"
    import "bootstrap"
    ```
  - In `config/importmap.rb` add
    ```
    pin "popper", to: 'popper.js', preload: true
    pin "bootstrap", to: 'bootstrap.min.js', preload: true
    ```
  - Clear asset cache with `rails tmp:clear`
  - Precompile assets with `rails assets:precompile`
  - Run server `rails s`

## Week 7
- https://ratebeer-b037.onrender.com/
  > note that free PostgreSQL Database on render.com expires 1 month after its creation!
- Deactivated tests in GitHub Actions.
- Couldn't get `chromedriver` or `selenium` to work.
- `User01` is the admin with password `passworD*`
- `db:seed` [here](/bin/render-build.sh).

## Week 8
- Log in as admin `User01` `passworD*` to be able to delete breweries.
- Ex 17: I simply used every possible names even if a company has different names from [Avoin data](https://avoindata.prh.fi/)
- In order to have a working **Action Cable WebSocket** on **render.com** in production environment, we have to install and set up **Redis**:
  1. Add `gem "redis"` in [gemfile](/Gemfile).
  2. Run `bundle install`.
  3. Add the following code snippet in [config/cable.yml](/config/cable.yml).
      ```
      production:
        adapter: redis
        url: <%= ENV.fetch("REDIS_URL", "redis://localhost:6379/0") %>
      ```
  4. Start a new Redis service on render and copy the internal URL of the service.
  5. Add a new environment variable, `REDIS_URL`, in the deployed app on render.com