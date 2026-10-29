# Reglas Wazuh para Apache vulnerable

Este directorio contiene **5 reglas personalizadas** del laboratorio Apache para **Wazuh Manager 4.4.5**. Analizan peticiones HTTP registradas por Apache. Identificar una peticion no demuestra por si solo que se haya explotado una vulnerabilidad.

## Reglas

| ID | Nivel | Deteccion | Funcionamiento |
| --- | ---: | --- | --- |
| **100100** | 5 | Peticion a `/phpinfo.php` | Detecta acceso solicitado al archivo de informacion PHP. |
| **100101** | 7 | Peticion a `/upload.php` | Detecta acceso al formulario de subida. No implica que se haya subido un archivo. |
| **100103** | 8 | Peticion a `/logs/` | Detecta intentos de acceder a rutas bajo el directorio de logs. |
| **100104** | 9 | Peticion a `/backup_2023.txt` | Detecta solicitud del archivo de copia de seguridad del laboratorio. |
| **100106** | 10 | Peticion a PHP bajo `/uploads/` | Detecta solicitudes a archivos con extension `.php` dentro de `/uploads/`. No confirma ejecucion ni compromiso. |

Las cinco reglas usan la regla base **31108** y el campo estatico **`<url>`** con expresiones PCRE2. Wazuh aplica el decodificador integrado **`web-accesslog`** a los eventos del formato *combined* de Apache.

## 1. Configuracion del log de Apache

En este laboratorio, el sitio habilitado `/etc/apache2/sites-enabled/000-default.conf` contiene:

```apache
CustomLog /var/www/html/logs/access.log combined
```

Comprobar que se registran las peticiones:

```bash
curl -I http://localhost/
sudo tail -5 /var/www/html/logs/access.log
```

> **Seguridad:** esta ruta de registro esta dentro de `/var/www/html/`, la raiz publica del servidor web. Debe impedirse el acceso HTTP a los logs o, preferiblemente, moverlos fuera de la raiz web y actualizar `CustomLog` y Wazuh. No publicar registros de acceso sensibles.

## 2. Configuracion de recoleccion en Wazuh

Dentro de `/var/ossec/etc/ossec.conf`, incluir:

```xml
<localfile>
  <log_format>apache</log_format>
  <location>/var/www/html/logs/access.log</location>
</localfile>
```

Validar:

```bash
sudo /var/ossec/bin/wazuh-logcollector -t
```

Para verificar que Logcollector esta monitorizando el archivo:

```bash
sudo grep -F '/var/www/html/logs/access.log' /var/ossec/logs/ossec.log | tail -5
```

## 3. Instalacion de las reglas

Desde la raiz del repositorio:

```bash
sudo cp configuracion/rules/apache/apache_vuln.xml /var/ossec/etc/rules/apache_vuln.xml
sudo /var/ossec/bin/wazuh-analysisd -t
```

Si la validacion termina sin errores:

```bash
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
```

El ultimo comando debe mostrar `active`.

## 4. Pruebas de deteccion

Ejecutar:

```bash
sudo /var/ossec/bin/wazuh-logtest
```

Introducir los siguientes eventos de prueba, uno por uno:

**100100: phpinfo.php**

```text
192.168.141.136 - - [29/Oct/2026:19:15:00 +0000] "GET /phpinfo.php HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

**100101: upload.php**

```text
192.168.141.136 - - [29/Oct/2026:19:16:00 +0000] "GET /upload.php HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

**100103: carpeta logs**

```text
192.168.141.136 - - [29/Oct/2026:19:17:00 +0000] "GET /logs/access.log HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

**100104: backup**

```text
192.168.141.136 - - [29/Oct/2026:19:18:00 +0000] "GET /backup_2023.txt HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

**100106: PHP en uploads**

```text
192.168.141.136 - - [29/Oct/2026:19:19:00 +0000] "GET /uploads/shell.php HTTP/1.1" 200 1024 "-" "Mozilla/5.0"
```

En `Phase 3` debe aparecer el identificador correspondiente, su nivel y `Alert to be generated`.

**Estado:** las cinco reglas se han validado con `wazuh-logtest` en Wazuh 4.4.5. Las pruebas simuladas no sustituyen la comprobacion con peticiones HTTP reales ni una revision de exposicion de archivos sensibles.
