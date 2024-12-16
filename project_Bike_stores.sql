use BikeStores
select * from production.brands
select * from production.categories
select * from production.products
select * from production.stocks
select * from sales.customers
select * from sales.order_items
select * from sales.orders
select * from sales.staffs
select * from sales.stores

--1) Which bike is most expensive? What could be the motive behind pricing this bike at the high price?
select  product_id, product_name,max(list_price) as 'high_price',model_year
from production.products
group by product_name,product_id,model_year
order by'high_price' desc

--2) How many total customers does BikeStore have? 
select count(c.customer_id) as ' Total_customers ' 
from sales.customers c 


/* Would you consider people with order status 3 as customers substantiate your answer? 
individuals with status = 3 cannot be considered actual customers since their orders are Rejected  (shipped_date = NULL).*/

SELECT o.customer_id, o.order_id, o.order_status,o.shipped_date
FROM sales.orders o
WHERE o.order_status =3 

--3) How many stores does BikeStore have? 
select count(s.store_id) as '#stores'
from sales.stores s 

--4) What is the total price spent per order? 
select oi.order_id,sum(oi.list_price * oi.quantity*(1-oi.discount)) as 'total price'
from sales.order_items oi
group by oi.order_id

--5) What’s the sales/revenue per store?
select s.store_id,sum(oi.list_price * oi.quantity*(1-oi.discount)) as 'total revenue'
from sales.order_items oi inner join sales.orders o
on oi.order_id=o.order_id
inner join sales.stores s
on s.store_id=o.store_id
group by s.store_id
order by s.store_id ,'Total revenue' desc

--6)  Which category is most sold? >>Regarding total sales
select top 1 c.category_id,c.category_name,sum(o.quantity) as 'Total_sales'  
from production.categories c inner join production.products p
on c.category_id=p.category_id
inner join sales.order_items o
on p.product_id=o.product_id
group by c.category_id,c.category_name
order by [Total_sales] desc 

--7) Which category rejected more orders?
select top 1  c.category_id,c.category_name,count(o.order_id) as 'rejected_orders'  
from production.categories c inner join production.products p
on c.category_id=p.category_id
inner join sales.order_items oi
on p.product_id=oi.product_id
inner join sales.orders o
on oi.order_id=o.order_id
where o.order_status=3
group by c.category_id,c.category_name
order by [rejected_orders] desc 

--8) Which bike is the least sold? 
select top 1 p.product_id,p.product_name,sum(oi.quantity) as 'lest_soled '
from production.products p inner join sales.order_items oi
on p.product_id=oi.product_id
group by p.product_name,p.product_id
order by [lest_soled ] asc

--9) What’s the full name of a customer with ID 259?
select c.first_name+' '+c.last_name as 'full_name '
from sales.customers c
where c.customer_id=259

--10) What did the customer on question 9 buy and when? What’s the status of this order?
select  p.product_id,p.product_name,o.order_id,o.order_date,o.order_status
from sales.orders o inner join sales.order_items oi
on o.order_id=oi.order_id
inner join production.products p
on oi.product_id=p.product_id
where o.customer_id=259

--11) Which staff processed the order of customer 259? And from which store?
select s.staff_id,s.first_name,s.last_name ,st.store_name,st.store_id
from sales.staffs s inner join sales.orders o
on s.staff_id=o.staff_id
inner join sales.stores st
on s.store_id=st.store_id
where o.customer_id=259

--12) How many staff does BikeStore have? Who seems to be the lead Staff at BikeStore? 
select count(s.staff_id) as ' #staff'
from sales.staffs s

select s.first_name,S.last_name,s.manager_id -- Fabiola Jackson IS LEAD
from sales.staffs s 

--13) Which brand is the most liked? >>Regarding total sales (Electra is the best-selling brand)
select top 1 b.brand_id,b.brand_name,sum(oi.quantity) as ' total_sales'
from production.brands b inner join production.products p
on b.brand_id=p.brand_id
inner join sales.order_items oi 
on p.product_id=oi.product_id
group by b.brand_id,b.brand_name
order by [ total_sales] desc

--14) How many categories does BikeStore have, and which one is the least liked?
select count (c.category_id) ' # categories'
from production.categories c

--which one is the least liked? >>Regarding total sales
select top 1 c.category_id,c.category_name,sum(oi.quantity) ' total_sales'
from production.categories c inner join production.products p
on c.category_id=p.category_id
inner join sales.order_items oi 
on p.product_id=oi.product_id
group by c.category_id,c.category_name
order by [ total_sales] asc

--15) Which store still have more products of the most liked brand?
select  top 1 s.store_id,s.store_name, sum(ps.quantity) as ' total_stocks',b.brand_name
from sales.stores s inner join production.stocks ps
on s.store_id=ps.store_id
inner join production.products p
on p.product_id=ps.product_id
inner join production.brands b
on p.brand_id=b.brand_id
where b.brand_id= (select top 1 b.brand_id
from production.brands b inner join production.products p
on b.brand_id=p.brand_id
inner join sales.order_items oi 
on p.product_id=oi.product_id
group by b.brand_id
order by sum(oi.quantity)desc
)
group by s.store_id,s.store_name,b.brand_name
order by [ total_stocks] desc

---16) Which state is doing better in terms of sales?  
select  top 1 s.state ,sum(oi.list_price * oi.quantity *(1-oi.discount)) as ' better sales'
from sales.stores s inner join sales.orders o
on s.store_id=o.store_id
inner join sales.order_items oi 
on o.order_id=oi.order_id
group by s.state
order by [ better sales] desc 

--17) What’s the discounted price of product id 259? 
select oi.product_id ,sum(oi.list_price * oi.quantity *(1-oi.discount)) 'Discounted_price '
from sales.order_items oi
where oi.product_id=259
group by oi.product_id
-->>another answer
select oi.product_id ,oi.list_price *(1-oi.discount) 'Discounted_price '
from sales.order_items oi
where oi.product_id=259

---


--18)What’s the product name, quantity, price, category, model year and brand name of product number 44?
select  p.product_name,oi.quantity,oi.list_price,c.category_id, c.category_name ,p.model_year,b.brand_id,b.brand_name
from production.products p inner join sales.order_items oi 
on p.product_id=oi.product_id
inner join production.categories c
on p.category_id=c.category_id
inner join production.brands b
on b.brand_id=p.brand_id
where p.product_id=44

--19) What’s the zip code of CA? 
select s.zip_code 
from sales.stores s
where s.state='CA'

--20) How many states does BikeStore operate in? 
select count(s.state) ' #states'
from sales.stores s

--21) How many bikes under the children category were sold in the last 8 months?
--zero bikes
SELECT SUM(oi.quantity) AS 'Total_Bikes_Sold'
FROM sales.order_items oi INNER JOIN production.products p 
ON oi.product_id = p.product_id
INNER JOIN production.categories c 
ON p.category_id = c.category_id
inner join sales.orders o
on o.order_id=oi.order_id
WHERE c.category_name  like 'children%'
AND o.order_date >= DATEADD(MONTH, -8, GETDATE());

--22) What’s the shipped date for the order from customer 523
select c.customer_id ,order_id, o.shipped_date
from sales.orders o inner join sales.customers c
on o.customer_id=c.customer_id
where c.customer_id=523

--23) How many orders are still pending? 
select count(o.order_id) ' #Orders'
from sales.orders o
where o.order_status=1  -- Order status: 1 = Pending; 2 = Processing; 3 = Rejected; 4 = Completed

--24) What’s the names of category and brand does "Electra white water 3i - 2018" fall under?
select p.product_name,c.category_name,b.brand_name
from production.products p inner join production.brands b
on p.brand_id=b.brand_id
inner join production.categories c
on p.category_id=c.category_id
where p.product_name= 'Electra white water 3i - 2018'

--shimaaAbdelgawad---

