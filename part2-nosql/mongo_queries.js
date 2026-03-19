// OP1: insertMany() — insert all 3 documents from sample_documents.json
db.products.insertMany([
  {
    "_id": "ELEC001",
    "name": "Samsung 55-inch 4K Smart TV",
    "category": "Electronics",
    "price": 45999,
    "brand": "Samsung",
    "warranty": {
      "duration_months": 24,
      "type": "Comprehensive",
      "coverage": ["Manufacturing defects", "Screen damage", "Component failure"]
    },
    "voltage_specs": {
      "voltage": "220-240V",
      "frequency": "50-60Hz",
      "power_consumption_watts": 120
    },
    "technical_specs": {
      "screen_size": "55 inches",
      "resolution": "3840x2160",
      "refresh_rate": "120Hz",
      "smart_features": ["WiFi", "Bluetooth", "Voice Control"]
    }
  },
  {
    "_id": "CLOTH001",
    "name": "Men's Cotton Casual Shirt",
    "category": "Clothing",
    "price": 1299,
    "brand": "Allen Solly",
    "sizes": ["S", "M", "L", "XL", "XXL"],
    "material": "100% Cotton",
    "color": "Navy Blue",
    "care_instructions": [
      "Machine wash cold",
      "Do not bleach",
      "Tumble dry low",
      "Iron on medium heat"
    ],
    "fit_type": "Regular Fit",
    "pattern": "Solid",
    "sleeve_type": "Full Sleeve"
  },
  {
    "_id": "GROC001",
    "name": "Organic Whole Wheat Bread",
    "category": "Groceries",
    "price": 65,
    "brand": "Harvest Gold",
    "expiry_date": ISODate("2024-12-15"),
    "nutritional_info": {
      "serving_size": "2 slices (60g)",
      "calories": 160,
      "total_fat_g": 2.5,
      "saturated_fat_g": 0.5,
      "cholesterol_mg": 0,
      "sodium_mg": 280,
      "total_carbohydrates_g": 28,
      "dietary_fiber_g": 4,
      "sugars_g": 3,
      "protein_g": 6,
      "vitamins": {
        "vitamin_d_mcg": 0,
        "calcium_mg": 40,
        "iron_mg": 2,
        "potassium_mg": 120
      }
    },
    "ingredients": ["Whole wheat flour", "Water", "Yeast", "Salt", "Sugar", "Vegetable oil"],
    "allergen_info": ["Contains wheat", "May contain traces of soy"]
  }
]);

// OP2: find() — retrieve all Electronics products with price > 20000
db.products.find({
  category: "Electronics",
  price: { $gt: 20000 }
});

// OP3: find() — retrieve all Groceries expiring before 2025-01-01
db.products.find({
  category: "Groceries",
  expiry_date: { $lt: ISODate("2025-01-01") }
});

// OP4: updateOne() — add a "discount_percent" field to a specific product
db.products.updateOne(
  { _id: "ELEC001" },
  { $set: { discount_percent: 15 } }
);

// OP5: createIndex() — create an index on category field and explain why
db.products.createIndex({ category: 1 });

/*
  EXPLANATION FOR OP5 (createIndex on category field):
  
  Why this index is important:
  
  1. QUERY PERFORMANCE: The category field is frequently used in filtering operations
     (as seen in OP2 and OP3). Without an index, MongoDB performs a collection scan,
     checking every document. With an index, MongoDB can quickly locate documents
     matching the category value.
  
  2. E-COMMERCE USE CASE: In an e-commerce platform, users commonly browse products
     by category (Electronics, Clothing, Groceries). This is one of the most common
     query patterns, making it an ideal candidate for indexing.

  3. SORTING AND AGGREGATION: If we need to group products by category or sort
     results within categories, the index will significantly improve performance
     for these operations as well.
  
  Performance Impact:
  - Without index: O(n) - scans all documents
  - With index: O(log n) - uses B-tree traversal
  
  For a catalog with thousands of products, this index can reduce query time from
  seconds to milliseconds.
*/