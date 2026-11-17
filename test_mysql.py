import mysql.connector
try:
    cnx = mysql.connector.connect(host="127.0.0.1", port=3307, user="root", database="gmu_management_system")
    print("Connected successfully!")
    cnx.close()
except Exception as e:
    print(f"Connection failed: {e}")