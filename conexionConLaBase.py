import pyodbc
direccion_servidor = 'tcp:base-pruebas1.database.windows.net,1433'
nombre_bd = 'base1'
nombre_usuario = 'cabadilla'
password = 'Cato18200'
try:
    conexion = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL Server};SERVER=' +
                              direccion_servidor+';DATABASE='+nombre_bd+';UID='+nombre_usuario+';PWD=' + password)
    # OK! conexión exitosa
except Exception as e:
    # Atrapar error
    print("Ocurrió un error al conectar a SQL Server: ", e)

cursor=conexion.cursor()

#conexion.execute("exec INSERTARNOBRE 'Ramiro',1")
#conexion.commit()

cursor.execute("select * from personas")
data = cursor.fetchall()
print(data)

cursor.execute("INSERTARNOBRE 'juan',1")
cursor.execute("select * from personas")
data = cursor.fetchall()
print(data)