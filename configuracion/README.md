# Configuración de Wazuh

Esta carpeta organiza los componentes de monitorización y detección del laboratorio **SecOps Training**.

## ¿Cómo trabajan juntos?

1. **Agentes y recolectores:** obtienen los registros de Windows, Sysmon y los servicios del servidor Ubuntu.
2. **Decodificadores:** interpretan los registros y extraen campos como IP, usuario, URL o acción.
3. **Reglas:** analizan los campos o el contenido del evento para generar alertas cuando se cumplen sus condiciones.
4. **Indexer y Dashboard:** almacenan las alertas para consultarlas e investigarlas.

```text
Windows + Sysmon → Wazuh Agent ──┐
                                 ├──→ Wazuh Manager → Decodificadores → Reglas → Alertas → Indexer → Dashboard
Logs locales de Ubuntu ──────────┘
```

## Estructura y documentación

| Carpeta | Función | Guía |
| --- | --- | --- |
| [agente/](agente/) | Instalación, registro, comprobación y eliminación del agente Windows. | [README de agentes](agente/README.md) |
| [decoders/](decoders/) | Decodificación de eventos, incluido el decodificador personalizado de MySQL. | [README de decodificadores](decoders/README.md) |
| [rules/](rules/) | Conceptos de reglas y las detecciones personalizadas de SSH, FTP, MySQL y Apache. | [README de reglas](rules/README.md) |

Cada guía enlaza a la documentación técnica específica, con sus comandos de instalación, pruebas y archivos XML.

## Estado comprobado

- Wazuh Manager, Indexer y Dashboard operativos en Ubuntu Server.
- Agente Windows **005 / WindowsPRO-1** conectado, con eventos Sysmon visibles en el Dashboard.
- **20 reglas personalizadas** verificadas con `wazuh-logtest`: SSH (5), FTP (5), MySQL (5), Apache (5).
- Pendiente: pruebas completas con tráfico real, escenarios definidos, análisis y respuesta.

**La coincidencia de una regla no demuestra por sí sola la explotación de una vulnerabilidad.**

[Volver al README principal](../README.md)
