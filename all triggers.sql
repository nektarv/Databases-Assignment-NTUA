 -- make a frankenstein that handles everything on episode insertion
/*TODO:
ADD A RECIPE SELECTOR BASED ON CHEFS PROBABLY 
PROBABLY(?) ADD A COLUMN ON PLAYS OF WHAT EVERY CHEF COOKS
AND SOME CHECKS INSIDE DATABASE WHICH WE HAVE ALREADY INCLUDED ON FAKER BUT SHOULD EXIST AS INTEGRITY CONSTRAINTS*/

DELIMITER $$

DROP TRIGGER IF EXISTS `Episode_grades`$$

CREATE DEFINER = CURRENT_USER TRIGGER `Episode_grades` 
AFTER INSERT ON `Episodes` 
FOR EACH ROW
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE rgrade INT;
    DECLARE rscore1 INT;
    DECLARE rscore2 INT;
    DECLARE rscore3 INT;
    DECLARE rCU_ID INT;
    DECLARE rCH_ID INT;
    DECLARE rREC_ID INT;
    DECLARE prev_ep1 INT;
    DECLARE prev_ep2 INT;
    DECLARE prev_ep3 INT;
    DECLARE judge1 INT;
    DECLARE judge2 INT;
    DECLARE judge3 INT;

    -- Get IDs of the last three episodes
    SELECT EP_ID INTO prev_ep1 FROM Episodes ORDER BY EP_ID DESC LIMIT 2, 1;
    SELECT EP_ID INTO prev_ep2 FROM Episodes ORDER BY EP_ID DESC LIMIT 1, 1;
    SELECT EP_ID INTO prev_ep3 FROM Episodes ORDER BY EP_ID DESC LIMIT 0, 1;

    -- Setup cuisines-----
    loop_players: LOOP
		SET rscore1=FLOOR(RAND() * 6);
        SET rscore2=FLOOR(RAND() * 6);
        SET rscore3=FLOOR(RAND() * 6);
        SET rgrade = rscore1+rscore2+rscore3;
        SET j=0;
        
        -- Ensure rCU_ID is valid and hasn't been used in all of the previous three episodes
        SELECT CU_ID INTO rCU_ID 
        FROM ethnic_cuisine
        WHERE CU_ID NOT IN (
            SELECT DISTINCT CU_ID
            FROM ep_cu
            WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
            GROUP BY CU_ID
            HAVING COUNT(DISTINCT EP_ID) = 3
        )
        ORDER BY RAND() 
        LIMIT 1;

        -- Ensure rCH_ID is valid and from the selected cuisine
        SELECT C.CH_ID INTO rCH_ID 
        FROM Chefs C JOIN chef_cu A ON C.CH_ID=A.CH_ID
        WHERE C.CH_ID NOT IN (
            SELECT DISTINCT CH_ID
            FROM PLAYS
            WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
            GROUP BY CH_ID
            HAVING COUNT(DISTINCT EP_ID) = 3
        ) 
        AND A.CU_ID = rCU_ID -- Ensure chef is from the selected cuisine
        ORDER BY RAND() 
        LIMIT 1;
        
		SELECT R.REC_ID INTO rREC_ID
        FROM rec_chef R
        WHERE R.REC_ID NOT IN (
            SELECT DISTINCT recipe
            FROM PLAYS
            WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
            GROUP BY recipe
            HAVING COUNT(DISTINCT EP_ID) = 3
        ) 
        AND R.CH_ID = rCH_ID -- Ensure chef cooks recipy
        AND EXISTS (SELECT REC_ID 
        FROM recipes t 
        WHERE t.REC_ID=R.REC_ID 
        AND t.CU_ID = rCU_ID)
        ORDER BY RAND() 
        LIMIT 1;

        -- Check for unique combination of CH_ID and EP_ID
        IF NOT EXISTS (
            SELECT 1 
            FROM PLAYS 
            WHERE CH_ID = rCH_ID AND EP_ID = NEW.EP_ID
        ) THEN
            SET j=j+1;
        END IF;

        -- Insert into ep_cu table to record the association
        IF NOT EXISTS (
            SELECT 1 
            FROM ep_cu 
            WHERE CU_ID = rCU_ID AND EP_ID = NEW.EP_ID
        ) THEN
            SET j=j+1;
        END IF;

        IF j=2 THEN
            INSERT INTO PLAYS (CH_ID, EP_ID, Grade, Cuisine,recipe,score1,score2,score3) VALUES (rCH_ID, NEW.EP_ID, rgrade, rCU_ID,rREC_ID,rscore1,rscore2,rscore3);
            INSERT INTO ep_cu (CU_ID, EP_ID) VALUES (rCU_ID, NEW.EP_ID);
            SET i=i+1;
        END IF;

        -- Exit the loop after 10 unique insertsrec_chef
        IF i >= 10 THEN
            LEAVE loop_players;
        END IF;
    END LOOP;

    -- Select three judges who haven't judged in the last three consecutive episodes and are not players
    SELECT CH_ID INTO judge1 
    FROM Chefs 
    WHERE CH_ID NOT IN (
        SELECT DISTINCT CH_ID
        FROM judges
        WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
        GROUP BY CH_ID
        HAVING COUNT(DISTINCT EP_ID) = 3
    ) AND CH_ID NOT IN (
        SELECT CH_ID
        FROM PLAYS
        WHERE EP_ID = NEW.EP_ID
    )
    ORDER BY RAND() 
    LIMIT 1;

    SELECT CH_ID INTO judge2 
    FROM Chefs 
    WHERE CH_ID NOT IN (
        SELECT DISTINCT CH_ID
        FROM judges
        WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
        GROUP BY CH_ID
        HAVING COUNT(DISTINCT EP_ID) = 3
    ) AND CH_ID NOT IN (
        SELECT CH_ID
        FROM PLAYS
        WHERE EP_ID = NEW.EP_ID
    ) AND CH_ID <> judge1
    ORDER BY RAND() 
    LIMIT 1;

    SELECT CH_ID INTO judge3 
    FROM Chefs 
    WHERE CH_ID NOT IN (
        SELECT DISTINCT CH_ID
        FROM judges
        WHERE EP_ID IN (prev_ep1, prev_ep2, prev_ep3)
        GROUP BY CH_ID
        HAVING COUNT(DISTINCT EP_ID) = 3
    ) AND CH_ID NOT IN (
        SELECT CH_ID
        FROM PLAYS
        WHERE EP_ID = NEW.EP_ID
    ) AND CH_ID NOT IN (judge1, judge2)
    ORDER BY RAND() 
    LIMIT 1;

    -- Insert the judges into the JUDGES table
    INSERT INTO judges (CH_ID, EP_ID, count) VALUES (judge1, NEW.EP_ID,1);
    INSERT INTO judges (CH_ID, EP_ID, count) VALUES (judge2, NEW.EP_ID,2);
    INSERT INTO judges (CH_ID, EP_ID, count) VALUES (judge3, NEW.EP_ID,3);

END$$

DELIMITER ;
-- --------------------------------------------------------------------------

DELIMITER $$

DROP TRIGGER IF EXISTS Create_nutrition_info_for_recipe$$
DELIMITER $$

CREATE DEFINER = CURRENT_USER TRIGGER `Create_nutrition_info_for_recipe`
BEFORE INSERT ON `nutrition_info` 
FOR EACH ROW
BEGIN
    DECLARE total_kcals INT DEFAULT 0;
    DECLARE quantity INT;
    
     SELECT Portions INTO quantity
     FROM recipes r
     WHERE r.REC_ID=NEW.REC_ID;

    SELECT (SUM(i.`Kcal per 100` * ri.Precise_Quantity / 100))/quantity
    INTO total_kcals
    FROM ingredients i 
    JOIN rec_ingr ri ON ri.ING_ID = i.ING_ID
    WHERE ri.REC_ID = NEW.REC_ID;

    SET NEW.`Kcal per serving` = total_kcals;
END$$

DELIMITER ;

-- ---------------------------------------------------------------------
DELIMITER //


DROP PROCEDURE IF EXISTS `get_winner`//

CREATE PROCEDURE get_winner(Episode INT)
BEGIN
		DECLARE mywinner INT;
        SELECT c.CH_ID INTO mywinner
        FROM chefs c JOIN plays p ON c.CH_ID = p.CH_ID
        WHERE p.EP_ID = Episode
        ORDER BY grade DESC, c.class
        LIMIT 1;
	UPDATE episodes E
    SET E.winner = mywinner
    WHERE E.EP_ID=Episode;
END //
DELIMITER ;

-- ---------------------------------------------------------------------

DELIMITER //

DROP PROCEDURE IF EXISTS `set_all_winners` //

CREATE PROCEDURE `set_all_winners`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max1 INT;

    -- Get the maximum episode ID
    SELECT MAX(EP_ID) INTO max1
    FROM episodes;

    -- Loop through all episode IDs from 1 to max1
    WHILE i <= max1 DO
        -- Call the get_winner procedure for the current episode ID
        CALL get_winner(i);

        -- Increment the loop counter
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
-- ------------------------------------
DELIMITER //
DROP PROCEDURE IF EXISTS add_chef//

CREATE PROCEDURE add_chef(in user_id INT)
BEGIN
DECLARE username VARCHAR(255);
    DECLARE pass VARCHAR(255);

    -- Construct username and password
    SET username = CONCAT('chef', user_id);
    SET pass = CONCAT('password', user_id);
    
	SET @sql_query = CONCAT('DROP USER IF EXISTS \'', username,'\'@\'localhost\';');

    -- Prepare and execute the SQL statement
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
	SET @sql_query = CONCAT('CREATE USER \'', username,'\'@\'localhost\' IDENTIFIED BY \'', pass, '\';');

    -- Prepare and execute the SQL statement
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    
	SET @sql_query = CONCAT('GRANT Chef TO \'',username,'\'@\'localhost\';');

    -- Prepare and execute the SQL statement
    PREPARE stmt FROM @sql_query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
    DELETE FROM user_chefs_mapping WHERE mysql_user=username;
    INSERT INTO user_chefs_mapping (mysql_user, ch_id) VALUES (username,user_id);
END//

-- -------------------------------------------------------------

DROP PROCEDURE IF EXISTS `set_all_chefs` //

CREATE PROCEDURE `set_all_chefs`()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE max1 INT;
    DECLARE min1 INT;

    -- Get the maximum episode ID
    SELECT MAX(CH_ID) INTO max1
    FROM Chefs;
	SELECT MIN(CH_ID) INTO min1
    FROM Chefs;
    
	SET i=min1;
    -- Loop through all episode IDs from 1 to max1
    WHILE i <= max1 DO
			IF EXISTS (SELECT CH_ID from Chefs WHERE CH_ID=i) THEN CALL add_chef(i);
        -- Call the get_winner procedure for the current episode ID
			END IF;
        -- Increment the loop counter
        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;




