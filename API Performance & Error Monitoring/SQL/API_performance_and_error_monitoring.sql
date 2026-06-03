create database API_performance_and_error_monitoring;

use API_performance_and_error_monitoring;

CREATE TABLE apis (
    api_id INT PRIMARY KEY,
    api_name VARCHAR(100),
    api_category VARCHAR(50),
    endpoint VARCHAR(255),
    version VARCHAR(20),
    owner_team VARCHAR(50),
    status VARCHAR(20),
    service_name VARCHAR(20)
);

CREATE TABLE api_logs (
    log_id INT PRIMARY KEY,
    api_id INT,
    request_time DATETIME,
    response_time_ms FLOAT,
    status_code INT,
    request_method VARCHAR(10),
    payload_size_kb FLOAT,
    cpu_usage FLOAT,
    memory_usage FLOAT,
    request_count INT,
    error_message VARCHAR(255),
    server_region VARCHAR(50),
    is_error text,
    performance_category VARCHAR(20),
    
    FOREIGN KEY (api_id) REFERENCES apis(api_id)
);

CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100),
    company_name VARCHAR(100),
    subscription_type VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE
);

CREATE TABLE api_usage (
    usage_id INT PRIMARY KEY,
    user_id INT,
    api_id INT,
    usage_date DATE,
    total_requests INT,
    successful_requests INT,
    failed_requests INT,
    success_rate float,
    error_rate float,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (api_id) REFERENCES apis(api_id)
);

-- Total API Requests
SELECT SUM(total_requests) AS total_requests
FROM api_usage;

-- Success Rate %
SELECT 
ROUND((SUM(successful_requests) * 100.0) /SUM(total_requests),2) AS success_rate
FROM api_usage;

-- Error Rate %
SELECT 
ROUND((SUM(failed_requests) * 100.0) /SUM(total_requests),2) AS error_rate
FROM api_usage;

-- Top 10 APIs by Usage
SELECT a.api_name,
SUM(u.total_requests) AS total_requests
FROM api_usage u
JOIN apis a
ON u.api_id = a.api_id
GROUP BY a.api_name
ORDER BY total_requests DESC
LIMIT 10;

-- APIs with Highest Errors
SELECT a.api_name,
SUM(u.failed_requests) AS failed_requests
FROM api_usage u
JOIN apis a
ON u.api_id = a.api_id
GROUP BY a.api_name
ORDER BY failed_requests DESC
LIMIT 10;

-- Average Response Time by API
SELECT a.api_name,
ROUND(AVG(l.response_time_ms),2) AS avg_response_time
FROM api_logs l
JOIN apis a
ON l.api_id = a.api_id
GROUP BY a.api_name
ORDER BY avg_response_time DESC;

-- HTTP Status Code Analysis
SELECT status_code,COUNT(*) AS total_count
FROM api_logs
GROUP BY status_code
ORDER BY total_count DESC;

-- Request Method Distribution
SELECT request_method,COUNT(*) AS total_requests
FROM api_logs
GROUP BY request_method
ORDER BY total_requests DESC;

-- Users by Country
SELECT country,COUNT(user_id) AS total_users
FROM users
GROUP BY country
ORDER BY total_users DESC;

-- Subscription Type Distribution
SELECT subscription_type,COUNT(user_id) AS total_users
FROM users
GROUP BY subscription_type
ORDER BY total_users DESC;

-- API Usage by Subscription Type
SELECT u.subscription_type,SUM(au.total_requests) AS total_requests
FROM api_usage au
JOIN users u
ON au.user_id = u.user_id
GROUP BY u.subscription_type
ORDER BY total_requests DESC;

-- Top Companies by API Usage
SELECT u.company_name,SUM(au.total_requests) AS total_requests
FROM api_usage au
JOIN users u
ON au.user_id = u.user_id
GROUP BY u.company_name
ORDER BY total_requests DESC
LIMIT 10;

-- Server Region Performance
SELECT server_region,ROUND(AVG(response_time_ms),2) AS avg_response_time,
SUM(request_count) AS total_requests
FROM api_logs
GROUP BY server_region
ORDER BY total_requests DESC;

-- CPU & Memory Usage Analysis
SELECT server_region,
ROUND(AVG(cpu_usage),2) AS avg_cpu_usage,
ROUND(AVG(memory_usage),2) AS avg_memory_usage
FROM api_logs
GROUP BY server_region;

-- Monthly API Request Trend
SELECT MONTH(usage_date) AS month_no,
SUM(total_requests) AS total_requests
FROM api_usage
GROUP BY month_no
ORDER BY month_no;

-- Slowest APIs
SELECT a.api_name,
ROUND(AVG(l.response_time_ms),2) AS avg_response_time
FROM api_logs l
JOIN apis a
ON l.api_id = a.api_id
GROUP BY a.api_name
ORDER BY avg_response_time DESC
LIMIT 10;

-- Error Rate by API Category
SELECT a.api_category,
ROUND(
    (SUM(u.failed_requests) * 100.0) /
    SUM(u.total_requests),2
) AS error_rate
FROM api_usage u
JOIN apis a
ON u.api_id = a.api_id
GROUP BY a.api_category
ORDER BY error_rate DESC;

-- Most Active Users
SELECT u.username,
SUM(au.total_requests) AS total_requests
FROM api_usage au
JOIN users u
ON au.user_id = u.user_id
GROUP BY u.username
ORDER BY total_requests DESC
LIMIT 10;

-- Rank APIs by Total Requests
WITH api_usage_rank AS (
    SELECT a.api_name,SUM(u.total_requests) AS total_requests,
        RANK() OVER(ORDER BY SUM(u.total_requests) DESC) AS rnk
    FROM api_usage u
    JOIN apis a
    ON u.api_id = a.api_id
    GROUP BY a.api_name
)

SELECT *
FROM api_usage_rank
WHERE rnk <= 10;


-- Running Total of Monthly Requests
WITH monthly_requests AS (
    SELECT MONTH(usage_date) AS month_no,SUM(total_requests) AS monthly_total
    FROM api_usage
    GROUP BY MONTH(usage_date)
)
SELECT month_no,monthly_total,
SUM(monthly_total) OVER(ORDER BY month_no) AS running_total
FROM monthly_requests;


-- APIs Performing Above Average
WITH api_requests AS (
    SELECT a.api_name,SUM(u.total_requests) AS total_requests
    FROM api_usage u
    JOIN apis a
    ON u.api_id = a.api_id
    GROUP BY a.api_name
)
SELECT api_name,total_requests
FROM api_requests
WHERE total_requests >
(
    SELECT AVG(total_requests)
    FROM api_requests
)
ORDER BY total_requests DESC;

-- Response Time Ranking by Region
SELECT server_region,api_id,
    AVG(response_time_ms) AS avg_response_time,
    DENSE_RANK() OVER(
	PARTITION BY server_region ORDER BY AVG(response_time_ms) DESC
    ) AS response_rank
FROM api_logs
GROUP BY server_region, api_id;