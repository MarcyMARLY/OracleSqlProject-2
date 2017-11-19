CREATE TABLE A1_CLIENTS(
	cl_record_id VARCHAR2(50) NOT NULL,
	cl_main_id VARCHAR2(50) NOT NULL,
	cl_dupl_main_id VARCHAR(50) NOT NULL,
	cl_name VARCHAR2(50) NOT NULL,
	cl_surname VARCHAR2(50) NOT NULL,
	cl_auth_status INT,
	cl_address VARCHAR2(50),
	cl_amend_date DATE,
	cl_officcer VARCHAR2(50),
	cl_auth_officcer VARCHAR2(50), 
    cl_auth_date DATE ,
    cl_email VARCHAR2(50),
    cl_salary NUMBER(20,2),
    CONSTRAINT pk_cl_id PRIMARY KEY (cl_main_id),
    CONSTRAINT fk_of FOREIGN KEY (cl_officcer) REFERENCES A2_OFFICERS(of_id)
);


CREATE TABLE A2_OFFICERS(
	of_id VARCHAR2(50) NOT NULL,
	of_f_name VARCHAR2(50),
	of_l_name VARCHAR2(50),
	of_hire_date DATE,
	CONSTRAINT pk_of_id PRIMARY KEY (of_id)
);

CREATE TABLE A3_CREDIT_CARDS(
	c_record_id VARCHAR2(50) NOT NULL,
	c_main_id VARCHAR2(50) NOT NULL,
	c_dup_main_id VARCHAR2(50) NOT NULL,
	c_owner_id VARCHAR2(50) NOT NULL,
	c_curr_type VARCHAR2(50),
	c_balance NUMBER(20,2),
	c_interest NUMBER(20,2),
	c_status INT,
	c_amend_date  DATE,
	c_last_payment_date DATE,
	c_credit_limit NUMBER DEFAULT 100,	
	CONSTRAINT pk_c_id PRIMARY KEY (c_main_id),
	CONSTRAINT fk_ow FOREIGN KEY (c_owner_id) REFERENCES A1_CLIENTS(cl_main_id)
);
CREATE TABLE A4_CARD_TRANSACTIONS(
	tr_record_id VARCHAR2(50) NOT NULL,
	tr_type INT,
	tr_card_owner VARCHAR2(50) NOT NULL,
	tr_balance NUMBER(20,2),
	tr_card_id VARCHAR2(50) NOT NULL,
	tr_paym_day DATE,
	tr_pay_on_time INT
);