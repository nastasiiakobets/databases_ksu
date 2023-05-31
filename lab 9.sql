-- *1*. Розробити та перевірити скалярну (scalar) функцію, що повертає загальну вартість книг виданих в певному році.
DELIMITER //
CREATE FUNCTION calculate_total_cost(year INT) RETURNS DECIMAL(10, 2)
BEGIN
    DECLARE total_cost DECIMAL(10, 2);

    SELECT SUM(price) INTO total_cost FROM books_info WHERE YEAR(release_date) = year;

    RETURN total_cost;
END //
DELIMITER ;

SELECT calculate_total_cost(2022) AS total_cost;

-- *2*. Розробити і перевірити табличну (inline) функцію, яка повертає список книг виданих в певному році.
DELIMITER //
CREATE FUNCTION get_books_by_year(year INT) RETURNS TABLE
RETURN (
    SELECT * FROM books_info WHERE YEAR(release_date) = year
) //
DELIMITER ;

SELECT * FROM get_books_by_year(2022);

-- *3*. Розробити і перевірити функцію типу multi-statement, яка буде:
-- a. приймати в якості вхідного параметра рядок, що містить список назв видавництв, розділених символом ‘;’;
-- b. виділяти з цього рядка назву видавництва;
-- c. формувати нумерований список назв видавництв.
DELIMITER //
CREATE FUNCTION generate_publisher_list(publisher_list VARCHAR(255)) RETURNS VARCHAR(255)
BEGIN
    DECLARE result VARCHAR(255) DEFAULT '';
    DECLARE publisher_name VARCHAR(50);
    DECLARE counter INT DEFAULT 1;

    WHILE counter <= LENGTH(publisher_list) DO
        SET publisher_name = SUBSTRING_INDEX(SUBSTRING_INDEX(publisher_list, ';', counter), ';', -1);
        SET result = CONCAT(result, counter, '. ', publisher_name, '\n');
        SET counter = counter + 1;
    END WHILE;

    RETURN result;
END //
DELIMITER ;

SELECT generate_publisher_list('Видавництво 1;Видавництво 2;Видавництво 3') AS publisher_list;

-- *4*. Виконати набір операцій по роботі з SQL курсором: оголосити курсор;
-- a. використовувати змінну для оголошення курсору;
-- b. відкрити курсор;
-- c. переприсвоїти курсор іншої змінної;
-- d. виконати вибірку даних з курсору;
-- e. закрити курсор;
DELIMITER //

CREATE PROCEDURE cursor_operations()
BEGIN
    -- a. Оголошення курсора з використанням змінної
    DECLARE cur CURSOR FOR SELECT name FROM books_info;

    -- b. Відкриття курсора
    OPEN cur;

    -- c. Переприсвоєння курсора іншій змінній
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET @is_done = TRUE;
    SET @is_done = FALSE;

    -- d. Виконання вибірки даних з курсора
    FETCH cur INTO @book_name;
    WHILE NOT @is_done DO
        -- Виконання операцій з отриманим рядком даних
        SELECT @book_name;

        FETCH cur INTO @book_name;
    END WHILE;

    -- e. Закриття курсора
    CLOSE cur;
END //

DELIMITER ;

CALL cursor_operations();


-- *5*. звільнити курсор. Розробити курсор для виводу списка книг виданих у визначеному році.
DELIMITER //

CREATE PROCEDURE list_books_by_year(IN target_year INT)
BEGIN
    -- Оголошення змінних для курсора
    DECLARE book_name VARCHAR(255);
    DECLARE book_cursor CURSOR FOR SELECT name FROM books_info WHERE YEAR(publication_date) = target_year;

    -- Відкриття курсора
    OPEN book_cursor;

    -- Виведення списку книг
    FETCH book_cursor INTO book_name;
    WHILE (book_name IS NOT NULL) DO
        SELECT book_name;
        FETCH book_cursor INTO book_name;
    END WHILE;

    -- Закриття курсора
    CLOSE book_cursor;

    -- Звільнення курсора
    DEALLOCATE book_cursor;
END //

DELIMITER ;