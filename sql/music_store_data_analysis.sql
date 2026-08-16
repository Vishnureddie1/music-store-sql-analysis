/*
   MUSIC STORE DATA ANALYSIS
   Database Creation and SQL Analysis
*/
CREATE DATABASE music_store;

USE music_store;


CREATE TABLE Genre (
    genre_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE MediaType (
    media_type_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    last_name VARCHAR(120),
    first_name VARCHAR(120),
    title VARCHAR(120),
    reports_to INT,
    levels VARCHAR(255),
    birthdate DATE,
    hire_date DATE,
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100)
);


CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(120),
    last_name VARCHAR(120),
    company VARCHAR(120),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20),
    phone VARCHAR(50),
    fax VARCHAR(50),
    email VARCHAR(100),
    support_rep_id INT,
    FOREIGN KEY (support_rep_id)
        REFERENCES Employee(employee_id)
);


CREATE TABLE Artist (
    artist_id INT PRIMARY KEY,
    name VARCHAR(120)
);


CREATE TABLE Album (
    album_id INT PRIMARY KEY,
    title VARCHAR(160),
    artist_id INT,
    FOREIGN KEY (artist_id)
        REFERENCES Artist(artist_id)
);


CREATE TABLE Track (
    track_id INT PRIMARY KEY,
    name VARCHAR(200),
    album_id INT,
    media_type_id INT,
    genre_id INT,
    composer VARCHAR(220),
    milliseconds INT,
    bytes INT,
    unit_price DECIMAL(10,2),

    FOREIGN KEY (album_id)
        REFERENCES Album(album_id),

    FOREIGN KEY (media_type_id)
        REFERENCES MediaType(media_type_id),

    FOREIGN KEY (genre_id)
        REFERENCES Genre(genre_id)
);


CREATE TABLE Invoice (
    invoice_id INT PRIMARY KEY,
    customer_id INT,
    invoice_date DATE,
    billing_address VARCHAR(255),
    billing_city VARCHAR(100),
    billing_state VARCHAR(100),
    billing_country VARCHAR(100),
    billing_postal_code VARCHAR(20),
    total DECIMAL(10,2),

    FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);


CREATE TABLE InvoiceLine (
    invoice_line_id INT PRIMARY KEY,
    invoice_id INT,
    track_id INT,
    unit_price DECIMAL(10,2),
    quantity INT,

    FOREIGN KEY (invoice_id)
        REFERENCES Invoice(invoice_id),

    FOREIGN KEY (track_id)
        REFERENCES Track(track_id)
);


CREATE TABLE Playlist (
    playlist_id INT PRIMARY KEY,
    name VARCHAR(255)
);


CREATE TABLE PlaylistTrack (
    playlist_id INT,
    track_id INT,

    PRIMARY KEY (playlist_id, track_id),

    FOREIGN KEY (playlist_id)
        REFERENCES Playlist(playlist_id),

    FOREIGN KEY (track_id)
        REFERENCES Track(track_id)
);


SHOW TABLES;
	SELECT COUNT(*) AS TOTAL_NO_OF_TABLES
	FROM INFORMATION_SCHEMA.TABLES
	WHERE TABLE_SCHEMA  = 'music_store';


DESCRIBE Genre;
DESCRIBE MediaType;
DESCRIBE Employee;
DESCRIBE Customer;
DESCRIBE Artist;
DESCRIBE Album;
DESCRIBE Track;
DESCRIBE Invoice;
DESCRIBE InvoiceLine;
DESCRIBE Playlist;
DESCRIBE PlaylistTrack;


SELECT * FROM Genre;
SELECT * FROM MediaType;
SELECT * FROM Employee;
SELECT * FROM Customer;
SELECT * FROM Artist;
SELECT * FROM Album;
SELECT * FROM Track;
SELECT * FROM Invoice;
SELECT * FROM InvoiceLine;
SELECT * FROM Playlist;
SELECT * FROM PlaylistTrack;


/* ============================================================
   QUESTION 1
   Who is the senior-most employee based on job title?
   ============================================================ */

SELECT
    first_name,
    last_name,
    title,
    hire_date
FROM Employee
ORDER BY hire_date ASC
LIMIT 1;


/* ============================================================
   QUESTION 2
   Which countries have the most invoices?
   ============================================================ */

SELECT
    billing_country,
    COUNT(invoice_id) AS total_invoices
FROM Invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;


/* ============================================================
   QUESTION 3
   What are the top 3 values of total invoice?
   ============================================================ */

SELECT
    invoice_id,
    total
FROM Invoice
ORDER BY total DESC
LIMIT 3;


/* ============================================================
   QUESTION 4
   Which city has the best customers?
   Find the city with the highest total invoice revenue.
   ============================================================ */

SELECT
    billing_city,
    SUM(total) AS total_sales
FROM Invoice
GROUP BY billing_city
ORDER BY total_sales DESC
LIMIT 1;


/* ============================================================
   QUESTION 5
   Who is the best customer?
   ============================================================ */

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(i.total) AS total_spent
FROM Customer c
JOIN Invoice i
    ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 1;


/* ============================================================
   QUESTION 6
   Rock Music Listeners
   ============================================================ */

SELECT DISTINCT
    c.email,
    c.first_name,
    c.last_name,
    g.name AS genre
FROM Customer c
JOIN Invoice i
    ON c.customer_id = i.customer_id
JOIN InvoiceLine il
    ON i.invoice_id = il.invoice_id
JOIN Track t
    ON il.track_id = t.track_id
JOIN Genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email ASC;


/* ============================================================
   QUESTION 7
   Top 10 Rock Artists
   ============================================================ */

SELECT
    ar.name AS artist_name,
    COUNT(t.track_id) AS total_tracks
FROM Artist ar
JOIN Album al
    ON ar.artist_id = al.artist_id
JOIN Track t
    ON al.album_id = t.album_id
JOIN Genre g
    ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY
    ar.artist_id,
    ar.name
ORDER BY total_tracks DESC
LIMIT 10;


/* ============================================================
   QUESTION 8
   Tracks longer than the average song length
   ============================================================ */

SELECT
    name,
    milliseconds
FROM Track
WHERE milliseconds > (
    SELECT AVG(milliseconds)
    FROM Track
)
ORDER BY milliseconds DESC;


/* ============================================================
   QUESTION 9
   Amount spent by each customer on artists
   ============================================================ */

SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    ar.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM Customer c
JOIN Invoice i
    ON c.customer_id = i.customer_id
JOIN InvoiceLine il
    ON i.invoice_id = il.invoice_id
JOIN Track t
    ON il.track_id = t.track_id
JOIN Album al
    ON t.album_id = al.album_id
JOIN Artist ar
    ON al.artist_id = ar.artist_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    ar.artist_id,
    ar.name
ORDER BY total_spent DESC;


/* ============================================================
   QUESTION 10
   Most popular music genre for each country
   ============================================================ */

WITH GenrePurchases AS (
    SELECT
        i.billing_country AS country,
        g.name AS genre,
        COUNT(il.invoice_line_id) AS total_purchases
    FROM Customer c
    JOIN Invoice i
        ON c.customer_id = i.customer_id
    JOIN InvoiceLine il
        ON i.invoice_id = il.invoice_id
    JOIN Track t
        ON il.track_id = t.track_id
    JOIN Genre g
        ON t.genre_id = g.genre_id
    GROUP BY
        i.billing_country,
        g.name
),

RankedGenres AS (
    SELECT
        country,
        genre,
        total_purchases,
        RANK() OVER (
            PARTITION BY country
            ORDER BY total_purchases DESC
        ) AS genre_rank
    FROM GenrePurchases
)

SELECT
    country,
    genre,
    total_purchases
FROM RankedGenres
WHERE genre_rank = 1
ORDER BY country;


/* ============================================================
   QUESTION 11
   Highest-spending customer for each country
   ============================================================ */

WITH CustomerSpending AS (
    SELECT
        i.billing_country AS country,
        c.customer_id,
        c.first_name,
        c.last_name,
        SUM(i.total) AS total_spent
    FROM Customer c
    JOIN Invoice i
        ON c.customer_id = i.customer_id
    GROUP BY
        i.billing_country,
        c.customer_id,
        c.first_name,
        c.last_name
),

RankedCustomers AS (
    SELECT
        country,
        customer_id,
        first_name,
        last_name,
        total_spent,
        RANK() OVER (
            PARTITION BY country
            ORDER BY total_spent DESC
        ) AS customer_rank
    FROM CustomerSpending
)

SELECT
    country,
    first_name,
    last_name,
    total_spent
FROM RankedCustomers
WHERE customer_rank = 1
ORDER BY country;
