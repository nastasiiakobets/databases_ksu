-- 1. Вивести значення наступних колонок: назва книги, ціна, назва видавництва. Використовувати внутрішнє з'єднання, застосовуючи where.
SELECT 
	books_info.name AS name_book, 
	books_info.price AS price_book,
	publishers.publisher_name AS name_publisher
FROM books_info, publishers
WHERE books_info.publisher_id = publishers.publisher_id;

-- 2. Вивести значення наступних колонок: назва книги, назва категорії. Використовувати внутрішнє з'єднання, застосовуючи inner join.
SELECT
	books_info.name AS name_book, 
	categories.category_name AS name_category
FROM books_info
INNER JOIN categories ON books_info.category_id = categories.category_id;

-- 3. Вивести значення наступних колонок: назва книги, ціна, назва видавництва, формат.
SELECT	
    books_info.name AS name_book,
    books_info.price AS price_book,
    publishers.publisher_name AS name_publisher,
    books_info.format AS format_book
FROM books_info
JOIN publishers ON books_info.publisher_id = publishers.publisher_id;

-- 4. Вивести значення наступних колонок: тема, категорія, назва книги, назва видавництва. Фільтр по темам і категоріям.
SELECT	
    topics.topic_name AS name_topic,
    categories.category_name AS name_category,
    books_info.name AS name_book,
    publishers.publisher_name AS name_publisher
FROM books_info
JOIN publishers ON books_info.publisher_id = publishers.publisher_id 
JOIN categories ON books_info.category_id = categories.category_id
JOIN topics ON books_info.topic_id = topics.topic_id
WHERE categories.category_name = 'Інші книги'
ORDER BY topics.topic_id DESC;

-- 5. Вивести книги видавництва 'BHV', видані після 2000 р
SELECT * 
FROM books_info
JOIN publishers ON books_info.publisher_id = publishers.publisher_id
WHERE publishers.publisher_name = 'Видавнича група BHV' AND 
Year(books_info.data_)>'2000' ;

-- 6. Вивести загальну кількість сторінок по кожній назві категорії. Фільтр по спадаючій кількості сторінок.
SELECT
	categories.category_name AS name_category,
    SUM(books_info.pages) AS sum_pages
FROM books_info
JOIN categories ON books_info.category_id = categories.category_id
GROUP BY books_info.category_id
ORDER BY sum_pages DESC;

-- 7. Вивести середню вартість книг по темі 'Використання ПК' і категорії 'Linux'.
SELECT
    topics.topic_name AS name_topic,
    categories.category_name AS name_category,
	AVG(books_info.price) AS avg_price
FROM books_info
JOIN topics ON books_info.topic_id = topics.topic_id
JOIN categories ON books_info.category_id = categories.category_id
WHERE topics.topic_name ='Використання ПК в цілому' 
AND categories.category_name = 'Linux'; -- +REXEPT для пошуку фрази в даних

-- 8. Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи where.
SELECT *
FROM books_info, categories, publishers, topics
WHERE books_info.category_id = categories.category_id 
AND books_info.publisher_id = publishers.publisher_id 
AND books_info.topic_id = topics.topic_id;

-- 9. Вивести всі дані універсального відношення. Використовувати внутрішнє з'єднання, застосовуючи inner join.
SELECT *
FROM books_info
INNER JOIN categories ON books_info.category_id = categories.category_id
INNER JOIN publishers ON books_info.publisher_id = publishers.publisher_id
INNER JOIN topics ON books_info.topic_id = topics.topic_id;

-- 10. Вивести всі дані універсального відношення. Використовувати зовнішнє з'єднання, застосовуючи left join / rigth join.
SELECT *
FROM books_info
LEFT JOIN categories ON books_info.category_id = categories.category_id
RIGHT JOIN topics ON books_info.topic_id = topics.topic_id
LEFT JOIN publishers ON books_info.publisher_id = publishers.publisher_id;

-- 11. Вивести пари книг, що мають однакову кількість сторінок. Використовувати самооб’єднання і аліаси (self join).
SELECT
 a.name AS book1,
 b.name AS book2,
 a.pages
FROM books_info AS a
JOIN books_info AS b ON a.pages = b.pages 
AND a.N < b.N
ORDER BY a.pages;

-- 12. Вивести тріади книг, що мають однакову ціну. Використовувати самооб'єднання і аліаси (self join).
SELECT
 a.name AS book1,
 b.name AS book2,
 c.name AS book3,
 a.price
FROM books_info AS a
JOIN books_info AS b ON a.price = b.price AND a.N<b.N
JOIN books_info AS c ON a.price = c.price AND b.N<c.N AND b.price =c.price 
ORDER BY a.price;

-- 13. Вивести всі книги категорії 'C ++'. Використовувати підзапити (subquery).
SELECT 
    a.name AS name_book
FROM books_info AS a
WHERE a.category_id = (
    	SELECT c.category_id
    	FROM categories AS c
    	WHERE c.category_name = 'C&C++'
);

-- 14. Вивести книги видавництва 'BHV', видані після 2000 р Використовувати підзапити (subquery).
SELECT 
    a.name AS name_book,
    a.data_ AS data_book
FROM books_info AS a
WHERE a.publisher_id = (
    	SELECT p.publisher_id
    	FROM publishers AS p
    	WHERE p.publisher_name = 'Видавнича група BHV'AND 
        Year(books_info.data_)>'2000'
);

-- 15. Вивести список видавництв, у яких розмір книг перевищує 400 сторінок. Використовувати пов'язані підзапити (correlated subquery).
SELECT 
	p.publisher_name AS name_publisher
FROM publishers AS p
WHERE EXISTS (
    	SELECT a.publisher_id
    	FROM books_info AS a
    	WHERE p.publisher_id = a.publisher_id AND 
        a.pages > 400
);

-- 16. Вивести список категорій в яких більше 3-х книг. Використовувати пов'язані підзапити (correlated subquery).
SELECT 
	c.category_name AS name_category
FROM categories AS c
WHERE (
    	SELECT COUNT(a.category_id)
    	FROM books_info AS a
    	WHERE c.category_id = a.category_id
)>= 3;

-- 17. Вивести список книг видавництва 'BHV', якщо в списку є хоча б одна книга цього видавництва. Використовувати exists.
SELECT
	a.name AS name_book
FROM books_info AS a
WHERE EXISTS(
    	SELECT *
    	FROM publishers AS p
    	WHERE p.publisher_name = 'Видавнича група BHV' AND
    	 p.publisher_id = a.publisher_id
);

-- 18. Вивести список книг видавництва 'BHV', якщо в списку немає жодної книги цього видавництва. Використовувати not exists.
SELECT
	a.name AS name_book
FROM books_info AS a
WHERE NOT EXISTS(
    	SELECT *
    	FROM publishers AS p
    	WHERE p.publisher_name = 'Видавнича група BHV' AND
    	 p.publisher_id = a.publisher_id
);

-- 19. Вивести відсортований загальний список назв тем і категорій. Використовувати union.
SELECT `category_name` FROM `categories` 
UNION 
SELECT `topic_name` FROM `topics` 
ORDER BY `category_name` ASC;

-- 20. Вивести відсортований в зворотному порядку загальний список перших слів, назв книг і категорій що не повторюються. Використовувати union.
SELECT DISTINCT SUBSTRING_INDEX(a.name, ' ', 1) AS first_word 
FROM `books_info` AS a
UNION
SELECT DISTINCT SUBSTRING_INDEX(c.category_name, ' ', 1) AS first_word 
FROM `categories` AS c
ORDER BY `first_word` DESC;