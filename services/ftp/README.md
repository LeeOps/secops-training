# Detección de FTP Vulnerable en Wazuh

**Este laboratorio usa una configuración FTP muy realista… tan realista que todavía se encuentra en demasiadas empresas.**  
Es la típica instalación donde el servidor funciona, los archivos suben, nadie toca TLS “porque total, está en la intranet”, y todo el mundo confía ciegamente en el firewall como si fuera Gandalf en la muralla: _“¡no pasarán!”_

Perfecto para practicar.

---
## ¿Por qué vigilar FTP en pleno 2025?
---

Porque siempre hay un iluminado que deja un FTP abierto “para compartir archivos rápido”.  
Y claro, luego se sorprenden cuando:

- entra todo Dios,
- les listan directorios,
- les descargan cosas,
- y les suben un `shell.php` con más mala leche que tu router cuando va mal.

Así que este módulo existe para evitar que tu Wazuh viva engañado.

---
## ¿Qué detecta este módulo?
---
Nuestro archivo de reglas hará que Wazuh diga cosas como:

- “Aquí hay logins fallidos que huelen a script kiddie con prisa”
- “Esta IP está haciendo **enumeración de directorios** como si no hubiera mañana”
- “Alguien está subiendo ficheros al FTP… ¿hola?”
- “Se ha iniciado **FTP anónimo**. Encended la sirena.”
- “Se ha descargado un archivo ejecutable desde FTP. Qué podría salir mal…”

Vamos, lo que un SIEM decente debería haber hecho siempre.


---
## Requisitos
---

- FTP instalado (te recomiendo **vsftpd**, lo ponemos vulnerable ahora).
- Logs visibles en:  `/var/log/vsftpd.log`
- Wazuh Manager funcionando

---
## Estructura del servicio
---

```

services/ftp/ 
├── README.md       ← Esto que estás leyendo 
├── deploy.md       ← Cómo montar el SSH vulnerable sin morir en el intento 
└── configs/       
└── ftp_config     ← El archivo REAL que activa el modo "pégame por favor"
```

---
## ¿Qué incluye este servicio?
---
### ✔️ `vsftpd.conf` vulnerable

Una configuración que convierte tu servidor FTP en:

> “El paraíso del script kiddie aburrido”.

Contiene :

- Sniffing
- MITM
- Credential harvesting
- Fuerza bruta
- DoS en conexiones PASV
- Reconocimiento y fingerprinting
- Acceso no autorizado por contraseñas débiles
- Interceptación y modificación de archivos

---
### ✔️ `deploy.md`

Guía detallada donde explico:

- cómo instalar vsftpd
- cómo aplicar _esta configuración demoníaca_
- cómo reiniciar el servicio
- cómo crear usuarios débiles
- cómo activar FTP anónimo
- dónde están los logs
- cómo comprobar que el FTP está listo para ser atacado

---
## ⚠️ Advertencia seria 
---

No se te ocurra configurar así un servicio ftp en producción.

---
