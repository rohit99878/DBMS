DROP TRIGGER IF EXISTS balance_update;
DELIMITER $$
CREATE TRIGGER balance_update
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
    IF NEW.type="deposit" THEN
    UPDATE accounts SET balance=balance+NEW.amt WHERE acc_no=NEW.acc_no;
    ELSE 
    UPDATE accounts SET balance=balance-NEW.amt WHERE acc_no=NEW.acc_no;
    END IF;
END;
$$
DELIMITER ;
