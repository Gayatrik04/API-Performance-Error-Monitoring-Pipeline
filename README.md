# API Performance & Error Monitoring Pipeline
An end-to-end data analytics and business intelligence solution tracking infrastructure health, microservice execution stability, and platform tier engagement.

-----------
## Problem Statement
Modern digital platforms depend heavily on APIs to exchange information between services, users, and external integrations. As consumption scales, organizations face massive challenges in tracking real-time latency, infrastructure utilization, and system loads. Without a centralized analytics framework, severe architectural issues—such as extreme response timeouts, asymmetric server workloads, and rising execution failure rates—go completely undetected, leading to diminished application efficiency and degraded user experiences.

--------
## Objective
The objective of this project is to build an end-to-end diagnostic data pipeline and multi-page dashboard suite using interconnected API telemetry, system logs, user subscription attributes, and regional footprint records. The pipeline isolates high-latency components, audits operational error distribution patterns, tracks client engagement profiles, and provides actionable engineering recommendations to resolve localized system load anomalies

-------
## Dataset Description
The analysis processes a relational network constructed across four primary database tables:
* APIs Registry (apis): Contains endpoints, application names, classifications, lifecycle state tags (Active, Testing, Deprecated, Inactive), and corresponding software development owner teams.

* Users Table (users): Retains corporate profiles, account usernames, demographic country records, account sign-up dates, and plan tier constraints (Free, Basic, Premium, Enterprise).

* API Usage Aggregates (api_usage): Combines metrics tracing localized daily volume consumption per account, logging successful calls vs. failed requests.

* API Execution Logs (api_logs): Holds granular microservice performance markers, including timestamp records, transaction response time in milliseconds, HTTP response codes, query methods (GET, POST, PUT, DELETE), CPU/Memory usage profiles, geographic data center assignments, and error string values.
  
---------------
## Tech Stack & Tools Used
* Data Ingestion & Wrangling: Python v3.11 (Pandas, NumPy)
* Database Engine: MySQL Server (Relational schema definition, multi-table JOINs, CTE expressions, and window functions)
* Exploratory Data Analysis: Jupyter Notebook, Matplotlib, Seaborn
* Business Intelligence Reporting: Microsoft Power BI Desktop (DAX queries, relational cross-filtering data modeling, interactive layouts)
  
------------
## Key Steps in the Analysis
### Step 1: Data Cleaning & Vectorized Transformations
* Missing Value Handling: Replaced non-critical empty text attributes with "Unknown" flags and stripped invalid empty structures.
* Deduplication & Standardization: Cleared duplicated observations and normalized casing for categorical groups (subscription_type, country, status).
* Type Casting: Re-parsed localized text fields into structured standard temporal formats (datetime) for trend calculations.
* Outlier Treatment: Applied Interquartile Range (IQR) barriers to detect and filter anomalous numeric spikes (e.g., negative response latencies).

### Step 2: Exploratory Data Analysis (EDA)
* Evaluated geographic server traffic splits to check workload balancing across cloud regions.
* Plotted temporal line metrics mapping monthly customer onboarding volumes to identify user sign-up trends.
* Analyzed response latency distributions via histograms to locate performance density patterns.

### Step 3: Normalization & SQL Database Deployment
* Constructed a standardized table topology utilizing explicit primary and foreign keys.
* Built advanced relational window functions and CTEs to perform top-N ranking calculations directly within database views.
  
-----------------
## Dashboards & Visualizations
### Executive Operations Panel
Tracks overall platform statistics (3,026M Requests, 98% Success, 2% Errors) and displays the historical transaction trend crash post-May. 
**Live Power BI Dashboard Layout:** [[View Live Dashboard](https://github.com/Gayatrik04/API-Performance-Error-Monitoring-Pipeline/blob/main/API%20Performance%20%26%20Error%20Monitoring/dashboard/API%20Performance%20%26%20Error%20Analysis%20Dashboard.pbix)
### Latency & Failure Diagnostic Panel
Isolates systemic exception metrics, high-latency outlier components, and structural performance bottlenecks.
Structural EDA Distributive Visuals Baseline exploratory analysis profiling regional transaction balance, onboarding trajectories, and latency patterns.

## Exploratory Data Analysis Charts
Below are the exploratory visuals generated during data profiling to understand system load distribution, registration trends, and processing times[cite: 1]:
* **[Server Region Workload Distribution](https://github.com/Gayatrik04/API-Performance-Error-Monitoring-Pipeline/blob/main/API%20Performance%20%26%20Error%20Monitoring/screenshot/Request%20count%20by%20server%20region.png)** – *A chart mapping incoming requests across global servers, showing balanced infrastructure ingress led by Sa-East-1.*
* **[Monthly User Sign-Up Trends](https://github.com/Gayatrik04/API-Performance-Error-Monitoring-Pipeline/blob/main/API%20Performance%20%26%20Error%20Monitoring/screenshot/Monthly%20SignUp%20trend.png)** – *A line chart tracking user acquisition, highlighting the sudden customer onboarding spike in month 12.*
* **[Server Response Time Frequency Spread](https://github.com/Gayatrik04/API-Performance-Error-Monitoring-Pipeline/blob/main/API%20Performance%20%26%20Error%20Monitoring/screenshot/Response%20Time%20Distribution.png)** – *An optimized histogram displaying performance clusters peaking sharply between 50ms and 100ms.*.
  
-----------------------
## Key Insights & Findings
* The "May Cliff" Core Collapse: Net active transactions and new account generation rates experienced a simultaneous drop-off in May 2026 and remained flat, showing a critical platform telemetry breakdown or massive service disruption.
* Critical Gateway Latencies: Average platform-wide response times are high (2.38K ms), caused primarily by severe sync blocks inside the Auth and Marketing service components that exceed 8,000 seconds.
* Auth Microservice Failure Focus: Auth Engine #59 processed 444 Million inquiries but dropped 920,000 explicit errors, signaling major thread exhaustion or locking issues under peak request loads.
* Shadow Telemetry Blind Spot: Over 224 Million total requests are labeled as "Unknown" categories, highlighting an unmapped layer of untracked service traffic.
* Enterprise Monetization Mismatch: High-paying Enterprise users (1,000 active accounts across 11 major corporate organizations) demonstrate near-zero interaction with the platform. Instead, compute infrastructure costs are entirely driven by low-tier Free and Basic subscribers averaging 605.12K requests per user.
* Balanced Regional Distribution: Ingress transaction data center workloads are evenly balanced globally. The highest density occurs within Sa-East-1 (~1,300 requests), while the minimum rest point falls to Eu-West-1 (~1,180 requests).
  
-----------------
## Conclusion & Recommendations
Based on the operational insights derived from the monitoring pipeline, the following actions are recommended for implementation[cite: 1]:
* Deploy an Incident Forensic Team for the "May Cliff": Treat the post-May traffic and registration drop as a P0 catastrophic event[cite: 1]. Audit infrastructure logs to check if an unindexed query lockup, an expired root SSL/TLS certificate, a broken user-billing gateway, or a major routing black hole caused the data collection or traffic engines to freeze[cite: 1].
* Overhaul Authentication & Gateway Architecture: Decouple the core architecture of Auth Engine #59[cite: 1]. Implement high-speed distributed database caching networks (Redis or Memcached) to handle session token validations, and deploy token-based authentications (JWTs) utilizing expanded, optimized Time-To-Live (TTL) boundaries[cite: 1].
* Transition to Asynchronous Message Hubs: Shift heavy, long-running processes (such as the Marketing and Auth engines currently averaging >8,000 seconds) from synchronous REST pathways to asynchronous message-driven backbones like Apache Kafka or RabbitMQ[cite: 1]. Configure endpoints to instantly return a 202 Accepted status code, delivering data out-of-band via upstream webhooks[cite: 1].
* Establish Automated Circuit Breakers: Deploy a cloud-native service mesh architecture (Istio)[cite: 1]. If Auth Engine #59 hits its 2% error rate threshold, trigger an automated circuit breaker to fail fast and instantly redirect incoming traffic to a generic backup container rather than letting connections timeout indefinitely[cite: 1].
* Enforce Strict API Route Telemetry: Mandate that all engineering teams resolve the unmapped Unknown API category classification[cite: 1]. Every live endpoint route must explicitly map back to a defined engineering team owner and a valid microservice bucket to eliminate security holes caused by shadow services[cite: 1].
  
----------------------
Prepared By: Gayatri Kasbekar | Tools Used: Python, MySQL, Power BI[cite: 1]
## GitHub Repository
https://github.com/Gayatrik04/SQL-Query-Performance-Analysis/

## LinkedIn
https://www.linkedin.com/in/gayatri-kasbekar-674a883a3/
