from flask import Flask,render_template,url_for,request,redirect,flash,session
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
    cursor.execute("exec verUsuario "+contrasena+","+nombre)
    data=cursor.fetchall()
    if data==[]:
        flash('Digite un usuario o contrasena validos')
        return redirect('/')
    else:
        session['usuario']=data[0][0]
        session['contrasena']=data[0][1]
        session['admin']=data[0][2]

    cursor.execute("exec verUsuarioVer "+session['usuario'])
    data=cursor.fetchall()
    session['numeroDeCuenta']=data[0][1]
    return redirect('/main')

@app.route('/volverAlMenu')
def volverAlMenu():
    return redirect('/main')

#ruta del menu principal
@app.route('/main')
def main():
    return render_template('main.html')

#ruta de los beneficiarios
@app.route('/beneficiario')
def beneficiario():
    numeroDeCuenta=session['numeroDeCuenta']
    cursor.execute("exec verBeneficiario "+str(numeroDeCuenta))
    data=cursor.fetchall()
    cursor.commit()
    #data=(('1','vsdvdvf','3'),('2','vsdvdvf','5'),('3','vsdvdvf','8'))
    return render_template('beneficiario.html',datos=data)

@app.route('/insertarBene',methods=['POST'])
def insertarBene():
    doc = request.form['valorDoc']
    porcentaje = request.form['porcentaje']
    parentezco = request.form['parentezco']
    cuenta=session["numeroDeCuenta"]

    cursor.execute("exec verPorcentaje "+str(cuenta))
    sumaPorcentaje=cursor.fetchall()
    suma=sumaPorcentaje[0][0]

    if suma+int(porcentaje)<=100:
        cursor.execute("exec insertarBeneficiario "+str(porcentaje)+","+str(cuenta)+","+str(parentezco)+","+str(doc)+",0")
        data=cursor.fetchall()
        cursor.commit()
        if data[0][0]==1:
            if suma+int(porcentaje)==100:
                flash('valor insertado correctamente')
            else:
                flash('valor insertado correctamente, recuerde que la suma de los tres beneficiarios debe de ser 100')
        else:
            flash('Solo pueden existir tres beneficiarios asociados a una cuenta')
    else:
        flash('La suma de los porcentaje no puden pasar de 100, cambie el valor')
    return redirect(url_for('beneficiario'))

@app.route('/editarBene/<ide>')
def editarBene(ide):
    return render_template("editarBene.html",doc=ide)

@app.route('/mandarEdit/<doc>',methods=['POST'])
def mandarEdit(doc):
    porcentaje = request.form['porcentaje']
    parentezco = request.form['parentezco']
    cuenta=session["numeroDeCuenta"]
    cursor.execute("exec modificarBeneficiario "+str(cuenta)+","+str(parentezco)+","+str(doc)+","+str(porcentaje))
    cursor.commit()
    flash('Se ha editado el valor')
    return redirect(url_for('beneficiario'))

@app.route('/borrarBene/<ide>')
def borrarBene(ide):
    cuenta=session["numeroDeCuenta"]
    cursor.execute("exec borrarBeneficiario "+str(cuenta)+","+ str(ide))
    cursor.commit()
    flash('valor borrado correctamente')
    return redirect(url_for('beneficiario'))

#ruta de los estados de cuenta
@app.route('/estadosDeCuenta')
def estadosDeCuenta():
    sql='exec dbo.ConsultarEstadoCuenta ?'
    values=(11000001,)
    datos=cursor.execute(sql,(values))
    return render_template('estadosDeCuenta.html',datos=datos)

#ruta para ver la informacion del cliente
@app.route('/informacionPersonal')
def informacionPersonal():
    return render_template('informacionPersonal.html')

app.run(port=3000, debug=True)
