DROP PROCEDURE IF EXISTS sp_hello;

DELIMITER $$
CREATE PROCEDURE sp_hello()
BEGIN
SELECT "HELLO WORLD" AS msg;
END;
$$
DELIMITER ;

