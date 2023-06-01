--напишіть мені функцію, яка рахуватиме: 
--кількість сторінок виданих всіма видавництвами у 2000 році
--(або оберіть будь який рік з ненульовим тиражем) 

DELIMITER //
CREATE FUNCTION calculate_total_pages(year INT)
RETURNS INT
BEGIN
 
    DECLARE has_publishers INT;
    SELECT COUNT(*) INTO has_publishers
    FROM books_info
    WHERE YEAR(data_) = year AND circulation > 0;

    IF has_publishers > 0 THEN
        DECLARE total_pages INT;
        SELECT SUM(pages) INTO total_pages
        FROM books_info
        WHERE YEAR(data_) = year;
        RETURN total_pages;
    ELSE
        RETURN NULL;
    END IF;
END //
DELIMITER ;


CALL calculate_total_pages(2000);

--функцію яка знайде видавництво з найвищою посторінковою вартістю у цьому році
--і сформує тимчасову таблицю з усіма даними про тираж цього видавництва

DELIMITER //
CREATE FUNCTION find_highest_price_publisher(year INT)
RETURNS TABLE (
    publisher_id INT,
    publisher_name VARCHAR(100),
    max_price DECIMAL(10, 2)
)
BEGIN
    DECLARE publisher_id INT;
    DECLARE publisher_name VARCHAR(100);
    DECLARE max_price DECIMAL(10, 2);
    
    SELECT p.publisher_id, p.publisher_name, b.max_price
    INTO publisher_id, publisher_name, max_price
    FROM (
        SELECT publisher_id, MAX(price/pages) AS max_price
        FROM books_info
        WHERE YEAR(data_) = year AND circulation > 0
        GROUP BY publisher_id
    ) AS b
    JOIN publishers AS p ON p.publisher_id = b.publisher_id
    ORDER BY b.max_price DESC
    LIMIT 1;

    RETURN (
        SELECT publisher_id, publisher_name, max_price
    );
END //
DELIMITER ;

CALL find_highest_price_publisher(2000);
