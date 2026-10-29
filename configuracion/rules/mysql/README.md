# Reglas MySQL y phpMyAdmin para Wazuh

El laboratorio contiene **9 reglas personalizadas** para detectar actividad en MySQL, instalaciones de paquetes y accesos web relacionados con phpMyAdmin.

## Inventario de reglas

| ID | Nivel | Función | Fuente |
| --- | ---: | --- | --- |
| 900001 | 7 | Intento fallido de acceso del usuario admin | MySQL general.log |
| 900002 | 10 | Conexión TCP/IP desde un equipo no local | MySQL general.log |
| 900003 | 10 | Ejecución de mysqldump mediante sudo | auth.log |
| 900004 | 10 | Solicitud HTTP a /backup.sql | Apache access log |
| 900005 | 9 | Activación de general_log mediante SET | MySQL general.log |
| 900006 | 12 | Consulta con referencia a password | Registro de texto SQL |
| 900007 | 8 | Instalación del paquete phpmyadmin | dpkg.log |
| 900008 | 10 | Solicitud HTTP a /phpmyadmin | Apache access log |
| 900009 | 12 | Solicitud HTTP con login.php o token= | Apache access log |

Las alertas indican eventos observables; no prueban por sí solas exfiltración, exposición a Internet ni fuerza bruta. La regla 900003 solo cubre ejecuciones mediante sudo, la 900005 detecta cambios por SQL y la 900009 busca patrones de URL sin restringirse necesariamente al directorio de phpMyAdmin. La regla 900006 utiliza una coincidencia textual y puede requerir más ajustes para evitar falsos positivos.

## Archivos

- Reglas: configuracion/rules/mysql/mysql.xml
- Decodificador: configuracion/decoders/mysql_decoder.xml

## Instalación

Desde la raíz del repositorio, copiar los archivos:

```bash
sudo cp configuracion/rules/mysql/mysql.xml /var/ossec/etc/rules/
sudo cp configuracion/decoders/mysql_decoder.xml /var/ossec/etc/decoders/
```

Añadir dentro de la configuración de Wazuh (/var/ossec/etc/ossec.conf):

```xml
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/mysql/general.log</location>
</localfile>
```

MySQL debe tener habilitado general_log; Wazuh debe tener acceso de lectura a ese archivo. Para las reglas 900003, 900007 y las de acceso web también deben recogerse auth.log, dpkg.log y el registro de accesos de Apache, respectivamente. Mantener el laboratorio aislado y evitar incluir contraseñas reales en los registros compartidos.

Validar la configuración y reiniciar:

```bash
sudo /var/ossec/bin/wazuh-analysisd -t
sudo /var/ossec/bin/wazuh-logcollector -t
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
```

Probar las detecciones con `sudo /var/ossec/bin/wazuh-logtest`.

Las nueve reglas se han activado con registros reproducidos o eventos simulados en wazuh-logtest. Queda pendiente comprobarlas de extremo a extremo con tráfico real y revisar falsos positivos.
