import { column, Schema, Table } from '@powersync/web';

export const CUSTOMER_TABLE = 'customer';
export const USERS_TABLE = 'users';
export const CATEGORIES_TABLE = 'categories';
export const PRODUCTS_TABLE = 'products';
export const MENU_TABLE = 'menu';
export const MENU_PRODUCTS_TABLE = 'menuproducts';
export const ORDERS_TABLE = 'orders';
export const MENU_ORDER_TABLE = 'menuorder';
export const PRODUCT_ORDER_TABLE = 'productorder';

const customer = new Table({
    email: column.text,
    password: column.text
});

const users = new Table({
    firstname: column.text,
    lastname: column.text,
    city: column.text,
    birthAt: column.text,
    contact: column.text,
    OTPCode: column.text,
    OTPExpAt: column.text,
    customer_id: column.text
}, { indexes: { customer: ['customer_id'] } });

const categories = new Table({
    categorie_id: column.text,
    name: column.text,
    image: column.text
});

const products = new Table({
    name: column.text,
    price: column.real,
    disponibilite: column.text,
    inPromo: column.integer,
    active: column.integer,
    promoPrice: column.real,
    ingredients: column.text,
    allergies: column.text,
    description: column.text,
    images: column.text,
    categorie_id: column.text
}, { indexes: { category: ['categorie_id'] } });

const menu = new Table({
    name: column.text,
    price: column.real,
    disponibilite: column.text,
    description: column.text,
    inPromo: column.integer,
    active: column.integer,
    images: column.text
});

const menuProducts = new Table({
    menu_id: column.text,
    product_id: column.text
}, { indexes: { menu: ['menu_id'], product: ['product_id'] } });

const orders = new Table({
    order_date: column.text,
    status: column.text,
    order_type: column.text,
    totalPrice: column.integer,
    paymentMethod: column.text,
    user_id: column.text
});

const menuOrder = new Table({
    menu_id: column.text,
    ingredients: column.text,
    quantity: column.integer,
    order_id: column.text
}, { indexes: { menu: ['menu_id'], order: ['order_id'] } });

const productOrder = new Table({
    order_id: column.text,
    ingredients: column.text,
    quantity: column.integer,
    product_id: column.text
}, { indexes: { order: ['order_id'], product: ['product_id'] } });

export const AppSchema = new Schema({
    customer,
    users,
    categories,
    products,
    menu,
    menuProducts,
    orders,
    menuOrder,
    productOrder
});

export type Database = (typeof AppSchema)['types'];
export type CustomerRecord = Database['customer'];
export type UserRecord = Database['users'];
export type CategoryRecord = Database['categories'];
export type ProductRecord = Database['products'];
export type MenuRecord = Database['menu'];
export type MenuProductRecord = Database['menuProducts'];
export type OrderRecord = Database['orders'];
export type MenuOrderRecord = Database['menuOrder'];
export type ProductOrderRecord = Database['productOrder'];
