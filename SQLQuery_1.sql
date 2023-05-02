CREATE TABLE books 
(
  num INTEGER NOT NULL, 
  isnew BOOLEAN NOT NULL,
  name_ VARCHAR (80) NOT NULL,
  price FLOAT (4,2) NOT NULL,
  publisher VARCHAR (50) NOT NULL,
  pages INTEGER NOT NULL,
  format VARCHAR (50) NOT NULL,
  data_ DATE NOT NULL,
  circulation INTEGER NOT NULL,
  topic VARCHAR (50) NOT NULL,
  category VARCHAR (50) DEFAULT 'Підручник'
);

CREATE INDEX idx_Book ON books (num ASC ,name_ ASC, subject ASC, category ASC);

INSERT INTO books(num, isnew, price, name_, publisher, pages, format, data_,circulation, topic, category)
VALUES
(2, 5110, 'No', 'Апаратні засоби мультимедіа. Відеосистема РС', 15.51, 'Видавнича група BHV', 400, '70х100/16', '2000-07-24',5000, 'Використання ПК в цілому','Підручники'),
(8, 4985, 'No', 'Засвой самостійно модернізацію та ремонт ПК за 24 години, 2-ге вид.', 18.90, 'Вільямс', 288, '70х100/16', '2000-07-07', 5000, 'Використання ПК в цілому', 'Підручники'),
(9, 5141, 'No', 'Структури даних та алгоритми', 37.80, 'Вільямс', 384, '70х100/16', '2000-9-29', 5000, 'Використання ПК в цілому','Підручники'),
(20, 5127, 'No', 'Автоматизація інженерно-графічних робіт', 11.58, 'Видавнича група BHV', 256, '70х100/16', '2000-6-15', 5000, 'Використання ПК в цілому', 'Підручники'),
(31, 5110, 'No', 'Апаратні засоби мультимедіа. Відеосистема РС', 15.51, 'Видавнича група BHV', 400, '70х100/16', '2000-07-24', 5000, 'Використання ПК в цілому','Апаратні засоби ПК'),
(46, 5199, 'No', 'Залізо IBM 2001', 30.07, 'МикроАрт', 368, '70х100/16', '2000-12-02', 5000, 'Використання ПК в цілому', 'Апаратні засоби ПК'),
(50, 3851, 'No', 'Захист інформації та безпека комп''ютерних систем', 26.00, 'DiaSoft', 480, '84х108/16', NULL, 5000, 'Використання ПК в цілому','Захист і безпека ПК'),
(58, 3932, 'No', 'Як перетворити персональний комп''ютер на вимірювальний комплекс', 7.65, 'ДМК', 144, '60х88/16', '1999-06-09', 5000, 'Використання ПК в цілому', 'Інші книги'),
(59, 4713, 'No', 'Plug-ins. Додаткові програми для музичних програм', 11.41, 'ДМК', 144, '70х100/16', '2000-02-22', 5000, 'Використання ПК в цілому', 'Інші книги'),
(175, 5217, 'No', 'Windows МЕ. Найновіші версії програм', 16.57, 'Триумф', 320, '70х100/16', '2000-08-25', 5000, 'Операційні системи', 'Windows 2000'),
(176, 4829, 'No', 'Windows 2000 Professional крок за кроком з CD', 27.25, 'Эком', 320, '70х100/16', '2000-04-28', 5000, 'Операційні системи', 'Windows 2000'),
(188, 5170, 'No', 'Linux версії', 24.43, 'ДМК', 346, '70х100/16', '2000-09-29', 5000, 'Операційні системи', 'Linux'),
(191, 860, 'No', 'Операційна система UNIX', 3.50, 'Видавнича група BHV', 395, '84х100\16', '1997-05-05', 5000, 'Операційні системи', 'Unix'),
(203, 44, 'No', 'Відповіді на актуальні запитання щодо OS/2 Warp', 5.00, 'DiaSoft', 352, '60х84/16', '1996-03-20', 5000, 'Операційні системи', 'Інші операційні системи'),
(206, 5176, 'No', 'Windows Ме. Супутник користувача', 12.79, 'Видавнича група BHV', 306, '', '2000-10-10', 5000, 'Операційні системи', 'Інші операційні системи'),
(209, 5462, 'No', 'Мова програмування С++. Лекції та вправи', 29.00, 'DiaSoft', 656, '84х108/16', '2000-12-12', 5000, 'Програмування', 'C&C++'),
(210, 4982, 'No', 'Мова програмування С. Лекції та вправи', 29.00, 'DiaSoft', 432, '84х108/16', '2000-07-12', 5000, 'Програмування', 'C&C++'),
(220, 4687, 'No', 'Ефективне використання C++ .50 рекомендацій щодо покращення ваших програм та проектів', 17.60, 'ДМК', 240, '70х100/16', '2000-02-03', 5000, 'Програмування', 'C&C++'),
(222, 235, 'No', 'Інформаційні системи і структури даних', NULL, 'Києво-Могилянська академія', 288, '60х90/16', NULL, 400, 'Використання ПК в цілому', 'Інші книги'),
(225, 8746, 'Yes', 'Бази даних в інформаційних системах', NULL, 'Університет "Україна"', 418, '60х84/16', '2018-25-07', 100, 'Програмування', 'SQL'),
(226, 2154, 'Yes', 'Сервер на основі операційної системи FreeBSD 6.1', 0, 'Університет "Україна"', 216, '60х84/16', '2015-03-11', 500, 'Програмування', 'Інші операційні системи'),
(245, 2662, 'No', 'Організація баз даних та знань', 0, 'Вінниця: ВДТУ', 208, '60х90/16', '2001-10-10', 1000, 'Програмування', 'SQL'),
(247, 5641, 'Yes', 'Організація баз даних та знань', 0, 'Видавнича група BHV', 384, '70х100/16', '2021-15-12', 5000, 'Програмування', 'SQL')
;

DROP TABLE books; 


ALTER TABLE books
	ADD COLUMN Author VARCHAR(15) AFTER `price`;
    
ALTER TABLE books
	MODIFY COLUMN Author VARCHAR(20) AFTER `price`;
    
ALTER TABLE books
	DROP COLUMN Author;

ALTER TABLE books DROP INDEX idx_Book;
CREATE UNIQUE INDEX idx_Book ON books(num DESC , name_ ASC, subject ASC, category ASC);

ALTER TABLE books DROP INDEX idx_Book;
