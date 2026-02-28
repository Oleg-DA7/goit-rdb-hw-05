USE goit_rdb_hw3;

# Напишіть SQL запит, який буде відображати таблицю order_details та поле customer_id з таблиці orders 
# відповідно для кожного поля запису з таблиці order_details. 
# Це має бути зроблено за допомогою вкладеного запиту в операторі SELECT.
# var. 1
select * from order_details od inner join orders o on od.order_id = o.id;
# var. 2
select *, (select customer_id from orders o where od.order_id = o.id) as cust_id from order_details od;

# 2. Напишіть SQL запит, який буде відображати таблицю order_details. 
# Відфільтруйте результати так, щоб відповідний запис із таблиці orders виконував умову shipper_id=3.
# Це має бути зроблено за допомогою вкладеного запиту в операторі WHERE.
# var. 1
select *, (select shipper_id from orders o where od.order_id = o.id and shipper_id = 3) as sh_id from order_details od;
# var. 2
with tmpT1 as (
select *, (select shipper_id from orders o where od.order_id = o.id) as sh_id from order_details od 
)
select * from tmpT1 where sh_id = 3;

# 3. Напишіть SQL запит, вкладений в операторі FROM, який буде обирати рядки з умовою quantity>10 
# з таблиці order_details. Для отриманих даних знайдіть середнє значення поля quantity — групувати слід за order_id.
select order_id, avg(quantity) from (select order_id, quantity from order_details where quantity > 10) as t
group by order_id;

# 4. Розв’яжіть завдання 3, використовуючи оператор WITH для створення тимчасової таблиці temp.
# Якщо ваша версія MySQL більш рання, ніж 8.0, створіть цей запит за аналогією до того, як це зроблено в конспекті.
with t as (
select order_id, quantity from order_details where quantity > 10
)
select order_id, avg(quantity) from t group by order_id;

# 5. Створіть функцію з двома параметрами, яка буде ділити перший параметр на другий. 
# Обидва параметри та значення, що повертається, повинні мати тип FLOAT.
# Використайте конструкцію DROP FUNCTION IF EXISTS. Застосуйте функцію до атрибута quantity таблиці order_details.
# Другим параметром може бути довільне число на ваш розсуд.
DROP FUNCTION IF EXISTS fDivide;
DELIMITER //

CREATE FUNCTION fDivide(_enum INT, _denom INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    IF _denom = 0 THEN
        RETURN NULL;
    ELSE
        RETURN _enum / _denom;
    END IF;
END //

DELIMITER ;

select fDivide(10, 2);
select fDivide(10, 0);
select fDivide(quantity, 2) from order_details;

