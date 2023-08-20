DROP PROCEDURE IF EXISTS sp_square;

DELIMITER $$
CREATE PROCEDURE sp_square(IN p_num INT,OUT p_res INT)
BEGIN
SET p_res = p_num * p_num;
END;

$$

DELIMITER ;