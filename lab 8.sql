-- Реалізувати набір тригерів, що реалізують такі ділові правила:
-- 1. Кількість тем може бути в діапазоні від 5 до 10.
DELIMITER //
CREATE TRIGGER topic_count_rule
BEFORE INSERT ON topics
FOR EACH ROW
BEGIN
    DECLARE topic_count INT;
    SELECT COUNT(*) INTO topic_count FROM topics;
    IF topic_count >= 5 AND topic_count <= 10 THEN
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Кількість тем повинна бути в діапазоні від 5 до 10.';
    END IF;
END //
DELIMITER ;

-- 2. Новинкою може бути тільки книга видана в поточному році.
DELIMITER //
CREATE TRIGGER new_release_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    IF YEAR(NEW.release_date) = YEAR(CURDATE()) THEN
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Новинкою може бути тільки книга видана в поточному році.';
    END IF;
END //
DELIMITER ;

-- 3. Книга з кількістю сторінок до 100 не може коштувати більше 10 $, до 200 - 20 $, до 300 - 30 $.
DELIMITER //
CREATE TRIGGER price_based_on_page_count_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    DECLARE price DECIMAL(10, 2);
    IF NEW.page_count <= 100 THEN
        SET price = 10;
    ELSEIF NEW.page_count <= 200 THEN
        SET price = 20;
    ELSEIF NEW.page_count <= 300 THEN
        SET price = 30;
    ELSE
        SET price = NEW.price;
    END IF;
    SET NEW.price = price;
END //
DELIMITER ;

-- 4. Видавництво "BHV" не випускає книги накладом меншим 5000, а видавництво Diasoft - 10000.
DELIMITER //
CREATE TRIGGER minimum_print_run_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    IF NEW.publisher_id = (SELECT 
                            publisher_id 
                           FROM publishers 
                           WHERE publisher_name = 'Видавнича група BHV'
                          ) THEN
        IF NEW.print_run < 5000 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво "BHV" не випускає книги накладом меншим 5000.';
        END IF;
    ELSEIF NEW.publisher_id = (SELECT 
                                publisher_id 
                               FROM publishers 
                               WHERE publisher_name = 'Diasoft'
                              ) THEN
        IF NEW.print_run < 10000 THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво "Diasoft" не випускає книги накладом меншим 10000.';
        END IF;
    END IF;
END //
DELIMITER ;

-- 5. Книги з однаковим кодом повинні мати однакові дані.
DELIMITER //
CREATE TRIGGER consistent_data_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * 
               FROM books_info 
               WHERE book_id <> NEW.book_id AND code = NEW.code
               )THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Книги з однаковим кодом повинні мати однакові дані.';
    END IF;
END //
DELIMITER ;

-- 6. При спробі видалення книги видається інформація про кількість видалених рядків. Якщо користувач не "dbo", то видалення забороняється.
DELIMITER //
CREATE TRIGGER delete_book_rule
BEFORE DELETE ON books_info
FOR EACH ROW
BEGIN
    IF CURRENT_USER() <> 'dbo' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видалення заборонено для користувачів, відмінних від "dbo".';
    ELSE
        SET @deleted_rows = ROW_COUNT();
        SELECT CONCAT('Кількість видалених рядків: ', @deleted_rows) AS message;
    END IF;
END //
DELIMITER ;

-- 7. Користувач "dbo" не має права змінювати ціну книги.
DELIMITER //
CREATE TRIGGER dbo_update_price_rule
BEFORE UPDATE ON books_info
FOR EACH ROW
BEGIN
    IF CURRENT_USER() = 'dbo' THEN
        IF OLD.price <> NEW.price THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Користувачу "dbo" заборонено змінювати ціну книги.';
        END IF;
    END IF;
END //
DELIMITER ;

-- 8. Видавництва ДМК і Еком підручники не видають.
DELIMITER //
CREATE TRIGGER no_textbooks_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    IF NEW.publisher_id IN (SELECT publisher_id 
                            FROM publishers 
                            WHERE publisher_name IN ('ДМК', 'Еком')) THEN
        IF NEW.category_id = (SELECT category_id 
                              FROM categories 
                              WHERE category_name = 'Підручники') THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництва "ДМК" і "Еком" не видають підручники.';
        END IF;
    END IF;
END //
DELIMITER ;

-- 9. Видавництво не може випустити більше 10 новинок протягом одного місяця поточного року.
DELIMITER //
CREATE TRIGGER maximum_new_releases_per_month_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    DECLARE new_releases_count INT;

    SELECT COUNT(*) 
    INTO new_releases_count 
    FROM books_info 
    WHERE publisher_id = NEW.publisher_id AND 
    YEAR(release_date) = YEAR(CURDATE()) AND 
    MONTH(release_date) = MONTH(CURDATE());

    IF new_releases_count >= 10 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво не може випустити більше 10 новинок протягом одного місяця.';
    END IF;
END //
DELIMITER ;

-- 10. Видавництво BHV не випускає книги формату 60х88 / 16.
DELIMITER //
CREATE TRIGGER bhv_no_format_rule
BEFORE INSERT ON books_info
FOR EACH ROW
BEGIN
    IF NEW.publisher_id = (SELECT publisher_id FROM publishers WHERE publisher_name = 'BHV') THEN
        IF NEW.format = '60х88 / 16' THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Видавництво "BHV" не випускає книги формату "60х88 / 16".';
        END IF;
    END IF;
END //
DELIMITER ;