DROP PROCEDURE IF EXISTS sp_square2;

DELIMITER $$
CREATE PROCEDURE sp_square2(INOUT p_res INT)
BEGIN
SET p_res = p_res * p_res;
END;

$$

DELIMITER ;