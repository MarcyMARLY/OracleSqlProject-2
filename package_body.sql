CREATE OR REPLACE PACKAGE BODY CREDIT_CARD_MANAGEMENT_SYSTEM IS 
	PROCEDURE add_client(cl_name IN A1_CLIENTS.cl_name%TYPE,
										cl_surname IN A1_CLIENTS.cl_surname%TYPE,
										cl_address IN A1_CLIENTS.cl_address%TYPE,
										cl_officcer IN A1_CLIENTS.cl_officcer%TYPE,
										cl_auth_officcer IN A1_CLIENTS.cl_auth_officcer%TYPE,
										cl_email IN A1_CLIENTS.cl_email%TYPE,
										cl_salary IN A1_CLIENTS.cl_salary%TYPE
										)
		AS
		val NUMBER;
		BEGIN
			val := M_SEQ.nextval;
			INSERT INTO A1_CLIENTS VALUES(R_SEQ.nextval, val, val, add_client.cl_name,add_client.cl_surname,0, add_client.cl_address,SYSDATE,add_client.cl_officcer,
				add_client.cl_auth_officcer,'01.01.00',add_client.cl_email,add_client.cl_salary);
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
										cl_address IN A1_CLIENTS.cl_address%TYPE,
										cl_email IN A1_CLIENTS.cl_email%TYPE,
										cl_salary IN A1_CLIENTS.cl_salary%TYPE)
	IS
		v_cl_record A1_CLIENTS%ROWTYPE;
	BEGIN
		SELECT * INTO v_cl_record FROM A1_CLIENTS WHERE A1_CLIENTS.cl_main_id = update_client.cl_main_id AND A1_CLIENTS.cl_auth_status = 1;
		UPDATE A1_CLIENTS SET A1_CLIENTS.cl_auth_status = 2, A1_CLIENTS.cl_main_id = A1_CLIENTS.cl_main_id + 1000
		WHERE A1_CLIENTS.cl_auth_status = 1 AND A1_CLIENTS.cl_main_id = update_client.cl_main_id;

		INSERT INTO A1_CLIENTS VALUES(R_SEQ.nextval,update_client.cl_main_id,update_client.cl_main_id,update_client.cl_name,update_client.cl_surname,
			1,update_client.cl_address,v_cl_record.cl_amend_date, v_cl_record.cl_officcer,v_cl_record.cl_auth_officcer,
			v_cl_record.cl_auth_date,update_client.cl_email,update_client.cl_salary);
		COMMIT;
	END update_client;

	PROCEDURE add_card(c_owner_id IN A3_CREDIT_CARDS.c_owner_id%TYPE,
										c_curr_type  IN A3_CREDIT_CARDS.c_curr_type%TYPE,
										c_interest IN A3_CREDIT_CARDS.c_interest%TYPE
										)
	IS
	val NUMBER;
	BEGIN
		IF check_credit_score(c_owner_id) THEN
		val:=CARD_M_SEQ.nextval;
		IF calc_credit_score(c_owner_id) > 3 THEN
			INSERT INTO A3_CREDIT_CARDS VALUES (CARD_R_SEQ.nextval,val,val,add_card.c_owner_id,add_card.c_curr_type,0,
				add_card.c_interest,0,SYSDATE,SYSDATE,500);
			ELSE IF calc_credit_score(c_owner_id) = 3 THEN
			INSERT INTO A3_CREDIT_CARDS VALUES (CARD_R_SEQ.nextval,val,val,add_card.c_owner_id,add_card.c_curr_type,0,
				add_card.c_interest,0,SYSDATE,SYSDATE,300);
			ELSE 
				INSERT INTO A3_CREDIT_CARDS VALUES (CARD_R_SEQ.nextval,val,val,add_card.c_owner_id,add_card.c_curr_type,0,
				add_card.c_interest,0,SYSDATE,SYSDATE,100);
				END IF;
		END IF;
		END IF;
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
	AS
	CURSOR cur_tr_all IS
		SELECT * FROM A4_CARD_TRANSACTIONS WHERE A4_CARD_TRANSACTIONS.tr_card_owner = dup_main_id AND A4_CARD_TRANSACTIONS.tr_type = 3;
	CURSOR cur_tr_t3 IS
		SELECT * FROM A4_CARD_TRANSACTIONS WHERE A4_CARD_TRANSACTIONS.tr_card_owner = dup_main_id AND A4_CARD_TRANSACTIONS.tr_pay_on_time=1;
	CURSOR cur_card_num IS
		SELECT * FROM A3_CREDIT_CARDS WHERE A3_CREDIT_CARDS.c_owner_id = dup_main_id AND A3_CREDIT_CARDS.c_status = 1;
	v_record A1_CLIENTS%ROWTYPE;
	BEGIN
		OPEN cur_card_num;
		IF cur_card_num%NOTFOUND THEN RETURN 5; END IF;
		CLOSE cur_card_num;
		OPEN cur_tr_all;
		IF cur_tr_all%NOTFOUND THEN RETURN 5; END IF;
		CLOSE cur_tr_all;
		OPEN cur_tr_t3;
		IF cur_tr_t3%NOTFOUND THEN RETURN 5; END IF;
		CLOSE cur_tr_t3;

		OPEN cur_tr_all;
		OPEN cur_tr_t3;
		OPEN cur_card_num;
		SELECT * INTO v_record FROM A1_CLIENTS WHERE A1_CLIENTS.cl_main_id = dup_main_id AND A1_CLIENTS.cl_auth_status = 1;
		IF cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 < 30 THEN
			RETURN 5;
		ELSE IF (cur_tr_t3%ROWCOUNT)/(cur_tr_all%ROWCOUNT+1)*100 < 60 AND cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 > 30 THEN
			IF TRUNC(SYSDATE - v_record.cl_auth_date) > 1200 THEN
				IF cur_card_num%ROWCOUNT > 1 THEN
					RETURN 5;
				ELSE RETURN 4;
				END IF;
			ELSE RETURN 4;
			END IF;
		
		ELSE IF (cur_tr_t3%ROWCOUNT)/(cur_tr_all%ROWCOUNT+1)*100 < 80 AND cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 > 60 THEN
			IF TRUNC(SYSDATE - v_record.cl_auth_date) > 1200 THEN
				IF cur_card_num%ROWCOUNT > 1 THEN
					RETURN 4;
				ELSE RETURN 3;
				END IF;
			ELSE RETURN 3;
			END IF;
		
		ELSE IF cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 < 90 AND cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 > 60 THEN
			IF TRUNC(SYSDATE - v_record.cl_auth_date) > 1200 THEN
				IF cur_card_num%ROWCOUNT > 1 THEN
					RETURN 3;
				ELSE RETURN 2;
				END IF;
			ELSE RETURN 2;
			END IF;
		
		ELSE IF cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 < 100 AND cur_tr_t3%ROWCOUNT/(cur_tr_all%ROWCOUNT+1)*100 > 90
		 THEN 
			RETURN 1;
			END IF;
		END IF;
		END IF;
		END IF;
		END IF;
		CLOSE cur_card_num;
		CLOSE cur_tr_all;
		CLOSE cur_tr_t3;

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