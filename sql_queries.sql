-- Bank Loan Portfolio Data Analysis & Validation
-- Database: MS SQL Server

-- ----------------------------------------------------
-- 1. High-Level KPIs (Volume, Disbursal, Collections)
-- ----------------------------------------------------

-- Total applications received
SELECT COUNT(DISTINCT id) AS Total_Applications 
FROM Bank_Loan_Data;

-- Month-to-Date (MTD) applications for December
SELECT COUNT(DISTINCT id) AS MTD_Applications 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 12;

-- Previous month (PM) applications for November (used for MoM comparisons)
SELECT COUNT(DISTINCT id) AS PM_Applications 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 11;

-- Total funded amount disbursed across all loans
SELECT SUM(loan_amount) AS Total_Funded_Amount 
FROM Bank_Loan_Data;

-- MTD funded amount (December)
SELECT SUM(loan_amount) AS MTD_Funded_Amount 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 12;

-- Previous month funded amount (November)
SELECT SUM(loan_amount) AS PM_Funded_Amount 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 11;

-- Total cash collected / received so far
SELECT SUM(total_payment) AS Total_Amount_Received 
FROM Bank_Loan_Data;

-- MTD amount received (December)
SELECT SUM(total_payment) AS MTD_Amount_Received 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 12;

-- Previous month amount received (November)
SELECT SUM(total_payment) AS PM_Amount_Received 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 11;

-- Overall average interest rate across portfolio
SELECT ROUND(AVG(int_rate * 100), 2) AS Avg_Interest_Rate 
FROM Bank_Loan_Data;

-- December average interest rate
SELECT ROUND(AVG(int_rate * 100), 2) AS MTD_Avg_Interest_Rate 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 12;

-- November average interest rate
SELECT ROUND(AVG(int_rate * 100), 2) AS PM_Avg_Interest_Rate 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 11;

-- Average Debt-to-Income (DTI) ratio
SELECT ROUND(AVG(dti), 4) AS Avg_DTI 
FROM Bank_Loan_Data;

-- December DTI
SELECT ROUND(AVG(dti), 4) AS MTD_Avg_DTI 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 12;

-- November DTI
SELECT ROUND(AVG(dti), 4) AS PM_Avg_DTI 
FROM Bank_Loan_Data
WHERE MONTH(issue_date) = 11;


-- ----------------------------------------------------
-- 2. Monthly Trends
-- ----------------------------------------------------

-- Checking monthly loan application counts
SELECT 
    DATENAME(month, issue_date) AS [Month], 
    COUNT(id) AS Total_Applications 
FROM Bank_Loan_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);

-- Monthly funded capital trend
SELECT 
    DATENAME(month, issue_date) AS [Month], 
    SUM(loan_amount) AS Total_Funded_Amount 
FROM Bank_Loan_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);

-- Monthly collections trend
SELECT 
    DATENAME(month, issue_date) AS [Month], 
    SUM(total_payment) AS Total_Received_Amount 
FROM Bank_Loan_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);

-- Combined monthly view for dashboard validation
SELECT
    DATENAME(month, issue_date) AS [Month],
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Amount_Funded,
    SUM(total_payment) AS Amount_Received
FROM Bank_Loan_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);


-- ----------------------------------------------------
-- 3. Good Loan vs Bad Loan Analysis
-- ----------------------------------------------------

-- Total count of performing loans (Fully Paid & Current)
SELECT COUNT(id) AS Good_Loan_Applications 
FROM Bank_Loan_Data
WHERE loan_status IN ('Fully Paid', 'Current');

-- Percentage of good loans in portfolio
SELECT 
    COUNT(id) AS Total_Applications,
    COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) AS Good_Applications,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) AS DECIMAL(10, 2)) / 
        CAST(COUNT(id) AS DECIMAL(10, 2)),
        'P2'
    ) AS Good_Loan_Percentage
FROM Bank_Loan_Data;

-- Percentage of capital funded into good loans
SELECT 
    SUM(loan_amount) AS Total_Loan_Funded,
    SUM(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN loan_amount END) AS Good_Loan_Funded,
    FORMAT(
        CAST(SUM(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN loan_amount END) AS DECIMAL(20, 2)) /
        CAST(SUM(loan_amount) AS DECIMAL(20, 2)), 
        'P2'
    ) AS Good_Loan_Funded_Percentage
FROM Bank_Loan_Data;

-- Non-performing loans (Charged Off) count and rate
SELECT 
    COUNT(id) AS Total_Applications,
    COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS Bad_Applications,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS DECIMAL(10, 2)) / 
        CAST(COUNT(id) AS DECIMAL(10, 2)), 
        'P2'
    ) AS Bad_Loan_Percentage
FROM Bank_Loan_Data;

-- Total capital lost in defaults
SELECT 
    SUM(loan_amount) AS Total_Loan_Funded,
    SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amount END) AS Bad_Loan_Funded,
    FORMAT(
        CAST(SUM(CASE WHEN loan_status = 'Charged Off' THEN loan_amount END) AS DECIMAL(20, 2)) /
        CAST(SUM(loan_amount) AS DECIMAL(20, 2)), 
        'P2'
    ) AS Bad_Loan_Funded_Percentage
FROM Bank_Loan_Data;

-- Month by month tracking of good loans
SELECT 
    DATENAME(month, issue_date) AS [Month],
    COUNT(id) AS Total_Applications,
    COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) AS Good_Applications,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) AS DECIMAL(10, 2)) / 
        CAST(COUNT(id) AS DECIMAL(10, 2)), 
        'P2'
    ) AS Good_Loan_Percentage
FROM Bank_Loan_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);

-- Month by month tracking of default rates
SELECT 
    DATENAME(month, issue_date) AS [Month],
    COUNT(id) AS Total_Applications,
    COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS Bad_Applications,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS DECIMAL(10, 2)) / 
        CAST(COUNT(id) AS DECIMAL(10, 2)), 
        'P2'
    ) AS Bad_Loan_Percentage
FROM Bank_Loan_Data
GROUP BY MONTH(issue_date), DATENAME(month, issue_date)
ORDER BY MONTH(issue_date);


-- ----------------------------------------------------
-- 4. Portfolio Breakdown by Categories
-- ----------------------------------------------------

-- Detailed summary by loan status
SELECT 
    loan_status,
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Loan_Funded,
    SUM(total_payment) AS Loan_Received,
    FORMAT(AVG(int_rate), 'P2') AS Avg_Int_Rate,
    CAST(AVG(dti) AS DECIMAL(10, 2)) AS Avg_DTI
FROM Bank_Loan_Data
GROUP BY loan_status;

-- Loan distribution across states
SELECT
    address_state AS [State],
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Amount_Funded,
    SUM(total_payment) AS Amount_Received
FROM Bank_Loan_Data
GROUP BY address_state
ORDER BY Total_Applications DESC;

-- Breakdown by loan tenure (36 vs 60 months)
SELECT
    term AS Term,
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Amount_Funded,
    SUM(total_payment) AS Amount_Received
FROM Bank_Loan_Data
GROUP BY term
ORDER BY Total_Applications DESC;

-- Default rate by borrower employment length
SELECT
    emp_length AS Emp_Length,
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Amount_Funded,
    SUM(total_payment) AS Amount_Received,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS DECIMAL(20, 2)) /
        CAST(COUNT(id) AS DECIMAL(20, 2)), 
        'P2'
    ) AS Bad_Application_Rate
FROM Bank_Loan_Data
GROUP BY emp_length
ORDER BY Bad_Application_Rate;

-- Default rate and volume by loan purpose
SELECT
    purpose AS Purpose,
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Amount_Funded,
    SUM(total_payment) AS Amount_Received,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS DECIMAL(20, 2)) /
        CAST(COUNT(id) AS DECIMAL(20, 2)), 
        'P2'
    ) AS Bad_Application_Rate
FROM Bank_Loan_Data
GROUP BY purpose
ORDER BY Total_Applications DESC;

-- Default rate by home ownership status
SELECT
    home_ownership AS Home_Ownership,
    COUNT(id) AS Total_Applications,
    SUM(loan_amount) AS Amount_Funded,
    SUM(total_payment) AS Amount_Received,
    FORMAT(
        CAST(COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) AS DECIMAL(20, 2)) /
        CAST(COUNT(id) AS DECIMAL(20, 2)), 
        'P2'
    ) AS Bad_Application_Rate
FROM Bank_Loan_Data
GROUP BY home_ownership
ORDER BY Total_Applications DESC;
