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

El laboratorio se encuentra en desarrollo activo, pero la base funcional YA está completada.  
Los módulos restantes (Kali Linux y los casos prácticos avanzados) se irán añadiendo conforme se terminen las pruebas y validaciones finales.

---
# Descripción general
---

Este repositorio no es una guía rápida ni un listado de comandos sueltos.

El objetivo es construir un entorno **completo de Seguridad Operacional (SecOps)** donde se documenta:

- qué ocurre internamente en cada sistema  
- por qué sucede  
- cómo se generan y procesan los eventos  
- cómo se detectan y analizan  
- cómo se responde y se mitiga  

Todo dentro de un laboratorio seguro, aislado y totalmente reproducible, pensado para entrenamiento realista tanto **Blue Team** como **Red Team**.

---
# Enfoque del laboratorio
---

### 🟦 Blue Team
- Análisis de logs y eventos  
- Validación de reglas y alertas  
- Investigación en Dashboard  
- Integridad del sistema  
- Respuesta ante incidentes  
- Detección de técnicas MITRE  

### 🔴 Red Team (controlado)
- Ejecución técnica de ataques  
- Generación intencionada de eventos  
- Pruebas de persistencia y movimiento lateral  
- Kerberoasting, AS-REP, RDP abuse, etc.  
- Evaluación de detecciones y evasión

---
# Ciclo completo
---

ataque → evento → alerta → análisis → respuesta → mitigación

El laboratorio está diseñado para que ambos roles puedan estudiarse de forma conjunta.

---
# Arquitectura prevista
---

El laboratorio completo incluye:

### 🟩 1. Servidor Wazuh sobre Ubuntu Server (CLI)
- Consola  
- Indexer  
- Dashboard  
- Certificados  
- Reglas personalizadas  
- Recepción de agentes Linux y Windows  

### 🟦 2. Windows Pro (cliente generador de eventos)
- Sysmon  
- Wazuh Agent  
- Eventos de usuario, procesos y red  
- Integración con AD (opcional)

Uso Windows 10 Pro como primera máquina Windows del laboratorio porque consume menos recursos y permite generar telemetría completa (Sysmon, Wazuh Agent y eventos ETW).

La telemetría funciona igual en Pro y en Server, por lo que cualquiera puede usar Windows Server si lo prefiere.

> ### >>>> Nota sobre la versión de Windows utilizada <<<<
> Este laboratorio utiliza inicialmente Windows Pro por simplicidad, pero el entorno es **totalmente compatible con Windows Server 2019/2022**.

> Si quieres ampliar el laboratorio a un entorno corporativo realista, puedes añadir:

>  - Active Directory Domain Services  
>  - DNS interno  
>  - Kerberos  
>  - Usuarios, grupos y OUs  
>  - GPOs  
>  - File Server (SMB nativo)  
>  - Print Server  
>  - Sysmon + Wazuh Agent  

Más adelante se añadirá una sección dedicada a la ampliación con Active Directory.

>>>>> La carpeta `instalacion/windows-ad/` se creará cuando comience la documentación del módulo AD (instalación de AD DS, dominio, OUs, usuarios, GPOs y unión de equipos).

Por ahora, la integración con AD está planificada como ampliación opcional del laboratorio.


### 🟪 3. Kali Linux (equipo atacante)
⏳ *Pendiente de configuración final*  

Será la máquina destinada a ejecutar:
- Recon  
- Explotación controlada  
- Movimiento lateral  
- Técnicas MITRE  
- Ataques a AD
  
Esto permitirá escalar el proyecto a un entorno corporativo realista donde entrenar:

- Kerberoasting  
- AS-REP Roasting  
- Enumeración de dominio  
- Movimientos laterales  
- Abuso de permisos  
- Detecciones avanzadas en el SIEM
  
### 🟧 4. Configuración de red
Toda la infraestructura corre en **NAT**, lo que garantiza:

- Aislamiento completo  
- Seguridad  
- Reproducción de escenarios  
- Interconexión entre máquinas  
- Ningún servicio expuesto a Internet  

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
│   │   ├── img
│   │   └── README.md
│   │
│   ├── windows
│   │   ├── img
│   │   └── README.md
│   │
│   └── windows-ad   < NUEVA SECCIÓN (recomendada)
│       ├── img
│       ├── ad-install.md
│       ├── ad-users-gpos.md
│       └── README.md
│
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
# Evolución del proyecto
---


El laboratorio continúa ampliándose con:

- Nuevos casos prácticos (ataque → detección → respuesta)  
- Integración total de Windows Server + AD  
- Técnicas MITRE adicionales  
- Escenarios de movimiento lateral  
- Hardening avanzado  
- Más agentes Linux/Windows  
- Escenarios Red Team completos  

El propósito final es crear un entorno modular, escalable y apto para formación continua.

---
### ⏳ PENDIENTE
---

- Kali Linux  
- Escenarios Red Team completos  
- Creación y documentación del módulo Active Directory (instalación, OUs, GPOs, unión de clientes)



