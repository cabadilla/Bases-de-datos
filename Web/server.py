from flask import Flask,render_template,url_for,request,redirect,flash
from flask_sqlalchemy import SQLAlchemy
import pyodbc

direccion_servidor = 'tcp:serverproyecto.database.windows.net,1433'
nombre_bd = 'ProyectoBasesI'
nombre_usuario = 'allisoncarlos'
password ='ac-12345'
try:
    conexion = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + direccion_servidor+';DATABASE='+nombre_bd+';UID='+nombre_usuario+';PWD=' + password)
    # OK! conexión exitosa
    conexion = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                              direccion_servidor+';DATABASE='+nombre_bd+';UID='+nombre_usuario+';PWD=' + password)
    #OK! conexión exitosa
except Exception as e:
    #Atrapar error
    print("Ocurrió un error al conectar a SQL Server: ", e)

cursor=conexion.cursor()


app = Flask(__name__)
app.static_folder = 'static'

app.secret_key='mysecretkey'

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
    cursor.execute("exec verBeneficiario")
    data=cursor.fetchall()
    #print(data)
    #data=(('1','vsdvdvf','3'),('2','vsdvdvf','5'),('3','vsdvdvf','8'))
    return render_template('beneficiario.html',datos=data)

@app.route('/insertarBene',methods=['POST'])
def insertarBene():
    doc = request.form['valorDoc']
    porcentaje = request.form['porcentaje']
    parentezco = request.form['parentezco']
    flash('valor insertado correctamente')
    return redirect(url_for('beneficiario'))

@app.route('/editarBene/<ide>')
def editarBene(ide):
    flash(ide)
    return redirect(url_for('beneficiario'))

@app.route('/consultarBene')
def consultarBene():
    pass

@app.route('/borrarBene/<ide>')
def borrarBene(ide):
    pass

#ruta de los estados de cuenta
@app.route('/estadosDeCuenta')
def estadosDeCuenta():
    return render_template('estadosDeCuenta.html')

#ruta para ver la informacion del cliente
@app.route('/informacionPersonal')
def informacionPersonal():
    return render_template('informacionPersonal.html')

app.run(port=3000, debug=True)
