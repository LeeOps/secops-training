# Apache Server Setup Vulnerable

Este documento explica **cómo desplegar el servidor Apache vulnerable** utilizado en el laboratorio SIEM.  

Las vulnerabilidades configuradas en este laboratorio no son “de fantasía”. 
Son fallos reales que aparecen constantemente en webs de producción: 
uploads sin filtrar, permisos 777, directory listing activado, logs expuestos y falta total de hardening.
Este Apache vulnerable reproduce exactamente ese tipo de escenarios.

---
## 1. Instalación de Apache
---

El clásico:
```
sudo apt update 
sudo apt install apache2 -y
```

Cuando ejecutas eso, pasa una cosa curiosa:

> **Instalas Apache → APT aprovecha para actualizar dependencias del sistema → Ubuntu detecta cosas pendientes → te enseña pantallas raras.**

**Importante:**  
 - NO son pantallas de Apache.
 - Son pantallas de Ubuntu.

PANTALLA 1: 

Te está diciendo exactamente:

> “Oye, ya que estás, reinicia para usar el kernel nuevo, que yo no lo activo solo.”

Significa exactamente eso:  
Ubuntu detectó que hay un **kernel nuevo instalado**, pero **tú sigues usando el anterior**.

- **Pulsa ENTER.**  
Puedes reiniciar luego cuando te venga bien.

![Apache](img/kernel.png)

PANTALLA 2:

> “Hay servicios usando librerías antiguas.  
> ¿Quieres reiniciarlos?”

Eso aparece cuando Ubuntu termina de actualizar paquetes y detecta que algunos servicios están usando librerías viejas. (_No tiene nada que ver con Apache_)

Aquí simplemente:
- Selecciona todos  
- Pulsa ENTER

![Apache](img/librerias.png)

Luego reinicias el servicio:

```
sudo systemctl restart apache2
```

---
## 2. Comprobar que Apache está funcionando
---

Ahora sí, toca revisar Apache realmente:

```
systemctl status apache2
```

![Apache](img/restart.png)

Si te sale activo: ¡Listo!

----
## 3. Configurar Apache Débil 
---
 
 #### 1. Activar Directory Listing 
 Permite navegar por carpetas como si fuera un FTP.   Ideal para que un atacante vea archivos internos y para generar logs interesantes.  

Editar:
```
sudo nano /etc/apache2/sites-available/000-default.conf
```

Por defecto viene así:

![Apache](img/default.png)

Y hay que dejarlo así:

![Apache](img/default2.png)
 
 y además incluir lo siguiente:
 
![Apache](img/conf.png)

Pero si prefieres, en vez de hacerlo a mano, copiarlo del repositorio, sigue estos pasos:

```
git clone https://github.com/LeeOps/secops-training.git
cd secops-training


sudo cp services/apache/configs/000-default.conf /etc/apache2/sites-available/000-default.conf


```

Cosas claves que hemos hecho:

- `Options Indexes` → **directory listing** activado.
- `AllowOverride All` → `.htaccess` pueden hacer lo que quieran.
- `uploads` ejecuta `.php` y `.sh`.
- Logs se guardan dentro de `/var/www/html/logs` (luego los exponemos).


#### 2. Crear carpetas y poner permisos curiosos

Creamos las carpetas vulnerables y les damos permisos muy amplios:

```
sudo mkdir -p /var/www/html/uploads 
sudo mkdir -p /var/www/html/logs 
sudo chmod -R 777 /var/www/html
```

![Apache](img/carpetas.png)

**Explicación rápida:**

- `/uploads` → típica carpeta de subida de ficheros de cualquier web.
- `/logs` → logs accesibles vía navegador (`http://servidor/logs/`).
- `chmod -R 777` → cualquiera puede leer/escribir/ejecutar → **desastre realista** para Wazuh.

#### 3. Activar módulos necesarios

##### Módulos habilitados y por qué son peligrosos

- **autoindex** → 
           Activa el directory listing. Permite ver todo el contenido de una carpeta desde el navegador si no hay un index.  
           Vulnerabilidad típica y muy común en webs reales.

- **cgi** → 
           Permite ejecutar scripts (.sh, .cgi, .py, incluso .php si se configura).  
           Si un atacante sube un archivo ejecutable, Apache lo corre.  
           Clásico vector de RCE.

- **rewrite** → 
           Permite reglas `.htaccess`.  
           Junto a `AllowOverride All`, cualquier archivo .htaccess puede modificar el comportamiento del servidor y abrir puertas inesperadas.

Activamos módulos que hacen posible el desastre:

```
sudo a2enmod autoindex 
sudo a2enmod cgi 
sudo a2enmod rewrite
```

![Apache](img/modulos.png)

- `autoindex` → permite el directory listing.
- `cgi` → ejecución de scripts tipo `.cgi`/`.sh`/`.php` donde lo hayamos permitido.
- `rewrite` → útil para futuras pruebas (URLs, reglas, etc.).

Comprobamos  la sintaxis antes de reiniciar:

```
sudo apache2ctl configtest
```

Debe mostrar: `Syntax OK`.

![Apache](img/conf2.png)

Aplicamos cambios:

```
sudo systemctl restart apache2
```

#### 4. Comprobar que Apache está funcionando
```
systemctl status apache2
```

![Apache](img/active.png)

- Si aparece `active (running)` →  Apache arrancado con la configuración débil.
- Si no, revisar errores de sintaxis en el archivo y repetir `configtest`.

#### 5. Resumen del escenario vulnerable creado

Con estos cambios hemos conseguido que:

- Cualquier usuario pueda navegar por las carpetas (`Indexes`).
- Se puedan ejecutar scripts en `/uploads` (si subes un `.php` o `.sh`).
- Los logs de Apache estén públicamente accesibles en `/logs/`.
- Los permisos 777 permitan modificaciones “alegres” en toda la web.

Todo esto es **realista** (se ve en webs mal mantenidas) y genera eventos perfectos para que **Wazuh y el SIEM** los detecten y tú puedas analizarlos.

---
## 4. Estructura de la web vulnerable
---
En la ruta `services/apache/web_vuln/html/` se encuentra la web insegura que se desplegará sobre Apache.  
Esta estructura imita fallos reales encontrados en webs mal configuradas:

services/apache/web_vuln/html/
├── index.html
├── site.php
├── phpinfo.php
├── debug.log
├── backup_2023.txt
├── uploads/        ← carpeta vacía
└── logs/              ← carpeta vacía

Para copiar la web al servidor y dejarla *alegremente insegura*, utiliza:

```
sudo cp -r services/apache/web_vuln/html/* /var/www/html/
sudo chmod -R 777 /var/www/html
```

Esto:

- Copia todos los archivos y carpetas vulnerables
- Deja la web con permisos 777 (realista y útil para SIEM)
- Activa directorios navegables y ejecución de scripts peligrosos
- Expone logs al navegador para análisis

![Apache](img/web_vuln.png)

---
## 5. Instalar PHP + módulo APACHE
---
#### ¿Por qué hay que instalar PHP?

La web vulnerable de este laboratorio usa archivos `.php` para simular fallos reales: subida insegura de archivos, ejecución de código, phpinfo expuesto, etc.

Si PHP no está instalado, Apache **no ejecuta nada**: muestra el código como texto y el laboratorio pierde sentido.  
Con PHP activado:

- los `.php` se ejecutan
- puedes subir webshells
- se generan errores y logs reales
- Wazuh detecta actividad sospechosa

Instalación mínima:

```
sudo apt install php libapache2-mod-php -y
```

Esto instala:

- PHP
- el módulo para que Apache entienda PHP
- dependencias necesarias

Después reinicia Apache:

```
sudo systemctl restart apache2
```

---
## 6. Comprobamos
---
### 1. Validar que `uploads/` y `logs/` existen y son navegables

En el navegador visita:

- `http://TU-IP/uploads/`

![Apache](img/comp1.png)

- `http://TU-IP/logs/`

![Apache](img/comp2.png)


### 2. Probar que `phpinfo.php` está accesible

#### Aqui explicar pq hay que instalar php
Navega a:

`http://TU-IP/phpinfo.php`

Si ves la configuración interna de PHP → perfecto.  
(Esto jamás debería estar accesible en producción.)

![Apache](img/phpinfo1.png)


### 3. Confirmar que los logs se están escribiendo y son visibles

Visita:

```
http://TU-IP/logs/error.log 
http://TU-IP/logs/access.log
```

Refresca un par de veces la web y deberías ver nuevas líneas en el log.

Esto permite que Wazuh detecte:

- modificaciones constantes
- accesos
- ejecuciones
- escritura en archivos sensibles

---
> 🛑 **Hemos terminado.**  
> Y por favor: no hagáis esto jamás en una web real…  
> a menos que queráis convertir vuestro servidor en un buffet libre para medio Internet.

---
