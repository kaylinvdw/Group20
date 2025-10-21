create table IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table IF NOT EXISTS books (
    book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) UNIQUE
);

create table IF NOT EXISTS wishlists (
    wishlist_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    UNIQUE (user_id, book_id)
);

create table IF NOT EXISTS institutions (
    institution_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

create table IF NOT EXISTS courses (
    course_id INTEGER PRIMARY KEY AUTOINCREMENT,
    institution_id INTEGER NOT NULL,
    name VARCHAR(255) NOT NULL,
    course code VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (institution_id) REFERENCES institutions(institution_id) ON DELETE CASCADE
);


create table IF NOT EXISTS course_books (
    course_book_id INTEGER PRIMARY KEY AUTOINCREMENT,
    course_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    UNIQUE (course_id, book_id)
);

create table IF NOT EXISTS vendors (
    vendor_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    contact_email VARCHAR(100) UNIQUE,
    website_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

--INSERT INTO users VALUES (1,"Tonya", "u23748878@tuks.co.za", "Tony@878", "2024-06-01 10:00:00", "2024-06-01 10:00:00");
-- INSERT INTO users VALUES (2,"Tiana", "u23560445@tuks.co.za", "Ti@naGrobler445", "2024-06-01 10:00:00", "2024-06-01 10:00:00");
-- INSERT INTO users VALUES (3,"Leandri", "u23539331@tuks.co.za", "Le@ndri$wanepoel331", "2024-06-01 10:00:00", "2024-06-01 10:00:00");
-- INSERT INTO users VALUES (4,"Kaylin", "u23555557@tuks.co.za", "K@ylin557", "2024-06-01 10:00:00", "2024-06-01 10:00:00");
-- INSERT INTO users VALUES (5,"Ibrahim", "ibrahim.akanbi@tuks.co.za", "Ibr@him100", "2024-06-01 10:00:00", "2024-06-01 10:00:00");
-- SELECT* from users;

--still has the three extra columns, how to delete that!
-- INSERT INTO books (book_id, title, author, isbn) VALUES (1, "Basic Accounting for Non-Accountants (4th Edition)", "Melanie Cloete, Ferina Marimuthu", "9780627038907");
-- INSERT INTO books (book_id, title, author, isbn) VALUES (2, "Calculus: Early Transcendentals (9th Edition)", "James Stewart, Daniel Clegg, Saleem Watsona", " 9780357113516");
-- INSERT INTO books (book_id, title, author, isbn) VALUES (3, "Chemistry and Chemical Reactivity (10th Edition)", "Kotz, Treichel, Townsend", "9781337399074");
-- INSERT INTO books (book_id, title, author, isbn)  VALUES (4, "Differential Equations with Boundary Value Problems (9th Edition)", "Dennis G. Zill", "9781337559881");
-- INSERT INTO books (book_id, title, author, isbn)  VALUES (5, "Physics for Scientists and Engineers (10th Edition)", "Serway, Jewett", "9781337553292");
-- INSERT INTO books (book_id, title, author, isbn)  VALUES (6, "Engineering Mechanics: Dynamics (8th Edition)", "Meriam, Kraige, Bolton", "9781118885840");
-- INSERT INTO books (book_id, title, author, isbn)  VALUES (7, "Mechanical Engineering Design (11th Edition)", "Richard G. Budynas, J. Keith Nisbett", "9789813158986");
-- INSERT INTO books (book_id, title, author, isbn)  VALUES (8, "Supply Chain Management: A Logistics Perspective (12th Edition)", "Langley, Novack, Gibson, Coyle", "9780357984925");
-- SELECT* from books;

-- INSERT INTO wishlists (1, 1, 2, "2024-06-01 12:00:00");

INSERT INTO institutions (1, "Stellenbosch University", "Plein Street, Stellenbosch, 7600");
INSERT INTO institutions (2, "University of Pretoria", "Lynnwood Rd, Hatfield, Pretoria, 0002");
INSERT INTO institutions (3, "University of the Witwatersrand", "1 Jan Smuts Ave, Braamfontein, Johannesburg, 2000");
INSERT INTO institutions (4, "University of Cape Town", "Rondebosch, Cape Town, 7701");
INSERT INTO institutions (5, "University of Johannesburg", "Auckland Park, Johannesburg, 2006");
SELECT* from institutions;

