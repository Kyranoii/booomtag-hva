from flask import Flask, jsonify
import mysql.connector
import os

app = Flask(__name__)


def get_db_connection():
    return mysql.connector.connect(
        host=os.environ["DB_HOST"],
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"],
    )


@app.route("/")
def root():
    return "App is running. Use /loadtest or /health.", 200


@app.route("/loadtest")
def loadtest():
    db = get_db_connection()
    cursor = db.cursor(dictionary=True)

    cursor.execute(
        "SELECT firstname, lastname, email FROM users LIMIT 20;"
    )
    rows = cursor.fetchall()

    cursor.close()
    db.close()

    return jsonify(rows)


@app.route("/health")
def health():
    return jsonify({"status": "ok"})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)




# from flask import Flask, request, jsonify
# import mysql.connector
# import os

# app = Flask(__name__)


# def get_db_connection():
#     return mysql.connector.connect(
#         host=os.environ["DB_HOST"],
#         user=os.environ["DB_USER"],
#         password=os.environ["DB_PASSWORD"],
#         database=os.environ["DB_NAME"],
#     )


# # @app.route("/")
# # def home():
# #     # Get current page from query string
# #     page = request.args.get("page", default=1, type=int)
# #     limit = 100
# #     offset = (page - 1) * limit

# #     db = get_db_connection()
# #     cursor = db.cursor(dictionary=True)

# #     # Get current page rows
# #     cursor.execute(
# #         "SELECT id, firstname, lastname, email FROM users LIMIT %s OFFSET %s;",
# #         (limit, offset),
# #     )
# #     rows = cursor.fetchall()

# #     # Check if a next page exists
# #     cursor.execute("SELECT COUNT(*) AS total FROM users;")
# #     total = cursor.fetchone()["total"]

# #     cursor.close()
# #     db.close()

# #     has_next = total > page * limit
# #     has_prev = page > 1

# #     # render custom HTML table
# #     html = """
# # <html>
# # <head>
# # <title>User List</title>
# # <style>
# #     body {
# #         background-color: #0b0f19;
# #         color: #e0e6f0;
# #         font-family: Arial, sans-serif;
# #         padding: 20px;
# #     }
# #     h1 {
# #         text-align: center;
# #         color: #7ab8ff;
# #         margin-bottom: 30px;
# #     }
# #     table {
# #         width: 90%;
# #         margin: 0 auto;
# #         border-collapse: collapse;
# #         background-color: #111827;
# #         border-radius: 10px;
# #         overflow: hidden;
# #     }
# #     th, td {
# #         padding: 12px 15px;
# #         text-align: left;
# #         border-bottom: 1px solid #1f2937;
# #     }
# #     th {
# #         background-color: #1e3a8a;
# #         color: #dbeafe;
# #     }
# #     tr:hover {
# #         background-color: #1f2937;
# #     }
# #     .pagination {
# #         width: 90%;
# #         margin: 20px auto;
# #         text-align: center;
# #     }
# #     .pagination a {
# #         display: inline-block;
# #         padding: 10px 20px;
# #         margin: 5px;
# #         color: #dbeafe;
# #         background-color: #1e3a8a;
# #         border-radius: 6px;
# #         text-decoration: none;
# #     }
# #     .pagination a:hover {
# #         background-color: #3b82f6;
# #     }
# #     .disabled {
# #         opacity: 0.5;
# #         pointer-events: none;
# #     }
# # </style>
# # </head>
# # <body>
# # <h1>User Database</h1>
# # <table>
# # <tr><th>ID</th><th>Firstname</th><th>Lastname</th><th>Email</th></tr>
# #     """

# #     for row in rows:
# #         html += (
# #             f"<tr><td>{row['id']}</td>"
# #             f"<td>{row['firstname']}</td>"
# #             f"<td>{row['lastname']}</td>"
# #             f"<td>{row['email']}</td></tr>"
# #         )

# #     html += "</table>"

# #     # Pagination controls
# #     html += '<div class="pagination">'

# #     # Previous button
# #     if has_prev:
# #         html += f'<a href="/?page={page-1}">Previous</a>'
# #     else:
# #         html += '<a class="disabled">Previous</a>'

# #     # Next button
# #     if has_next:
# #         html += f'<a href="/?page={page+1}">Next</a>'
# #     else:
# #         html += '<a class="disabled">Next</a>'

# #     html += "</div>"

# #     html += """
# # </body>
# # </html>
# #     """

# #     return html


# @app.route("/loadtest")
# def loadtest():
#     """
#     Lichte endpoint speciaal voor k6-loadtests:
#     - kleine SELECT
#     - geen HTML, alleen JSON
#     - 1 query, geen pagination
#     """
#     db = get_db_connection()
#     cursor = db.cursor(dictionary=True)

#     # lichte query: alleen de kolommen die we nodig hebben, beperkte set
#     cursor.execute(
#         "SELECT id, firstname, lastname, email FROM users LIMIT 20;"
#     )
#     rows = cursor.fetchall()

#     cursor.close()
#     db.close()

#     return jsonify(rows)


# @app.route("/health")
# def health():
#     return jsonify({"status": "ok"})


# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=80)



