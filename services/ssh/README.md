# Servicio SSH Vulnerable 

Bienvenido al rincón donde convertimos un SSH normalito en un **imán para atacantes**.  
Este servicio está _deliberadamente_ mal configurado:  
lo justo para que Hydra se divierta y Wazuh se ponga nervioso.

El objetivo de esto es simple:

- Permitir fuerza bruta real (Hydra, Medusa, lo que te apetezca)
- Generar logs útiles para detección
- Activar reglas de Wazuh (fallos + compromiso)
- Servir como base para tu PoC “SSH Brute Force”

Vamos, que es un SSH hecho a propósito para sufrir…  

---
## Estructura del servicio
---


```

services/ssh/ 
├── README.md           ← Esto que estás leyendo 
├── deploy.md           ← Cómo montar el SSH vulnerable sin morir en el intento 
└── configs/       
    └── sshd_config     ← El archivo REAL que activa el modo "pégame por favor"
```

---
## ¿Qué incluye este servicio?
---

### ✔️ `sshd_config` vulnerable

Una configuración lista para copiar a `/etc/ssh/sshd_config` que convierte tu máquina en:

> “Un SSH que acepta a cualquiera… siempre que acierte la contraseña”.

Incluye:

- `PermitRootLogin yes` → venga, entra como root, total…
- `PasswordAuthentication yes` → porque sin contraseña no hay Hydra
- `LogLevel VERBOSE` → para que Wazuh cotillee todo
- Escuchar en todas las interfaces → para que tu Kali sí o sí lo encuentre

Ideal para PoCs.  
Terrible para producción.  
Perfecta para ti.

### ✔️ `deploy.md`

Guía paso a paso donde explico:

- cómo instalar OpenSSH Server
- cómo aplicar **esta configuración del mal**
- cómo crear usuarios débiles (hola `123456`)
- cómo reiniciar el servicio
- dónde están los logs que Wazuh analiza
- cómo comprobar que el SSH está listo para ser torturado

Vamos, todo lo que necesitas para preparar un objetivo digno de Hydra.

---
## ⚠️ Advertencia seria 
---
Esto está pensado **para laboratorio**, no para la vida real.  
No lo expongas en tu router, en la nube o en tu casa de la playa…  
a no ser que quieras visitas indeseadas del mundo entero.

---

