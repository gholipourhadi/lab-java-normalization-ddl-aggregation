-- ================================================
-- Blog Database (Improved)
-- ================================================

CREATE TABLE authors (
                         id INT PRIMARY KEY AUTO_INCREMENT,
                         name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE posts (
                       id INT PRIMARY KEY AUTO_INCREMENT,
                       author_id INT NOT NULL,
                       title VARCHAR(200) NOT NULL,
                       word_count INT NOT NULL CHECK (word_count > 0),
                       views INT NOT NULL CHECK (views >= 0),
                       FOREIGN KEY (author_id) REFERENCES authors(id)
                           ON DELETE CASCADE
);

CREATE INDEX idx_posts_author_id ON posts(author_id);

-- Insert authors
INSERT INTO authors (name) VALUES
                               ('Maria Charlotte'),
                               ('Juan Perez'),
                               ('Gemma Alcocer');

-- Insert posts
INSERT INTO posts (author_id, title, word_count, views) VALUES
                                                            (1, 'Best Paint Colors', 814, 14),
                                                            (2, 'Small Space Decorating Tips', 1146, 221),
                                                            (1, 'Hot Accessories', 986, 105),
                                                            (1, 'Mixing Textures', 765, 22),
                                                            (2, 'Kitchen Refresh', 1242, 307),
                                                            (1, 'Homemade Art Hacks', 1002, 193),
                                                            (3, 'Refinishing Wood Floors', 1571, 7542);


-- ================================================
-- Airline Database (Improved)
-- ================================================

CREATE TABLE aircraft (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          name VARCHAR(100) NOT NULL UNIQUE,
                          total_seats INT NOT NULL CHECK (total_seats > 0)
);

CREATE TABLE flights (
                         flight_number VARCHAR(10) PRIMARY KEY,
                         aircraft_id INT NOT NULL,
                         mileage INT NOT NULL CHECK (mileage > 0),
                         FOREIGN KEY (aircraft_id) REFERENCES aircraft(id)
                             ON DELETE CASCADE
);

CREATE TABLE customers (
                           id INT PRIMARY KEY AUTO_INCREMENT,
                           name VARCHAR(100) NOT NULL,
                           status ENUM('None', 'Silver', 'Gold') NOT NULL,
                           total_mileage INT NOT NULL CHECK (total_mileage >= 0)
);

CREATE TABLE bookings (
                          id INT PRIMARY KEY AUTO_INCREMENT,
                          customer_id INT NOT NULL,
                          flight_number VARCHAR(10) NOT NULL,
                          FOREIGN KEY (customer_id) REFERENCES customers(id)
                              ON DELETE CASCADE,
                          FOREIGN KEY (flight_number) REFERENCES flights(flight_number)
                              ON DELETE CASCADE,
                          UNIQUE (customer_id, flight_number)
);

-- Indexes
CREATE INDEX idx_bookings_customer_id ON bookings(customer_id);
CREATE INDEX idx_bookings_flight_number ON bookings(flight_number);
CREATE INDEX idx_flights_aircraft_id ON flights(aircraft_id);

-- Insert aircraft
INSERT INTO aircraft (name, total_seats) VALUES
                                             ('Boeing 747', 400),
                                             ('Airbus A330', 236),
                                             ('Boeing 777', 264);

-- Insert flights
INSERT INTO flights (flight_number, aircraft_id, mileage) VALUES
                                                              ('DL143', 1, 135),
                                                              ('DL122', 2, 4370),
                                                              ('DL53', 3, 2078),
                                                              ('DL222', 3, 1765),
                                                              ('DL37', 1, 531);

-- Insert customers
INSERT INTO customers (name, status, total_mileage) VALUES
                                                        ('Agustine Riviera', 'Silver', 115235),
                                                        ('Alaina Sepulvida', 'None', 6008),
                                                        ('Tom Jones', 'Gold', 205767),
                                                        ('Sam Rio', 'None', 2653),
                                                        ('Jessica James', 'Silver', 127656),
                                                        ('Ana Janco', 'Silver', 136773),
                                                        ('Jennifer Cortez', 'Gold', 300582),
                                                        ('Christian Janco', 'Silver', 14642);

-- Insert bookings
INSERT INTO bookings (customer_id, flight_number) VALUES
                                                      (1, 'DL143'),
                                                      (1, 'DL122'),
                                                      (2, 'DL122'),
                                                      (3, 'DL122'),
                                                      (3, 'DL53'),
                                                      (4, 'DL143'),
                                                      (3, 'DL222'),
                                                      (5, 'DL143'),
                                                      (6, 'DL222'),
                                                      (7, 'DL222'),
                                                      (5, 'DL122'),
                                                      (4, 'DL37'),
                                                      (8, 'DL222');


-- ================================================
-- Queries (Improved)
-- ================================================

-- 1. Total number of flights
SELECT COUNT(*) FROM flights;

-- 2. Average flight distance
SELECT AVG(mileage) FROM flights;

-- 3. Average number of seats per aircraft
SELECT AVG(total_seats) FROM aircraft;

-- 4. Average miles flown by customers, grouped by status
SELECT status, AVG(total_mileage)
FROM customers
GROUP BY status;

-- 5. Max miles flown by customers, grouped by status
SELECT status, MAX(total_mileage)
FROM customers
GROUP BY status;

-- 6. Number of aircraft with "Boeing" in their name
SELECT COUNT(*)
FROM aircraft
WHERE name LIKE '%Boeing%';

-- 7. Flights with distance between 300 and 2000 miles
SELECT *
FROM flights
WHERE mileage BETWEEN 300 AND 2000;

-- 8. Average flight distance booked, grouped by customer status
SELECT c.status, AVG(f.mileage)
FROM bookings b
         JOIN customers c ON b.customer_id = c.id
         JOIN flights f ON b.flight_number = f.flight_number
GROUP BY c.status;

-- 9. Most booked aircraft among Gold status members
SELECT a.name, COUNT(*) AS total_bookings
FROM bookings b
         JOIN customers c ON b.customer_id = c.id
         JOIN flights f ON b.flight_number = f.flight_number
         JOIN aircraft a ON f.aircraft_id = a.id
WHERE c.status = 'Gold'
GROUP BY a.name
ORDER BY total_bookings DESC
    LIMIT 1;