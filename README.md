# SecOps-Training — Laboratorio Realista de Seguridad Operacional



 <div align="center">

```
###############################################
#                 S E C O P S                #
#               T R A I N I N G              #
###############################################
```

</div>


                                        
⚠️ Estado del proyecto

El laboratorio se encuentra actualmente en desarrollo.

La infraestructura base y los principales servicios de monitorización ya se encuentran implementados y documentados.

Actualmente están disponibles:
- Servidor Wazuh sobre Ubuntu Server.
- Wazuh Manager, Indexer y Dashboard.
- Agente Wazuh en Windows.
- Sysmon para generación de telemetría avanzada.
- Configuración de servicios vulnerables controlados.
- Reglas personalizadas de detección.
- Monitorización de eventos y logs.

Quedan pendientes principalmente:
- Incorporación de Kali Linux como equipo de pruebas.
- Desarrollo de casos prácticos completos.
- Validación del ciclo ataque → detección → análisis → respuesta.
- Revisión y documentación final del laboratorio.
  
---
# Descripción general
---

Este repositorio contiene un laboratorio práctico de Seguridad Operacional (SecOps) diseñado para estudiar de forma controlada cómo se generan, recopilan y analizan eventos de seguridad.

El objetivo no es únicamente instalar herramientas, sino comprender el funcionamiento completo de un sistema de monitorización:

- Generación de eventos
- Recopilación de logs
- Procesamiento mediante Wazuh
- Generación de alertas
- Análisis de actividad
- Aplicación de medidas de respuesta

Todo el entorno se ejecuta en una infraestructura virtual aislada destinada exclusivamente a formación y pruebas.  

---
# Enfoque del laboratorio
---

### 🟦 Monitorización Blue Team
Actualmente el laboratorio permite trabajar con:

Análisis de logs y eventos
Validación de reglas
Investigación de alertas en Wazuh Dashboard
Monitorización de sistemas Linux y Windows
Telemetría generada mediante Sysmon
Detección de accesos y comportamientos sospechosos
Creación de reglas personalizadas 

### 🔴 Simulación de actividad ofensiva
El laboratorio está preparado para incorporar una máquina Kali Linux desde la que se realizarán pruebas controladas contra los servicios configurados.

Estas pruebas estarán destinadas exclusivamente a generar telemetría y comprobar la capacidad de detección del sistema.

---
# Ciclo completo
---

El objetivo final es reproducir el siguiente ciclo:

actividad de prueba
        ↓
evento
        ↓
registro / log
        ↓
Wazuh
        ↓
alerta
        ↓
análisis
        ↓
respuesta / mitigación

---
# Arquitectura prevista
---

El laboratorio completo incluye:

### 🟩 1. Ubuntu Server / Wazuh

Servidor central del laboratorio encargado de la recopilación y análisis de eventos.

Incluye:

- Wazuh Manager
- Wazuh Indexer
- Wazuh Dashboard
- Certificados
- Reglas personalizadas
- Recepción de eventos de sistemas Linux y Windows.

 
### 🟦 2. Windows Pro

Máquina Windows utilizada como sistema monitorizado y generador de eventos.

Incluye:

- Wazuh Agent
- Sysmon
- Eventos de usuario
- Creación y ejecución de procesos
- Eventos de red
- Registros del sistema operativo
  

### 🟪 3. Kali Linux (equipo atacante)
⏳ Pendiente

Se incorporará una máquina Kali Linux como equipo destinado a ejecutar pruebas controladas contra los servicios vulnerables del laboratorio.

Inicialmente se utilizará para:

- Reconocimiento de servicios
- Escaneo de puertos
- Pruebas de autenticación
- Fuerza bruta controlada
- Generación de eventos destinados a validar reglas de detección.

  
### 🟧 4. Red del laboratorio
La infraestructura se ejecuta en una red virtual NAT.

Esto permite:

- Comunicación entre las máquinas del laboratorio
- Aislamiento del entorno
- Realización segura de pruebas
- Evitar la exposición directa de los servicios vulnerables a Internet

---
#  Servicios configurados
---

El servidor dispone de varios servicios configurados específicamente para generar eventos de seguridad dentro del laboratorio.

###  SSH

Servicio SSH configurado deliberadamente con determinados parámetros inseguros para permitir pruebas controladas de autenticación.

Permite generar eventos relacionados con:

- Intentos de autenticación fallidos
- Fuerza bruta
- Accesos correctos
- Actividad de usuarios

Las reglas personalizadas de Wazuh permiten analizar estos eventos.

###  FTP

Servidor FTP basado en vsftpd.

El servicio permite generar eventos relacionados con:

- Autenticaciones fallidas
- Fuerza bruta
- Autenticaciones correctas
- Subida de archivos
- Descarga de archivos
- Operaciones realizadas por los usuarios

Los logs generados son enviados a Wazuh para su análisis.

###  MySQL

Servidor MySQL configurado como entorno de pruebas.

Incluye:

Usuario administrativo de laboratorio;

- Acceso remoto
- Base de datos de ejemplo
- Generación de logs
- Copia de seguridad accesible desde el servicio web
- PhpMyAdmin

Su finalidad es permitir posteriormente pruebas controladas de enumeración, autenticación y acceso a datos.

###  Apache

Servidor web Apache utilizado para generar eventos HTTP.

Se han creado reglas Wazuh destinadas a detectar accesos a determinados recursos del entorno, entre ellos:

- Phpinfo.php;
- Recursos de subida
- Directorio uploads
- Archivos de backup
- Recursos de logs
- Errores HTTP repetidos
  
--- 
#  Reglas personalizadas
---

El repositorio contiene reglas Wazuh específicas para los servicios del laboratorio.

Actualmente se trabajan reglas relacionadas con:

- SSH
- FTP
- MySQL
- Apache

Las reglas permiten transformar determinados eventos registrados por los servicios en alertas visibles dentro de Wazuh Dashboard.

---
#  Sysmon
---

La máquina Windows incorpora Sysmon para generar telemetría detallada sobre el comportamiento del sistema.

Esto permite obtener información adicional sobre:

- Procesos
- Conexiones de red
- Creación de procesos
- Actividad del sistema
- EVentos relevantes para seguridad

Los eventos de Sysmon son recopilados mediante Wazuh Agent y enviados al servidor central

---
#  Estructura del repositorio
---

El contenido del laboratorio se organiza en bloques claros:
```
secops-training
│
├── cases
│
├── configuracion
│   ├── agente
│   │   ├── comprobaciones
│   │   │   ├── img
│   │   │   └── README.md
│   │   ├── eliminacion
│   │   │   ├── img
│   │   │   └── README.md
│   │   └── instalacion
│   │       ├── img
│   │       └── README.md
│   │
│   └── rules
│       ├── apache
│       │   ├── apache_vuln.xml
│       │   └── README.md
│       │
│       ├── ftp
│       │   ├── img
│       │   ├── ftp-events.xml
│       │   └── README.md
│       │
│       ├── mysql
│       │   ├── img
│       │   ├── mysql.xml
│       │   └── README.md
│       │
│       └── ssh
│           ├── img
│           ├── README.md
│           └── ssh-bruteforce.xml
│
├── instalacion
│   ├── ubuntu
│   │   ├── img
│   │   └── README.md
│   │
│   ├── wazuh
│   |  ├── img
│   |  └── README.md
│   │
│   └── windows
│       ├── img
│       └── README.md
|
├── services
│   ├── apache
│   │   ├── configs
│   │   │   └── 000-default.conf
│   │   └── img
│   │
│   ├── ftp
│   │   ├── configs
│   │   │   └── ftp_config
│   │   ├── img
│   │   ├── deploy.md
│   │   └── README.md
│   │
│   ├── mysql
│   │   ├── configs
│   │   │   └── backup.sql
│   │   ├── img
│   │   ├── deploy.md
│   │   └── README.md   
│   │
│   └── ssh
│       ├── configs
│       ├── img
│       ├── deploy.md
│       └── README.md
│
├── sysmon
│   ├── img
│   └── README.md
│
└── README.md (general)
```

---
# Próximas fases
---

Las siguientes fases del proyecto serán:

1. Incorporación de Kali Linux

Configuración de una máquina Kali Linux dentro de la red virtual del laboratorio.

2. Validación de conectividad

Comprobación de comunicación entre Kali y los diferentes servicios.

3. Casos prácticos

Desarrollo de escenarios controlados, por ejemplo:

- Escaneo de servicios;
- Intentos repetidos de autenticación SSH;
- Intentos repetidos de autenticación FTP;
- Actividad sospechosa contra servicios web;
- Pruebas contra MySQL.

4. Detección

Comprobación de que los eventos generados aparecen correctamente en Wazuh.

5. Análisis y respuesta

Documentación de:

- Evento producido;
- Log generado;
- Regla activada;
- Alerta resultante;
- Análisis realizado;
- Posible medida de mitigación.


---
#  Objetivo final
---
El objetivo final del proyecto es disponer de un laboratorio modular y reproducible que permita comprender de forma práctica la relación entre:

sistema
   ↓
evento
   ↓
log
   ↓
SIEM
   ↓
detección
   ↓
análisis
   ↓
respuesta

El laboratorio está diseñado exclusivamente para formación y pruebas en un entorno virtual controlado.


---
⏳ Pendiente
---

Incorporación de Kali Linux.
Desarrollo de casos prácticos.
Pruebas de detección.
Documentación de alertas.
Validación de respuestas y mitigaciones.
Revisión final de documentación.
