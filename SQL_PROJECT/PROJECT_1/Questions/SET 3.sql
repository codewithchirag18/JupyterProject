SET 3
Q1. Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent?

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




