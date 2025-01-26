
create table
  public.Customer (
    id uuid not null default gen_random_uuid(),
    email char(50) not null unique,
    password char(200) not null,
    constraint customer_pkey primary key (id)
  ) tablespace pg_default;

create table
  public.Users (
    id uuid not null default gen_random_uuid(),
    firstname char(50) not null,
    lastname char(50) not null,
    city char(50),
    birthAt date,
    contact char(50) not null,
    OTPCode char(50),
    OTPExpAt date,
    customer_id uuid not null,
    constraint users_pkey primary key (id),
    constraint users_customer_id_fkey foreign key (customer_id) references public.Customer(customer_id) on delete cascade
  ) tablespace pg_default;

create table
  public.Categories (
    id uuid not null default gen_random_uuid(),
    name char(50) not null,
    image char(50),
    constraint categories_pkey primary key (id)
  ) tablespace pg_default;

create table
  public.Products (
    id uuid not null default gen_random_uuid(),
    name char(50) not null unique,
    price float not null,
    disponibilite text not null check (disponibilite in ('exhausted', 'in stock')),
    inPromo boolean not null default false,
    active boolean not null default true,
    promoPrice float,
    ingredients char(200) not null,
    allergies char(200) not null,
    description char(150) not null,
    images char(150),
    categorie_id uuid not null,
    constraint products_pkey primary key (id),
    constraint products_categorie_id_fkey foreign key (categorie_id) references public.Categories(categorie_id) on delete cascade
  ) tablespace pg_default;

create table
  public.Menu (
    id uuid not null default gen_random_uuid(),
    name char(50) not null unique,
    price float not null,
    disponibilite text not null check (disponibilite in ('exhausted', 'in stock')),
    description char(150) not null,
    inPromo boolean not null default false,
    active boolean not null default true,
    images char(150),
    constraint menu_pkey primary key (id)
  ) tablespace pg_default;

create table
  public.MenuProducts (
    id uuid not null default gen_random_uuid(),
    menu_id uuid not null,
    product_id uuid not null,
    constraint menu_products_pkey primary key (id),
    constraint menu_products_menu_id_fkey foreign key (menu_id) references public.Menu(id) on delete cascade,
    constraint menu_products_product_id_fkey foreign key (product_id) references public.Products(id) on delete cascade
  ) tablespace pg_default;

create table
  public.Orders (
    id uuid not null default gen_random_uuid(),
    order_date date not null,
    status text not null check (status in ('pending', 'in_cooking', 'packaging', 'checkout', 'validated', 'delivered', 'cancelled')),
    order_type text check (order_type in ('order_status')),
    totalPrice integer not null,
    ingredients char(200) not null,
    paymentMethod char(200) not null,
    constraint orders_pkey primary key (id)
  ) tablespace pg_default;

create table
  public.MenuOrder (
    id uuid not null default gen_random_uuid(),
    menu_id uuid not null,
    order_id uuid not null,
    constraint menu_order_pkey primary key (id),
    constraint menu_order_menu_id_fkey foreign key (menu_id) references public.Menu(id) on delete cascade,
    constraint menu_order_order_id_fkey foreign key (order_id) references public.Orders(id) on delete cascade
  ) tablespace pg_default;

create table
  public.ProductOrder (
    id uuid not null default gen_random_uuid(),
    product_id uuid not null,
    constraint product_order_pkey primary key (id, id),
    constraint product_order_order_id_fkey foreign key (order_id) references public.Orders(id) on delete cascade,
    constraint product_order_product_id_fkey foreign key (product_id) references public.Products(id) on delete cascade
  ) tablespace pg_default;

-- Create publication for powersync
create publication powersync for table 
  public.Customer,
  public.Users,
  public.Categories,
  public.Products,
  public.Menu,
  public.MenuProducts,
  public.Orders,
  public.MenuOrder,
  public.ProductOrder;