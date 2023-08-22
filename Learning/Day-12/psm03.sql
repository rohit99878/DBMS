DROP TRIGGER IF EXISTS balance_check;

DELIMITER $$
CREATE TRIGGER balance_check
BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF OLD.balance<=0 THEN
        call sp_hello();
    END IF;
END;
$$

DELIMITER ;