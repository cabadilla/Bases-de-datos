from flask import Flask,render_template,url_for
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)
app.static_folder = 'static'
@app.route('/')
def login():
    return render_template('login.html')

app.run(port=3000, debug=True)