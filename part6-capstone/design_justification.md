# Design Justification: Hospital AI-Powered Data System

## Storage Systems

For this hospital network's AI-powered data system, I've selected a multi-database architecture tailored to each of the four goals:

**Goal 1 - Predict Patient Readmission Risk:** A **Data Warehouse (PostgreSQL/Snowflake)** serves as the primary analytical store for historical treatment data. This choice enables efficient aggregation of patient histories, treatment outcomes, and readmission patterns needed for ML model training. The structured, denormalized star schema optimizes complex analytical queries across millions of patient records. Additionally, a **Feature Store (Feast/Tecton)** caches pre-computed features to reduce model inference latency.

**Goal 2 - Natural Language Query Interface:** A **Vector Database (Pinecone/Weaviate)** stores embeddings of patient records and medical histories, enabling semantic search capabilities. When doctors ask "Has this patient had a cardiac event before?", the NLP system converts the query to embeddings and performs similarity search. The underlying patient data remains in a **PostgreSQL OLTP database** for transactional integrity, while the vector DB provides the semantic layer.

**Goal 3 - Monthly Management Reports:** A **Data Warehouse (Snowflake/BigQuery)** with a star schema handles aggregated reporting. Fact tables store bed occupancy events and departmental costs, while dimension tables capture time, department, and facility hierarchies. This OLAP system is optimized for read-heavy analytical queries with pre-aggregated materialized views for common report patterns.

**Goal 4 - Real-time ICU Vitals Streaming:** A **Time-Series Database (InfluxDB/TimescaleDB)** stores high-frequency vitals data (heart rate, BP, oxygen levels) with millisecond precision. The streaming pipeline uses **Apache Kafka** for ingestion, ensuring fault-tolerant, ordered delivery of vital signs. For long-term storage and compliance, older vitals data is archived to a **Data Lake (S3/Azure Data Lake)** in Parquet format.

## OLTP vs OLAP Boundary

The transactional (OLTP) system encompasses the **operational PostgreSQL database** that handles real-time patient admissions, doctor orders, medication administration, and billing transactions. This system prioritizes ACID compliance, low-latency writes, and row-level locking for concurrent updates. The OLTP boundary includes the ICU monitoring system's immediate alert generation and the real-time vitals dashboard.

The transition to OLAP occurs through **ETL pipelines** that run on scheduled intervals (hourly for vitals, daily for patient records). Apache Airflow orchestrates these pipelines, extracting data from OLTP sources, transforming it into denormalized schemas, and loading it into the data warehouse. The **Kafka streaming layer** acts as a buffer zone—it's transactional in nature (ensuring exactly-once delivery) but feeds into analytical systems.

The analytical (OLAP) boundary begins at the **Data Warehouse**, where data is optimized for read-heavy operations, complex aggregations, and historical analysis. The ML training pipeline operates entirely in OLAP territory, consuming batch data from the warehouse. The vector database, while supporting real-time queries, is populated through batch embedding generation from OLAP sources.

A critical design decision is the **Change Data Capture (CDC)** implementation using Debezium, which captures OLTP database changes in near-real-time and streams them to Kafka. This creates a hybrid zone where transactional data becomes immediately available for analytical processing without impacting OLTP performance.

## Trade-offs

**Significant Trade-off: Data Freshness vs. System Performance**

The primary trade-off in this design is between data freshness for AI predictions and the performance impact on operational systems. Real-time readmission risk predictions require up-to-the-minute patient data, but continuously querying the OLTP database for ML inference would create unacceptable load on the transactional system that doctors and nurses depend on for patient care.