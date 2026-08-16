# music-store-sql-analysis
SQL project analyzing a music store's sales, customers, and artist trends using multi-table joins, subqueries, and window functions.
# 🎵 Music Store Data Analysis (SQL Project)

A relational database and SQL analysis project built on a 10-table music store schema (Chinook-style database), covering customers, invoices, tracks, albums, artists, genres, and employees. This project demonstrates database design, complex multi-table joins, aggregations, subqueries, and window functions to answer real business questions.

## 📌 Project Overview

This project simulates a digital music store's backend database. Using SQL, I designed a normalized relational schema and answered 11 business questions covering sales trends, customer behavior, artist popularity, and country-wise music preferences.

## 📁 Repository Structure
```
├── sql/ → Full SQL script (schema + analysis queries)
├── data/ → Source CSV files (11 tables)
├── presentation/ → Project presentation (PDF)
└── README.md
```
## 🧱 Database Schema

The database consists of 11 interrelated tables:

| Table | Description |
|---|---|
| `Genre` | Music genres |
| `MediaType` | Audio file formats |
| `Employee` | Staff details, including reporting hierarchy |
| `Customer` | Customer contact and support rep details |
| `Artist` | Music artists |
| `Album` | Albums linked to artists |
| `Track` | Individual songs, linked to album, genre, and media type |
| `Invoice` | Customer purchase invoices |
| `InvoiceLine` | Line-item details per invoice |
| `Playlist` | Playlists|
|`PlaylistTrack` | Playlists and their tracks |

**Relationships:** Customer → Invoice → InvoiceLine → Track → Album → Artist / Genre, with Employee linked to Customer via `support_rep_id`.


## ❓ Business Questions Answered

1. Who is the senior most employee based on job title?
2. Which countries have the most invoices?
3. What are the top 3 values of total invoice?
4. Which city has the best customers (highest total invoice value)?
5. Who is the best customer by total amount spent?
6. Which customers listen to Rock music? (email, name, genre)
7. Which artists have written the most rock tracks? (Top 10)
8. Which tracks are longer than the average song length?
9. How much has each customer spent per artist?
10. What is the most popular genre in each country?
11. Who is the top-spending customer in each country?

## 🔧 Tools & Techniques Used

- MySQL / MySQL Workbench
- Multi-table `JOIN`s across up to 5 tables
- Aggregate functions (`SUM`, `COUNT`, `AVG`)
- Subqueries and Common Table Expressions (CTEs)
- Window functions (`RANK()`) for tie-aware ranking
- Data cleaning: resolving foreign key import failures and NULL handling

## 📊 Key Insights

- A small number of cities and countries account for a disproportionate share of total revenue.
- Rock is the most consistently popular genre across markets.
- Top-spending customers vary significantly by country, useful for region-specific marketing.

*(See the full [presentation](presentation) for detailed insights and visuals.)*

## 🚀 How to Run

1. Clone this repository.
2. Open MySQL Workbench (or any MySQL client) and run `sql/` to create the schema.
3. Import each CSV in `data/` into its corresponding table via Table Data Import Wizard (or `LOAD DATA INFILE`).
4. Run the numbered analysis queries at the bottom of the SQL file.

## 📁 Dataset Source

Based on the Chinook sample database structure, adapted for this project.

---

**Author:** D.Vishnu vardhan reddy  
**Connect:**
[LinkedIn](https://www.linkedin.com/in/vishnureddy17)|
[GitHub](https://github.com/Vishnureddie1)
