-- TODO change this if changing the DB connection name
\connect postgres;

-- Create tables
CREATE TABLE Customer (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(200) NOT NULL
);

CREATE TABLE Users (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    firstname VARCHAR(50) NOT NULL,
    lastname VARCHAR(50) NOT NULL,
    city VARCHAR(50),
    birthAt Date,
    contact VARCHAR(50) NOT NULL,
    OTPCode VARCHAR(50),
    OTPExpAt Date,
    customer_id uuid NOT NULL REFERENCES Customer(id)
);

CREATE TABLE Categories (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    image VARCHAR(50)
);

CREATE TABLE Products (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    price float NOT NULL,
    disponibilite VARCHAR(20) NOT NULL CHECK (disponibilite IN ('exhausted', 'in stock')),
    inPromo boolean NOT NULL DEFAULT False,
    active boolean NOT NULL DEFAULT True,
    promoPrice float,
    ingredients VARCHAR(200) NOT NULL,
    allergies VARCHAR(200) NOT NULL,
    description VARCHAR(150) NOT NULL,
    images VARCHAR(150),
    categorie_id uuid NOT NULL REFERENCES Categories(id)
);

CREATE TABLE Menu (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    price float NOT NULL,
    disponibilite VARCHAR(20) NOT NULL CHECK (disponibilite IN ('exhausted', 'in stock')),
    description VARCHAR(150) NOT NULL,
    inPromo boolean NOT NULL DEFAULT False,
    active boolean NOT NULL DEFAULT True,
    images VARCHAR(150)
);

CREATE TABLE MenuProducts (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,  
    menu_id uuid NOT NULL REFERENCES Menu(id),
    product_id uuid NOT NULL REFERENCES Products(id)
);

CREATE TABLE Orders (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    order_date date NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'in_cooking', 'packaging', 'checkout', 'validated', 'delivered', 'cancelled')),
    order_type VARCHAR(20) CHECK (order_type IN ('order_status')),
    totalPrice int NOT NULL,
    paymentMethod VARCHAR(200) NOT NULL,
    user_id uuid NOT NULL REFERENCES Users(id)
);

CREATE TABLE MenuOrder (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    ingredients VARCHAR(200) NOT NULL,
    quantity int NOT NULL,
    menu_id uuid NOT NULL REFERENCES Menu(id),
    order_id uuid NOT NULL REFERENCES Orders(id)
);

CREATE TABLE ProductOrder (
    id uuid NOT NULL default gen_random_uuid () PRIMARY KEY,
    ingredients VARCHAR(200) NOT NULL,
    quantity int NOT NULL,
    order_id uuid NOT NULL REFERENCES Orders(id),
    product_id uuid NOT NULL REFERENCES Products(id)
);

-- Create publication for PowerSync
create publication powersync for table Customer, Users, Categories, Products, Menu, MenuProducts, Orders, MenuOrder, ProductOrder;
