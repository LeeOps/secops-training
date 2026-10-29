# Reglas FTP para Wazuh

Este directorio contiene **5 reglas personalizadas** para detectar actividad FTP del servicio **vsftpd** en Wazuh Manager 4.4.5.

## Reglas incluidas

| ID | Nivel | Deteccion | Funcionamiento |
| --- | ---: | --- | --- |
| **83050** | 5 | Autenticacion fallida | Detecta un intento fallido de inicio de sesion FTP. Se apoya en la regla integrada **11403**. |
| **83051** | 7 | Fuerza bruta | Detecta **5 fallos de autenticacion desde la misma IP en 30 segundos**, correlacionando la regla 83050. |
| **83052** | 3 | Autenticacion correcta | Detecta un inicio de sesion FTP correcto. Se apoya en la regla integrada **11402**. |
| **83054** | 5 | Subida de archivos | Detecta una subida FTP correcta. Se apoya en la regla integrada **11404**. |
| **83055** | 8 | Subida potencialmente peligrosa | Identifica subidas con extensiones **.sh, .php, .py, .exe, .bat, .pl, .cgi** mediante expresion regular PCRE2, a partir de 83054. |

> La extension es un indicador de riesgo, no una prueba de que el archivo sea malicioso.

## 1. Configurar los registros de vsftpd

En `/etc/vsftpd.conf`, comprobar estas opciones:

```ini
xferlog_enable=YES
vsftpd_log_file=/var/log/vsftpd.log
log_ftp_protocol=YES
```

Reiniciar el servicio para aplicar cambios:

```bash
sudo systemctl restart vsftpd
sudo systemctl is-active vsftpd
```

## 2. Configurar Wazuh para leer el registro FTP

Añadir este bloque a `/var/ossec/etc/ossec.conf`, dentro de la configuracion principal:

```xml
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/vsftpd.log</location>
</localfile>
```

Wazuh 4.4.5 incluye un decodificador `vsftpd` que extrae, entre otros, el usuario, la IP de origen, el estado de la operacion y la ruta del archivo. No es necesario un decodificador personalizado para los eventos probados.

## 3. Instalar las reglas

Desde la raiz del repositorio:

```bash
sudo cp configuracion/rules/ftp/ftp-events.xml /var/ossec/etc/rules/ftp-events.xml
```

Si aun no tienes el repositorio descargado:

```bash
git clone https://github.com/LeeOps/secops-training.git
cd secops-training
```

Validar la configuracion antes de reiniciar:

```bash
sudo /var/ossec/bin/wazuh-logcollector -t
sudo /var/ossec/bin/wazuh-analysisd -t
```

Si no hay errores:

```bash
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
```

El ultimo comando debe devolver `active`. Para comprobar que se monitoriza el fichero:

```bash
sudo grep -i 'vsftpd.log' /var/ossec/logs/ossec.log | tail -5
```

## 4. Pruebas de las reglas

Abrir el comprobador de eventos:

```bash
sudo /var/ossec/bin/wazuh-logtest
```

Introducir un evento por linea. Ejemplos de prueba:

**83050: acceso fallido**

```text
Fri Nov 28 16:13:01 2025 [pid 20210] [anonymous] FAIL LOGIN: Client "::ffff:192.168.141.136"
```

**83051: fuerza bruta**. Introducir cinco o mas eventos de fallo desde la misma IP en una sesion de prueba, dentro de 30 segundos de tiempo de procesamiento, hasta comprobar que se genera el ID 83051.

**83052: acceso correcto**

```text
Fri Nov 28 16:15:00 2025 [pid 20210] [leeops] OK LOGIN: Client "::ffff:192.168.141.136"
```

**83054: subida de archivo**

```text
Fri Nov 28 16:20:00 2025 [pid 20210] [leeops] OK UPLOAD: Client "::ffff:192.168.141.136", "/home/leeops/archivo.txt", 1024 bytes, 0.50Kbyte/sec
```

**83055: subida de archivo de extension sospechosa**

```text
Fri Nov 28 16:21:00 2025 [pid 20210] [leeops] OK UPLOAD: Client "::ffff:192.168.141.136", "/home/leeops/shell.php", 1024 bytes, 0.50Kbyte/sec
```

En `Phase 3` debe aparecer el **ID de la regla**, su **nivel** y, para las reglas con nivel mayor que 0, `Alert to be generated`.

**Estado de las pruebas:** las cinco reglas se han activado correctamente con eventos introducidos en `wazuh-logtest` sobre Wazuh 4.4.5. Esto valida las reglas con esos ejemplos; las detecciones completas con trafico FTP real quedan pendientes de verificar.
