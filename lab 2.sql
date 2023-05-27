--1. Вивести значення наступних колонок: номер, код, новинка, назва, ціна, сторінки
SELECT N, num, isnew, name, price, pages FROM books;

--2.Вивести значення всіх колонок
SELECT * FROM books;

--3. Вивести значення колонок в наступному порядку: код, назва, новинка, сторінки, ціна, номер
SELECT num, name, isnew, pages, price, N FROM books;

--4. Вивести значення всіх колонок 10 перших рядків
SELECT * FROM books LIMIT 10;

--5. Вивести значення всіх колонок 10% перших рядків
SELECT * FROM books LIMIT (SELECT COUNT(*) * 0.1 FROM books); --?

--6. Вивести значення колонки код без повторення однакових кодів
SELECT DISTINCT `num` FROM books;

--7. Вивести всі книги новинки
SELECT * FROM books WHERE isnew = 'Yes';

--8. Вивести всі книги новинки з ціною від 20 до 30
SELECT * FROM books WHERE isnew = 'Yes' AND price BETWEEN 10 AND 20;

--9. Вивести всі книги новинки з ціною менше 20 і більше 30
SELECT * FROM books WHERE isnew = 'Yes' AND (20 > `price` AND `price` > 30);

--10. Вивести всі книги з кількістю сторінок від 300 до 400 і з ціною більше 20 і менше 30
SELECT * FROM books WHERE pages BETWEEN 300 AND 400 AND (20 < `price` AND `price` < 30);

--11. Вивести всі книги видані взимку 2000 року
SELECT * FROM books WHERE YEAR(`data_`) = 2000 AND MONTH(`data_`) IN (12, 1, 2);

--12. Вивести книги зі значеннями кодів 5110, 5141, 4985, 4241
SELECT * FROM books WHERE num IN (5110, 5141, 4985, 4241);

--13. Вивести книги видані в 1999, 2001, 2003, 2005 р
SELECT * FROM books WHERE YEAR(data_) IN (1999, 2001, 2003, 2005);

--14. Вивести книги назви яких починаються на літери А-К
SELECT * FROM books WHERE name>='А' AND name<='К';

--15. Вивести книги назви яких починаються на літери "АПП", видані в 2000 році з ціною до 20
SELECT * FROM books WHERE name LIKE ('АПП%') AND YEAR(`data_`) = 2000 AND 20 > `price`;

--16. Вивести книги назви яких починаються на літери "АПП", закінчуються на "е", видані в першій половині 2000 року
SELECT * FROM books WHERE name LIKE ('АПП%') AND name LIKE ('%е') AND YEAR(`data_`) = 2000 AND MONTH(`data_`)<=6;

--17. Вивести книги, в назвах яких є слово Microsoft, але немає слова Windows
SELECT * FROM books WHERE name IN ('Microsoft') AND name NOT IN ('Windows');

--18. Вивести книги, в назвах яких присутня як мінімум одна цифра.
SELECT * FROM books WHERE name REGEXP '[[:digit:]]' = 1;

--19. Вивести книги, в назвах яких присутні не менше трьох цифр.
SELECT * FROM `books` WHERE `name` REGEXP '(.*[0-9]){3,}'

--20. Вивести книги, в назвах яких присутній рівно п'ять цифр.
SELECT * FROM `books` WHERE `name` REGEXP '(.*[0-9]){5}'