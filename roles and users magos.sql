-- change database name

-- Drop existing roles and users
DROP ROLE IF EXISTS `Admin`;
DROP ROLE IF EXISTS `Chef`;

DROP USER IF EXISTS 'admin_user'@'localhost';
DROP USER IF EXISTS 'chef3'@'localhost';
DROP USER IF EXISTS 'chef2'@'localhost';

-- Create roles
CREATE ROLE `Admin`;
CREATE ROLE `Chef`;

-- Grant privileges to roles
GRANT ALL PRIVILEGES ON `cooking_contestdb`.* TO `Admin`;

-- Create admin user and grant role
CREATE USER 'admin_user'@'localhost' IDENTIFIED BY 'bored admin';
GRANT `Admin` TO 'admin_user'@'localhost';
SET DEFAULT ROLE `Admin` TO 'admin_user'@'localhost';

-- Create chef users
CREATE USER 'chef3'@'localhost' IDENTIFIED BY 'password1';
CREATE USER 'chef2'@'localhost' IDENTIFIED BY 'password2';

USE cooking_contestdb;
-- Create user-chefs mapping table
DROP TABLE IF EXISTS user_chefs_mapping;

CREATE TABLE user_chefs_mapping (
    mysql_user VARCHAR(100) NOT NULL,
    ch_id INT NOT NULL,
    PRIMARY KEY (mysql_user),
    FOREIGN KEY (ch_id) REFERENCES chefs(CH_ID)
);

-- Insert mapping for chefs
INSERT INTO user_chefs_mapping (mysql_user, ch_id) VALUES ('chef3', 3);
INSERT INTO user_chefs_mapping (mysql_user, ch_id) VALUES ('chef2', 2);

-- Create personal_info view
DROP VIEW IF EXISTS personal_info;
DROP VIEW IF EXISTS episodes_played;

CREATE VIEW personal_info AS
SELECT 
    CH_ID, First_Name, Last_Name, Phone, Birthday, Age, Experience, Class, File_Name
FROM chefs;


CREATE VIEW episodes_played AS
SELECT 
    p.CH_ID, p.EP_ID, p.recipe, p.Grade, e.Winner
FROM
    PLAYS p
JOIN
    Episodes e ON p.EP_ID = e.EP_ID;



CREATE OR REPLACE VIEW chefs_recipes AS
SELECT 
    rc.CH_ID, r.REC_ID, r.Name,
    r.Pastry, r.Difficulty, r.Desctiprion,
    r.Tip1, r.Tip2, r.Tip3,
    r.`Total Time`, r.`Prep Time`, r.Exec_Time,
    r.Portions, r.Characterization, r.PRIM_ING_ID,
    r.CU_ID, r.THEME_ID, r.file_name,
    n.`Kcal per serving`,
    n.`Protein per serving`,
    n.`Carbs per serving`,
    n.`Fat per serving`
FROM
    rec_chef rc
JOIN
    recipes r ON rc.REC_ID = r.REC_ID
JOIN
    nutrition_info n ON r.REC_ID = n.REC_ID;





-- Create stored procedures
DELIMITER //
Drop procedure if exists get_personal_info//

CREATE PROCEDURE get_personal_info()
BEGIN
	DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    SELECT CH_ID, First_Name, Last_Name, Phone, Birthday, Age, Experience, Class, File_Name
    FROM chefs
    WHERE CH_ID = user_id;
END //

Drop procedure if exists update_personal_info//

CREATE PROCEDURE update_personal_info(
    IN first_name VARCHAR(50),
    IN last_name VARCHAR(50),
    IN phone VARCHAR(20),
    IN birthday DATE,
    IN age INT,
    IN experience INT,
    IN class INT,
    IN file_name VARCHAR(100)
)
BEGIN
    DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));

    UPDATE chefs c
    SET 
        c.First_Name = first_name,
        c.Last_Name = last_name,
        c.Phone = phone,
        c.Birthday = birthday,
        c.Age = age,
        c.Experience = experience,
        c.Class = class,
        c.File_Name = file_name
    WHERE c.CH_ID = user_id;
END //

Drop procedure if exists get_episodes_played//

CREATE PROCEDURE get_episodes_played()
BEGIN
	DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    SELECT EP_ID, recipe, Grade, Winner
    FROM episodes_played
    WHERE CH_ID = user_id;
END //

Drop procedure if exists get_chefs_recipes//

CREATE PROCEDURE get_chefs_recipes()
BEGIN
	DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    SELECT *
    FROM chefs_recipes
    WHERE CH_ID = user_id;
END //


Drop procedure if exists update_recipe//

CREATE PROCEDURE update_recipe(
    IN rec_id INT,
    IN difficulty INT, 
    IN description  VARCHAR(100),
	IN Tip1 VARCHAR(150), 
    IN Tip2 VARCHAR(150), 
    IN Tip3 VARCHAR(150), 
    IN total_time INT,
    IN prep_time INT,
    IN cook_time INT,
    IN portions INT,
    IN File_name VARCHAR(255),
    IN protein INT,
    IN carbs INT,
    IN fat INT
)
BEGIN
	DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
	IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- Update the recipes table
		UPDATE recipes
		SET 
			Difficulty = difficulty,
			Desctiprion = description,
			`Prep Time` = prep_time,
			Exec_Time = cook_time,
			`Total Time` = total_time,
			Portions = portions,
			file_Name = File_name
		WHERE REC_ID = rec_id;

		-- Update the nutrition_info table
		UPDATE nutrition_info
		SET 
			`Protein per serving` = protein,
			`Carbs per serving` = carbs,
			`Fat per serving` = fat
		WHERE REC_ID = rec_id;
	END IF;
END //

drop procedure if exists add_recipe//


CREATE PROCEDURE add_recipe(
	IN name VARCHAR(100),
    IN pastry TINYINT,
    IN difficulty INT, 
    IN description VARCHAR(100),
    IN tip1 VARCHAR(150), 
    IN tip2 VARCHAR(150), 
    IN tip3 VARCHAR(150),
    IN total_time INT,
    IN prep_time INT,
    IN cook_time INT,
    IN portions INT,
    IN primary_ing INT,
    IN cuisine INT, 
    IN theme INT, 
    IN file_name VARCHAR(255),
    IN protein INT,
    IN carbs INT,
    IN fat INT
)
BEGIN
    DECLARE user_id INT;
    DECLARE new_rec_id INT;

    -- Get the chef's ID based on the MySQL user
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    
    -- Insert into the recipes table
    INSERT INTO recipes (Name, Pastry, Difficulty, Desctiprion, Tip1, Tip2, Tip3, `Prep Time`, Exec_Time, `Total Time`, Portions,PRIM_ING_ID, CU_ID, THEME_ID, file_Name)
    VALUES (name, pastry, difficulty, description,tip1, tip2, tip3, prep_time, cook_time, total_time, portions,primary_ing, cuisine,theme, file_name );
    
    -- Get the last inserted recipe ID
    SET new_rec_id = LAST_INSERT_ID();

    -- Insert into the nutrition_info table
    INSERT INTO nutrition_info (REC_ID, `Protein per serving`, `Carbs per serving`, `Fat per serving`)
    VALUES (new_rec_id, protein, carbs, fat);
    
    -- Link the new recipe to the chef
    INSERT INTO rec_chef (REC_ID, CH_ID)
    VALUES (new_rec_id, user_id);
END //

Drop procedure if exists get_recipe_steps//

CREATE PROCEDURE get_recipe_steps(IN rec_id INT)
BEGIN
DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- Update the recipes table
SELECT * FROM steps s WHERE s.REC_ID=rec_id;
END IF;
END //

Drop procedure if exists add_step//

CREATE PROCEDURE add_step(
    IN rec_id INT,
    IN step_count INT,
    IN step_desc VARCHAR(200)
)
BEGIN
DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- Update the recipes table
INSERT INTO steps VALUES (rec_id, step_count, step_desc);
END IF;
END //

Drop procedure if exists delete_recipe_step//

CREATE PROCEDURE delete_recipe_step(IN rec_id INT, IN step_count INT)
BEGIN
DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- Update the recipes table
DELETE FROM steps s WHERE s.REC_ID=rec_id AND s.Count=step_count;
END IF;
END //


Drop procedure if exists get_recipe_ingredients//

CREATE PROCEDURE get_recipe_ingredients(IN rec_id INT)
BEGIN
    DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- show the rec_ings table
        SELECT * FROM rec_ingr ri WHERE ri.REC_ID=rec_id;
    END IF;
END //

Drop procedure if exists add_ingredient//

CREATE PROCEDURE add_ingredient(
    IN rec_id INT,
    IN ing_id INT,
    IN precise INT,
    IN inprecise VARCHAR(20)
)
BEGIN
    DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- Insert into the rec_ingr table
        INSERT INTO rec_ingr VALUES (rec_id, ing_id, precise, inprecise);
    END IF;
END //

Drop procedure if exists delete_recipe_ingredient//

CREATE PROCEDURE delete_recipe_ingredient(IN rec_id INT, IN ing_id INT)
BEGIN
    DECLARE user_id INT;
    SET user_id = (SELECT ch_id FROM user_chefs_mapping WHERE mysql_user = SUBSTRING_INDEX(USER(), '@', 1));
    IF NOT EXISTS (
        SELECT 1 
        FROM chefs_recipes c
        WHERE c.CH_ID = user_id AND c.REC_ID = rec_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The recipe does not belong to you';
    ELSE
    -- Update the steps table
        DELETE FROM rec_ingr ri WHERE ri.REC_ID=rec_id AND ri.ING_ID=ing_id;
    END IF;
END //

DELIMITER ;

;

-- Grant execute permissions on procedures to chef users
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_personal_info TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.update_personal_info TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_personal_info TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.update_personal_info TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_episodes_played TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_episodes_played TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_chefs_recipes TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_chefs_recipes TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.update_recipe TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.update_recipe TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_recipe TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_recipe TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_recipe_steps TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_recipe_steps TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.delete_recipe_step TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.delete_recipe_step TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_step TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_step TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_recipe_ingredients TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_recipe_ingredients TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.delete_recipe_ingredient TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.delete_recipe_ingredient TO 'chef3'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_ingredient TO 'chef2'@'localhost';
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_ingredient TO 'chef3'@'localhost';

GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_personal_info TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_personal_info TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_episodes_played TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_chefs_recipes TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.update_recipe TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_recipe TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_recipe_steps TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.delete_recipe_step TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_step TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.get_recipe_ingredients TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.delete_recipe_ingredient TO `Chef`;
GRANT EXECUTE ON PROCEDURE `cooking_contestdb`.add_ingredient TO `Chef`;

