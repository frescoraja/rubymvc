# RubyMVC

RubyMVC is a lightweight web application framework written in Ruby, inspired by
Ruby on Rails/ActiveRecord

## About

> Based on the MVC software architectural pattern, with RubyMVC you can build
> and run a simple, lightweight, full-stack web application!  Generate models in
> ruby that represent your relational DB (Either PostgreSQL or SQLite are
> supported) data - supports belongs_to, has_many, and has_many_through
> assocations. Use the Controller class to serve static assets, render HTML, or
> embed your data in an ERB template. Use the Session class to handle cookie or
> flash data. Define routes with the Router class to construct a robust API that
> parses arbitrarily nested query parameters into a Hash object with indifferent
> access (as string or symbol).

---

## Web Sketch App - PAINT

This repo contains the source code for RubyMVC along with a simple web-app demo.
With it you can create PNG sketches in your browser using the customizeable
color swatch and canvas, then save them to the DB of your choice (PG or SQLite)
and view them in the home page gallery along with their metadata (author, title,
and date of creation). The UI was built using jQuery.

## Instructions to run

If you would like to run this web application locally, you must be using ruby
2.3.4, and have PostgreSQL.

### PostgreSQL

The following instructions are for PG DB, and assume it is running on your local
host on default port 5432.

```cli
# login to postgres cli from terminal:
$> psql

# create database:
psql> CREATE DATABASE rubymvc;

# connect to database:
psql> \c rubymvc;

# create sketch table:
psql> CREATE TABLE sketch(
  id SERIAL PRIMARY KEY,
  author VARCHAR(255) DEFAULT 'Anonymous' NOT NULL,
  title VARCHAR(255) DEFAULT 'Untitled' NOT NULL,
  image VARCHAR(1024) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

# exit postgres command line utility:
psql> \q

# install ruby dependencies (from terminal):
$> bundle install

# run web app:
$> USER=`whoami` ./bin/server 3000
```

Alternatively, you can use your own postgres server and use the DATABASE_URL
variable when running the script to start the app, ie:

```cli
DATABASE_URL=postgresql://username@127.0.0.1:5432/rubymvc ./bin/server 3000
```

Once it's up an running, point your browser to
[http://localhost:3000/sketches/new](http://localhost:3000/sketches/new)
