                                              🎵 Music Store Database Analysis (SQL Project)

📌 Project Overview-:

This project analyzes a Music Store Database using PostgreSQL.
The goal is to answer real-world business questions related to customers, sales, invoices, artists, and genres.   

🛠 Tools & Skills Used-:

1.Database: PostgreSQL (PgAdmin4)
2.Skills: Joins, Aggregate Functions (SUM, COUNT, MAX, AVG), GROUP BY, HAVING, Subqueries, Sorting, Window Functions


                                                                       ✅ Set 1: Sales & Customers

Q1: Who is the senior most employe sbased on job title

ANSWER-: 

SELECT * From employee
ORDER BY levels desc
LIMIT 1;


Q2.Which Countries have the most invoices?

ANSWER-:

select COUNT(*),billing_country
from invoice
group by billing_country
order by COUNT(*) desc;

Q3. what are the top 3 value of total invoice?

ANSWER-:

SELECT total from invoice
ORDER by total desc
LIMIT 3

Q4. Which city has the best customers? we would like to throw a promotional music festival in the city 
we made the most money. Write a query that returns one city that has the highest um of invoice
totals.Return both the city nme and sum of all the invoice totals?

ANSWER-:

select SUM(total) as invoice_total, billing_city
from invoice 
group by billing_city
order by invoice_total desc

--answer is : the city which has the best customer is Prague.

Q5. Who is the best customer? The ustomer who has spend the most money will be declared 
the best customer. Write a Query that returns the person who has spent the most money?

ANSWER-:

Select customer.customer_id,customer.first_name,customer.last_name,SUM(invoice.total) as TOTAL
FROM customer
JOIN invoice ON 
customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY TOTAL desc
LIMIT 1

                                                                          ✅ Set 2: Music Trends

 Q1. Write query to return email,first name,last name & genre of all rock Music listeners. 
 Return your list ordered alphabaetically by email starting with A?

ANSWER-:

 SELECT DISTINCT email,first_name,last_name
 FROM customer 
 JOIN invoice on customer.customer_id=invoice.customer_id
 JOIN invoice_line on invoice.invoice_id=invoice_line.invoice_id
 WHERE track_id IN(
	SELECT track.track_id FROM track
	JOIN genre ON track.genre_id=genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email

Q2. Lets Invite the artist who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock brands?

ANSWER-:

SELECT artist.artist_id,artist.name, COUNT(artist.artist_id) as number_of_songs
FROM artist 
JOIN album On artist.artist_id = album.artist_id
JOIN track ON album.album_id=track.album_id
JOIN genre ON track.genre_id = genre.genre_id
WHERE genre.name LIKE 'Rock'
GROUP BY artist.artist_id
ORDER BY number_of_songs DESC 
LIMIT 10;

Q3. Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track .Order by the song with the longest 
songs listed first?

ANSWER-:

SELECT name,milliseconds 
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) as avg_track_length
	FROM track)
ORDER BY milliseconds DESC
LIMIT 10;


                                                                           ✅ Set 3: Advanced Insights

Q1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent?

ANSWER-:

WITH best_selling_artist AS (
	SELECT artist.artist_id,artist.name AS artist_name,
	SUM(invoice_line.unit_price*invoice_line.quantity) AS total_sales
	FROM invoice_line 
	JOIN track ON invoice_line.track_id=track.track_id
	JOIN album ON track.album_id=album.album_id
	JOIN artist ON artist.artist_id=album.artist_id
	GROUP BY 1
	ORDER BY 3 DESC
	LIMIT 1
)

SELECT c.customer_id,c.first_name,c.last_name,bsa.artist_name,
SUM(il.unit_price*il.quantity) AS amount_spent
FROM invoice i 
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id=i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id=t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id=alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;

Q2. We want to find out the most popular music genre for each counrty.
we determine the ost popular genre as the genre with the highest amount of purchases. 
Write a query that returns each country along with the top genre. For countries where 
the maximum number of purchases is shared return all the Genres?

ANSWER-:

WITH popular_genre AS
(
	SELECT COUNT(invoice_line.quantity) AS purchases,customer.country,genre.name,genre.genre_id,
	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity)DESC)AS RowNo
	FROM invoice_line
	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
	JOIN customer On customer.customer_id = invoice.customer_id
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN genre ON genre.genre_id = track.genre_id
	GROUP BY 2,3,4
	ORDER BY 2 ASC,1 DESC
)
SELECT * FROM popular_genre WHERE RowNo <=1

Q3. Wrie a query that determines the customer that has spent the mmost on music for each country.
Write a query that returns the country along with the top customer and hw much they spent.
For countries where the top amount spent is shared,provide all customers who spent this amount?

ANSWER-:

WITH RECURSIVE
	customer_with_country AS (
		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending
		FROM invoice 
		JOIN customer ON customer.customer_id = invoice.customer_id
		GROUP BY 1,2,3,4
		ORDER BY 2,3 DESC),

	customer_max_spending AS(
		SELECT billing_country,MAX(total_spending) AS max_spending
		FROM customer_with_country
		GROUP BY billing_country)
		
SELECT cc.billing_country,cc.total_spending , cc.first_name,cc.last_name
FROM customer_with_country cc
JOIN customer_max_spending ms
ON cc.billing_country = ms.billing_country
WHERE cc.total_spending = ms.max_spending
ORDER BY 1;

METHOD 2

WITH customer_with_country AS (
	SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
	ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total)DESC) AS RowNo
	FROM invoice
	JOIN customer on customer.customer_id = invoice.customer_id
	GROUP BY 1,2,3,4
	ORDER BY 4 ASC,5 DESC)
SELECT * FROM customer_with_country WHERE RowNO <=1;

## ✅ Results
All query results are stored inside the [`outputs/`](./outputs) folder as **CSV files/screenshots**.


📊 Key Insights-:

1.Found the best customer by total spend.

2.Identified most profitable city for promotions.

3.Analyzed genre popularity per country.

4.Ranked artists and tracks based on engagement and sales.

🚀 Conclusion-:

This project demonstrates how SQL can be used to extract actionable insights from a relational database, showcasing skills in querying, analysis, and business problem-solving