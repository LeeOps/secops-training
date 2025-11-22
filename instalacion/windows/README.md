# **Instalación de Windows Pro en VMware Workstation / Player**

---
## 🖥️ Descarga de Windows 10 Pro (ISO oficial)
---
En este laboratorio vamos a instalar una máquina Windows que usaremos más adelante para conectar el **Wazuh Agent**, revisar logs, generar eventos y simular ataques.  
No te preocupes: todo lo veremos paso a paso.

### Antes de empezar: ¿de dónde saco Windows?

Yo estoy usando una **ISO de Windows 10 Pro** que ya tenía descargada.  
Para no alargar esto con capturas que pueden cambiar según la versión, te dejo directamente el enlace oficial por si tú necesitas descargarla:

👉 [https://www.microsoft.com/es-es/software-download/](https://www.microsoft.com/es-es/software-download/)

Cualquier **Windows 10 Pro o Windows 11 Pro** te servirá.  
La versión “Pro” es importante porque más adelante, si quieres, podrás unir la máquina a un dominio o usar funcionalidades avanzadas.

---
## Configuración recomendada de la máquina virtual (Windows 10 Pro)
---
## ⚙️ Configuración recomendada de la máquina virtual

Esta máquina Windows va a convivir con otras (Wazuh, Kali, Ubuntu…). Así que vamos a darle lo justo para que funcione fluida sin quitarle vida a tu equipo.

Aquí tienes lo ideal si tienes 16 GB de RAM:

|Recurso|Configuración que vamos a usar|
|---|---|
|RAM|**4 GB**|
|CPU|**2 vCPUs**|
|Disco|**50 GB (SCSI)**|
|Red|**NAT**|

Con esto va sobrada para ejecutar Sysmon, Wazuh Agent y todas las herramientas que usaremos.

---
## Crear la máquina virtual en VMware
---

- Abre VMware Workstation / Player.
- Haz clic en **Create a New Virtual Machine**.
- Elige **Typical (recommended)**.

![Windows](typical.png)

4. Selecciona tu ISO de Windows cuando te lo pida.

![Windows](iso_cre.png)

5.  Ponle un nombre a tu máquina y decide dónde guardarla.
 ![Windows](nombrar.png)

6. Ahora ajustamos el hardware (RAM, CPU, disco…).  
    Haz clic en **Customize Hardware**.

![Windows](LABORATORIOS/labs/BlueTeam/Wazu-Lab/instalacion/instalacion-windows/img/hardware.png)

7. Cuando termines, pulsa **Finish** y VMware creará la VM.  
   Puede tardar un poco.

![Windows](disk.png)


---
## ▶️ Instalación de Windows paso a paso
---
Aquí puede variar un poco según la ISO, pero no te preocupes: todas las instalaciones de Windows son prácticamente iguales.  
Tú sigue estas indicaciones y si algo cambia, elige lo más parecido.

1. Selecciona idioma, formato y teclado


![[idioma.png]]
2. Pulsa **Instalar ahora**

![[instalar.png]]
    
3. ### Cuando te pida una clave, dale a:
👉 **No tengo clave de producto**

![[activar.png]]
4. ### Elige **Windows 10 Pro**
   (Es la que usaremos en todo el laboratorio)

![[winpro.png]]

5. Acepta los términos de licencia

![[licencia.png]]
 
 6. ### Deja las opciones del disco tal cual vienen
    A menos que quieras complicarte, lo dejamos en “Siguiente”.

![[disco.png]]

Y ahora Windows empezará a instalarse.  
Tardará unos minutos.


![[instalando.png]]

Configura:

- idioma
- teclado
- nombre de usuario
- contraseña ...
Sigue los pasos...

Cuando llegues al escritorio, verás que la pantalla se ve muy pequeña:  
Eso es normal → necesitamos instalar **VMware Tools**.

Reinicia cuando te lo pida, y la resolución ya encajará.

---
## ⚠️ ¿Por qué estamos usando Windows 10 Pro?
___
Aunque Windows 11 funciona bien, Windows 10 Pro es simplemente **más práctico para laboratorios de ciberseguridad**.

Te explico por qué:

#### ✔️ 1. Consume menos recursos
Windows 11 tira más de CPU, GPU y RAM. Si vas a tener varias máquinas arrancadas, se nota.

#### ✔️ 2. Mejor compatibilidad
Muchos materiales, PoCs, configuraciones de Sysmon y laboratorios de Wazuh están pensados para Windows 10.  
Seguirlos es más fácil.

####✔️ 3. Instalación sencilla en VMware
Windows 11 necesita TPM, Secure Boot y otros requisitos que en VMware a veces dan problemas.

#### ✔️ 4. Es el estándar en formación y labs
Casi todos los cursos, demo-labs y guías de seguridad usan Windows 10 Pro como base.

---
 
A partir de aquí tu máquina Windows está lista para:

- instalar Sysmon
- configurar Wazuh Agent
- generar eventos
- simular ataques
- o lo que toque en tu laboratorio.

---
## ➡️ Siguiente Paso: Instalación y Registro de los Agentes de Wazuh

---

La siguiente fase del laboratorio será:

- Actualizar el sistema
- Descargar e instalar **Wazuh (All-in-One)**
- Acceder al dashboard
- Iniciar la configuración del SIEM

 👉Sigue aquí:  [Ir a Instalación y Registro Agentes Wazuh](https://github.com/LeeOps/secops-training/blob/main/configuracion/wazuh/agentes.md)


