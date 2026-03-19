# RDBMS vs NoSQL Database Comparison

## Database Recommendation

### Healthcare Patient Management System: MySQL vs MongoDB

For a healthcare startup building a patient management system, I would recommend **MySQL (RDBMS)** as the primary database, with the following justification:

**Why MySQL for Core Patient Management:**

Healthcare data demands strict ACID (Atomicity, Consistency, Isolation, Durability) compliance. Patient records, medical histories, prescriptions, and billing information require guaranteed consistency and transactional integrity. MySQL excels here by ensuring that critical operations—such as updating patient records or processing insurance claims—either complete fully or roll back entirely, preventing data corruption or partial updates that could have serious medical consequences.

From a CAP theorem perspective, healthcare systems prioritize **Consistency and Availability** over Partition tolerance. Patient data must be accurate across all nodes, and the system must remain available for emergency access. MySQL's strong consistency model ensures that when a doctor updates a patient's medication, all subsequent queries immediately reflect this change, which is crucial for patient safety.

Additionally, healthcare data is highly structured and relational: patients have appointments, doctors have specializations, prescriptions link to medications, and insurance claims reference treatments. MySQL's relational model naturally represents these relationships through foreign keys and JOIN operations, making complex queries efficient and maintainable.

**Impact of Fraud Detection Module:**

The addition of a fraud detection module would **partially shift the recommendation** toward a hybrid architecture. While MySQL should remain the system of record for patient data, I would introduce MongoDB for the fraud detection component. Here's why:

Fraud detection requires real-time analysis of large volumes of unstructured or semi-structured data—claim patterns, behavioral anomalies, external data sources, and machine learning model outputs. MongoDB's BASE (Basically Available, Soft state, Eventually consistent) properties and flexible schema make it ideal for this use case. The fraud detection system can tolerate eventual consistency since fraud analysis is typically asynchronous and doesn't require immediate transactional guarantees.

**Final Architecture Recommendation:**

Implement a **polyglot persistence strategy**: MySQL for core patient management (ACID-critical operations) and MongoDB for fraud detection analytics (flexible, high-throughput analysis). This approach leverages each database's strengths while maintaining data integrity where it matters most—patient safety and regulatory compliance.