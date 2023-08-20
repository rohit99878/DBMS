DROP PROCEDURE IF EXISTS sp_even_sum;

DELIMITER $$    
CREATE PROCEDURE sp_even_sum(IN p_low int,IN p_up int)
BEGIN
DECLARE v_sum INT DEFAULT 0;

WHILE p_low<=p_up DO

    IF p_low%2 = 0 THEN
    SET v_sum = v_sum + p_low;
    END IF;

SET p_low = p_low + 1;
END WHILE;
INSERT INTO result VALUES(v_sum,"Even sum");
END;
$$

DELIMITER ;