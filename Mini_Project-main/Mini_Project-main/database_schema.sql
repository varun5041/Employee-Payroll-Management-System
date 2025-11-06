-- ============================================
-- Employee Payroll System Database Schema
-- Database: payrollSystem
-- ============================================

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS payrollSystem;
USE payrollSystem;

-- ============================================
-- Table: employees
-- Main employee table storing common employee information
-- ============================================
CREATE TABLE IF NOT EXISTS employees (
    id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    hire_date DATE,
    department_id INT,
    type ENUM('FULL_TIME', 'PART_TIME') NOT NULL,
    designation VARCHAR(100),
    INDEX idx_name (name),
    INDEX idx_email (email),
    INDEX idx_department (department_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: full_time_employees
-- Stores specific information for full-time employees
-- ============================================
CREATE TABLE IF NOT EXISTS full_time_employees (
    id INT PRIMARY KEY,
    monthly_salary DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    hra DECIMAL(10, 2) DEFAULT 0.00 COMMENT 'House Rent Allowance',
    da DECIMAL(10, 2) DEFAULT 0.00 COMMENT 'Dearness Allowance',
    pf_percentage DECIMAL(5, 2) DEFAULT 0.00 COMMENT 'Provident Fund Percentage',
    bonus DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id) REFERENCES employees(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: part_time_employees
-- Stores specific information for part-time employees
-- ============================================
CREATE TABLE IF NOT EXISTS part_time_employees (
    id INT PRIMARY KEY,
    hours_worked INT NOT NULL DEFAULT 0,
    hourly_rate DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    overtime_rate DECIMAL(10, 2) DEFAULT 0.00,
    FOREIGN KEY (id) REFERENCES employees(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: payroll
-- Stores payroll history records for all employees
-- ============================================
CREATE TABLE IF NOT EXISTS payroll (
    id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT NOT NULL,
    month INT NOT NULL CHECK (month >= 1 AND month <= 12),
    year INT NOT NULL,
    gross_salary DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_deductions DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    net_salary DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (emp_id) REFERENCES employees(id) ON DELETE CASCADE ON UPDATE CASCADE,
    UNIQUE KEY unique_emp_month_year (emp_id, month, year),
    INDEX idx_emp_id (emp_id),
    INDEX idx_month_year (month, year),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Optional: Table for departments (if needed)
-- ============================================
CREATE TABLE IF NOT EXISTS departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Add foreign key constraint for department_id in employees table
-- (Uncomment if departments table is being used)
-- ALTER TABLE employees 
-- ADD CONSTRAINT fk_department 
-- FOREIGN KEY (department_id) REFERENCES departments(id) 
-- ON DELETE SET NULL ON UPDATE CASCADE;

-- ============================================
-- Sample Data (Optional - for testing)
-- ============================================

-- Sample Full-Time Employee
-- INSERT INTO employees (id, name, email, phone, hire_date, department_id, type, designation) 
-- VALUES (1, 'John Doe', 'john.doe@example.com', '123-456-7890', '2024-01-15', NULL, 'FULL_TIME', 'Software Engineer');
-- 
-- INSERT INTO full_time_employees (id, monthly_salary, hra, da, pf_percentage, bonus) 
-- VALUES (1, 50000.00, 10000.00, 5000.00, 12.00, 10000.00);

-- Sample Part-Time Employee
-- INSERT INTO employees (id, name, email, phone, hire_date, department_id, type, designation) 
-- VALUES (2, 'Jane Smith', 'jane.smith@example.com', '987-654-3210', '2024-02-01', NULL, 'PART_TIME', 'Consultant');
-- 
-- INSERT INTO part_time_employees (id, hours_worked, hourly_rate, overtime_rate) 
-- VALUES (2, 160, 500.00, 750.00);

-- ============================================
-- End of Schema
-- ============================================

