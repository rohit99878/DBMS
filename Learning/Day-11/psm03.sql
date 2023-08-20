DROP PROCEDURE IF EXISTS sp_rect_area;

DELIMITER $$
CREATE PROCEDURE sp_rect_area(IN p_len int,IN p_bre int)
BEGIN
DECLARE v_area INT;
SET v_area = p_len * p_bre;
INSERT INTO result VALUES(v_area,"Rect Area");
END;
$$

DELIMITER ;