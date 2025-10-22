--Database: data.db

-- Enable foreign key constraints
PRAGMA foreign_keys = OFF;

-- Drop tables if they exist (for clean setup)
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS wishlists;
DROP TABLE IF EXISTS institutions;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS course_books;
DROP TABLE IF EXISTS vendors;

PRAGMA foreign_keys = ON;


-- Create users table
create table users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create books table
create table books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE
);

-- Create wishlists table
create table wishlists (
    wishlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    UNIQUE (user_id, book_id)
);

-- Create institutions table
create table institutions (
    institution_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create courses table
create table courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    institution_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    course_code VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE
);

-- Create course_books junction table
create table course_books (
    course_book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    UNIQUE (course_id, book_id)
);

-- Create vendors table
create table vendors (
    vendor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    website_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data into users table
INSERT INTO users (username, email, password_hash) VALUES ('Tonya', 'u23748878@tuks.co.za', 'Tony@878');
INSERT INTO users (username, email, password_hash) VALUES ('Tiana', 'u23560445@tuks.co.za', 'Ti@naGrobler445');
INSERT INTO users (username, email, password_hash) VALUES ('Leandri', 'u23539331@tuks.co.za', 'Le@ndri$wanepoel331');
INSERT INTO users (username, email, password_hash) VALUES ('Kaylin' ,'u23555557@tuks.co.za', 'K@ylin557');
INSERT INTO users (username, email, password_hash) VALUES ('Ibrahim', 'ibrahim.akanbi@tuks.co.za', 'Ibr@him100');
SELECT* from users;

-- Insert sample data into books table
--still has the three extra columns, how to delete that!
INSERT INTO books (title, author, isbn) VALUES ('Basic Accounting for Non-Accountants (4th Edition', 'Melanie Cloete, Ferina Marimuthu', '9780627038907');
INSERT INTO books (title, author, isbn) VALUES ('Calculus: Early Transcendentals (9th Edition)', 'James Stewart, Daniel Clegg, Saleem Watsona', '9780357113516');
INSERT INTO books (title, author, isbn) VALUES ('Chemistry and Chemical Reactivity (10th Edition', 'Kotz, Treichel, Townsend', '9781337399074');
INSERT INTO books (title, author, isbn) VALUES ('Differential Equations with Boundary Value Problems (9th Edition)', 'Dennis G. Zill', '9781337559881');
INSERT INTO books (title, author, isbn) VALUES ('Physics for Scientists and Engineers (10th Edition)', 'Serway, Jewett', '9781337553292');
INSERT INTO books (title, author, isbn) VALUES ('Engineering Mechanics: Dynamics (8th Edition)', 'Meriam, Kraige, Bolton', '9781118885840');
INSERT INTO books (title, author, isbn) VALUES ('Mechanical Engineering Design (11th Edition)', 'Richard G. Budynas, J. Keith Nisbett', '9789813158986');
INSERT INTO books (title, author, isbn) VALUES ('Supply Chain Management: A Logistics Perspective (12th Edition)', 'Langley, Novack, Gibson, Coyle', '9780357984925');
SELECT* from books;



--Insert sample data into institutions table
INSERT INTO institutions ('Stellenbosch University', 'Plein Street, Stellenbosch, 7600');
INSERT INTO institutions ('University of Pretoria', 'Lynnwood Rd, Hatfield, Pretoria, 0002');
INSERT INTO institutions ('University of the Witwatersrand', '1 Jan Smuts Ave, Braamfontein, Johannesburg, 2000');
INSERT INTO institutions ('University of Cape Town', 'Rondebosch, Cape Town, 7701');
INSERT INTO institutions ('University of Johannesburg', 'Auckland Park, Johannesburg, 2006');
SELECT* from institutions;

--Insert into wishlists to show activity
INSERT INTO wishlists (user_id, book_id) VALUES (1, 2);
INSERT INTO wishlists (user_id, book_id) VALUES (2, 3);
SELECT* from wishlists;
