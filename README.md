# COVID-19 Data Exploration & SQL Analysis Project

## 📌 Project Overview
This project focuses on exploring, analyzing, and deriving actionable insights from the global COVID-19 dataset using **SQL**. The primary objective is to evaluate infection rates, mortality metrics, and the progression of vaccination campaigns worldwide. 

Beyond simply writing queries, this project was designed to simulate a real-world data engineering and analysis workflow. It covers the entire lifecycle: provisioning cloud infrastructure, establishing secure database connections, architecting the data schema, validating logical data integrity, and ultimately deploying advanced SQL techniques to extract complex insights.

---

## 🛠️ Infrastructure & Technology Stack
The project leverages a robust blend of cloud and local database management tools:
* **Cloud Provider:** Amazon Web Services (AWS)
* **Database Service:** AWS RDS (Relational Database Service)
* **Database Engine:** Microsoft SQL Server (T-SQL)
* **IDE / Management Tool:** SQL Server Management Studio (SSMS)
* **Security & Networking:** Successfully configured AWS **Security Groups (Inbound Rules)** to securely connect the cloud-hosted RDS instance with the local SSMS environment, ensuring a seamless and secure data pipeline.

![Initial Data Exploration](https://github.com/WESAMAAM/sql/blob/4794634f36ac8684b309ea908ebf7e795d9403f1/images/Screenshot%202026-09-11%20153052.png)

---

## 📂 Data Setup & Architecture
To ensure query efficiency and organizational clarity, the dataset was carefully structured before analysis:

1. **Raw Data Ingestion:** Using the **SQL Server Import and Export Wizard**, the comprehensive master dataset (`Covid_All_Info` containing over 67,700 rows) was imported directly into the database. This serves as a pristine, unaltered historical reference.
2. **Table Normalization (Splitting):** To optimize querying and avoid scanning unnecessary columns, the master dataset was logically divided into two primary working tables:
   * `CovidDeaths`: Dedicated to population metrics, daily/cumulative cases, and mortality data.
   * `CovidVaccinations`: Focused on testing metrics and the rollout of vaccination campaigns.

![Initial Data Exploration](https://github.com/WESAMAAM/sql/blob/fea7ada9cb84fb1d00368c2a04deecff101b497c/images/Screenshot%202026-09-10%20160306.png)
![Initial Data Exploration](https://github.com/WESAMAAM/sql/blob/4794634f36ac8684b309ea908ebf7e795d9403f1/images/Screenshot%202026-09-11%20153052.png)
![Initial Data Exploration](https://github.com/WESAMAAM/sql/blob/4794634f36ac8684b309ea908ebf7e795d9403f1/images/Screenshot%202026-09-11%20153052.png)

---

## 🧠 Data Accuracy & Logical Validation
Writing syntactically correct code is only half the battle; understanding the underlying data context is critical. This project heavily emphasizes logical validation to prevent skewed results:

* **Cumulative Data Handling (`MAX` vs. `SUM`):** 
  Early in the exploration phase, it became evident that metrics like `total_cases` and `total_deaths` were recorded *cumulatively* over time. Initially, using the `SUM()` function aggregated these running totals, resulting in astronomical and illogical figures. The logic was quickly corrected to use the `MAX()` function, successfully isolating the highest recorded (and therefore final/accurate) figure for each location.
* **Precision Data Type Casting (`CAST`):** 
  To prevent Data Type Mismatches and ensure mathematical precision, rigorous casting was applied:
  * **Whole Numbers:** Used `CAST(column AS int)` for raw counts (e.g., total cases, total deaths) because fractional humans cannot exist.
  * **Decimals:** Explicitly retained the `float` data type strictly for division operations (e.g., calculating Infection Rates or Death Percentages) to preserve crucial decimal precision and avoid rounding errors.

---

## 📊 Data Exploration & Key Queries

### 1. Initial Data Exploration
The analysis began with querying foundational data to verify successful imports and inspect the schema. 
> *Note: Transitioning to T-SQL required adapting to specific syntax, utilizing `SELECT TOP 10 *` rather than the `LIMIT` clause commonly found in other SQL dialects.*

![Initial Data Exploration](https://github.com/WESAMAAM/sql/blob/4794634f36ac8684b309ea908ebf7e795d9403f1/images/Screenshot%202026-09-11%20153052.png)

### 2. Mortality & Infection Rates (Likelihood of Contracting & Dying)
* **Total Cases vs. Total Deaths:** Calculated the `DeathPercentage` to estimate the likelihood of dying if a person contracted COVID-19 in their respective country.
* **Total Cases vs. Population:** Calculated the `ContractPercentage` (Infection Rate) to show what percentage of a country's population had been infected, highlighting heavily impacted nations like Andorra, Montenegro, and Czechia.

![Mortality Rates Analysis](https://github.com/WESAMAAM/sql/blob/673ba28f24b082d2d49d48b9a07458a100a69fcd/images/Screenshot%202026-09-11%20154145.png)
![Infection Rates vs Population](https://github.com/WESAMAAM/sql/blob/a8e70ec320836216dc8096446880901d09720153/images/Screenshot%202026-09-11%20154326.png)

### 3. Regional & Global Breakdown
To maintain analytical accuracy, it was crucial to separate individual country data from aggregated continental data (which were mixed in the dataset).
* **Country-Level Focus:** Used `WHERE location NOT IN ('World', 'Europe', 'North America', etc.)` to isolate sovereign nations. (Note: The `population` column was intentionally excluded from the final selection here to focus purely on the location and death tolls).
* **Continent-Specific Breakdowns:** Authored highly filtered queries using `WHERE continent = '...'` to drill down into the specific death counts for countries within individual continents (Asia, Africa, North America, South America, Europe, Oceania).
* **Global Macro-Numbers:** Created a unified query to calculate total global cases, global deaths, and the overall global death percentage (yielding approximately 2.1%).

![Highest Death Count by Country vs Continent](https://github.com/WESAMAAM/sql/blob/8e11251acc96dc797bda2877d6e240a6b931a857/images/Screenshot%202026-09-08%20231657.png)
![Highest Death Count by Country vs Continent](https://github.com/WESAMAAM/sql/blob/018ccc4c4c434953f0e5c15f6ebc77c2052e0e8f/images/Screenshot%202026-09-08%20232502.png)
![Death Count Segmented by Specific Continents](https://github.com/WESAMAAM/sql/blob/e3ec6ec09032d251ccf4107031316abb6daa0b2f/images/Screenshot%202026-09-09%20000425.png)
![Global Numbers Analysis](https://github.com/WESAMAAM/sql/blob/f944a0238f25ee69ac864aea120f4d5865eb7ad5/images/Screenshot%202026-09-09%20002234.png)

---

## 🚀 Advanced SQL Techniques
To move beyond basic aggregations and extract deeper contextual insights, the following advanced SQL methodologies were implemented:

### Relational Joins & Time Series Tracking
Merged the `CovidDeaths` table with the master `Covid_All_Info` table utilizing `JOIN` on dual primary keys (`location` and `date`). This allowed for the tracking of daily and cumulative vaccinations against populations over time. The query was designed with flexibility in mind, incorporating comments to help users swap the target country (e.g., 'Albania') effortlessly.

![Using Joins for Time Series Data](https://github.com/WESAMAAM/sql/blob/5a7f22a0c258aaf4b7ad823a6ed297e5523505eb/images/Screenshot%202026-09-09%20191731.png)

### Common Table Expressions (CTEs)
To perform further calculations on already aggregated and joined data (specifically, calculating the rolling vaccination percentage over time), a **CTE** was employed (`WITH VacOverTime AS`). This encapsulated the complex `JOIN` logic into a temporary, easily readable result set, which was then queried in the outer `SELECT` statement.

![Implementing CTEs](https://github.com/WESAMAAM/sql/blob/723ff3796d17fee9b67448aaf12ffe96404db3c0/images/Screenshot%202026-09-09%20220943.png)

### Temporary Tables (Temp Tables)
As a robust alternative to CTEs—especially useful for performance optimization and code reusability—**Temp Tables** (`#VaccinationForCountries`) were utilized. 
* **Best Practices Applied:** Integrated the `DROP TABLE IF EXISTS` command prior to table creation to prevent execution errors upon multiple runs. Data was systematically populated using `INSERT INTO` to store complex groupings for continent-wide vaccination percentage tracking.

![Utilizing Temp Tables](https://github.com/WESAMAAM/sql/blob/41239e3cfe3192459f7cefdd9f58e5663ac54039/images/Screenshot%202026-09-10%20005018.png)

---

## 💡 Key Learnings & Challenges
* **Database Engine Adaptability (PostgreSQL vs. SQL Server):** Coming from a PostgreSQL background, this project served as a practical transition into Microsoft SQL Server (T-SQL). Adapting to syntax nuances—such as substituting `LIMIT` with `TOP`, and handling data conversions via explicit `CAST()` rather than the Postgres `::` shorthand—highlighted the architectural differences between engines and reinforced my ability to quickly adapt to new RDBMS environments.
* **Context is King:** The most valuable lesson was that SQL syntax mastery is secondary to data comprehension. Realizing that the data was cumulative and pivoting from `SUM()` to `MAX()` saved the integrity of the entire analysis. It proved that a good data analyst doesn't just write queries; they interrogate the logic behind the data.

* ## 🛠️ Tools & Technologies Used
* **Cloud Infrastructure:** AWS RDS (Amazon Relational Database Service)
* **Database Engine:** Microsoft SQL Server
* **Development Environment:** SQL Server Management Studio (SSMS)
* **Query Language:** T-SQL

## 📊 Conclusion & Key Data Findings

Based on the SQL analysis of the dataset, several critical insights regarding the global impact of COVID-19 and the subsequent vaccination campaigns were extracted. *(Note: The numbers reflect the specific historical timeframe of the dataset, representing a snapshot of the pandemic's progression).*

**1. Global Macro-Statistics**

* **Total Global Cases:** 151,399,480 recorded infections worldwide.
* **Total Global Deaths:** 3,180,238 total fatalities.
* **Global Mortality Rate:** Across the entire world, the average likelihood of dying after contracting the virus was **2.1%**.

**2. Mortality Impact & Severity (Death to Case Ratio)**
When analyzing the likelihood of dying if infected, the data revealed severe disparities in healthcare outcomes across different nations:

* **Yemen** faced one of the most critical mortality rates globally at **19.41%** (1,226 deaths out of 6,317 cases).
* **Mexico** followed with a highly elevated death percentage of **9.25%** (216,907 deaths out of 2.34M cases).
* *Note: Vanuatu showed a 25% mortality rate, but this is a statistical outlier due to an extremely low sample size (1 death out of 4 total cases).*

**3. Highest Infection Rates (Cases vs. Population)**
When comparing total cases to the overall population, European nations dominated the highest infection rates, indicating rapid viral spread:

* **Andorra:** Ranked highest globally, with **17.13%** of its population contracting the virus.
* **Montenegro:** Followed closely at **15.51%**.
* **Czechia & San Marino:** Recorded infection rates of **15.23%** and **14.93%**, respectively.

**4. Absolute Death Tolls (Countries & Continents)**
Looking at the raw volume of fatalities, the absolute impact was heavily concentrated in specific regions:

* **By Country:** The **United States** recorded the highest absolute death toll (576,232 deaths), followed by **Brazil** (403,781 deaths) and **Mexico** (216,907 deaths).
* **By Continent:** **Europe** suffered the highest continental death toll (1,016,750 deaths), followed closely by **North America** (847,942 deaths) and **South America** (672,415 deaths). Oceania was the least impacted with only 1,046 deaths.

**5. Vaccination Campaign Leaders**
Using advanced queries to track vaccination progress, the data highlighted nations leading the global immunization effort:

* **Gibraltar (Europe)** reached a vaccination percentage of **208.76%**, while **Seychelles (Africa)** reached **128.98%**, and **Israel (Asia)** reached **121.28%**.
* *Analytical Note: Percentages exceeding 100% in the dataset indicate the administration of multiple doses (e.g., two-dose regimens or boosters) relative to the total population size.*
