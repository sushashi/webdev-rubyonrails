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
- https://mysite-9qj1.onrender.com/breweries
- https://mysite-9qj1.onrender.com/beers

## Week 2

- https://mysite-9qj1.onrender.com/

## Week 3
- I reinitialized the web service and the database on render with, there was a problem with the database migration.
- Comment/Uncomment database seed [file](/db/seeds.rb) if needed.