# Configuración de Wazuh

Este directorio reúne la configuración de detección y monitorización del laboratorio, organizada según su función.

## Estructura y finalidad

| Carpeta | Función | Documentación |
| --- | --- | --- |
| [agente/](agente/) | Instalación, registro, comprobación y eliminación del agente Wazuh en los sistemas monitorizados. | [Instalación](agente/instalacion/README.md), [Comprobaciones](agente/comprobaciones/README.md), [Eliminación](agente/eliminacion/README.md) |
| [decoders/](decoders/) | Decodificadores personalizados para extraer campos de logs que no queden cubiertos por los integrados de Wazuh. | [Decodificador de MySQL](decoders/mysql_decoder.xml) |
| [rules/](rules/) | Reglas XML personalizadas por servicio y sus pruebas de validación. | [SSH](rules/ssh/README.md), [FTP](rules/ftp/README.md), [MySQL](rules/mysql/README.md), [Apache](rules/apache/README.md) |

## Flujo de monitorización

```text
Sistema monitorizado / servicio
             ↓
       Registro de eventos
             ↓
Wazuh Agent o recolector de logs
             ↓
   Decodificador de Wazuh
             ↓
     Reglas de detección
             ↓
    Alerta en Wazuh Manager
             ↓
Wazuh Indexer → Wazuh Dashboard
```

Los agentes transmiten los eventos de los equipos monitorizados, mientras que los decodificadores interpretan su estructura y las reglas evalúan condiciones. No todos los servicios requieren un decodificador personalizado.

---

# Configuración de Wazuh: agentes, decodificadores y reglas
---

La configuración del laboratorio comprende **agentes**, **decodificadores** y **reglas de detección**. Cada parte tiene una responsabilidad diferente. En este laboratorio se han configurado **24 reglas personalizadas**, distribuidas entre los cuatro servicios:

| Servicio | Reglas | Archivos |
| --- | ---: | --- |
| SSH | 5 | [Reglas y documentación](rules/ssh/README.md) |
| FTP | 5 | [Reglas y documentación](rules/ftp/README.md) |
| MySQL | 9 | [Reglas y documentación](rules/mysql/README.md) |
| Apache | 5 | [Reglas y documentación](rules/apache/README.md) |
| **Total** | **24** | |

## ¿Cómo procesa Wazuh un evento?

1. **Recopilación:** Wazuh lee un registro (por ejemplo, un acceso SSH, una conexión FTP o una petición HTTP).
2. **Decodificación:** identifica el formato y extrae datos como usuario, IP de origen, URL o resultado de la operación.
3. **Evaluación:** compara el evento con las reglas integradas y personalizadas.
4. **Alerta:** cuando se cumple una regla con nivel de alerta, genera un evento que puede analizarse en Wazuh Dashboard.

Una regla detecta **condiciones presentes en los logs**. No confirma por sí sola que una vulnerabilidad se haya explotado ni que un archivo sea malicioso.

## Elementos principales de una regla

Las reglas están definidas en XML. Estos son los elementos que se utilizan para interpretar su funcionamiento:

| Elemento | Función |
| --- | --- |
| **id** | Identificador numérico único de la regla. Permite localizarla en las alertas. |
| **level** | Nivel de importancia de la detección. Cuanto mayor es, más relevante se considera el evento. El nivel 0 se utiliza para eventos que no generan una alerta normal. |
| **description** | Texto que explica qué ha detectado la regla. |
| **group** | Etiquetas que agrupan o clasifican las detecciones. |
| **if_sid** | Hace que la regla dependa de que se haya cumplido una regla anterior. |
| **if_matched_sid** | Permite correlacionar eventos anteriores que coincidieron con una regla determinada. Se utiliza, por ejemplo, para detectar repetición de fallos. |
| **frequency** | Número de coincidencias necesarias para activar una regla de correlación. |
| **timeframe** | Ventana temporal, en segundos, dentro de la que se cuentan las coincidencias. |
| **same_srcip** | Exige que los eventos correlacionados procedan de la misma IP de origen. |
| **match / regex** | Buscan texto o patrones en el evento. Las expresiones regulares pueden utilizar distintos motores, como PCRE2 cuando se indica. |
| **decoded_as** | Limita la regla a eventos identificados por un decodificador concreto. |
| **url** | Comprueba el campo URL extraído por el decodificador web. |

**Ejemplo del laboratorio:** la regla FTP **83050** detecta un inicio de sesión fallido, mientras que la **83051** utiliza `if_matched_sid`, `frequency="5"`, `timeframe="30"` y `same_srcip` para alertar de cinco fallos desde la misma IP en 30 segundos.

### ¿Qué son los decodificadores?

Un **decoder** interpreta una línea de log para que Wazuh pueda trabajar con sus campos. Por ejemplo, en los registros FTP, el decodificador integrado `vsftpd` extrae el usuario, la IP y el resultado del acceso; en Apache, `web-accesslog` obtiene la IP, el método HTTP, la URL y el código de respuesta.

Cuando el formato no queda cubierto por un decodificador existente, se puede añadir uno personalizado. Este laboratorio incluye un [decodificador específico para MySQL](decoders/mysql_decoder.xml).

## Instalación y comprobación

Desde la raíz del repositorio, los XML se copian al directorio de reglas del Manager:

```bash
sudo cp configuracion/rules/ssh/ssh-bruteforce.xml /var/ossec/etc/rules/
sudo cp configuracion/rules/ftp/ftp-events.xml /var/ossec/etc/rules/
sudo cp configuracion/rules/mysql/mysql.xml /var/ossec/etc/rules/
sudo cp configuracion/rules/apache/apache_vuln.xml /var/ossec/etc/rules/
```

Además de las reglas, cada servicio necesita tener correctamente configurada la **generación y recopilación de logs**. Los archivos de configuración, los decodificadores adicionales y los pasos concretos de cada servicio se explican en los README enlazados arriba.

Para validar la configuración del motor de análisis:

```bash
sudo /var/ossec/bin/wazuh-analysisd -t
```

Si no hay errores, reiniciar y comprobar Wazuh:

```bash
sudo systemctl restart wazuh-manager
sudo systemctl is-active wazuh-manager
```

Para probar una regla con un evento de ejemplo:

```bash
sudo /var/ossec/bin/wazuh-logtest
```

En la salida de `wazuh-logtest` se revisan especialmente:

- **Phase 1:** recepción y predecodificación del evento.
- **Phase 2:** decodificador utilizado y campos reconocidos.
- **Phase 3:** identificador, nivel y descripción de la regla activada.

**Estado de validación:** las 24 reglas personalizadas se han comprobado con eventos de prueba en `wazuh-logtest`. Sigue pendiente verificar el ciclo completo de generación de tráfico real, detección en Wazuh Dashboard, análisis y respuesta.

---
