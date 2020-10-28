from flask import Flask,render_template,url_for,request
from flask_sqlalchemy import SQLAlchemy


app = Flask(__name__)
app.static_folder = 'static'
@app.route('/')
def login(methods=['GET']):
    return render_template('login.html')

@app.route('/nombres',methods=['POST'])
def nombres():
    nombre = request.form['u']
    contrasena = request.form['p']
    return 'Hola ' + nombre + ' ' + contrasena


app.run(port=3000, debug=True)