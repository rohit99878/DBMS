DROP FUNCTION IF EXISTS Title;

DELIMITER $$
CREATE FUNCTION Title(p_name CHAR(40))
RETURNS CHAR(40)
Not DETERMINISTIC
BEGIN
DECLARE v_result CHAR(40);
SET v_result = CONCAT(UPPER(LEFT(p_name,1)),LOWER(SUBSTRING(p_name,2)));
RETURN v_result;
END;
$$

DELIMITER ;
