use sakila;
-- 1a.
SELECT  first_name, last_name FROM actor;
-- 1b.
SELECT CONCAT(UPPER(first_name), " ", UPPER(last_name)) AS "Actor Name" FROM actor;
-- 2a.
SELECT actor_id, first_name, last_name FROM actor WHERE first_name="Joe";
-- 2b.
SELECT first_name, last_name FROM actor WHERE (upper(last_name)) LIKE '%GEN%';
-- 2c.
SELECT first_name, last_name FROM actor WHERE (upper(last_name)) LIKE '%LI%' 
ORDER BY last_name, first_name;
-- 2d.
SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a. Varchar works for variable length text, blob works for binary only.

ALTER TABLE country
  ADD description varchar(1000);

-- 3b.

ALTER TABLE country
  DROP COLUMN description;

-- 4a.
SELECT last_name, COUNT(*) FROM actor
	GROUP BY last_name;

-- 4b.
SELECT last_name, COUNT(*) FROM actor 
	GROUP BY last_name HAVING COUNT(*)>=2;
    
-- 4c.
UPDATE actor
SET 
    first_name = "Harpo"
WHERE first_name="Groucho" and last_name="Williams";

-- 4d.
UPDATE actor
SET 
    first_name = "Groucho"
WHERE first_name="Harpo" and last_name="Williams";

-- 5a. The command below is not really meant to be run because the table already exists.

CREATE TABLE address (
  address_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  address VARCHAR(50) NOT NULL,
  address2 VARCHAR(50) DEFAULT NULL,
  district VARCHAR(20) NOT NULL,
  city_id SMALLINT UNSIGNED NOT NULL,
  postal_code VARCHAR(10) DEFAULT NULL,
  phone VARCHAR(20) NOT NULL,
  location GEOMETRY,
  last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY  (address_id),
  KEY idx_fk_city_id (city_id)l
  )
  ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
  
-- 6a.

SELECT staff.first_name, staff.last_name, address.address, address.address2 FROM staff
	LEFT JOIN 
		address ON staff.address_id=address.address_id;
        

-- 6b.
-- working but gives extra total?
SELECT s.first_name, s.last_name, sum(p.amount) as "Total Amount"
	FROM payment p
	INNER JOIN staff s
	ON p.staff_id=s.staff_id and p.payment_date LIKE('2005-08%')
    GROUP BY s.staff_id;
  
-- 6c.

    
SELECT f.title, COUNT(fa.actor_id) FROM film_actor fa
	LEFT JOIN film f 
    ON fa.film_id=f.film_id
    GROUP BY f.title;
    
-- 6d.
SELECT f.title, COUNT(i.film_id) FROM inventory i
	LEFT JOIN film f 
    ON i.film_id=f.film_id
    GROUP BY f.title
    HAVING f.title="Hunchback Impossible";
    
-- 6e.

SELECT c.first_name, c.last_name, sum(p.amount) AS "Total Amount"
	FROM payment p
	LEFT JOIN customer c
	ON p.customer_id=c.customer_id
    GROUP BY c.customer_id
	ORDER BY c.last_name;
    
-- 7a.

SELECT f.title 
FROM film f 
WHERE 
f.title 
LIKE('K%')
OR f.title
LIKE('Q%')
AND 
(SELECT l.language_id from language l
WHERE l.name = "ENGLISH");



-- 7b.

SELECT a.first_name, a.last_name from actor a
WHERE a.actor_id IN 
    
(SELECT fa.actor_id from film_actor fa INNER JOIN 
	film f ON f.film_id=fa.film_id 
	WHERE f.title="ALONE TRIP");
 
 -- 7c.
 SELECT c.first_name, c.last_name, c.email FROM
	customer c 
	WHERE c.address_id in
	(SELECT a.address_id from address a INNER JOIN
	city c ON a.city_id= c.city_id 
	INNER JOIN
	country co ON c.country_id=co.country_id
	AND
	co.country = "Canada");
 

-- 7d.
SELECT f.title FROM film f INNER JOIN
film_category fc ON f.film_id=fc.film_id INNER JOIN
category c ON fc.category_id=c.category_id WHERE c.name="family";

-- 7e.
SELECT f.title, count(*) 
	FROM film f 
    INNER JOIN inventory i 
    ON f.film_id=i.film_id 
	INNER JOIN rental r 
	ON r.inventory_id=i.inventory_id
	GROUP BY f.title
	ORDER BY count(*) desc;
    
-- 7f. 
 
 SELECT s.store_id, sum(p.amount) as "Sales Total" from store s INNER JOIN
 customer c ON s.store_id=c.store_id INNER JOIN
 payment p ON c.customer_id=p.customer_id
 GROUP BY s.store_id;
 
 -- 7g.
SELECT s.store_id, co.country FROM store s
	INNER JOIN address a
	ON s.address_id=a.address_id
    INNER JOIN
    city c
    ON a.city_id = c.city_id
    INNER JOIN 
	country co
    ON c.country_id=co.country_id;
    
-- 7h. 
SELECT c.category_id, c.name, sum(p.amount) as "Genre Total" from category c 
    INNER JOIN film_category fc
    ON c.category_id=fc.category_id
	INNER JOIN 
    film f
    ON fc.film_id=f.film_id
    INNER JOIN
    inventory i
    ON f.film_id=i.film_id
    INNER JOIN rental r
    ON i.inventory_id=r.inventory_id
	INNER JOIN 
    payment p
    ON r.rental_id=p.rental_id
    GROUP BY c.category_id
    ORDER BY sum(p.amount) desc
    LIMIT 5;

-- 8a.

CREATE VIEW top5_genres AS
	SELECT c.category_id, c.name, sum(p.amount) as "Genre Total" from category c 
    INNER JOIN film_category fc
    ON c.category_id=fc.category_id
	INNER JOIN 
    film f
    ON fc.film_id=f.film_id
    INNER JOIN
    inventory i
    ON f.film_id=i.film_id
    INNER JOIN rental r
    ON i.inventory_id=r.inventory_id
	INNER JOIN 
    payment p
    ON r.rental_id=p.rental_id
    GROUP BY c.category_id
    ORDER BY sum(p.amount) desc
    LIMIT 5;
    
-- 8b.

SELECT * FROM top5_genres;

-- 8c.

DROP VIEW IF EXISTS top5_genres;
        
    
    
    