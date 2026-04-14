🚧 Indian Road Accident Analysis (SQL Project)
📌 Project Overview

This project analyzes Indian road accident data using SQL to uncover key insights such as accident trends, high-risk areas, causes, and severity patterns.

The goal is to help government authorities, analysts, and decision-makers understand accident patterns and take preventive actions.

📂 Dataset Information
Dataset Name: indian_roads_dataset
Total Records: 20,000
Data includes:
Date, Time (Hour)
State & City
Accident Severity
Casualties
Cause of Accident
Weather Conditions
Road Type
Traffic Density
Festival & Weekend Indicators
Risk Score
🔍 Data Exploration
Checked total records
Identified missing (NULL) values using dynamic SQL
Verified data quality before analysis
📊 Key Business Questions Solved
1. 🚩 High-Risk States
Identified states with the highest number of casualties
Helps government prioritize safety measures
2. ⚠️ Accident Causes Analysis
Found most common accident causes
Calculated percentage contribution of each cause
3. 🌦️ Weather vs Severity
Analyzed how weather impacts accident severity
Used ranking to find dangerous combinations
4. ⏰ Time-Based Analysis
Identified most dangerous hours of the day
Compared:
Weekday vs Weekend accidents
Festival vs Non-festival accidents
5. 🏙️ City Risk Ranking
Ranked cities based on fatal accidents
Helps identify urban high-risk zones
6. 📈 Running Total Analysis
Calculated cumulative casualties over time
Useful for trend tracking
7. 🔥 Multi-Factor Risk Profiling
Combined multiple factors:
Road Type
Weather
Visibility
Traffic Density
Cause
Ranked top 20 most dangerous scenarios
8. 💀 Deadliest Combinations
Identified most dangerous mix of:
Hour + Road Type + Weather
9. 📅 Monthly Trend Analysis
Compared month-over-month accident trends
Used LAG() function to calculate:
Previous month accidents
Monthly change
--
🛠️ SQL Concepts Used
Aggregations (COUNT, SUM, AVG)
Window Functions:
LAG()
RANK(), DENSE_RANK()
Common Table Expressions (CTE)
CASE Statements
Dynamic SQL
Grouping & Filtering
💡 Key Insights (Example)
Certain states contribute significantly to total casualties
Drunk driving is a major cause of accidents
Fatal accidents increase under poor weather conditions
Specific hours (peak traffic time) are more dangerous
Festivals may increase accident frequency
