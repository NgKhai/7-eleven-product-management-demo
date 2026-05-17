require('dotenv').config();
const { connectDB } = require('../config/database');
const Category = require('../models/Category.model');
const Order = require('../models/Order.model');
const Product = require('../models/Product.model');
const User = require('../models/User.model');

const seed = async () => {
  await connectDB();
  await Promise.all([
    Order.deleteMany(),
    Product.deleteMany(),
    Category.deleteMany(),
    User.deleteMany(),
  ]);

  // ── Users ──────────────────────────────────────────────────────────────
  const admin = await User.create({
    name: 'Administrator',
    email: process.env.ADMIN_EMAIL || 'admin@example.com',
    password: process.env.ADMIN_PASSWORD || 'Admin@123456',
    role: 'admin',
  });

  const user1 = await User.create({
    name: 'John Doe',
    email: 'user@example.com',
    password: 'User@123456',
    role: 'user',
    address: '123 Demo Street',
  });

  const user2 = await User.create({
    name: 'Jane Smith',
    email: 'jane@example.com',
    password: 'User@123456',
    role: 'user',
    address: '456 Elm Avenue, Apt 12',
  });

  const user3 = await User.create({
    name: 'Mike Johnson',
    email: 'mike@example.com',
    password: 'User@123456',
    role: 'user',
    address: '789 Oak Boulevard',
  });

  // ── Categories ─────────────────────────────────────────────────────────
  const categories = await Category.insertMany([
    {
      name: 'Beverages',
      description: 'Hot & cold drinks, coffee, tea, juices, water, and energy drinks',
      imageUrl: 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400',
    },
    {
      name: 'Snacks & Chips',
      description: 'Potato chips, nuts, candy bars, cookies, and savory bites',
      imageUrl: 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=400',
    },
    {
      name: 'Ready Meals',
      description: 'Sandwiches, rice bowls, wraps, salads, and heat-and-eat meals',
      imageUrl: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400',
    },
    {
      name: 'Dairy & Frozen',
      description: 'Milk, yogurt, ice cream, frozen treats, and cheese',
      imageUrl: 'https://images.unsplash.com/photo-1563636619-e9143da7973b?w=400',
    },
    {
      name: 'Personal Care & Essentials',
      description: 'Toiletries, hygiene products, medicine, and travel-size essentials',
      imageUrl: 'https://images.unsplash.com/photo-1556228578-0d85b1a4d571?w=400',
    },
    {
      name: 'Promotions & Combos',
      description: 'Limited-time deals, meal combos, and seasonal bundles',
      imageUrl: 'https://images.unsplash.com/photo-1607082349566-187342175e2f?w=400',
    },
  ]);

  const [beverages, snacks, readyMeals, dairy, personalCare, promos] = categories;

  // ── Products ───────────────────────────────────────────────────────────
  const products = await Product.insertMany([

    // ─── Beverages (8) ─────────────────────────────────────────────────
    {
      name: 'Iced Americano',
      description: 'Freshly brewed iced coffee made with premium espresso and cold water. A bold, smooth pick-me-up.',
      price: 2.49,
      stockQuantity: 80,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1517701550927-30cf4ba1dba5?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Caramel Latte',
      description: 'Rich espresso blended with steamed milk and buttery caramel syrup, topped with whipped cream.',
      price: 3.99,
      stockQuantity: 60,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Green Tea Matcha Latte',
      description: 'Ceremonial-grade matcha whisked with creamy oat milk. Earthy, smooth, and energizing.',
      price: 3.49,
      stockQuantity: 45,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1515823064-d6e0c04616a7?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Fresh Orange Juice 350ml',
      description: '100% squeezed fresh orange juice with no added sugar. Packed with Vitamin C.',
      price: 2.99,
      stockQuantity: 40,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1621506289937-a8e4df240d0b?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Mineral Water 500ml',
      description: 'Purified natural mineral water in a convenient BPA-free bottle. Perfect for daily hydration.',
      price: 0.99,
      stockQuantity: 200,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Energy Drink 250ml',
      description: 'High-caffeine energy drink with taurine and B-vitamins. Sugar-free formula for sustained energy.',
      price: 2.79,
      stockQuantity: 90,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1622543925917-763c34d1a86e?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Sparkling Lemon Soda 330ml',
      description: 'Crisp, bubbly lemon soda with real lemon juice. A refreshing citrus kick.',
      price: 1.49,
      stockQuantity: 120,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1625772299848-391b6a87d7b3?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Thai Milk Tea',
      description: 'Authentic Thai-style iced tea with sweetened condensed milk. Rich, creamy, and aromatic.',
      price: 2.99,
      stockQuantity: 55,
      categoryId: beverages._id,
      images: [{ url: 'https://images.unsplash.com/photo-1558857563-b371033873b8?w=500' }],
      createdBy: admin._id,
    },

    // ─── Snacks & Chips (7) ────────────────────────────────────────────
    {
      name: 'Classic Salted Potato Chips 150g',
      description: 'Thin-cut, perfectly salted potato chips. Crunchy and irresistible.',
      price: 2.29,
      stockQuantity: 100,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'BBQ Flavored Tortilla Chips 200g',
      description: 'Bold smoky BBQ seasoning on crispy corn tortilla chips. Great with salsa or guacamole.',
      price: 2.99,
      stockQuantity: 70,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1600952841320-db92ec4047ca?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Mixed Nuts & Trail Mix 120g',
      description: 'Premium blend of almonds, cashews, walnuts, and dried cranberries. A protein-packed snack.',
      price: 3.99,
      stockQuantity: 50,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1599599810694-b5b37304c041?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Chocolate Cookie Sandwich',
      description: 'Crispy chocolate cookies filled with smooth vanilla cream. Individually wrapped for freshness.',
      price: 1.79,
      stockQuantity: 85,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1558961363-fa8fdf82db35?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Beef Jerky Teriyaki 80g',
      description: 'Slow-dried premium beef strips marinated in sweet teriyaki glaze. High protein, low fat.',
      price: 4.99,
      stockQuantity: 35,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1613145997970-db84a7975fbb?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Gummy Bears Pack 200g',
      description: 'Assorted fruity gummy bears in strawberry, grape, orange, lemon, and apple flavors.',
      price: 1.99,
      stockQuantity: 110,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1582058091505-f87a2e55a40f?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Protein Bar – Peanut Butter 60g',
      description: '20g of protein per bar with crunchy peanut butter coating. Perfect post-workout snack.',
      price: 2.49,
      stockQuantity: 65,
      categoryId: snacks._id,
      images: [{ url: 'https://images.unsplash.com/photo-1622484212850-eb596d769eab?w=500' }],
      createdBy: admin._id,
    },

    // ─── Ready Meals (6) ───────────────────────────────────────────────
    {
      name: 'Chicken Teriyaki Rice Bowl',
      description: 'Tender chicken pieces glazed with teriyaki sauce, served on steamed jasmine rice with pickled ginger.',
      price: 5.99,
      stockQuantity: 30,
      categoryId: readyMeals._id,
      images: [{ url: 'https://images.unsplash.com/photo-1569058242567-93de6f36f8eb?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Turkey & Cheese Sandwich',
      description: 'Sliced turkey breast with cheddar cheese, lettuce, and honey mustard on multigrain bread.',
      price: 4.49,
      stockQuantity: 25,
      categoryId: readyMeals._id,
      images: [{ url: 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Caesar Salad Bowl',
      description: 'Crisp romaine lettuce, parmesan shavings, croutons, and creamy Caesar dressing.',
      price: 4.99,
      stockQuantity: 20,
      categoryId: readyMeals._id,
      images: [{ url: 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Spicy Tuna Onigiri (2 pcs)',
      description: 'Japanese-style rice balls filled with spicy tuna mayo, wrapped in crispy nori seaweed.',
      price: 3.49,
      stockQuantity: 40,
      categoryId: readyMeals._id,
      images: [{ url: 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Mac & Cheese Cup',
      description: 'Creamy three-cheese macaroni in a microwaveable cup. Ready in 90 seconds.',
      price: 3.29,
      stockQuantity: 50,
      categoryId: readyMeals._id,
      images: [{ url: 'https://images.unsplash.com/photo-1543339494-b4cd4f7ba686?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Hot Dog Classic',
      description: 'All-beef frank in a soft steamed bun with ketchup and mustard on the side.',
      price: 2.49,
      stockQuantity: 60,
      categoryId: readyMeals._id,
      images: [{ url: 'https://images.unsplash.com/photo-1612392062126-11e08dfa9fbc?w=500' }],
      createdBy: admin._id,
    },

    // ─── Dairy & Frozen (5) ────────────────────────────────────────────
    {
      name: 'Strawberry Yogurt Cup 150g',
      description: 'Creamy Greek yogurt with real strawberry pieces. High in protein, low in sugar.',
      price: 1.99,
      stockQuantity: 40,
      categoryId: dairy._id,
      images: [{ url: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Chocolate Ice Cream Bar',
      description: 'Premium Belgian chocolate-coated vanilla ice cream on a stick. A classic frozen treat.',
      price: 2.49,
      stockQuantity: 75,
      categoryId: dairy._id,
      images: [{ url: 'https://images.unsplash.com/photo-1629385701021-fcd568a743e8?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Fresh Whole Milk 1L',
      description: 'Farm-fresh pasteurized whole milk. Great for coffee, cereal, or drinking on its own.',
      price: 2.29,
      stockQuantity: 30,
      categoryId: dairy._id,
      images: [{ url: 'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Frozen Pepperoni Pizza',
      description: 'Stone-baked thin-crust pizza topped with mozzarella and spicy pepperoni. Oven-ready.',
      price: 5.49,
      stockQuantity: 20,
      categoryId: dairy._id,
      images: [{ url: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Mango Sorbet Cup',
      description: 'Dairy-free tropical mango sorbet made with real fruit puree. Refreshing and vegan-friendly.',
      price: 2.79,
      stockQuantity: 0,
      status: 'out_of_stock',
      categoryId: dairy._id,
      images: [{ url: 'https://images.unsplash.com/photo-1570197571499-166b36435e9f?w=500' }],
      createdBy: admin._id,
    },

    // ─── Personal Care & Essentials (5) ────────────────────────────────
    {
      name: 'Travel Toothpaste 30ml',
      description: 'Compact mint toothpaste for bags, office drawers, and travel. TSA-approved size.',
      price: 1.75,
      stockQuantity: 0,
      status: 'out_of_stock',
      categoryId: personalCare._id,
      images: [{ url: 'https://images.unsplash.com/photo-1559650656-5d1d361ad10e?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Hand Sanitizer 60ml',
      description: '70% alcohol hand sanitizer gel with aloe vera. Kills 99.9% of germs instantly.',
      price: 1.49,
      stockQuantity: 150,
      categoryId: personalCare._id,
      images: [{ url: 'https://images.unsplash.com/photo-1584483766114-2cea6facdf57?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Facial Tissue Pack (10 sheets)',
      description: 'Soft, triple-ply facial tissues. Pocket-sized pack for on-the-go convenience.',
      price: 0.99,
      stockQuantity: 200,
      categoryId: personalCare._id,
      images: [{ url: 'https://images.unsplash.com/photo-1585421514284-efb74c2b69ba?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Mini Deodorant Spray 50ml',
      description: 'Fresh ocean-scent antiperspirant spray. 48-hour protection in travel size.',
      price: 2.99,
      stockQuantity: 45,
      categoryId: personalCare._id,
      images: [{ url: 'https://images.unsplash.com/photo-1608248543803-ba4f8c70ae0b?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Pain Relief Tablets (12 pack)',
      description: 'Fast-acting ibuprofen 200mg tablets. Relieves headaches, muscle pain, and fever.',
      price: 3.49,
      stockQuantity: 60,
      categoryId: personalCare._id,
      images: [{ url: 'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500' }],
      createdBy: admin._id,
    },

    // ─── Promotions & Combos (4) ───────────────────────────────────────
    {
      name: 'Coffee + Pastry Morning Combo',
      description: 'Choose any hot coffee and a freshly baked croissant or muffin. Available 6AM–10AM.',
      price: 3.99,
      stockQuantity: 50,
      categoryId: promos._id,
      images: [{ url: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Snack Attack Combo',
      description: 'Any bag of chips + a 330ml soda can. Mix and match your favorites and save!',
      price: 3.50,
      stockQuantity: 45,
      categoryId: promos._id,
      images: [{ url: 'https://images.unsplash.com/photo-1621939514649-280e2ee25f60?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Lunch Deal – Sandwich + Drink',
      description: 'Any premium sandwich with a 500ml drink of your choice. Weekday lunch special.',
      price: 5.99,
      stockQuantity: 30,
      categoryId: promos._id,
      images: [{ url: 'https://images.unsplash.com/photo-1509722747041-616f39b57569?w=500' }],
      createdBy: admin._id,
    },
    {
      name: 'Summer Ice Cream Bundle (3 bars)',
      description: 'Pick any 3 ice cream bars and save 20%. Limited summer promotion while stocks last.',
      price: 5.99,
      stockQuantity: 25,
      categoryId: promos._id,
      images: [{ url: 'https://images.unsplash.com/photo-1497034825429-c343d7c6a68f?w=500' }],
      createdBy: admin._id,
    },
  ]);

  // ── Sample Orders ──────────────────────────────────────────────────────
  const order1 = new Order({
    customerId: user1._id,
    items: [
      {
        productId: products[0]._id,
        productName: products[0].name,
        imageUrl: products[0].images[0]?.url || '',
        quantity: 2,
        unitPrice: products[0].price,
        subtotal: products[0].price * 2,
      },
      {
        productId: products[15]._id,
        productName: products[15].name,
        imageUrl: products[15].images[0]?.url || '',
        quantity: 1,
        unitPrice: products[15].price,
        subtotal: products[15].price,
      },
    ],
    totalAmount: products[0].price * 2 + products[15].price,
    status: 'delivered',
    shippingAddress: '123 Demo Street',
    note: 'Please leave at the door',
    statusHistory: [
      { status: 'pending', note: 'Order placed', updatedBy: user1._id },
      { status: 'processing', note: 'Preparing order', updatedBy: admin._id },
      { status: 'shipping', note: 'Out for delivery', updatedBy: admin._id },
      { status: 'delivered', note: 'Delivered successfully', updatedBy: admin._id },
    ],
  });
  await order1.save();

  const order2 = new Order({
    customerId: user2._id,
    items: [
      {
        productId: products[8]._id,
        productName: products[8].name,
        imageUrl: products[8].images[0]?.url || '',
        quantity: 3,
        unitPrice: products[8].price,
        subtotal: products[8].price * 3,
      },
      {
        productId: products[4]._id,
        productName: products[4].name,
        imageUrl: products[4].images[0]?.url || '',
        quantity: 2,
        unitPrice: products[4].price,
        subtotal: products[4].price * 2,
      },
      {
        productId: products[22]._id,
        productName: products[22].name,
        imageUrl: products[22].images[0]?.url || '',
        quantity: 1,
        unitPrice: products[22].price,
        subtotal: products[22].price,
      },
    ],
    totalAmount: products[8].price * 3 + products[4].price * 2 + products[22].price,
    status: 'processing',
    shippingAddress: '456 Elm Avenue, Apt 12',
    statusHistory: [
      { status: 'pending', note: 'Order placed', updatedBy: user2._id },
      { status: 'processing', note: 'Being prepared', updatedBy: admin._id },
    ],
  });
  await order2.save();

  const order3 = new Order({
    customerId: user3._id,
    items: [
      {
        productId: products[31]._id,
        productName: products[31].name,
        imageUrl: products[31].images[0]?.url || '',
        quantity: 1,
        unitPrice: products[31].price,
        subtotal: products[31].price,
      },
      {
        productId: products[2]._id,
        productName: products[2].name,
        imageUrl: products[2].images[0]?.url || '',
        quantity: 1,
        unitPrice: products[2].price,
        subtotal: products[2].price,
      },
    ],
    totalAmount: products[31].price + products[2].price,
    status: 'pending',
    shippingAddress: '789 Oak Boulevard',
    note: 'Ring the bell twice',
    statusHistory: [
      { status: 'pending', note: 'Order placed', updatedBy: user3._id },
    ],
  });
  await order3.save();

  const order4 = new Order({
    customerId: user1._id,
    items: [
      {
        productId: products[20]._id,
        productName: products[20].name,
        imageUrl: products[20].images[0]?.url || '',
        quantity: 5,
        unitPrice: products[20].price,
        subtotal: products[20].price * 5,
      },
    ],
    totalAmount: products[20].price * 5,
    status: 'cancelled',
    shippingAddress: '123 Demo Street',
    note: 'Changed my mind',
    statusHistory: [
      { status: 'pending', note: 'Order placed', updatedBy: user1._id },
      { status: 'cancelled', note: 'Cancelled by customer', updatedBy: user1._id },
    ],
  });
  await order4.save();

  // ── Summary ────────────────────────────────────────────────────────────
  console.log('\n✅ Seed complete!\n');
  console.log(`   📦 ${products.length} products across ${categories.length} categories`);
  console.log(`   🛒 4 sample orders`);
  console.log(`   👤 4 users (1 admin + 3 customers)\n`);
  console.log('── Login Credentials ──────────────────────────');
  console.log('   Admin:  admin@example.com  | Admin@123456');
  console.log('   User 1: user@example.com   | User@123456');
  console.log('   User 2: jane@example.com   | User@123456');
  console.log('   User 3: mike@example.com   | User@123456');
  console.log('───────────────────────────────────────────────\n');
  process.exit(0);
};

seed().catch((error) => {
  console.error('Seed failed:', error);
  process.exit(1);
});
