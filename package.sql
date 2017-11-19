CREATE OR REPLACE PACKAGE CREDIT_CARD_MANAGEMENT_SYSTEM IS 
	PROCEDURE add_client(cl_name IN A1_CLIENTS.cl_name%TYPE,
									cl_surname IN A1_CLIENTS.cl_surname%TYPE,
									cl_address IN A1_CLIENTS.cl_address%TYPE,
									cl_officcer IN A1_CLIENTS.cl_officcer%TYPE,
									cl_auth_officcer IN A1_CLIENTS.cl_auth_officcer%TYPE,
									cl_email IN A1_CLIENTS.cl_email%TYPE,
									cl_salary IN A1_CLIENTS.cl_salary%TYPE
									);

	PROCEDURE auth_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);
	PROCEDURE delete_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);
	PROCEDURE auth_delete_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE);

	PROCEDURE update_client(cl_main_id IN A1_CLIENTS.cl_main_id%TYPE,
										cl_name IN A1_CLIENTS.cl_name%TYPE,
										cl_surname IN A1_CLIENTS.cl_surname%TYPE,
										cl_address IN A1_CLIENTS.cl_address%TYPE,
										cl_email IN A1_CLIENTS.cl_email%TYPE,
										cl_salary IN A1_CLIENTS.cl_salary%TYPE);
	PROCEDURE add_card(c_owner_id IN A3_CREDIT_CARDS.c_owner_id%TYPE,
										c_curr_type  IN A3_CREDIT_CARDS.c_curr_type%TYPE,
										c_interest IN A3_CREDIT_CARDS.c_interest%TYPE);

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