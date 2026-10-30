# Agentes Wazuh

Un **Wazuh Agent** recopila eventos de un equipo monitorizado y los envía a Wazuh Manager. En este laboratorio, el agente de Windows también recoge eventos de **Sysmon**.

## Contenido de la carpeta

| Carpeta | Para qué sirve | Documentación |
| --- | --- | --- |
| [instalacion/](instalacion/) | Preparar el equipo Windows, instalar, configurar y registrar el agente en Wazuh Manager. | [Guía de instalación](instalacion/README.md) |
| [comprobaciones/](comprobaciones/) | Verificar el servicio, la conexión con el Manager y la recepción de eventos. | [Guía de comprobaciones](comprobaciones/README.md) |
| [eliminacion/](eliminacion/) | Desregistrar un agente que ya no se utilice y verificar su eliminación. | [Guía de eliminación](eliminacion/README.md) |

Cada subcarpeta tiene su propia explicación paso a paso y capturas. Aquí se muestra qué tarea corresponde a cada una, sin duplicar las instrucciones.

## Agente Windows del laboratorio

| Dato | Valor comprobado |
| --- | --- |
| ID | 005 |
| Nombre registrado en Wazuh | WindowsPRO-1 |
| Nombre actual del equipo | DESKTOP-KCP7NBQ |
| Sistema operativo | Windows 10 Pro |
| IP observada | 192.168.141.136 |
| IP del servidor Wazuh | 192.168.141.100 |
| Versión del agente | 4.4.5 |

El agente se ha comprobado **Active** y se ha confirmado que las alertas Sysmon aparecen en Wazuh Dashboard. No hace falta que el nombre del sistema Windows coincida con el nombre registrado del agente.

## Comprobación rápida

En Ubuntu Server:

```bash
sudo /var/ossec/bin/agent_control -l
```

En PowerShell de Windows:

```powershell
Get-Service WazuhSvc
Get-Service Sysmon64
```

Para comprobar la recepción de eventos, consultar la [guía de comprobaciones](comprobaciones/README.md).

[Volver a configuración](../README.md)
