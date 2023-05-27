--1. Вивести книги у яких не введена ціна або ціна дорівнює 0
SELECT * FROM books WHERE `price` IS NULL OR `price` = 0;

-- 2. Вивести книги у яких введена ціна, але не введений тираж
SELECT * FROM books WHERE price IS NOT NULL AND circulation IS NULL;

-- 3. Вивести книги, про дату видання яких нічого не відомо.
SELECT * FROM books WHERE data_ IS NULL;

-- 4. Вивести книги, з дня видання яких пройшло не більше року.
SELECT * FROM books WHERE (`data_` + INTERVAL 1 YEAR) > NOW();

-- 5. Вивести список книг-новинок, відсортованих за зростанням ціни
SELECT * FROM books WHERE isnew = 'YES' ORDER BY price ASC;

-- 6. Вивести список книг з числом сторінок від 300 до 400, відсортованих в зворотному алфавітному порядку назв 
SELECT * FROM books WHERE pages BETWEEN 300 AND 400 ORDER BY name DESC;

-- 7. Вивести список книг з ціною від 20 до 40, відсортованих за спаданням дати
SELECT * FROM books WHERE price BETWEEN 20 AND 40 ORDER BY data_ DESC;

-- 8. Вивести список книг, відсортованих в алфавітному порядку назв і ціною по спадаючій
SELECT * FROM books ORDER BY name ASC, price DESC;

-- 9. Вивести книги, у яких ціна однієї сторінки < 10 копійок.
SELECT * FROM books WHERE ( price / pages) < 10;

-- 10. Вивести значення наступних колонок: число символів в назві, перші 20 символів назви великими літерами
SELECT LENGTH(name) as lens, UPPER(LEFT(name, 20)) AS first_20 FROM books;

-- 11. Вивести значення наступних колонок: перші 10 і останні 10 символів назви прописними буквами, розділені '...' 
SELECT CONCAT(LOWER(LEFT(name, 10)), '...', LOWER(RIGHT(name, 10))) AS newname FROM books;

-- 12. Вивести значення наступних колонок: назва, дата, день, місяць, рік
SELECT name, data_, DAY(data_) AS day, MONTH(data_) AS month, YEAR(data_) AS year FROM books;

-- 13. Вивести значення наступних колонок: назва, дата, дата в форматі 'dd / mm / yyyy'
SELECT name, data_, DATE_FORMAT(data_,'%d/%m/%Y') AS newdata FROM books;

-- 14. Вивести значення наступних колонок: код, ціна, ціна в грн., ціна в євро, ціна в руб.
SELECT num, price AS price_in_dollar, (price*36.93) AS uah, (price *0.93) AS eur FROM books;

-- 15. Вивести значення наступних колонок: код, ціна, ціна в грн. без копійок, ціна без копійок округлена
SELECT num, price AS price_in_dollar, TRUNCATE(price*36.93, 0) AS uah_bez_kop, ROUND(price*36.93) AS uah_z_kop FROM books;

-- 16. Додати інформацію про нову книгу (всі колонки)
INSERT INTO books (N, num, isnew, name, price, publisher, pages, format, data_, circulation, topic, category) 
VALUES 
(1, 5689, 'NO', 'Пришвидшений курс Python', 10.28, 'Видавництво Старого Лева', 600, '165x215/30', '2021-12-03', 3000, 'Програмування','Python');

-- 17. Додати інформацію про нову книгу (колонки обов'язкові для введення)
INSERT INTO books (N, num, isnew, name, publisher, pages, format, circulation, topic, category) 
VALUES 
(137, 1627, 'YES', 'Ruby для дітей', 'Видавництво Старого Лева', 392, '165x215/15', 5000, 'Програмування','Інші книги');

-- 18. Видалити книги, видані до 1990 року
DELETE FROM books WHERE YEAR(data_) < 1990;

-- 19. Проставити поточну дату для тих книг, у яких дата видання відсутня
UPDATE books SET data_ = '1988-09-16' WHERE data_ IS NULL;

-- 20. Установити ознаку новинка для книг виданих після 2005 року
UPDATE books SET isnew = 'YES' WHERE YEAR(data_)> 2005;