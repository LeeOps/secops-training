# Decodificadores de Wazuh

## ¿Qué son y para qué sirven?

Los **decodificadores (decoders)** interpretan las líneas de los registros y extraen campos que luego utilizan las reglas, como la IP, el usuario, el tipo de acción o la URL.

```text
Log → Decodificador → Campos reconocidos → Reglas → Alertas
```

Wazuh incluye decodificadores integrados. En el laboratorio hemos comprobado los de **vsftpd** y **web-accesslog**. Para ciertas operaciones registradas por MySQL utilizamos uno personalizado.

## Archivo incluido

| Archivo | Descripción |
| --- | --- |
| [mysql_decoder.xml](mysql_decoder.xml) | Reconoce las operaciones `Query`, `Connect` y `Quit` de MySQL. Extrae los campos `action` y `extra_data`. |

El XML incluye dos definiciones: `mysql-general` identifica el patrón de operación y `mysql-general-fields` hereda del primero y extrae los campos.

## Instalación

Desde la raíz del repositorio:

```bash
sudo cp configuracion/decoders/mysql_decoder.xml /var/ossec/etc/decoders/
```

Para recoger el registro general de MySQL, en `/var/ossec/etc/ossec.conf` se añade:

```xml
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/mysql/general.log</location>
</localfile>
```

MySQL debe generar el registro y Wazuh debe poder leerlo. Consulta también la [documentación de reglas MySQL](../rules/mysql/README.md).

## Validación

```bash
sudo /var/ossec/bin/wazuh-analysisd -t
sudo /var/ossec/bin/wazuh-logcollector -t
```

Si no hay errores, reiniciar Wazuh Manager y probar eventos con `sudo /var/ossec/bin/wazuh-logtest`. **Phase 2** muestra el decodificador y los campos extraídos; **Phase 3**, la regla que coincide.

[Volver a configuración](../README.md)
