create table zepto(
sku_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountpercent numeric(5,2),
availablequantity integer,
discountsellingprice numeric(8,2),
weightingms integer,
outofstock boolean,
quantity integer
);

--data
select count(*) from zepto;
select * from zepto limit 10;

--data exploration
select count(*) from zepto;
--sample data
select * from zepto limit 10;
--null values
select * from zepto
where name is null 
or
category is null
or
mrp is null
or 
discountpercent is null
or 
discountsellingprice is null
or
availablequantity is null 
or
quantity is null
or
outofstock is null;

-- different product categories
select distinct category
from zepto
order by category;

--products in stock vs out of stock
select outofstock,count(sku_id)
from zepto
group by outofstock;

--product names present multiple times
select name,count(sku_id) as "number of skus"
from zepto
group by name
having count(sku_id) > 1
order by count(sku_id) desc;

--data cleaning
--products with price=0
select *
from zepto
where mrp=0 or discountsellingprice=0;

delete from zepto 
where mrp=0;

--convert paise in rupees
update zepto 
set mrp=mrp/100.0,
discountsellingprice=discountsellingprice/100.0

select mrp,discountsellingprice from zepto;

--Q1. find the top 10 best value products based on the discount percentage.
select distinct name,mrp,discountpercent
from zepto
order by discountpercent desc limit 10;

--Q2.what are the products with high mrp but out of stock.
select distinct name,mrp 
from zepto
where outofstock =True and mrp > 300
order by mrp desc;

--Q3.calculate estimated revenue for each category.
select category,
sum(discountsellingprice * availablequantity) as total_revenue
from zepto
group by category
order by total_revenue;

--Q4.find all products where mrp is greater than 500 and discount is less than 10%.
select distinct name,mrp,discountpercent
from zepto
where mrp >500 and discountpercent <10
order by mrp desc,discountpercent desc;

--Q5.identify the top 5 categories offering the highest average discount percentage.
select category ,round(avg(discountpercent),2) as "highest_average"
from zepto
group by category
order by highest_average desc limit 5;

--Q6.find the price per gram for products above 100g and sort by best value.
select distinct name,weightingms,discountsellingprice,
round(discountsellingprice/weightingms,2) as price_per_gram
from zepto
where weightingms >=100
order by price_per_gram;

--Q7.group products into categories like low,medium,bulk.
select distinct name,weightingms,
case when weightingms <1000 then 'low'
     when weightingms <5000 then 'medium'
	 else 'bulk'
	 end as weight_category
from zepto;

--Q8.what  is the total inventory weight per category.

select category,sum(weightingms * availablequantity) as "total_inventory_weight"
from zepto
group by category
order by total_inventory_weight desc;


