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
DROP TABLE IF EXISTS inventory;

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
    isbn VARCHAR(20) UNIQUE,
    html_page VARCHAR(255),
    image_path VARCHAR(255)
);

-- Create wishlists table
create table wishlists (
    wishlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    update_type TEXT NOT NULL CHECK (update_type IN ('add', 'remove', 'set')),
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

-- Create inventory table
create table inventory (
    inventory_id INTEGER PRIMARY KEY AUTOINCREMENT,
    book_id INTEGER NOT NULL,
    vendor_id INTEGER NOT NULL,
    stock_level INTEGER DEFAULT 0,
    book_type VARCHAR(50) DEFAULT 'new' CHECK (book_type IN ('New', 'Used', 'eBook')),
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (vendor_id) REFERENCES vendors(vendor_id) ON DELETE CASCADE,
    UNIQUE (book_id, vendor_id)
);

-- Insert sample data into users table
INSERT INTO users (username, email, password_hash) VALUES ('Tonya', 'u23748878@tuks.co.za', 'Tony@878');
INSERT INTO users (username, email, password_hash) VALUES ('Tiana', 'u23560445@tuks.co.za', 'Ti@naGrobler445');
INSERT INTO users (username, email, password_hash) VALUES ('Leandri', 'u23539331@tuks.co.za', 'Le@ndri$wanepoel331');
INSERT INTO users (username, email, password_hash)VALUES ('Kaylin' ,'u23555557@tuks.co.za', 'K@ylin557');
INSERT INTO users (username, email, password_hash) VALUES ('Ibrahim', 'ibrahim.akanbi@tuks.co.za', 'Ibr@him100');
SELECT* from users;

-- Insert sample data into books table
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Basic Accounting for Non-Accountants (4th Edition)', 'Melanie Cloete, Ferina Marimuthu', '9780627038907', 'accounting-textbook.html', 'textbook-images/basic-accounting-for-non-accountants-textbook.webp');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Calculus: Early Transcendentals (9th Edition)', 'James Stewart, Daniel Clegg, Saleem Watsona', '9780357113516', 'calculus-textbook.html', 'textbook-images/calculus-textbook.jpeg');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Chemistry and Chemical Reactivity (10th Edition)', 'Kotz, Treichel, Townsend', '9781337399074', 'chemistry-textbook.html', 'textbook-images/chemistry-textbook.jpeg');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Differential Equations with Boundary Value Problems (9th Edition)', 'Dennis G. Zill', '9781337559881', 'differential-equations-textbook.html', 'textbook-images/differential-equations-textbook.webp');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Physics for Scientists and Engineers (10th Edition)', 'Serway, Jewett', '9781337553292', 'physics-textbook.html', 'textbook-images/physics-for-engineers-textbook.jpeg');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Engineering Mechanics: Dynamics (8th Edition)', 'Meriam, Kraige, Bolton', '9781118885840', 'engineering-mechanics-textbook.html', 'textbook-images/dynamics-textbook.webp');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Mechanical Engineering Design (11th Edition)', 'Richard G. Budynas, J. Keith Nisbett', '9789813158986', 'mechanical-engineering-design-textbook.html ', 'textbook-images/mechanical-engineering-design.jpg');
INSERT INTO books (title, author, isbn, html_page, image_path) VALUES ('Supply Chain Management: A Logistics Perspective (12th Edition)', 'Langley, Novack, Gibson, Coyle', '9780357984925', 'supply-chain-management-textbook.html', 'textbook-images/supply-chain-management-textbook.jpeg');
SELECT* from books;


--Insert sample data into institutions table
INSERT INTO institutions (name, address) VALUES ('Stellenbosch University', 'Plein Street, Stellenbosch, 7600');
INSERT INTO institutions (name, address) VALUES ('University of Pretoria', 'Lynnwood Rd, Hatfield, Pretoria, 0002');
INSERT INTO institutions (name, address) VALUES ('University of Witwatersrand', '1 Jan Smuts Ave, Braamfontein, Johannesburg, 2000');
INSERT INTO institutions (name, address) VALUES ('University of Cape Town', 'Rondebosch, Cape Town, 7701');
INSERT INTO institutions (name, address) VALUES ('University of Johannesburg', 'Auckland Park, Johannesburg, 2006');
SELECT* from institutions;

--Insert into wishlists to show activity
INSERT INTO wishlists (user_id, book_id, update_type) VALUES (1, 2, 'add');
INSERT INTO wishlists (user_id, book_id, update_type) VALUES (2, 3, 'add');
SELECT* from wishlists;

--Insert sample data into vendors table
INSERT INTO vendors (name, contact_email, website_url) VALUES ('WizeBooks', 'wizebooks@gmail.com', 'https://www.wizebooks.co.za/');
INSERT INTO vendors (name, contact_email, website_url) VALUES ('Amazon', 'amazon@gmail.com', 'https://www.amazon.co.za/');
INSERT INTO vendors (name, contact_email, website_url) VALUES ('Takealot', 'takealot@gmail.com', 'https://www.takealot.com/');
INSERT INTO vendors (name, contact_email, website_url) VALUES ('Textbook Trader', 'textbooktrader@gmail.com', 'https://www.textbooktrader.co.za/');
INSERT INTO vendors (name, contact_email, website_url) VALUES ('BobShop', 'bobshop@gmail.com', 'https://www.bobshop.co.za/');
INSERT INTO vendors (name, contact_email, website_url) VALUES ('UP Library', 'up@ac.za', 'https://www.library.up.ac.za/home');
SELECT* from vendors;

-- Insert sample data into inventory table
INSERT INTO inventory (book_id, vendor_id, book_type, price) VALUES (1, 1, 'New', 779.00);
INSERT INTO inventory (book_id, vendor_id, book_type, price) VALUES (1, 2, 'New', 679.99);
INSERT INTO inventory (book_id, vendor_id, book_type, price) VALUES (1, 3, 'New', 810.00);
INSERT INTO inventory (book_id, vendor_id, book_type, price) VALUES (1, 4, 'Used', 599.00);
INSERT INTO inventory (book_id, vendor_id, book_type, price) VALUES (1, 5, 'Used', 560.00);
INSERT INTO inventory (book_id, vendor_id, book_type, price) VALUES (1, 6, 'eBook', 0.00);
SELECT* from inventory; 

-- Insert sample data into institutions table
INSERT INTO institutions (name) VALUES ('University of Pretoria');
INSERT INTO institutions (name) VALUES ('University of Cape Town');
INSERT INTO institutions (name) VALUES ('Stellenbosch University');
INSERT INTO institutions (name) VALUES ('University of the Witwatersrand');
INSERT INTO institutions (name) VALUES ('University of Johannesburg');

-- Insert sample data into courses table
INSERT INTO courses (institution_id, name, course_code) VALUES (1, 'Fincancial Accounting', 'FBS120');
INSERT INTO courses (institution_id, name, course_code) VALUES (2, 'Introduction to Accounting', 'ACC101');
INSERT INTO courses (institution_id, name, course_code) VALUES (3, 'Managerial Accounting', 'MGT150');
INSERT INTO courses (institution_id, name, course_code) VALUES (4, 'Financial Analysis', 'FIN210');
INSERT INTO courses (institution_id, name, course_code) VALUES (5, 'Basics of Accounting', 'BAC100');

-- Insert sample data into course_books table
INSERT INTO course_books (course_id, book_id) VALUES (1, 1);
INSERT INTO course_books (course_id, book_id) VALUES (2, 1);
INSERT INTO course_books (course_id, book_id) VALUES (3, 1);
INSERT INTO course_books (course_id, book_id) VALUES (4, 1);
INSERT INTO course_books (course_id, book_id) VALUES (5, 1);
SELECT* from course_books;

