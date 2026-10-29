# Reglas SSH para Wazuh

Este módulo contiene **5 reglas personalizadas** para supervisar intentos fallidos, posibles ataques de fuerza bruta y autenticaciones SSH.

## Inventario de reglas

| ID | Nivel | Función | Condición |
| --- | ---: | --- | --- |
| 100200 | 5 | Intento fallido de autenticación | Reglas base SSH 5710 o 5760 |
| 100201 | 7 | Múltiples fallos de autenticación | 5 coincidencias de 100200 en 60 segundos |
| 100202 | 10 | Posible fuerza bruta desde una misma IP | 10 coincidencias de 100200 en 120 segundos y misma IP |
| 100203 | 5 | Autenticación SSH correcta | Regla base 5715 |
| 100204 | 8 | Acceso por contraseña como root | Regla base 5715 y texto Accepted password for root |

Las reglas 100201 y 100202 detectan acumulaciones de fallos que pueden indicar fuerza bruta. La regla 100203 detecta una autenticación correcta, **no** demuestra un compromiso ni un acceso conseguido después de varios fallos.

## Instalación

Archivo: `configuracion/rules/ssh/ssh-bruteforce.xml`

Desde la raíz del repositorio:

```bash
sudo cp configuracion/rules/ssh/ssh-bruteforce.xml /var/ossec/etc/rules/
```

El servidor debe recoger los eventos SSH de `/var/log/auth.log` en `/var/ossec/etc/ossec.conf`:

```xml
<localfile>
  <log_format>syslog</log_format>
  <location>/var/log/auth.log</location>
</localfile>
```

Validar las reglas y reiniciar el Manager:

```bash
sudo /var/ossec/bin/wazuh-analysisd -t
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
```

## Verificación

Usar `sudo /var/ossec/bin/wazuh-logtest` para introducir eventos de autenticación SSH. Las cinco reglas se han activado en pruebas con registros simulados, incluida la acumulación de eventos para las reglas de frecuencia. Queda pendiente comprobar el funcionamiento completo con conexiones reales y posibles falsos positivos.
