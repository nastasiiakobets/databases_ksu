-- 1. Створити користувальницький тип даних для зберігання оцінки учня на основі стандартного типу tinyint з можливістю використання порожніх значень.
CREATE TYPE Grade AS tinyint NULL;


-- 2. Створити об'єкт-замовчування (default) зі значенням 3.
CREATE DEFAULT GradeDefault AS 3;


-- 3. Зв'язати об'єкт-замовчування з призначеним для користувача типом даних для оцінки.
EXEC sp_bindefault 'GradeDefault', 'Grade';


-- 4. Отримати інформацію про призначений для користувача тип даних.
EXEC sp_help 'Grade';


-- 5. Створити об'єкт-правило (rule): a> = 1 і a <= 5 і зв'язати його з призначеним для користувача типом даних для оцінки.
CREATE RULE GradeRule
AS @value >= 1 AND @value <= 5;

--прив'язка до призначеного типу даних для оцінки:
EXEC sp_bindrule 'GradeRule', 'Grade';


-- 6. Створити таблицю "Успішність студента", використовуючи новий тип даних. У таблиці повинні бути оцінки студента з кількох предметів.
CREATE TABLE StudentSuccess
(
    StudentID int,
    MathGrade Grade,
    ScienceGrade Grade,
    HistoryGrade Grade
);


-- 7. Скасувати всі прив'язки і видалити з бази даних тип даних користувача, замовчування і правило.
EXEC sp_unbindrule 'GradeRule', 'Grade';
EXEC sp_unbindefault 'GradeDefault', 'Grade';
DROP RULE GradeRule;
DROP DEFAULT GradeDefault;
DROP TYPE Grade;