from flask import Flask, render_template, request, redirect, url_for
import sqlite3
import os

app = Flask(__name__)
app.secret_key = 'your-secret-key-here'

# Database connection
def get_db_connection():
    conn = sqlite3.connect('data.db')
    conn.row_factory = sqlite3.Row
    return conn

# Route for the home page & statistics
@app.route('/')
def view_home_page():
    conn = get_db_connection()

    vendor_count = conn.execute('SELECT COUNT(*) FROM vendors').fetchone()[0]
    textbook_count = conn.execute('SELECT COUNT(*) FROM books').fetchone()[0]
    course_count = conn.execute('SELECT COUNT(*) FROM courses').fetchone()[0]
    university_count = conn.execute('SELECT COUNT(*) FROM institutions').fetchone()[0]

    conn.close()

    max_count = max(vendor_count, textbook_count, course_count, university_count)
    vendor_percent = int(vendor_count / max_count * 100)
    textbook_percent = int(textbook_count / max_count * 100)
    course_percent = int(course_count / max_count * 100)
    university_percent = int(university_count / max_count * 100)


    return render_template(
        'index.html',
        vendor_count=vendor_count,
        textbook_count=textbook_count,
        course_count=course_count,
        university_count=university_count,
        vendor_percent=vendor_percent,
        textbook_percent=textbook_percent,
        course_percent=course_percent,
        university_percent=university_percent
    )


# Route to show all books
@app.route('/newBooks')
def view_textbooks_page():
    conn = get_db_connection()

    books = conn.execute('SELECT * FROM books').fetchall()
    conn.close()
    return render_template('newBooks.html', books=books)

# Route to show individual textbook pages
@app.route('/Textbook_pages/<book_page>')
def view_individual_textbook(book_page):
    conn = get_db_connection()

    book = conn.execute('SELECT * FROM books WHERE html_page = ?', (book_page,)).fetchone()
    if not book:
        conn.close()
        return "Textbook not found", 404

    inventory_rows = conn.execute(
        'SELECT i.book_type, v.name AS vendor_name, v.website_url, i.price FROM inventory i JOIN vendors v ON i.vendor_id = v.vendor_id WHERE i.book_id = ? ORDER BY i.price',
        (book['book_id'],)
    ).fetchall()

    linked_courses = conn.execute(
        'SELECT c.name AS course_name, c.course_code, ins.name AS institution_name FROM course_books cb JOIN courses c ON cb.course_id = c.course_id JOIN institutions ins ON c.institution_id = ins.institution_id WHERE cb.book_id = ? ORDER BY ins.name',
        (book['book_id'],)
    ).fetchall()

    conn.close()

    return render_template(
        f'Textbook_pages/{book_page}', book=book, inventory_rows=inventory_rows, linked_courses=linked_courses
    )

@app.route('/addBook', methods=['GET', 'POST'])
def add_book():
    if request.method == 'POST':
        # These are ONLY executed if the form was submitted
        title = request.form.get('title')
        author = request.form.get('author')
        isbn = request.form.get('isbn')

        conn = get_db_connection()
        conn.execute(
            'INSERT INTO books (title, author, isbn) VALUES (?, ?, ?)',
            (title, author, isbn)
        )
        conn.commit()
        conn.close()

        return redirect('/newBooks')  # Your listing page

    # If GET request → show the form
    return render_template('addTextbook.html')


if __name__ == "__main__":
    app.run(debug=True)