## Anomaly Analysis

### 1. Insert Anomaly

**Example from Dataset**:

- **Specific Case**: If the company wants to add a new product (e.g., P009 - "Keyboard") to their inventory, they cannot do so in the current flat file structure without creating a fake order record.

---

### 2. Update Anomaly

**Example from Dataset**:

- **Specific Rows**:
  - **Row 39**: `office_address = "Mumbai HQ, Nariman Pt, Mumbai - 400021"`
  - **Row 40**: `office_address = "Mumbai HQ, Nariman Point, Mumbai - 400021"`
  - **Row 58**: `office_address = "Mumbai HQ, Nariman Pt, Mumbai - 400021"`
  - **Row 91**: `office_address = "Mumbai HQ, Nariman Pt, Mumbai - 400021"`
  
- **Problem**: The abbreviation "Pt" vs full word "Point" creates data inconsistency. If we need to update SR01's office address, we must update approximately 60+ rows where SR01 appears. Missing even one row creates data inconsistency.

**Additional Examples**:
- Customer C002 (Priya Sharma) appears in 15+ rows. If her email changes from `priya@gmail.com` to a new address, all 15+ rows must be updated.
- Product P007 (Pen Set) appears in 30+ rows. If the unit price changes from 250 to 275, all 30+ rows need updating.

---

### 3. Delete Anomaly

**Example from Dataset**:

- **Specific Row**: **Row 13** - Order ORD1185 by customer C003 (Amit Verma) for 1 Webcam at 2100 INR
  ```
  ORD1185,C003,Amit Verma,amit@gmail.com,Bangalore,P008,Webcam,Electronics,2100,1,2023-06-15,SR03,Ravi Kumar,ravi@corp.com,"South Zone, MG Road, Bangalore - 560001"
  ```
- **Problem**: If we delete order ORD1185 (perhaps due to cancellation or data cleanup), we lose all information about the Webcam product including:
  - Product name (Webcam)
  - Category (Electronics)
  - Unit price (2100)
  
**Additional Example**:
- If all orders from customer C008 (Kavya Rao) are deleted, we lose all information about this customer, including their contact details and location.

---

## Normalization Justification

### Manager's Argument: "Keeping everything in one table is simpler and normalization is over-engineering."

**Counter-Argument: Normalization is Essential for Data Integrity and Business Operations**

While a single-table approach may seem simpler initially, the `orders_flat.csv` dataset demonstrates critical flaws that directly impact business operations. Consider the real-world consequences:

**Data Integrity Crisis**: Sales representative SR01's office address appears inconsistently as both "Nariman Pt" and "Nariman Point" across 60+ rows (rows 39, 40, 58, 91, etc.). Which is correct? This ambiguity creates confusion for shipping, customer service, and reporting. In a normalized structure, this address exists once, eliminating inconsistency.

**Operational Inefficiency**: When customer Priya Sharma (C002) updates her email, staff must manually locate and update 15+ scattered rows. Human error is inevitable—missing even one row means some systems use the old email while others use the new one. This isn't theoretical; it's a daily operational nightmare that wastes staff time and creates customer service issues.

**Business Risk**: Product P008 (Webcam) appears only in row 13. If that order is cancelled or archived, the company loses all knowledge of this product's existence, pricing, and category. How can the sales team quote prices or inventory managers track stock for a product that "disappeared" from the system?

**Scalability Failure**: The current file has 186 rows with massive redundancy. Customer and product information repeats hundreds of times, wasting storage. As the business grows to thousands of orders monthly, this approach becomes unmanageable. Query performance degrades, file sizes explode, and the risk of data corruption increases exponentially.

**The Reality**: Normalization isn't over-engineering—it's fundamental database design that prevents data loss, ensures consistency, improves performance, and scales with business growth. The "simplicity" of one table is an illusion that creates complex, error-prone operations. Proper normalization to 3NF eliminates all three anomalies while actually simplifying data management through clear, logical structure.

The evidence is clear: normalization is not optional for any serious business database—it's essential for operational integrity and long-term success.