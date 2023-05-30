-- 1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
CREATE PROCEDURE n_p_np_f()
BEGIN
	SELECT
		books_info.name AS name_book, 
		books_info.price AS price_book,
		publishers.publisher_name AS name_publisher,
		books_info.format AS format_book
	FROM books_info
	INNER JOIN publishers ON books_info.publisher_id = publishers.publisher_id
END;

CALL n_p_np_f();

-- 2. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
CREATE PROCEDURE t_c_n_np()
BEGIN
	SELECT
		topics.topic_name AS name_topic,
    	categories.category_name AS name_category,
	    books_info.name AS name_book,
   	 	publishers.publisher_name AS name_publisher
	FROM books_info
	JOIN topics ON books_info.topic_id = topics.topic_id
	JOIN categories ON books_info.category_id = categories.category_id
	JOIN publishers ON books_info.publisher_id = publishers.publisher_id
    ORDER BY topics.topic_name, categories.category_name
END;

CALL t_c_n_np();

-- 3. Вивести книги видавництва 'BHV', видані після 2000 р
CREATE PROCEDURE bnv_2000()
BEGIN
	SELECT
		books_info.name AS name_book,
   	 	books_info.data_ AS data_book,
    	publishers.name AS name_publisher
	FROM books_info
	JOIN publishers ON books_info.publisher_id = publishers.publisher_id
	WHERE publishers.publisher_name = 'Видавнича група BHV' AND YEAR(books_info.data_) > 2000;
END;

CALL bnv_2000();

-- 4. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій / зростанню кількості сторінок.
DELIMITER //
CREATE PROCEDURE total_pages_by_category(IN sort_order VARCHAR(4))
BEGIN
    SELECT categories.category_name, SUM(books_info.pages) AS total_pages
    FROM books_info
    JOIN categories ON books_info.category_id = categories.category_id
    GROUP BY categories.category_name
    ORDER BY total_pages DESC;
END //
DELIMITER ;

CALL total_pages_by_category('DESC');

-- 5. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
DELIMITER //
CREATE PROCEDURE average_price_by_topic_category()
BEGIN
    SELECT 
	 AVG(books_info.price) AS average_price
    FROM books_info
    JOIN topics ON books_info.topic_id = topics.topic_id
    JOIN categories ON books_info.category_id = categories.category_id
    WHERE topics.topic_name = 'Використання ПК' AND categories.category_name = 'Linux';
END //
DELIMITER ;

CALL average_price_by_topic_category();

-- 6. Вивести всі дані універсального відношення.
DELIMITER //
CREATE PROCEDURE universal_relation()
BEGIN
    SELECT *
    FROM books_info;
END //
DELIMITER ;

CALL universal_relation();

-- 7. Вивести пари книг, що мають однакову кількість сторінок.
DELIMITER //
CREATE PROCEDURE book_pairs_same_page_count()
BEGIN
    SELECT 
	 a.name AS book1, 
	 b.name AS book2, a.pages
    FROM books_info a, books_info b
    WHERE a.num < B.num AND a.pages = b.pages;
END //
DELIMITER ;

CALL book_pairs_same_page_count();

-- 8. Вивести тріади книг, що мають однакову ціну.
DELIMITER //
CREATE PROCEDURE book_triples_same_price()
BEGIN
    SELECT 
	 a.name AS book1, 
	 b.name AS book2, 
	 c.name AS book3,
	 a.price
    FROM books_info a, books_info b, books_info c
    WHERE a.num < b.num AND b.num < c.num AND a.price = b.price AND b.price = c.price;
END //
DELIMITER ;

CALL book_triples_same_price();

-- 9. Вивести всі книги категорії 'C ++'.
DELIMITER //
CREATE PROCEDURE categ_c()
BEGIN
    SELECT 
     books_info.name AS name_book
    FROM books_info
    JOIN categories ON books_info.category_id = categories.category_id
    WHERE categories.category_name = 'C&C++';
END //
DELIMITER ;

CALL categ_c();

-- 10. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок.
DELIMITER //
CREATE PROCEDURE publishers_with_large_books()
BEGIN
    SELECT 
	 publishers.publisher_name
    FROM books_info
    JOIN publishers ON books_info.publisher_id = publishers.publisher_id
    WHERE books_info.pages > 400
    GROUP BY publishers.publisher_name;
END //
DELIMITER ;

CALL publishers_with_large_books();

-- 11. Вивести список категорій за якими більше 3-х книг.
DELIMITER //
CREATE PROCEDURE categories_with_more_than_three_books()
BEGIN
    SELECT 
	 categories.category_name
    FROM categories
    JOIN books_info ON books_info.category_id = categories.category_id
    GROUP BY categories.category_name
    HAVING COUNT(books_info.num) > 3;
END //
DELIMITER ;

CALL categories_with_more_than_three_books();

-- 12. Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва.
DELIMITER //
CREATE PROCEDURE books_by_publisher_bhv_with_any()
BEGIN
    SELECT 
	 books_info.name
    FROM books_info
    JOIN publishers ON books_info.publisher_id = publishers.publisher_id
    WHERE publishers.publisher_name = 'Видавнича група BHV'
    LIMIT 1;
END //
DELIMITER ;

CALL books_by_publisher_bhv_with_any();

-- 13. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва.
DELIMITER //
CREATE PROCEDURE books_by_publisher_bhv_without_any()
BEGIN
    SELECT 
	 books_info.name
    FROM books_info
    LEFT JOIN publishers ON books_info.publisher_id = publishers.publisher_id
    WHERE publishers.publisher_name != 'Видавнича група BHV' OR publishers.publisher_name IS NULL;
END //
DELIMITER ;

CALL books_by_publisher_bhv_without_any();

-- 14. Вивести відсортоване загальний список назв тем і категорій.
DELIMITER //
CREATE PROCEDURE sorted_topic_category_list()
BEGIN
    SELECT 
	 topic_name AS name_
    FROM topics
    UNION
    SELECT category_name AS name_
    FROM categories
    ORDER BY name_;
END //
DELIMITER ;

CALL sorted_topic_category_list();

-- 15. Вивести відсортований в зворотному порядку загальний список перших слів назв книг і категорій що не повторюються
DELIMITER //
CREATE PROCEDURE sorted_unique_first_words_desc()
BEGIN
    SELECT 
	 SUBSTRING_INDEX(name, ' ', 1) AS first_word
    FROM (
        SELECT books_info.name
        FROM books_info
        UNION
        SELECT categories.category_name
        FROM categories
    ) AS group_name
    GROUP BY first_word
    ORDER BY first_word DESC;
END //
DELIMITER ;

CALL sorted_unique_first_words_desc();