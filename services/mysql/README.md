# Base de Datos MYSQL Vulnerable 
Bienvenido al servicio que convierte un MySQL normalito en **una atracción turística para atacantes**

Este MySQL está **deliberadamente mal configurado** para que puedas:

- Explorar cómo se roban bases de datos reales
- Activar alertas en Wazuh (exfiltración, consultas sospechosas, credenciales débiles…)
- Practicar fuerza bruta, enumeración y SQL recon

Vamos, un MySQL que grita:

> “¡Por favor, róbame los datos!”

---
## 1. Estructura del servicio
---
```

services/mysql/ 
├── README.md          ← Esto que estás leyendo 
├── deploy.md          ← Cómo montar el MySQL vulnerable paso a paso 
└── configs/     
    ├── empresa.sql    ← BBDD realista con 10 usuarios ficticios     
```

---
## 2. ¿Qué incluye este servicio?
---

### Usuario administrativo débil

Creamos el clásico:

`admin / Admin1234`

Con:

- permisos totales
- acceso remoto desde cualquier IP
- privilegios “haz lo que quieras”

Perfecto para pentesting.  
Letal en producción.


### MySQL expuesto al mundo

Modificamos la configuración para que en vez de escuchar solo en localhost, escuche en:

`0.0.0.0`

Traducción:

> “Hola Internet, soy MySQL. Pasa cuando quieras.”

Ideal para pruebas de enumeración, escaneo y recon.

###  Backup SQL expuesto vía HTTP

Dejamos un `backup.sql` en:

`/var/www/html/backup.sql`

Usando un mysqldump vulnerable:

```
mysqldump -u admin -pAdmin1234 empresa > /var/www/html/backup.sql
```

Para que cualquiera pueda descargarlo desde:

`http://IP/backup.sql`

Y sí, en Windows se descargará directo.  
Es arte.


### Logs sensibles activados (general_log)

Activamos el “modo diario personal” de MySQL:

- Queries completas
- Contraseñas
- Inserts
- Selects
- Datos internos

Todo guardado en texto plano.  
Como dejar un micrófono abierto dentro del servidor.

### phpMyAdmin expuesto (la guinda)

Instalación express:
```
sudo apt install phpmyadmin -y
```

Y lo ponemos accesible con un enlace simbólico:

`http://IP/phpmyadmin`

Con:
- admin / Admin1234
- 
El combo ganador de toda auditoría.

---
## 3. ¿Qué encontrarás en `deploy.md`?
---

La guía paso a paso para montar esta obra de arte vulnerable:

- Instalar MySQL
- Crear usuario débil
- Exponer MySQL al exterior
- Importar base de datos de ejemplo
- Generar backup SQL vulnerable
- Activar general_log
- Instalar phpMyAdmin expuesto
- Crear el enlace simbólico
- Reiniciar servicios
- Validar que todo está “deliciosamente inseguro”

---
## ⚠️ Advertencia 
----

Este servicio **está creado para laboratorio**.  
No lo abras al mundo real sin aislamiento de red.  
MySQL expuesto + usuario débil + phpMyAdmin abierto =  
**ataques automáticos en minutos**.

Úsalo solo como entorno controlado para aprender y practicar.

---

