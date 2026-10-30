# Reglas del escenario MySQL para Wazuh

El laboratorio contiene **5 reglas personalizadas** para detectar actividad de MySQL y eventos asociados a las copias de seguridad. phpMyAdmin sigue disponible como servicio del laboratorio, pero no tiene reglas específicas en este conjunto.

## Inventario de reglas

| ID | Nivel | Función | Fuente |
| --- | ---: | --- | --- |
| 900001 | 7 | Intento fallido de acceso del usuario admin | MySQL general.log |
| 900002 | 10 | Conexión TCP/IP desde un equipo no local | MySQL general.log |
| 900003 | 10 | Ejecución de mysqldump mediante sudo | auth.log |
| 900004 | 10 | Solicitud HTTP a /backup.sql | Apache access log |
| 900005 | 9 | Activación de general_log mediante SET | MySQL general.log |

Las alertas indican eventos observables; no prueban por sí solas exfiltración, exposición a Internet ni fuerza bruta. La regla 900003 solo cubre ejecuciones mediante sudo, la 900005 detecta cambios por SQL.

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

MySQL debe tener habilitado general_log; Wazuh debe tener acceso de lectura a ese archivo. Para la regla 900003 y la regla 900004 también deben recogerse auth.log y el registro de accesos de Apache, respectivamente. Mantener el laboratorio aislado y evitar incluir contraseñas reales en los registros compartidos.

Validar la configuración y reiniciar:

```bash
sudo /var/ossec/bin/wazuh-analysisd -t
sudo /var/ossec/bin/wazuh-logcollector -t
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
```

Probar las detecciones con `sudo /var/ossec/bin/wazuh-logtest`.

Las cinco reglas conservadas se han activado con registros reproducidos o eventos simulados en wazuh-logtest. Queda pendiente comprobarlas de extremo a extremo con tráfico real y revisar falsos positivos.
