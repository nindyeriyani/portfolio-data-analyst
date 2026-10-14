-- ============================================================
-- queries_dasar.sql
-- Kumpulan 10 query SQL dasar
-- ============================================================
-- Penulis   : Nindy Sri Eriyani
-- Tanggal   : Oktober 2026
-- Konteks   : Latihan SQL dasar, program magang Data Analyst,
--             BBPVP Makassar (Periode 1)
-- Database  : SQLite (diuji di DB Browser for SQLite)
-- Sumber    : Data latihan SQLBolt (sqlbolt.com).
-- Tabel     : movies, boxoffice, employees, buildings,
--             north_american_cities
--
-- Cara menjalankan:
--   1. Jalankan data/seed_sqlbolt.sql lebih dulu untuk membuat tabel.
--   2. Jalankan file ini, atau salin satu query ke tab Execute SQL.
--
-- Daftar isi:
--   1. WHERE, LIKE, AND            6. Ekspresi dan alias
--   2. ORDER BY, LIMIT, OFFSET     7. Aggregate
--   3. DISTINCT                    8. GROUP BY
--   4. INNER JOIN                  9. HAVING
--   5. LEFT JOIN dan IS NULL      10. Subquery
-- ============================================================

-- 1. Konsep: WHERE, LIKE, AND (tabel movies)
-- Tampilkan judul dan tahun film yang judulnya mengandung kata 'Story' dan dirilis setelah 1995.
SELECT  title, year 
FROM movies
WHERE title LIKE '%Story%' AND year > 1995;

-- 2. Konsep: ORDER BY, LIMIT, OFFSET (tabel movies)
-- Tampilkan judul dan durasi film terpanjang peringkat ke-2 sampai ke-4.
SELECT title, length_minutes 
FROM  movies
ORDER BY length_minutes DESC
LIMIT 3 OFFSET 1;

-- 3. Konsep: DISTINCT (tabel north_american_cities)
-- Tampilkan daftar negara yang unik, urut abjad.
SELECT DISTINCT country
FROM north_american_cities
ORDER BY country ASC;

-- 4. Konsep: INNER JOIN (tabel movies dan boxoffice)
-- Tampilkan judul, sutradara, dan rating untuk film yang ratingnya di atas 8.0, urut dari rating tertinggi.
SELECT title, director, rating 
FROM movies
INNER JOIN boxoffice
	ON movies.id = boxoffice.movie_id
WHERE rating > 8.0
ORDER BY rating DESC;

-- 5. Konsep: LEFT JOIN dan IS NULL (tabel buildings dan employees)
-- Tampilkan nama gedung dan kapasitasnya untuk gedung yang tidak punya karyawan.
SELECT building_name, capacity
FROM buildings
LEFT JOIN employees
	ON buildings.building_name = employees.building
WHERE employees.building IS NULL;

-- 6. Konsep: ekspresi dan alias (tabel movies dan boxoffice)
-- Tampilkan judul dan total penjualan (domestik + internasional) dalam juta dolar, dibulatkan 1 angka desimal, dengan alias yang jelas. Urutkan dari terbesar dan ambil 5 teratas.
SELECT title, ROUND((domestic_sales + international_sales) / 1000000.0, 1) AS total_sales
FROM movies
INNER JOIN boxoffice
	ON movies.id = boxoffice.movie_id
ORDER BY total_sales DESC
LIMIT 5;

-- 7. Konsep: aggregate (tabel boxoffice)
-- Dalam satu baris, tampilkan rata-rata rating (2 desimal), rating tertinggi, dan rating terendah.
SELECT 
	ROUND((AVG (rating)), 2) AS rata_rata,
	MAX(rating) AS rating_tertinggi,
	MIN(rating) AS rating_terendah
FROM boxoffice;

-- 8. Konsep: GROUP BY (tabel movies)
-- Untuk tiap sutradara, tampilkan jumlah film dan rata-rata durasi (1 desimal), urut dari jumlah film terbanyak.
SELECT director,
	COUNT(*) AS jumlah_film,
	AVG(length_minutes) AS rata_rata
FROM movies
GROUP BY director
ORDER BY jumlah_film DESC

-- 9. Konsep: HAVING (tabel movies dan boxoffice)
-- Tampilkan sutradara yang rata-rata ratingnya di atas 8, beserta rata-ratanya (2 desimal), urut dari tertinggi.
SELECT director, rating,
	ROUND(AVG(rating), 2) AS rata_rata
FROM movies
INNER JOIN boxoffice
	ON movies.id = boxoffice.movie_id
GROUP BY director
HAVING AVG(rating) > 8.0
ORDER BY rata_rata DESC;

-- 10. Konsep: subquery (tabel movies)
-- Tampilkan judul dan durasi film yang durasinya lebih panjang dari rata-rata durasi seluruh film, urut dari terpanjang.
SELECT title, length_minutes
FROM movies
WHERE length_minutes > (SELECT  AVG(length_minutes) FROM movies)
ORDER BY length_minutes DESC;