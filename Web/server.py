from flask import Flask,render_template,url_for,request,redirect
from flask_sqlalchemy import SQLAlchemy
import pyodbc


app = Flask(__name__)
app.static_folder = 'static'




#ruta de inicio donde se hace el login
@app.route('/')
def login():
    return render_template('login.html')

#se entra a la sesion del usuario correcto y se validan los datos
@app.route('/entrar',methods=['POST'])
def entrar():
    nombre = request.form['u']
    contrasena = request.form['p']
    return redirect('/main')

#ruta del menu principal
@app.route('/main')
def main():
    return render_template('main.html')

#ruta de los beneficiarios
@app.route('/beneficiario')
def beneficiario():
    return render_template('beneficiario.html')

#ruta de los estados de cuenta
@app.route('/estadosDeCuenta')
def estadosDeCuenta():
    return render_template('estadosDeCuenta.html')

#ruta para ver la informacion del cliente
@app.route('/informacionPersonal')
def informacionPersonal():
    return render_template('informacionPersonal.html')

app.run(port=3000, debug=True)
