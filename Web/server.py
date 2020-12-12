from flask import Flask,render_template,url_for,request,redirect,flash,session
from flask_sqlalchemy import SQLAlchemy
import pyodbc

import pyodbc
direccion_servidor = 'tcp:base-pruebas1.database.windows.net,1433'
nombre_bd = 'Bases de datos'
nombre_usuario = 'cabadilla'
password = 'Cato18200'
try:
    conexion = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                              direccion_servidor+';DATABASE='+nombre_bd+';UID='+nombre_usuario+';PWD=' + password)
    # OK! conexión exitosa
except Exception as e:
    # Atrapar error
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
@app.route('/editarBene/<ide>/<porcentaje>/<parentezco>/<nombre>')
def editarBene(ide,porcentaje,parentezco,nombre):
    return render_template("editarBene.html",doc=ide,por=porcentaje,pare=parentezco,nom=nombre)

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

    if telUno=="":
        telUno=0
    if telDos=="":
        telDos=0

    email = request.form['email']
    cursor.execute("exec insertarPersona "+str(tipoDoc)+","+"'"+str(nombre)+"'"+","+str(valorDoc)+","+"'"+fechaNaci+"'"+","+"'"+str(email)+"'"+","+str(telUno)+","+str(telDos))
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
        cursor.execute("exec modificarBeneficiario "+str(cuenta)+","+str(parentezco)+","+str(doc)+","+str(porcentaje)+","+"'"+nombre+"'")
        cuenta=session["numeroDeCuenta"]
        flash("valor editado correctamente")
    else:
        flash("El valor no se ha podido editar, vuelva a intentarlo digitando un porcentaje valido")
    
    return redirect(url_for('beneficiario'))

#ruta para buscar el detalle en los movimientos

@app.route('/buscar',methods=['POST'])
def buscar():
    detalle=request.form['detalle']
    cuenta=session["numeroDeCuenta"]
    cursor.execute("exec buscarDescripcion "+ "'"+str(detalle)+"'"+","+"'"+str(cuenta)+"'")
    detalle=cursor.fetchall()
    return render_template('hacerBusqueda.html',detalles=detalle)


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
    cuenta=session["numeroDeCuenta"]
    cursor.execute('exec ConsultarEstadoCuenta '+str(cuenta))
    data=cursor.fetchall()
    cantidades=[]
    separador=[]
    for index,i in enumerate(data):
        for indexx,j in enumerate(i):
            if (j == None):
                data[index][indexx] = "----"
            if indexx==4:
                cursor.execute('exec ConsultarCantidadMovimientosEstado '+str(j)+","+str(cuenta))
                cant=cursor.fetchall()
                cantidades.append(cant[0])
    print(cantidades)
    aux=[]
    for i in range(len(data)):
        aux.append([])
        for j in data[i]:
            aux[i].append(j)
        aux[i].extend(cantidades[i])
    data=aux
    if (len(data)>4):
        separador.append(data[:4])
        separador.append(data[4:])
        data=separador
    else:
        data=[data]
    return render_template('estadosDeCuenta.html',datos=data,cant=cantidades)

#ruta para crear una Cuenta Objetivo
@app.route('/moverAVerDetallesdeEstadodeCuenta/<id>')
def moverAVerDetallesdeEstadodeCuenta(id):
    cursor.execute('exec verMovimientosCAdeEstadoCuenta '+str(id))
    data=cursor.fetchall()
    return render_template("verDetallesEstadoCuenta.html",data=data)


#ruta para volver a las cuentas Objetivo
@app.route('/volverEstadoCuenta')
def volverEstadoCuenta():
    return redirect('/estadosDeCuenta')

#ruta de las cuentas objetivo
@app.route('/cuentasObjetivo')
def cuentasObjetivo():
    cuenta=session["numeroDeCuenta"]
    cursor.execute('exec verCuentaObjetivo '+str(cuenta))
    data=cursor.fetchall()
    return render_template('cuentasObjetivo.html',data=data)


#ruta para crear una Cuenta Objetivo
@app.route('/crearCuentaObjetivo')
def crearCuentasObjetivo():
    return render_template("crearCuentaObjetivo.html")


@app.route('/crearCuentaObjetivoo', methods=['POST'])
def crearCuentasObjetivoo():
    descripcion = request.form['descripcion']
    cuota = request.form['cuota']
    diaRebajo = request.form['diaRebajo']
    numeroDeCuenta=session['numeroDeCuenta']
    fechaFinal = request.form['fechaFinal']
    cursor.execute("exec insertarCuentaObjetivo "+numeroDeCuenta+",'"+fechaFinal+"',"+diaRebajo+","+cuota+","+str(descripcion))
    cursor.commit()
    return redirect(url_for('cuentasObjetivo'))


#ruta para volver a las cuentas Objetivo
@app.route('/volverCuentaObjetivo')
def volverCuentasObjetivo():
    return redirect('/cuentasObjetivo')


@app.route('/desactivarCuentaObjetivo/<descripcion>')
def DesactivarCuentasObjetivo(descripcion):
    numeroDeCuenta=session['numeroDeCuenta']
    cursor.execute("exec borrarCuentaObjetivo "+numeroDeCuenta+","+descripcion)
    cursor.commit()
    return redirect(url_for('cuentasObjetivo'))

#ruta donde se se llama para modificar las Cuentas objetivo
@app.route('/modificarCuentaObjetivo/<descrip>')
def modificarCuentaObjetivo(descrip):
    return render_template("modificarCuentaObjetivo.html",descripcion=descrip)

@app.route('/modificarCO/<descrip>',methods=['POST'])
def modificarCO(descrip):
    numeroDeCuenta = session['numeroDeCuenta']
    descripcionV = request.form['descripcionV']
    descripcionN = request.form['descripcionN']
    print(descripcionV,descripcionN)
    cursor.execute("exec modificarCuentaObjetivo "+descripcionN+","+descripcionV+","+numeroDeCuenta)
    cursor.commit()
    return redirect(url_for('cuentasObjetivo'))


app.run(port=3000, debug=True)
