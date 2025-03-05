select * from album2
select*from employee

alter table employee
alter birthdate type timestamp
using birthdate::timestamp

--1.Senior most employee based on job title

select*from employee order by levels desc limit 1

--2.Countries with the most invoices

select*from invoice

select billing_country,count(*) from invoice
group by billing_country
order by 2 desc
limit 5

--3. top 3 values of total invoice
select total from invoice
order by 1 desc
limit 3

--4.City with the best customers(highest no.of totals)
select billing_city, round(sum(total)::numeric,2) from invoice
group by 1
order by 2 desc

--5. Best Customer(who has spent the most money)

select*from invoice
select*from customer
	
select c.customer_id, c.first_name,c.last_name,round(sum(i.total)::numeric,2)
from customer c join 
invoice i on c.customer_id=i.customer_id
group by 1,2,3
order by 4 desc

/*6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */
select*from genre
select distinct c.email,c.first_name,c.last_name,g.name
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on t.track_id=il.track_id
join genre g on g.genre_id=t.genre_id
where g.name='Rock'
order by 1

--OR

SELECT DISTINCT email,first_name, last_name
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track
	JOIN genre ON track.genre_id = genre.genre_id
	WHERE genre.name LIKE 'Rock'
)
ORDER BY email;


-- 7. Let's invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.

select a.name,count(a.artist_id)
from artist a 
join album ab on a.artist_id=ab.artist_id
join track t on t.album_id=ab.album_id
join genre g on g.genre_id=t.genre_id
where g.name='Rock'
group by 1
order by 2 desc
limit 10

-- 8. Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.
with a_s as(
select round(avg(milliseconds)::numeric,2) as a from track
	)

select t.name,t.milliseconds as tm from track t join a_s on t.milliseconds>a_s.a
order by 2 desc

--9. Customers who purchased best selling artists and how much they spent	
	
with bsa as(
select a.artist_id,a.name,sum(il.unit_price*il.quantity) as s
from invoice_line il
join track t on t.track_id=il.track_id
join album ab on ab.album_id = t.album_id	
join artist a on a.artist_id=ab.artist_id
group by 1,2
order by 3 desc
limit 1	
	)


select c.first_name,c.last_name,bsa.name,sum(il.unit_price*il.quantity)
from customer c
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on t.track_id=il.track_id
join album ab on ab.album_id = t.album_id
join bsa on ab.artist_id=bsa.artist_id
group by 1,2,3
order by 4 desc


--10. Most popular genre from each country

with pg as(
	select i.billing_country,g.genre_id,g.name,count(il.quantity) as c,
	dense_rank() over(partition by i.billing_country order by count(il.quantity) desc) as dnr
	from invoice i
	join invoice_line il on il.invoice_id=i.invoice_id
	join track t on t.track_id=il.track_id
    join genre g on g.genre_id=t.genre_id
	group by 1,2,3
)

select pg.billing_country,pg.name,pg.c from pg where pg.dnr=1
order by 3 desc


--11. Customer who spent the most money from each country

with m as(	
select c.first_name,c.last_name,i.billing_country,sum(i.total) as s,
dense_rank() over(partition by i.billing_country order by sum(i.total) desc ) as dnr
from customer c
join invoice i on c.customer_id=i.customer_id
group by 1,2,3
	)

select m.*
from m where m.dnr=1




