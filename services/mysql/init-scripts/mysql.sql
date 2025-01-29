-- Create a user with necessary privileges
CREATE USER 'repl_user'@'%' IDENTIFIED BY 'good_password';

-- Grant replication client privilege
GRANT REPLICATION SLAVE, REPLICATION CLIENT ON *.* TO 'repl_user'@'%';

-- Grant access to the specific database
GRANT ALL PRIVILEGES ON powersync.* TO 'repl_user'@'%';

-- Apply changes
FLUSH PRIVILEGES;

CREATE TABLE Customer (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    email CHAR(50) NOT NULL UNIQUE,
    password CHAR(200) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE Users (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    firstname CHAR(50) NOT NULL,
    lastname CHAR(50) NOT NULL,
    city CHAR(50),
    birthAt DATE,
    contact CHAR(50) NOT NULL,
    OTPCode CHAR(50),
    OTPExpAt DATE,
    customer_id CHAR(36) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
);

CREATE TABLE Categories (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    name CHAR(50) NOT NULL,
    image CHAR(50),
    PRIMARY KEY (id)
);

CREATE TABLE Products (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    name CHAR(50) NOT NULL UNIQUE,
    price FLOAT NOT NULL,
    disponibilite VARCHAR(20) NOT NULL CHECK (disponibilite IN ('exhausted', 'in stock')),
    inPromo BOOLEAN NOT NULL DEFAULT False,
    active BOOLEAN NOT NULL DEFAULT True,
    promoPrice FLOAT,
    ingredients CHAR(200) NOT NULL,
    allergies CHAR(200) NOT NULL,
    description CHAR(150) NOT NULL,
    images CHAR(150),
    categorie_id CHAR(36) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (categorie_id) REFERENCES Categories(id)
);

CREATE TABLE Menu (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    name CHAR(50) NOT NULL UNIQUE,
    price FLOAT NOT NULL,
    disponibilite VARCHAR(20) NOT NULL CHECK (disponibilite IN ('exhausted', 'in stock')),
    description CHAR(150) NOT NULL,
    inPromo BOOLEAN NOT NULL DEFAULT False,
    active BOOLEAN NOT NULL DEFAULT True,
    images CHAR(150),
    PRIMARY KEY (id)
);

CREATE TABLE MenuProducts (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    menu_id CHAR(36) NOT NULL,
    product_id CHAR(36) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (menu_id) REFERENCES Menu(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);

CREATE TABLE Orders (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    order_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'in_cooking', 'packaging', 'checkout', 'validated', 'delivered', 'cancelled')),
    order_type VARCHAR(20) CHECK (order_type IN ('order_status')),
    totalPrice INT NOT NULL,
    paymentMethod CHAR(200) NOT NULL,
    user_id CHAR(36) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

CREATE TABLE MenuOrder (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    menu_id CHAR(36) NOT NULL,
    order_id CHAR(36) NOT NULL,
    ingredients CHAR(200) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (menu_id) REFERENCES Menu(id),
    FOREIGN KEY (order_id) REFERENCES Orders(id)
);

CREATE TABLE ProductOrder (
    id CHAR(36) NOT NULL DEFAULT (UUID()),
    product_id CHAR(36) NOT NULL,
    ingredients CHAR(200) NOT NULL,
    quantity INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (order_id) REFERENCES Orders(id),
    FOREIGN KEY (product_id) REFERENCES Products(id)
);