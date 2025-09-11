SET 2 

 Q1. Write query to return email,first name,last name & genre of all rock Music listeners. 
 Return your list ordered alphabaetically by email starting with A?

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

SELECT name,milliseconds 
FROM track
WHERE milliseconds > (
	SELECT AVG(milliseconds) as avg_track_length
	FROM track)
ORDER BY milliseconds DESC
LIMIT 10;
