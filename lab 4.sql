-- 1. Вивести статистику: загальна кількість всіх книг, їх вартість, їх середню вартість, мінімальну і максимальну ціну
SELECT 
 COUNT(*) AS total_books, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books;

-- 2. Вивести загальну кількість всіх книг без урахування книг з непроставленою ціною
SELECT 
 COUNT(*) 
AS total_books 
FROM books 
WHERE price IS NOT NULL;

-- 3. Вивести статистику (див. 1) для книг новинка / не новинка
SELECT
 COUNT(*) AS total_books, isnew, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books 
GROUP BY isnew;

-- 4. Вивести статистику (див. 1) для книг за кожним роком видання
SELECT 
 COUNT(*) AS total_books, 
 YEAR(data_) year_of_publication, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books 
GROUP BY year_of_publication;

-- 5. Змінити п.4, виключивши з статистики книги з ціною від 10 до 20
SELECT
 COUNT(*) AS total_books, 
 YEAR(data_) year_of_publication, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books 
NOT BETWEEN 10 AND 20
GROUP BY year_of_publication;

-- 6. Змінити п.4. Відсортувати статистику по спадаючій кількості.
SELECT
 COUNT(*) AS total_books, 
 YEAR(data_) year_of_publication, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books 
GROUP BY year_of_publication
ORDER BY COUNT(*) DESC;

-- 7. Вивести загальну кількість кодів книг і кодів книг що не повторюються
SELECT COUNT(num) AS numbers, 
 COUNT(DISTINCT num) AS without_distortion 
FROM books;

-- 8. Вивести статистику: загальна кількість і вартість книг по першій букві її назви
SELECT 
 SUBSTRING(name, 1, 1) AS letter,
 COUNT(*) AS total_books,
 SUM(price) AS total_price
FROM books
GROUP BY letter;

-- 9. Змінити п. 8, виключивши з статистики назви що починаються з англ. букви або з цифри.
SELECT 
 SUBSTRING(name, 1, 1) AS letter,
 COUNT(*) AS total_books,
 SUM(price) AS total_price
FROM books
WHERE NOT name REGEXP '^[A-Za-z0-9]'
GROUP BY letter;

-- 10. Змінити п. 9 так щоб до складу статистики потрапили дані з роками більшими за 2000.
SELECT 
  SUBSTRING(name, 1, 1) AS letter,
  COUNT(*) AS total_books,
  SUM(price) AS total_price
FROM books
WHERE (name REGEXP '^[^A-Za-z0-9]' OR YEAR(data_) > 2000)
GROUP BY letter;


-- 11. Змінити п. 10. Відсортувати статистику по спадаючій перших букв назви.
SELECT 
  SUBSTRING(name, 1, 1) AS letter,
  COUNT(*) AS total_books,
  SUM(price) AS total_price
FROM books
WHERE (name REGEXP '^[^A-Za-z0-9]' OR YEAR(data_) > 2000)
GROUP BY letter
ORDER BY letter DESC;

-- 12. Вивести статистику (див. 1) по кожному місяцю кожного року.
SELECT COUNT(*) AS total_books, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx,
DATE_FORMAT(data_, '%Y-%m') AS monthstatistic
FROM books
GROUP BY monthstatistic;

-- 13. Змінити п. 12 так щоб до складу статистики не увійшли дані з незаповненими датами.
 SELECT COUNT(*) AS total_books, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx,
DATE_FORMAT(data_, '%Y-%m') AS monthstatistic
FROM books 
WHERE data_ IS NOT NULL
GROUP BY monthstatistic;

-- 14. Змінити п. 12. Фільтр по спадаючій року і зростанню місяця.
SELECT COUNT(*) AS total_books, 
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx,
DATE_FORMAT(data_, '%Y-%m') AS YearMonth 
FROM books 
GROUP BY YearMonth
ORDER BY YEAR(data_) DESC, MONTH(data_) ASC;

-- 15. Вивести статистику для книг новинка / не новинка: загальна ціна, загальна ціна в грн. / Євро / руб. 
-- Колонкам запиту дати назви за змістом.
SELECT 
  CASE 
    WHEN isnew = 'YES' THEN 'new'
    ELSE 'no new'
  END AS status_,
  SUM(price) AS total_price_dollar, 
  SUM(price * 36.93) AS total_price_uah,
  SUM(price * 0.93) AS total_price_euro
FROM books
GROUP BY status_;

-- 16. Змінити п. 15 так щоб виводилася округлена до цілого числа (дол. / Грн. / Євро / руб.) Ціна.
SELECT 
  CASE 
    WHEN isnew = 'YES' THEN 'new'
    ELSE 'no new'
  END AS status_,
  ROUND(price) AS total_price_dollar, 
  ROUND(price * 36.93) AS total_price_uah,
  ROUND(price * 0.93) AS total_price_euro
FROM books
GROUP BY status_;

-- 17. Вивести статистику (див. 1) по видавництвах.
SELECT 
 COUNT(*) AS total_books, 
 publisher,
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books
GROUP BY publisher;

-- 18. Вивести статистику (див. 1) за темами і видавництвами. Фільтр по видавництвам.
SELECT 
 COUNT(*) AS total_books, 
 publisher,
 topic,
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books
GROUP BY topic, publisher
ORDER BY publisher;

-- 19. Вивести статистику (див. 1) за категоріями, темами і видавництвами. Фільтр по видавництвам, темах, категоріям.
SELECT 
 COUNT(*) AS total_books, 
 category,
 publisher,
 topic,
 SUM(price) AS total_price, 
 AVG(price) AS average, 
 MIN(price) AS minn, 
 MAX(price) AS maxx 
FROM books
GROUP BY category, topic, publisher
ORDER BY  publisher, topic, category;

-- 20. Вивести список видавництв, у яких округлена до цілого ціна однієї сторінки більше 10 копійок.
SELECT 
    publisher, 
    ROUND(SUM(price/pages)) AS price_for_1_page
FROM books
GROUP BY publisher
HAVING price_for_1_page > 0.10;