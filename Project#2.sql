CREATE SEQUENCE R_SEQ
START WITH 1
INCREMENT BY 1
NOMAXVALUE;


CREATE SEQUENCE CARD_R_SEQ
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

CREATE SEQUENCE M_SEQ
START WITH 1
INCREMENT BY 100
NOMAXVALUE;

CREATE SEQUENCE CARD_M_SEQ
START WITH 1
INCREMENT BY 100
NOMAXVALUE;

CREATE SEQUENCE TR_R_SEQ
START WITH 1
INCREMENT BY 1
NOMAXVALUE;

drop table A3_CREDIT_CARDS;

drop table A1_CLIENTS;
drop table A2_OFFICERS;


CREATE TABLE A1_CLIENTS(
	cl_record_id VARCHAR2(50) NOT NULL,
	cl_main_id VARCHAR2(50) NOT NULL,
	cl_dupl_main_id VARCHAR(50) NOT NULL,
	cl_name VARCHAR2(50) NOT NULL,
	cl_surname VARCHAR2(50) NOT NULL,
	cl_auth_status INT,
	cl_is_block INT,
	cl_address VARCHAR2(50),
	cl_amend_date DATE,
	cl_officcer VARCHAR2(50),
	cl_auth_officcer VARCHAR2(50), 
    cl_auth_date DATE ,
    cl_email VARCHAR2(50),
    cl_salary NUMBER(20,2),
    cl_credit_score NUMBER,					
    cl_his_status INT,
    CONSTRAINT pk_cl_id PRIMARY KEY (cl_main_id),
    CONSTRAINT fk_of FOREIGN KEY (cl_officcer) REFERENCES A2_OFFICERS(of_id)
);

EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.add_client('Nona','Mu','Paris','1','2','Nona.Mu',12000,45,1);
EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.auth_client('101');
EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.update_client('101','Nona','MuE',0,'Paris','Nona.MuE',12000,45,1);
EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.add_card('101','USD',1.5,101);
EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.auth_add_card('101');
EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.put_money_on_card('1',200);
EXECUTE CREDIT_CARD_MANAGEMENT_SYSTEM.take_money_from_card('1',100);
execute DBMS_OUTPUT.PUT_LINE(print_client_balance('1'));
CREATE TABLE A2_OFFICERS(
	of_id VARCHAR2(50) NOT NULL,
	of_f_name VARCHAR2(50),
	of_l_name VARCHAR2(50),
	of_hire_date DATE,
	CONSTRAINT pk_of_id PRIMARY KEY (of_id)
);
INSERT INTO A2_OFFICERS VALUES('1','Officer1','Officer1',SYSDATE);
INSERT INTO A2_OFFICERS VALUES('2','Officer2','Officer2',SYSDATE);
INSERT INTO A2_OFFICERS VALUES('3','Officer3','Officer3',SYSDATE);


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
CREATE OR REPLACE PACKAGE CREDIT_CARD_MANAGEMENT_SYSTEM IS 
	PROCEDURE add_client(cl_name IN A1_CLIENTS.cl_name%TYPE,
									cl_surname IN A1_CLIENTS.cl_surname%TYPE,
									cl_address IN A1_CLIENTS.cl_address%TYPE,
									cl_officcer IN A1_CLIENTS.cl_officcer%TYPE,
									cl_auth_officcer IN A1_CLIENTS.cl_auth_officcer%TYPE,
									cl_email IN A1_CLIENTS.cl_email%TYPE,
									cl_salary IN A1_CLIENTS.cl_salary%TYPE,
									cl_credit_score IN A1_CLIENTS.cl_credit_score%TYPE,
									cl_his_status IN A1_CLIENTS.cl_his_status%TYPE);

	PROCEDURE auth_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);
	PROCEDURE delete_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);
	PROCEDURE auth_delete_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);

	PROCEDURE update_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE,
										cl_name IN A1_CLIENTS.cl_name%TYPE,
										cl_surname IN A1_CLIENTS.cl_surname%TYPE,
										cl_is_block IN A1_CLIENTS.cl_is_block%TYPE,
										cl_address IN A1_CLIENTS.cl_address%TYPE,
										cl_email IN A1_CLIENTS.cl_email%TYPE,
										cl_salary IN A1_CLIENTS.cl_salary%TYPE,
										cl_credit_score IN A1_CLIENTS.cl_credit_score%TYPE,
										cl_his_status IN A1_CLIENTS.cl_his_status%TYPE);
	PROCEDURE add_card(c_owner_id IN A3_CREDIT_CARDS.c_owner_id%TYPE,
										c_curr_type  IN A3_CREDIT_CARDS.c_curr_type%TYPE,
										c_interest IN A3_CREDIT_CARDS.c_interest%TYPE,
										c_credit_limit IN A3_CREDIT_CARDS.c_credit_limit%TYPE);

	PROCEDURE auth_add_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE);
	PROCEDURE delete_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE);
	PROCEDURE auth_delete_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE);
	PROCEDURE update_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE,
										c_balance IN A3_CREDIT_CARDS.c_balance%TYPE,
										c_last_payment_date IN A3_CREDIT_CARDS.c_last_payment_date%TYPE, 
										c_credit_limit IN A3_CREDIT_CARDS.c_credit_limit%TYPE);
	PROCEDURE put_money_on_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE, money IN A3_CREDIT_CARDS.c_balance%TYPE);
	FUNCTION check_credit_limit(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE,money IN A3_CREDIT_CARDS.c_balance%TYPE) RETURN BOOLEAN;
	PROCEDURE take_money_from_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE, money IN A3_CREDIT_CARDS.c_balance%TYPE);
	FUNCTION print_client_balance(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE) RETURN NUMBER;
	PROCEDURE kill_cards(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);
	PROCEDURE client_card_payment(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE);
	FUNCTION calc_credit_score(dup_main_id IN A1_CLIENTS.cl_dupl_main_id%TYPE) RETURN NUMBER;
	FUNCTION check_credit_score(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE) RETURN BOOLEAN;


END CREDIT_CARD_MANAGEMENT_SYSTEM;


CREATE OR REPLACE PACKAGE BODY CREDIT_CARD_MANAGEMENT_SYSTEM IS 
	PROCEDURE add_client(cl_name IN A1_CLIENTS.cl_name%TYPE,
										cl_surname IN A1_CLIENTS.cl_surname%TYPE,
										cl_address IN A1_CLIENTS.cl_address%TYPE,
										cl_officcer IN A1_CLIENTS.cl_officcer%TYPE,
										cl_auth_officcer IN A1_CLIENTS.cl_auth_officcer%TYPE,
										cl_email IN A1_CLIENTS.cl_email%TYPE,
										cl_salary IN A1_CLIENTS.cl_salary%TYPE,
										cl_credit_score IN A1_CLIENTS.cl_credit_score%TYPE,
										cl_his_status IN A1_CLIENTS.cl_his_status%TYPE
										)
		AS
		val NUMBER;
		BEGIN
			val := M_SEQ.nextval;
			INSERT INTO A1_CLIENTS VALUES(R_SEQ.nextval, val, val, add_client.cl_name,add_client.cl_surname,0,0, add_client.cl_address,SYSDATE,add_client.cl_officcer,
				add_client.cl_auth_officcer,'01.01.00',add_client.cl_email,add_client.cl_salary,add_client.cl_credit_score,add_client.cl_his_status);
			COMMIT;
	END add_client;

	PROCEDURE auth_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE) 
		IS
		BEGIN
			UPDATE A1_CLIENTS SET A1_CLIENTS.cl_auth_status = 1, A1_CLIENTS.cl_auth_date = SYSDATE WHERE A1_CLIENTS.cl_auth_status = 0 AND A1_CLIENTS.cl_main_id = auth_client.cl_main_id;
			COMMIT;
	END auth_client;


	PROCEDURE delete_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE) 
		IS
		BEGIN
			UPDATE A1_CLIENTS SET A1_CLIENTS.cl_auth_status = 2 WHERE A1_CLIENTS.cl_auth_status = 1 AND A1_CLIENTS.cl_main_id = delete_client.cl_main_id;
			kill_cards(cl_main_id);
			COMMIT;
	END delete_client;


	PROCEDURE auth_delete_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE) 
		IS
		BEGIN
			UPDATE A1_CLIENTS SET A1_CLIENTS.cl_auth_status = 3, A1_CLIENTS.cl_auth_date = SYSDATE WHERE A1_CLIENTS.cl_auth_status = 2 AND A1_CLIENTS.cl_main_id = auth_delete_client.cl_main_id;
			COMMIT;
	END auth_delete_client;


	PROCEDURE update_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE,
										cl_name IN A1_CLIENTS.cl_name%TYPE,
										cl_surname IN A1_CLIENTS.cl_surname%TYPE,
										cl_is_block IN A1_CLIENTS.cl_is_block%TYPE,
										cl_address IN A1_CLIENTS.cl_address%TYPE,
										cl_email IN A1_CLIENTS.cl_email%TYPE,
										cl_salary IN A1_CLIENTS.cl_salary%TYPE,
										cl_credit_score IN A1_CLIENTS.cl_credit_score%TYPE,
										cl_his_status IN A1_CLIENTS.cl_his_status%TYPE)
	IS
		v_cl_record A1_CLIENTS%ROWTYPE;
	BEGIN
		SELECT * INTO v_cl_record FROM A1_CLIENTS WHERE A1_CLIENTS.cl_main_id = update_client.cl_main_id AND A1_CLIENTS.cl_auth_status = 1;
		UPDATE A1_CLIENTS SET A1_CLIENTS.cl_auth_status = 2, A1_CLIENTS.cl_main_id = A1_CLIENTS.cl_main_id + 1000
		WHERE A1_CLIENTS.cl_auth_status = 1 AND A1_CLIENTS.cl_main_id = update_client.cl_main_id;

		INSERT INTO A1_CLIENTS VALUES(R_SEQ.nextval,update_client.cl_main_id,update_client.cl_main_id,update_client.cl_name,update_client.cl_surname,
			1,update_client.cl_is_block,update_client.cl_address,v_cl_record.cl_amend_date, v_cl_record.cl_officcer,v_cl_record.cl_auth_officcer,
			v_cl_record.cl_auth_date,update_client.cl_email,update_client.cl_salary,update_client.cl_credit_score,update_client.cl_his_status);
		COMMIT;
	END update_client;

	PROCEDURE add_card(c_owner_id IN A3_CREDIT_CARDS.c_owner_id%TYPE,
										c_curr_type  IN A3_CREDIT_CARDS.c_curr_type%TYPE,
										c_interest IN A3_CREDIT_CARDS.c_interest%TYPE,
										c_credit_limit IN A3_CREDIT_CARDS.c_credit_limit%TYPE
										)
	IS
	val NUMBER;
	BEGIN
		val:=CARD_M_SEQ.nextval;
		INSERT INTO A3_CREDIT_CARDS VALUES (CARD_R_SEQ.nextval,val,val,add_card.c_owner_id,add_card.c_curr_type,0,
			add_card.c_interest,0,SYSDATE,SYSDATE,add_card.c_credit_limit);
		COMMIT;
	END add_card;

	PROCEDURE auth_add_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE)
	IS
	BEGIN
		UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_status = 1 WHERE A3_CREDIT_CARDS.c_main_id = auth_add_card.c_main_id 
		AND A3_CREDIT_CARDS.c_status = 0;
		COMMIT;
	END auth_add_card;

	PROCEDURE delete_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE)
	IS
	BEGIN
		UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_status = 2 WHERE A3_CREDIT_CARDS.c_main_id = delete_card.c_main_id 
		AND A3_CREDIT_CARDS.c_status = 1;
		COMMIT;
	END delete_card;

	PROCEDURE auth_delete_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE)
	IS
	BEGIN
		UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_status = 3 WHERE A3_CREDIT_CARDS.c_main_id = auth_delete_card.c_main_id 
		AND A3_CREDIT_CARDS.c_status = 2;
		COMMIT;
	END auth_delete_card;

	PROCEDURE update_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE,
										c_balance IN A3_CREDIT_CARDS.c_balance%TYPE,
										c_last_payment_date IN A3_CREDIT_CARDS.c_last_payment_date%TYPE,
										c_credit_limit IN A3_CREDIT_CARDS.c_credit_limit%TYPE)
	IS
	v_card_record A3_CREDIT_CARDS%ROWTYPE;
	BEGIN
		SELECT * INTO v_card_record FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_main_id = update_card.c_main_id 
		AND A3_CREDIT_CARDS.c_status = 1;
		
		UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_status = 2, A3_CREDIT_CARDS.c_main_id = update_card.c_main_id+1000 
			WHERE A3_CREDIT_CARDS.c_main_id = update_card.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
		INSERT INTO A3_CREDIT_CARDS VALUES (CARD_R_SEQ.nextval, update_card.c_main_id,update_card.c_main_id,v_card_record.c_owner_id, 
				v_card_record.c_curr_type, update_card.c_balance,v_card_record.c_interest,v_card_record.c_status,v_card_record.c_amend_date,
				update_card.c_last_payment_date, update_card.c_credit_limit);
		COMMIT;
	END update_card;

	PROCEDURE put_money_on_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE, money IN A3_CREDIT_CARDS.c_balance%TYPE )
		IS	
		v_record A3_CREDIT_CARDS%ROWTYPE;	
		BEGIN
		SELECT * INTO v_record FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_main_id = put_money_on_card.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
		UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_balance = A3_CREDIT_CARDS.c_balance + money WHERE A3_CREDIT_CARDS.c_main_id = put_money_on_card.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
		INSERT INTO A4_CARD_TRANSACTIONS VALUES (TR_R_SEQ.nextval,1,v_record.c_owner_id,put_money_on_card.money,put_money_on_card.c_main_id,SYSDATE,0);
		END put_money_on_card;
	FUNCTION check_credit_limit(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE,money IN A3_CREDIT_CARDS.c_balance%TYPE)
		RETURN BOOLEAN
		IS
		v_record A3_CREDIT_CARDS%ROWTYPE;
		BEGIN
			SELECT * INTO v_record FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_main_id = check_credit_limit.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
			IF v_record.c_credit_limit > check_credit_limit.money THEN
			RETURN TRUE;
			ELSE RETURN FALSE;
			END IF;
		END check_credit_limit;

	PROCEDURE take_money_from_card(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE, money IN A3_CREDIT_CARDS.c_balance%TYPE )
	IS	
	v_record A3_CREDIT_CARDS%ROWTYPE;	
	BEGIN

	SELECT * INTO v_record FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_main_id = take_money_from_card.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
	IF check_credit_limit(v_record.c_main_id, take_money_from_card.money) THEN
		IF v_record.c_balance-money > 0 THEN
			UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_balance = A3_CREDIT_CARDS.c_balance - money WHERE A3_CREDIT_CARDS.c_main_id = take_money_from_card.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
			INSERT INTO A4_CARD_TRANSACTIONS VALUES (TR_R_SEQ.nextval,2,v_record.c_owner_id,take_money_from_card.money,
				take_money_from_card.c_main_id,SYSDATE,0);
		ELSE RAISE_APPLICATION_ERROR(-20000, 'You dont have enough money on this card!');
		END IF;
	ELSE RAISE_APPLICATION_ERROR(-20000, 'You are over you credit limit!');
	END IF;
	END take_money_from_card;

	FUNCTION print_client_balance(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE) RETURN NUMBER
		IS
		v_record A3_CREDIT_CARDS%ROWTYPE;
		BEGIN
		SELECT * INTO v_record FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_main_id = print_client_balance.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
		RETURN v_record.c_balance;
		END print_client_balance;
	PROCEDURE kill_cards(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE) 
IS
	CURSOR cur_cards IS
		SELECT c_status FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_owner_id = kill_cards.cl_main_id AND A3_CREDIT_CARDS.c_status = 1;
	BEGIN
		FOR cl_rec IN cur_cards
		LOOP
			UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_status = 2 WHERE A3_CREDIT_CARDS.c_owner_id = kill_cards.cl_main_id AND A3_CREDIT_CARDS.c_status = 1;
		END LOOP;
		COMMIT;
	END kill_cards;

	PROCEDURE client_card_payment(c_main_id IN A3_CREDIT_CARDS.c_main_id%TYPE)
IS 
	v_record A3_CREDIT_CARDS%ROWTYPE;
BEGIN
	SELECT * INTO v_record FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_main_id = client_card_payment.c_main_id AND A3_CREDIT_CARDS.c_status = 1;
	IF TRUNC(SYSDATE - ADD_MONTHS(v_record.c_last_payment_date,1)) <= 0 THEN
		IF v_record.c_balance - v_record.c_interest>=0 THEN
		UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_balance = A3_CREDIT_CARDS.c_balance - v_record.c_interest  WHERE A3_CREDIT_CARDS.c_main_id = client_card_payment.c_main_id AND A3_CREDIT_CARDS.c_status=1;
		INSERT INTO A4_CARD_TRANSACTIONS VALUES (TR_R_SEQ.nextval,3,v_record.c_owner_id,v_record.c_interest,
					client_card_payment.c_main_id,ADD_MONTHS(v_record.c_last_payment_date,1),0);
		ELSE RAISE_APPLICATION_ERROR(-20000,'You dont have enought money to pay');
		END IF;
		ELSE IF TRUNC(SYSDATE - ADD_MONTHS(v_record.c_last_payment_date,1)) > 0 THEN
			IF v_record.c_balance - v_record.c_interest - v_record.c_balance*0.5/100*TRUNC(SYSDATE - ADD_MONTHS(v_record.c_last_payment_date,1)) >= 0
				THEN
				UPDATE A3_CREDIT_CARDS SET A3_CREDIT_CARDS.c_balance = A3_CREDIT_CARDS.c_balance - v_record.c_interest - v_record.c_balance*0.5/100*TRUNC(SYSDATE - ADD_MONTHS(v_record.c_last_payment_date,1))
				 WHERE A3_CREDIT_CARDS.c_main_id = client_card_payment.c_main_id AND A3_CREDIT_CARDS.c_status=1;
				 INSERT INTO A4_CARD_TRANSACTIONS VALUES (TR_R_SEQ.nextval,3,v_record.c_owner_id,v_record.c_interest,
					client_card_payment.c_main_id,ADD_MONTHS(v_record.c_last_payment_date,1),1);
			ELSE RAISE_APPLICATION_ERROR(-20000,'You dont have enought money to pay');
			END IF;
			END IF;

	END IF;

END client_card_payment;

FUNCTION calc_credit_score(dup_main_id IN A1_CLIENTS.cl_dupl_main_id%TYPE) RETURN NUMBER
	IS
	CURSOR cur_tr_all IS
		SELECT * FROM A4_CARD_TRANSACTIONS WHERE A4_CARD_TRANSACTIONS.tr_card_owner = dup_main_id AND A4_CARD_TRANSACTIONS.tr_type = 3;
	CURSOR cur_tr_t3 IS
		SELECT * FROM A4_CARD_TRANSACTIONS WHERE A4_CARD_TRANSACTIONS.tr_card_owner = dup_main_id AND (A4_CARD_TRANSACTIONS.tr_type = 3 
			AND A4_CARD_TRANSACTIONS.tr_pay_on_time=1);
	CURSOR cur_card_num IS
		SELECT * FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_owner_id = dup_main_id AND A3_CREDIT_CARDS.c_status = 1;
	v_record A1_CLIENTS%ROWTYPE;
	BEGIN
		SELECT * INTO v_record FROM A1_CLIENTS WHERE A1_CLIENTS.cl_main_id = dup_main_id AND A1_CLIENTS.cl_auth_status = 1;
		IF cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 < 30 THEN
			RETURN 5;
		ELSE IF cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 < 60 AND cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 > 30 THEN
			IF TRUNC(SYSDATE - v_record.cl_auth_date) > 1200 THEN
				IF cur_card_num%ROWCOUNT > 1 THEN
					RETURN 5;
				ELSE RETURN 4;
				END IF;
			ELSE RETURN 4;
			END IF;
		
		ELSE IF cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 < 80 AND cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 > 60 THEN
			IF TRUNC(SYSDATE - v_record.cl_auth_date) > 1200 THEN
				IF cur_card_num%ROWCOUNT > 1 THEN
					RETURN 4;
				ELSE RETURN 3;
				END IF;
			ELSE RETURN 3;
			END IF;
		
		ELSE IF cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 < 90 AND cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 > 60 THEN
			IF TRUNC(SYSDATE - v_record.cl_auth_date) > 1200 THEN
				IF cur_card_num%ROWCOUNT > 1 THEN
					RETURN 3;
				ELSE RETURN 2;
				END IF;
			ELSE RETURN 2;
			END IF;
		
		ELSE IF cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 < 100 AND cur_tr_t3%ROWCOUNT/cur_tr_all%ROWCOUNT*100 > 90
		 THEN 
			RETURN 1;
			END IF;
		END IF;
		END IF;
		END IF;
		END IF;

 	END calc_credit_score;

 	FUNCTION check_credit_score(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE) RETURN BOOLEAN
		
	IS
	v_record A1_CLIENTS%ROWTYPE;
	BEGIN
		SELECT * INTO v_record FROM A1_CLIENTS WHERE A1_CLIENTS.cl_main_id = check_credit_score.cl_main_id AND A1_CLIENTS.cl_auth_status = 1;
		IF calc_credit_score(cl_main_id) = 2 AND v_record.cl_salary > 45000 THEN RETURN TRUE;
			ELSE IF calc_credit_score(cl_main_id) < 3 THEN RETURN FALSE;
			END IF;
		END IF;
		IF calc_credit_score(cl_main_id) > 3 THEN RETURN TRUE;
		ELSE RETURN FALSE;
		END IF;
	END check_credit_score;


END CREDIT_CARD_MANAGEMENT_SYSTEM;







 




