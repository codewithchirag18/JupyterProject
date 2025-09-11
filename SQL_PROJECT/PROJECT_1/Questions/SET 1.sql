Q1: Who is the senior most employe sbased on job title

SELECT * From employee
ORDER BY levels desc
LIMIT 1;

Q2.Which Countries have the most invoices?

select COUNT(*),billing_country
from invoice
group by billing_country
order by COUNT(*) desc;

Q3. what are the top 3 value of total invoice?

SELECT total from invoice
ORDER by total desc
LIMIT 3

Q4. Which city has the best customers? we would like to throw a promotional music festival in the city 
we made the most money. Write a query that returns one city that has the highest um of invoice
totals.Return both the city nme and sum of all the invoice totals?

select SUM(total) as invoice_total, billing_city
from invoice 
group by billing_city
order by invoice_total desc

--answer is : the city which has the best customer is Prague.

Q5. Who is the best customer? The ustomer who has spend the most money will be declared 
the best customer. Write a Query that returns the person who has spent the most money?

Select customer.customer_id,customer.first_name,customer.last_name,SUM(invoice.total) as TOTAL
FROM customer
JOIN invoice ON 
customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY TOTAL desc
LIMIT 1


