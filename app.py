from flask import Flask, render_template, request, redirect, url_for, session, jsonify, flash
import sqlite3
import os
from werkzeug.security import generate_password_hash, check_password_hash

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


# Route to show university pages
@app.route('/stellies')
def stellies():
    return render_template('University_pages/stellies.html')
@app.route('/uct')
def uct():
    return render_template('University_pages/uct.html')
@app.route('/uj')
def uj():
    return render_template('University_pages/uj.html')
@app.route('/up')
def up():
    return render_template('University_pages/up.html')
@app.route('/wits')
def wits():
    return render_template('University_pages/wits.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        username = request.form.get('username')
        email = request.form.get('email')
        password = request.form.get('password')

        if not username or not email or not password:
            flash("All fields are required.", "danger")
            return render_template('register.html', username=username, email=email)

        password_hash = generate_password_hash(password)

        conn = get_db_connection()
        try:
            conn.execute("INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)", (username, email, password_hash))
            conn.commit()
        except sqlite3.IntegrityError:
            conn.close()
            flash("Username or email already exists.", "danger")
            return render_template('register.html', username=username, email=email)

        conn.close()
        flash("Registration successful. Please log in.", "success")
        return redirect(url_for('login'))

    return render_template('register.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form.get('email')
        password = request.form.get('password')

        # Validate fields
        if not email or not password:
            flash("Please enter both email and password.", "danger")
            return render_template('login.html', email=email)

        conn = get_db_connection()
        user = conn.execute(
            "SELECT * FROM users WHERE email = ?",
            (email,)
        ).fetchone()
        conn.close()

        # Check password
        if user and check_password_hash(user['password_hash'], password):
            session['user_id'] = user['user_id']
            session['username'] = user['username']

            flash(f"Welcome back, {user['username']}!", "success")
            return redirect(url_for('view_home_page'))

        flash("Invalid email or password.", "danger")
        return render_template('login.html', email=email)

    return render_template('login.html')


@app.route('/wishlist', methods=['GET'])
def view_wishlist():
    if 'user_id' not in session:
        flash("You need to log in to view your wishlist.", "danger")
        return redirect(url_for('login'))

    user_id = session['user_id']
    conn = get_db_connection()
    wishlist_items = conn.execute(
        '''SELECT b.book_id, b.title, b.author, b.image_path, b.html_page
           FROM wishlists w
           JOIN books b ON w.book_id = b.book_id
           WHERE w.user_id = ? AND w.update_type='add' ''', 
        (user_id,)
    ).fetchall()
    conn.close()

    return render_template('wishlist.html', wishlist=wishlist_items)

# API endpoint to add a book to wishlist
@app.route('/wishlist/add', methods=['POST'])
def add_to_wishlist():
    if 'user_id' not in session:
        return jsonify({'status': 'error', 'message': 'Not logged in'}), 401

    user_id = session['user_id']
    book_id = request.json.get('book_id')

    conn = get_db_connection()
    # Prevent duplicates
    existing = conn.execute(
        'SELECT * FROM wishlists WHERE user_id = ? AND book_id = ? AND update_type="add"',
        (user_id, book_id)
    ).fetchone()

    if not existing:
        conn.execute(
            'INSERT INTO wishlists (user_id, book_id, update_type) VALUES (?, ?, "add")',
            (user_id, book_id)
        )
        conn.commit()
    conn.close()
    return jsonify({'status': 'success'})

# API endpoint to remove a book from wishlist
@app.route('/wishlist/remove', methods=['POST'])
def remove_from_wishlist():
    if 'user_id' not in session:
        return jsonify({'status': 'error', 'message': 'Not logged in'}), 401

    user_id = session['user_id']
    book_id = request.json.get('book_id')

    conn = get_db_connection()
    conn.execute(
        'DELETE FROM wishlists WHERE user_id = ? AND book_id = ? AND update_type="add"',
        (user_id, book_id)
    )
    conn.commit()
    conn.close()
    return jsonify({'status': 'success'})

if __name__ == "__main__":
    app.run(debug=True)