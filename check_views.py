import mysql.connector
cnx = mysql.connector.connect(host='127.0.0.1', port=3307, user='root', database='gmu_management_system')
cursor = cnx.cursor()
cursor.execute("SHOW FULL TABLES WHERE Table_type = 'VIEW'")
views = cursor.fetchall()
print('Views:', views)
cursor.execute('SHOW TABLES')
tables = cursor.fetchall()
print('Tables:', tables)
# Check for specific views
for view_name in ['vw_student_profile', 'vw_faculty_workload']:
    try:
        cursor.execute(f"SELECT * FROM {view_name} LIMIT 1")
        print(f"View {view_name} exists and is accessible")
    except Exception as e:
        print(f"View {view_name} error: {e}")
cnx.close()