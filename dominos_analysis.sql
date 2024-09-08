SELECT * FROM dominos.orders;
create table order_details(
order_details_id int not null,
order_id int not null,
pizza_id text not null,
quantity int not null,
primary key (order_details_id));

SELECT * FROM dominos.pizzas;
Create table orders (order_id int
not null,
order_date date not null,
order_time time not null,
primary key (order_id));

-- Calculate the total revenue generated from pizza sales.
select round (sum(order_details.quantity*pizzas.price),2)
as total_revenue
from order_details
join 
pizzas on pizzas.pizza_id= order_details.pizza_id;

-- Join the necessary tables to find the total quantity of each pizza category ordered

select pizza_types.category,
sum(order_details.quantity) AS quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

--   List the top 5 most ordered pizza types
--   along with their quantities
  
SELECT 
    pizza_types.name, SUM(order_details.quantity) AS quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name
ORDER BY quantity DESC
LIMIT 5;

-- Identify the most common pizza size ordered
select pizzas.size, count(order_details.order_details_id) as order_count
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc;

-- Identify the highest-priced pizza

select pizza_types.name,pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc limit 1;

-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category;


-- Group the orders by date and 
-- calculate the average number of pizzas ordered per day
select round(avg(quantity),0) from
(select orders.order_date,sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue

select pizza_types.name, 
SUM(order_details.quantity*pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_types_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue
select pizza_types.category,
round(sum(order_details.quantity*pizzas.price) / ( select round (sum(order_details.quantity*pizzas.price),2)
as total_revenue
from order_details
join 
pizzas on pizzas.pizza_id= order_details.pizza_id) * 100,2) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category
order by revenue desc ;

-- Analyze the cumulative revenue generated over time
select order_date,
sum(revenue) over(order by order_date) as cum_revenue
from 
(select orders.order_date,
sum(order_details.quantity*pizzas.price) as revenue
from order_details
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by orders.order_date) as sales;


