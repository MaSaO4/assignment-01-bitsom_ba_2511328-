## ETL Decisions

### Decision 1 — Date Format Standardization

**Problem:**  
The raw data contained three different date formats across the 300 transactions:
- Format 1: `DD/MM/YYYY` (e.g., "29/08/2023") - approximately 33% of records
- Format 2: `DD-MM-YYYY` (e.g., "12-12-2023") - approximately 33% of records  
- Format 3: `YYYY-MM-DD` (e.g., "2023-02-05") - approximately 33% of records

This inconsistency would cause:
- Parsing errors during data loading
- Incorrect date comparisons and sorting
- Ambiguity in date interpretation (e.g., is "01/02/2023" January 2nd or February 1st?)
- Failure of temporal analytics queries

**Resolution:**  
Standardized all dates to ISO 8601 format (`YYYY-MM-DD`) during the ETL process:
- Parsed each date format using appropriate date parsing logic
- Converted all dates to the standard `YYYY-MM-DD` format
- Created a `date_id` surrogate key in format `YYYYMMDD` (e.g., 20230829) for efficient joins
- Populated `dim_date` with hierarchical attributes (year, month, quarter, day_of_week) to support temporal analysis

**Example Transformations:**
- `"29/08/2023"` → `2023-08-29` (date_id: 20230829)
- `"12-12-2023"` → `2023-12-12` (date_id: 20231212)
- `"2023-02-05"` → `2023-02-05` (date_id: 20230205) [already standard]

---

### Decision 2 — NULL Value Handling for Store City

**Problem:**  
Approximately 15 transactions (~5% of the dataset) had NULL or missing values in the `store_city` column while the `store_name` column was populated. Examples include:
- Row 35: `store_name = "Mumbai Central"`, `store_city = NULL`
- Row 44: `store_name = "Chennai Anna"`, `store_city = NULL`
- Row 82: `store_name = "Delhi South"`, `store_city = NULL`
- Row 94: `store_name = "Delhi South"`, `store_city = NULL`

This created issues:
- Incomplete dimension records in `dim_store`
- Inability to perform location-based analytics
- Potential for duplicate store records with different city values
- Loss of geographic insights for business intelligence

**Resolution:**  
Implemented a lookup-based approach to derive missing city values from store names:
1. Identified the pattern that store names contain city identifiers:
   - "Chennai Anna" → Chennai
   - "Delhi South" → Delhi
   - "Mumbai Central" → Mumbai
   - "Bangalore MG" → Bangalore
   - "Pune FC Road" → Pune

2. Created a mapping logic to extract city from store name
3. Populated `dim_store` with complete records ensuring each store has exactly one city
4. Applied this mapping during fact table loading to ensure referential integrity

**Example Transformations:**
- `store_name = "Mumbai Central"`, `store_city = NULL` → `store_city = "Mumbai"`
- `store_name = "Chennai Anna"`, `store_city = NULL` → `store_city = "Chennai"`
- `store_name = "Delhi South"`, `store_city = NULL` → `store_city = "Delhi"`

---

### Decision 3 — Category Name Standardization

**Problem:**  
Product categories had inconsistent casing and naming conventions:
- **Electronics**: Mixed case usage
  - "Electronics" (proper case) - ~50% of electronics products
  - "electronics" (lowercase) - ~50% of electronics products
- **Grocery**: Inconsistent plural forms
  - "Grocery" (singular) - ~60% of grocery products
  - "Groceries" (plural) - ~40% of grocery products

This inconsistency caused:
- Duplicate category groupings in aggregations (e.g., "Electronics" and "electronics" treated as separate categories)
- Incorrect revenue calculations by category
- Confusion in business reporting and dashboards
- Difficulty in category-level trend analysis

**Resolution:**  
Implemented a standardization rule for all category names:
1. **Casing Rule**: Applied title case (first letter capitalized) to all categories
   - "electronics" → "Electronics"
   - "ELECTRONICS" → "Electronics"

2. **Naming Convention**: Standardized to singular form for consistency
   - "Groceries" → "Grocery"
   - Maintained "Electronics" (already singular)
   - Maintained "Clothing" (already singular)

3. **Implementation**: 
   - Created `dim_product` with standardized category values
   - Applied transformation during data loading to ensure consistency
   - Documented the standard categories: Electronics, Clothing, Grocery

**Example Transformations:**
- Product: "Speaker", Category: "electronics" → "Electronics"
- Product: "Biscuits", Category: "Groceries" → "Grocery"
- Product: "Milk 1L", Category: "Groceries" → "Grocery"
- Product: "Smartwatch", Category: "electronics" → "Electronics"