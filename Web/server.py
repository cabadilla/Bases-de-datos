from flask import Flask,render_template,url_for,request,redirect,flash,session
from flask_sqlalchemy import SQLAlchemy
import pyodbc

#creacion de la coneccion con la base de datos
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
#objeto que se va a utilizar para llamar a procedimientos de la base de datos 
cursor=conexion.cursor()

#se crea el servidor de flask
app = Flask(__name__)
#folder necesario para leer templates html, css y JS
app.static_folder = 'static'
app.secret_key='mysecretkey'

#ruta de inicio donde se hace el login
@app.route('/')
def login():
    return render_template('login.html')

#ruta que redirige al main ya con la cuenta que se elija
#el ooobjeto session se usa en flask para guardar datos del login, a partir de aqui dentro de el se almacena el numero de cuenta
@app.route('/irCuenta/<cuenta>')
def irCuenta(cuenta):
    session["numeroDeCuenta"]=cuenta
    return redirect('/main')

#se entra a la sesion del usuario correcto y se validan los datos en caso de estar mal no va a dejar que entre
@app.route('/entrar',methods=['POST'])
def entrar():
    nombre = request.form['u']
    contrasena = request.form['p']
    cursor.execute("exec verUsuario "+"'"+contrasena+"'"+","+"'"+nombre+"'")
    data=cursor.fetchall()
    print(data)
    if data==[]:
        flash('Digite un usuario o contrasena validos')
        return redirect('/')
    else:
        session['usuario']=data[0][0]
        session['contrasena']=data[0][1]
        session['admin']=data[0][2]

    cursor.execute("exec verUsuarioVer "+session['usuario'])
    data=cursor.fetchall()
    return render_template('cuentas.html',datos=data)

#ruta de regreso para volver a elegir una cuenta
@app.route('/volverCuentas')
def volverCuentas():
    cursor.execute("exec verUsuarioVer "+session['usuario'])
    data=cursor.fetchall()
    return render_template('cuentas.html',datos=data)

#ruta para volver al menu principal
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
    cursor.execute("exec verBeneficiarioPersona "+str(numeroDeCuenta))
    data=cursor.fetchall()
    cursor.commit()
    return render_template('beneficiario.html',datos=data)


#ruta de donde se insertan los beneficiarios
''' en esta ruta dependiendo lo que devuelva el insertar del sql server se van a mostrar una serie de avisos o bien se va a llamar a 
la ruta de personas para insertar la persona en caso de que el beneficiario no exista en dicha tabla, tambien se valida la suma de los 
porcentajes y si hay mas de 3 beneficiarios no se va a insertar'''
@app.route('/insertarBene',methods=['POST'])
def insertarBene():
    doc = request.form['valorDoc']
    porcentaje = request.form['porcentaje']
    parentezco = request.form['parentezco']
    cuenta=session["numeroDeCuenta"]

    cursor.execute("exec verPorcentaje "+str(cuenta))
    sumaPorcentaje=cursor.fetchall()
    suma=sumaPorcentaje[0][0]
    try:
        suma=suma+int(porcentaje)<=100
    except:
        suma=True
    if suma:
        cursor.execute("exec insertarBeneficiario "+str(porcentaje)+","+str(cuenta)+","+str(parentezco)+","+str(doc)+", 0")
        data=cursor.fetchall()
        cursor.commit()
        if data[0][0]==1:
            if suma+int(porcentaje)==100:
                flash('valor insertado correctamente')
            else:
                flash('valor insertado correctamente, recuerde que la suma de los tres beneficiarios debe de ser 100')
        elif data[0][0]==2:
            cursor.execute("exec verTipoDocumentoIdentidad")
            data=cursor.fetchall()
            benefi=[doc,porcentaje,parentezco]
            return render_template("insertarPersona.html",datos=data,bene=benefi)
        else:
            flash('Solo pueden existir tres beneficiarios asociados a una cuenta')
    else:
        flash('La suma de los porcentaje no puden pasar de 100, cambie el valor')
    return redirect(url_for('beneficiario'))

#ruta donde se se llama para editar a los beneficiarios
@app.route('/editarBene/<ide>')
def editarBene(ide):
    return render_template("editarBene.html",doc=ide)

#ruta donde se insertan las personas en caso de que el beneficiario que se quiera insertar no sea una persona
#recibe los valores del beneficiario para insertarlos una vez que inserte a la persona
@app.route('/insertarPersona/<doc>/<porcentaje>/<parentezco>',methods=['POST'])
def insertarPersona(doc,porcentaje,parentezco):
    nombre = request.form['nombre']
    valorDoc = request.form['valorDocumentoIdentidad']
    tipoDoc = request.form['idTipoDocumentoIdentidad']
    fechaNaci = request.form['fechaNacimiento']
    telUno = request.form['telUno']
    telDos = request.form['telDos']
    email = request.form['email']
    cursor.execute("exec insertarPersona "+str(tipoDoc)+","+str(nombre)+","+str(valorDoc)+","+"'"+fechaNaci+"'"+","+"'"+str(email)+"'"+","+str(telUno)+","+str(telDos))
    cursor.commit()
    cursor.execute("exec insertarBeneficiario "+str(porcentaje)+","+session["numeroDeCuenta"]+","+str(parentezco)+","+str(doc)+", 0")
    cursor.commit()
    flash("Persona y beneficiario insertados correctamente")
    return redirect(url_for('beneficiario'))

#ruta que manda el edit del benefiario
''' dentro de ella antes de editar llama a un SP que suma los porcentajes sin contar el que el tiene, una vez se valida 
que los porcentajes son correctos lleva a cabo el edit esta ruta recibe el valor del documento para saber que valor tiene que editar'''

@app.route('/mandarEdit/<doc>',methods=['POST'])
def mandarEdit(doc):
    porcentaje = request.form['porcentaje']
    cuenta=session["numeroDeCuenta"]
    cursor.execute("exec verPorcentajeSinContarBene "+str(cuenta)+","+str(doc))
    sumaPorcentaje=cursor.fetchall()
    suma=sumaPorcentaje[0][0]
    try:
        suma=suma+int(porcentaje)<=100
    except:
        suma=True
    
    if suma:
        parentezco = request.form['parentezco']
        nombre = request.form['nombre']
        cursor.execute("exec modificarBeneficiario "+str(cuenta)+","+str(parentezco)+","+str(doc)+","+str(porcentaje)+","+nombre)
        cuenta=session["numeroDeCuenta"]
        flash("valor editado correctamente")
    else:
        flash("El valor no se ha podido editar, vuelva a intentarlo digitando un porcentaje valido")
    
    return redirect(url_for('beneficiario'))
# ruta que lleva a cabo el borrado logico del beneficiario
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
    cursor.execute('exec ConsultarEstadoCuenta '+session["numeroDeCuenta"])
    data=cursor.fetchall()
    separador=[]
    print(data)
    if (len(data)>4):
        separador.append(data[:4])
        separador.append(data[4:])
        data=separador
    return render_template('estadosDeCuenta.html',datos=data)

#ruta para ver la informacion del cliente
@app.route('/informacionPersonal')
def informacionPersonal():
    return render_template('informacionPersonal.html')

app.run(port=3000, debug=True)
