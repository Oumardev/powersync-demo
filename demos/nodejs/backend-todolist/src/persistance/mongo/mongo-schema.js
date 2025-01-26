export const types = {
  date: (v) => new Date(v),
  boolean: (v) => !!v,
  string: (v) => String(v),
  number: (v) => Number(v),
  float: (v) => parseFloat(v),
  enum: (values) => (v) => values.includes(v) ? v : values[0]
};

export const schema = {
  Customer: {
    _id: types.string,
    email: types.string,
    password: types.string
  },
  Users: {
    _id: types.string,
    firstname: types.string,
    lastname: types.string,
    city: types.string,
    birthAt: types.date,
    contact: types.string,
    OTPCode: types.string,
    OTPExpAt: types.date,
    customer_id: types.string
  },
  Categories: {
    _id: types.string,
    name: types.string,
    image: types.string
  },
  Products: {
    _id: types.string,
    name: types.string,
    price: types.float,
    disponibilite: types.enum(['exhausted', 'in stock']),
    inPromo: types.boolean,
    active: types.boolean,
    promoPrice: types.float,
    ingredients: types.string,
    allergies: types.string,
    description: types.string,
    images: types.string,
    categorie_id: types.string
  },
  Menu: {
    _id: types.string,
    name: types.string,
    price: types.float,
    disponibilite: types.enum(['exhausted', 'in stock']),
    description: types.string,
    inPromo: types.boolean,
    active: types.boolean,
    images: types.string
  },
  MenuProducts: {
    _id: types.string,
    menu_id: types.string,
    product_id: types.string
  },
  Orders: {
    _id: types.string,
    order_date: types.date,
    status: types.enum(['pending', 'in_cooking', 'packaging', 'checkout', 'validated', 'delivered', 'cancelled']),
    order_type: types.enum(['order_status']),
    totalPrice: types.number,
    ingredients: types.string,
    paymentMethod: types.string
  },
  MenuOrder: {
    _id: types.string,
    menu_id: types.string,
    order_id: types.string
  },
  ProductOrder: {
    order_id: types.string,
    product_id: types.string
  }
};

/**
 * A basic function to convert data according to a schema specified above.
 *
 * A production application should probably use a purpose-built library for this,
 * and use MongoDB Schema Validation to enforce the types in the database.
 */
export function applySchema(tableSchema, data) {
  const converted = Object.entries(tableSchema)
    .map(([key, converter]) => {
      const rawValue = data[key];
      if (typeof rawValue == 'undefined') {
        return null;
      } else if (rawValue == null) {
        return [key, null];
      } else {
        return [key, converter(rawValue)];
      }
    })
    .filter((v) => v != null);
  return Object.fromEntries(converted);
}
