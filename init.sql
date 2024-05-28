
--- AUTH ---

DROP SEQUENCE IF EXISTS user_credentials_id_seq CASCADE;

DROP TABLE IF EXISTS user_credentials CASCADE;

CREATE TABLE user_credentials (
  id SERIAL,
  username VARCHAR(100),
  user_password VARCHAR,
  oauth2_idp VARCHAR(50),
  user_role VARCHAR(20)
);

INSERT INTO user_credentials (username, user_password, user_role)
VALUES ('user01@domain.com', '$2y$10$R.AVbuzy7f7Vijnj94DF1.7aI8C7V4Zwbf2FWAWk2dCRC3n1iOkbG', 'USER');

INSERT INTO user_credentials (username, user_password, user_role)
VALUES ('user02@domain.com', '$2y$10$SfJCRbSkbM.ObOJHvVCRNuxdrY13loabTM8ROaGW1kBCWJHhI/iZ6', 'USER');

INSERT INTO user_credentials (username, user_password, user_role)
VALUES ('user03@domain.com', '$2y$10$Snb12fzwuYwQY/5zxZTFDer0UK1.RyAVnzCqVVzcF8sF6OF6pdCAm', 'USER');

INSERT INTO user_credentials (username, oauth2_idp, user_role)
VALUES ('user04@gmail.com', 'GOOGLE', 'USER');

--- USERS ---
CREATE SEQUENCE users_id_seq;

DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users
(
    id integer NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    email character varying(255) COLLATE pg_catalog."default",
    first_name character varying(255) COLLATE pg_catalog."default",
    last_name character varying(255) COLLATE pg_catalog."default",
    password character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id)
);

INSERT INTO users (email, first_name, last_name)
VALUES ('user01@domain.com', 'User', 'One');

INSERT INTO users (email, first_name, last_name)
VALUES ('user02@domain.com', 'User', 'Two');

INSERT INTO users (email, first_name, last_name)
VALUES ('user03@domain.com', 'User', 'Three');

INSERT INTO users (email, first_name, last_name)
VALUES ('user04@domain.com', 'User', 'Four');

--- BUDGETS ---

DROP TABLE IF EXISTS monthly_summary;
DROP TABLE IF EXISTS buckets;
DROP TABLE IF EXISTS budgets;

CREATE TABLE budgets (
    budget_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    category VARCHAR(100) NOT NULL,
    total_amount INT,
	is_reserved BOOLEAN DEFAULT FALSE,
	month_year Date,
	notes VARCHAR(255),
    created_timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE buckets (
    bucket_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    bucket_name VARCHAR(100) NOT NULL,
    amount_required NUMERIC(10, 2) NOT NULL,
    amount_reserved NUMERIC(10, 2) NOT NULL,
    month_year Date,
	is_reserved BOOLEAN DEFAULT FALSE,
	is_active BOOLEAN DEFAULT FALSE,
    date_created TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE monthly_summary (
    summary_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    month_year DATE,
    projected_income NUMERIC(10, 2) NOT NULL,
    total_budget_amount NUMERIC(10, 2) NOT NULL
);

INSERT INTO budgets (user_id, category, total_amount, is_reserved, month_year, notes) VALUES
(1, 'Groceries', 150.00, FALSE, '2024-05-01', 'Weekly grocery shopping'),
(1, 'Rent', 1200.00, TRUE, '2024-05-01', 'May rent payment'),
(2, 'Utilities', 200.00, FALSE, '2024-05-01', 'Electricity and water bill'),
(2, 'Internet', 50.00, TRUE, '2024-05-01', 'Monthly internet bill'),
(3, 'Entertainment', 100.00, FALSE, '2024-05-01', 'Movies and dining out'),
(3, 'Savings', 500.00, TRUE, '2024-05-01', 'Monthly savings deposit');

INSERT INTO buckets (user_id, bucket_name, amount_required, amount_reserved, month_year, is_reserved, is_active) VALUES
(1, 'Vacation Fund', 2000.00, 500.00, '2024-05-01', FALSE, TRUE),
(1, 'Emergency Fund', 1000.00, 300.00, '2024-05-01', TRUE, TRUE),
(2, 'Car Maintenance', 500.00, 100.00, '2024-05-01', FALSE, FALSE),
(2, 'Home Improvement', 1500.00, 750.00, '2024-05-01', TRUE, TRUE),
(3, 'New Laptop', 1200.00, 600.00, '2024-05-01', FALSE, TRUE),
(3, 'Health Insurance', 800.00, 400.00, '2024-05-01', TRUE, FALSE);

INSERT INTO monthly_summary (user_id, month_year, projected_income, total_budget_amount) VALUES
(1, '2024-05-01', 7777.00, 1111.00),
(2, '2024-05-01', 9999.00, 3333.00),
(3, '2024-05-01', 9876.00, 999.00);

--- TAX ---

DROP TABLE IF EXISTS tax_brackets CASCADE;
DROP TABLE IF EXISTS standard_deduction CASCADE;
DROP TABLE IF EXISTS capital_gains_tax;
DROP TABLE IF EXISTS filing_status CASCADE;
DROP TABLE IF EXISTS child_tax_credit CASCADE;
DROP TABLE IF EXISTS dependent_care_tax_credit CASCADE;
DROP TABLE IF EXISTS dependent_care_tax_credit_limit CASCADE;
DROP TABLE IF EXISTS earned_income_tax_credit CASCADE;
DROP TABLE IF EXISTS education_tax_credit_aotc CASCADE;
DROP TABLE IF EXISTS education_tax_credit_llc CASCADE;
DROP TABLE IF EXISTS savers_tax_credit CASCADE;
DROP TABLE IF EXISTS state_tax CASCADE;
DROP TABLE IF EXISTS states CASCADE;
DROP TABLE IF EXISTS deduction CASCADE;
DROP TABLE IF EXISTS tax_return CASCADE;
DROP TABLE IF EXISTS taxreturn_deduction CASCADE;
DROP TABLE IF EXISTS w2 CASCADE;
DROP TABLE IF EXISTS other_income CASCADE;
DROP TABLE IF EXISTS taxreturn_credit CASCADE;


CREATE TABLE IF NOT EXISTS child_tax_credit (
  id SERIAL PRIMARY KEY,
  per_qualifying_child INT NOT NULL,
  per_other_child INT NOT NULL,
  income_threshold INT NOT NULL,
  rate_factor DECIMAL(5, 2) NOT NULL DEFAULT 0.05,
  refundable BOOLEAN NOT NULL,
  refund_limit INT NOT NULL,
  refund_rate DECIMAL(5, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS dependent_care_tax_credit (
  id SERIAL PRIMARY KEY,
  income_range INT NOT NULL,
  rate DECIMAL(5, 2) NOT NULL
);

CREATE TABLE IF NOT EXISTS dependent_care_tax_credit_limit (
  id SERIAL PRIMARY KEY,
  num_dependents INT NOT NULL,
  credit_limit INT NOT NULL,
  refundable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS earned_income_tax_credit (
  id SERIAL PRIMARY KEY,
  agi_threshold_3children INT NOT NULL,
  agi_threshold_2Children INT NOT NULL,
  agi_threshold_1Children INT NOT NULL,
  agi_threshold_0Children INT NOT NULL,
  amount_3children INT NOT NULL,
  amount_2children INT NOT NULL,
  amount_1children INT NOT NULL,
  amount_0children INT NOT NULL,
  investment_income_limit INT NOT NULL,
  refundable BOOLEAN NOT NULL,
  refund_limit INT NOT NULL,
  refund_rate DECIMAL(5, 2)
);

CREATE TABLE IF NOT EXISTS education_tax_credit_aotc (
  id SERIAL PRIMARY KEY,
  full_credit_income_threshold INT NOT NULL,
  partial_credit_income_threshold INT NOT NULL,
  income_partial_credit_rate DECIMAL(5, 2) NOT NULL,
  max_credit_amount INT NOT NULL,
  full_credit_expenses_threshold INT NOT NULL,
  partial_credit_expenses_threshold INT NOT NULL,
  partial_credit_expenses_rate DECIMAL(5,2) NOT NULL,
  refundable BOOLEAN NOT NULL,
  refund_limit INT NOT NULL,
  refund_rate DECIMAL(5, 2)
);

CREATE TABLE IF NOT EXISTS education_tax_credit_llc (
  id SERIAL PRIMARY KEY,
  full_credit_income_threshold INT NOT NULL,
  partial_credit_income_threshold INT NOT NULL,
  income_partial_credit_rate DECIMAL(5, 2) NOT NULL,
  max_credit_amount INT NOT NULL,
  expenses_threshold INT NOT NULL,
  credit_rate DECIMAL(5, 2) NOT NULL,
  refundable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS savers_tax_credit (
  id SERIAL PRIMARY KEY,
  agi_threshold_first_contribution_limit INT NOT NULL,
  agi_threshold_second_contribution_limit INT NOT NULL,
  agi_threshold_third_contribution_limit INT NOT NULL,
  first_contribution_rate DECIMAL(5, 2) NOT NULL,
  second_contribution_rate DECIMAL(5, 2) NOT NULL,
  third_contribution_rate DECIMAL(5, 2) NOT NULL,
  max_contribution_amount INT NOT NULL,
  refundable BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS filing_status (
  id SERIAL PRIMARY KEY,
  status VARCHAR(50) NOT NULL UNIQUE,
  child_tax_credit_id INT NOT NULL,
  earned_income_tax_credit_id INT NOT NULL,
  education_tax_credit_aotc_id INT NOT NULL,
  education_tax_credit_llc_id INT NOT NULL,
  savers_tax_credit_id INT NOT NULL,
  FOREIGN KEY (child_tax_credit_id) REFERENCES child_tax_credit(id),
  FOREIGN KEY (earned_income_tax_credit_id) REFERENCES earned_income_tax_credit(id),
  FOREIGN KEY (education_tax_credit_aotc_id) REFERENCES education_tax_credit_aotc(id),
  FOREIGN KEY (education_tax_credit_llc_id) REFERENCES education_tax_credit_llc(id),
  FOREIGN KEY (savers_tax_credit_id) REFERENCES savers_tax_credit(id)
);

CREATE TABLE IF NOT EXISTS standard_deduction (
  id SERIAL PRIMARY KEY,
  filing_status_id INT NOT NULL,
  deduction_amount INT NOT NULL,
  FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
);

CREATE TABLE IF NOT EXISTS capital_gains_tax (
  id SERIAL PRIMARY KEY,
  filing_status_id INT NOT NULL,
  rate DECIMAL(5, 2) NOT NULL,
  income_range INT NOT NULL,
  FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
);

CREATE TABLE IF NOT EXISTS tax_brackets (
  id SERIAL PRIMARY KEY,
  filing_status_id INT NOT NULL,
  rate DECIMAL(5, 2) NOT NULL,
  min_income INT NOT NULL,
  max_income INT NOT NULL,
  FOREIGN KEY (filing_status_id) REFERENCES filing_status(id)
);

CREATE TABLE IF NOT EXISTS states (
  id SERIAL PRIMARY KEY,
  state_name VARCHAR(50),
  state_code VARCHAR(2)
);

CREATE TABLE IF NOT EXISTS state_tax (
  id SERIAL PRIMARY KEY,
  state_id INT NOT NULL,
  income_range INT NOT NULL,
  rate DECIMAL(6, 5) NOT NULL,
  FOREIGN KEY (state_id) REFERENCES states(id)
);

CREATE TABLE IF NOT EXISTS deduction (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    agi_limit DECIMAL(10, 3),
    itemized BOOLEAN
);

CREATE TABLE IF NOT EXISTS tax_return (
    id SERIAL PRIMARY KEY,
    years INT,
    filing_status INT,
    user_id INT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(50),
    phone_number VARCHAR(20),
    address VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(2),
    zip VARCHAR(10),
    date_of_birth DATE,
    ssn VARCHAR(11),
    total_income NUMERIC,
    adjusted_gross_income NUMERIC,
    taxable_income NUMERIC,
    fed_tax_withheld NUMERIC,
    state_tax_withheld NUMERIC,
    social_security_tax_withheld NUMERIC,
    medicare_tax_withheld NUMERIC,
    total_credits NUMERIC,
    federal_refund NUMERIC,
    state_refund NUMERIC,
    CONSTRAINT unique_year_user_id UNIQUE (years, user_id)
);

CREATE TABLE IF NOT EXISTS taxreturn_deduction (
    id SERIAL PRIMARY KEY,
    taxreturn_id INT,
    deduction_id INT,
    amount_spent NUMERIC,
    CONSTRAINT fk_taxreturn FOREIGN KEY (taxreturn_id) REFERENCES tax_return(id),
    CONSTRAINT fk_deduction FOREIGN KEY (deduction_id) REFERENCES deduction(id),
    CONSTRAINT unique_taxreturn_deduction UNIQUE (taxreturn_id, deduction_id)
);

CREATE TABLE IF NOT EXISTS w2 (
    id SERIAL PRIMARY KEY,
    tax_return_id INT,
    years INT,
    user_id INT,
    employer VARCHAR(50),
    wages NUMERIC DEFAULT 0,
    state INT,
    federal_income_tax_withheld NUMERIC,
    state_income_tax_withheld NUMERIC,
    social_security_tax_withheld NUMERIC,
    medicare_tax_withheld NUMERIC,
    image_key VARCHAR(50),
    CONSTRAINT fk_tax_return FOREIGN KEY (tax_return_id) REFERENCES tax_return(id)
);

CREATE TABLE IF NOT EXISTS other_income (
  id SERIAL PRIMARY KEY,
  tax_return_id INT NOT NULL,
  long_term_capital_gains DECIMAL,
  short_term_capital_gains DECIMAL,
  other_investment_income DECIMAL,
  net_business_income DECIMAL,
  additional_income DECIMAL,
  FOREIGN KEY (tax_return_id) REFERENCES tax_return(id)
);

CREATE TABLE IF NOT EXISTS taxreturn_credit (
  id SERIAL PRIMARY KEY,
  tax_return_id INT NOT NULL,
  num_dependents INT,
  num_dependents_aotc INT,
  num_dependents_under_13 INT,
  child_care_expenses DECIMAL,
  education_expenses DECIMAL,
  llc_education_expenses DECIMAL,
  ira_contributions DECIMAL,
  claimed_as_dependent BOOLEAN,
  llc_credit BOOLEAN,
  FOREIGN KEY (tax_return_id) REFERENCES tax_return(id)
);


--- TRANSACTIONS ---

DROP TABLE IF EXISTS transaction;

CREATE TABLE transaction (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    account_id INT NOT NULL,
    vendor_name VARCHAR(100) NOT NULL,
    transaction_date DATE NOT NULL,
    transaction_amount DECIMAL(10, 2) NOT NULL,
    transaction_description VARCHAR(500),
    transaction_category VARCHAR(50) NOT NULL
);

INSERT INTO transaction (user_id, account_id, vendor_name, transaction_date, transaction_amount, transaction_description, transaction_category) VALUES
(1, 101, 'Amazon', '2024-01-15', 59.99, 'Purchase of electronics', 'SHOPPING'),
(2, 102, 'Starbucks', '2024-01-16', 4.75, 'Coffee and snacks', 'DINING'),
(1, 103, 'Walmart', '2024-01-17', 120.00, 'Grocery shopping', 'GROCERIES'),
(3, 104, 'Apple Store', '2024-01-18', 999.99, 'New iPhone purchase', 'SHOPPING'),
(2, 105, 'Netflix', '2024-01-19', 15.99, 'Monthly subscription', 'ENTERTAINMENT'),
(4, 106, 'Shell', '2024-01-20', 45.50, 'Gas for car', 'TRANSPORTATION'),
(3, 107, 'Costco', '2024-01-21', 200.00, 'Bulk shopping', 'GROCERIES'),
(1, 108, 'Uber', '2024-01-22', 25.00, 'Ride to airport', 'TRANSPORTATION'),
(4, 109, 'Spotify', '2024-01-23', 9.99, 'Monthly subscription', 'ENTERTAINMENT'),
(2, 110, 'Best Buy', '2024-01-24', 499.99, 'Laptop purchase', 'SHOPPING'),
(2, 102, 'Skillstorm', '2024-01-10', 2010.45, 'Paycheck', 'INCOME');

--- ACCOUNTS ---
CREATE SEQUENCE accounts_id_seq;

DROP TABLE IF EXISTS accounts;

CREATE TABLE IF NOT EXISTS accounts
(
    id integer NOT NULL DEFAULT nextval('accounts_id_seq'::regclass),
    account_number character varying(255) COLLATE pg_catalog."default",
    institution character varying(255) COLLATE pg_catalog."default",
    investment_rate numeric(38,2),
    routing_number character varying(255) COLLATE pg_catalog."default",
    starting_balance numeric(38,2),
    _type character varying(255) COLLATE pg_catalog."default",
    user_id character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT accounts_pkey PRIMARY KEY (id),
    CONSTRAINT accounts__type_check CHECK (_type::text = ANY (ARRAY['CHECKING'::character varying, 'SAVINGS'::character varying, 'CREDIT'::character varying, 'INVESTMENT'::character varying]::text[]))
);

INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
VALUES 
('123456789', 'Bank A', NULL, '111000025', 1500.00, 'CHECKING', '1'),
('987654321', 'Bank B', NULL, '111000026', 2000.00, 'CHECKING', '1'),
('112233445', 'Bank C', NULL, '111000027', 1200.00, 'CHECKING', '1');

INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
VALUES 
('223344556', 'Bank D', NULL, '222000025', 3000.00, 'SAVINGS', '1'),
('667788990', 'Bank E', NULL, '222000026', 2500.00, 'SAVINGS', '1');

INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
VALUES 
('445566778', 'Bank F', NULL, '333000025', 500.00, 'CREDIT', '1'),
('998877665', 'Bank G', NULL, '333000026', 800.00, 'CREDIT', '1');

INSERT INTO accounts (account_number, institution, investment_rate, routing_number, starting_balance, _type, user_id)
VALUES 
('554433221', 'Investment Bank A', 5.00, '444000025', 10000.00, 'INVESTMENT', '1'),
('776655443', 'Investment Bank B', 4.50, '444000026', 8000.00, 'INVESTMENT', '1');
