# Servidor Apache Vulnerable

----
## 1. Descripción
----

Este repositorio contiene la configuración **básica y avanzada** de un servidor **Apache2** preparado para **prácticas, laboratorios y entornos de aprendizaje orientados al análisis de seguridad**.

Está diseñado para funcionar como un **servidor vulnerable** dentro de un entorno SIEM, con el objetivo de generar eventos reales que puedan ser detectados, analizados y correlacionados.

---
## 2. Objetivo del laboratorio
----

Este entorno sirve para entrenar y observar:

- Cómo Wazuh detecta cambios en archivos, configuraciones y estructura del servidor.  
- Cómo aparecen los eventos en el SIEM, desde accesos sospechosos hasta modificaciones del sistema.  
- Qué logs genera Apache cuando es atacado, escaneado o manipulado por un atacante.  
- Cómo correlacionar acciones ofensivas y defensivas, viendo el impacto real en los logs y alertas.  
- Cómo documentar un entorno realista, apto para auditorías, prácticas de investigación y ejercicios de detección.

---
## 3. Estructura del servicio
---

```
services/apache/ 
    ├── README.md       ← Esto que estás leyendo 
    ├── deploy.md       ← Cómo montar el apache vulnerable sin morir en el intento 
    |── configs/       
    |         └── 000-default.conf   ← Archivo de configuraciones
    ├──  web_vuln/
                 └──upload.php

```

---
## 4. Vulnerabilidades Apache
---

Apache, por sí solo, no es “peligroso”.  
Lo que lo convierte en un problema es **lo que se le pone encima** o **cómo se configura**.  
En un entorno real —y también en este laboratorio— existen **dos formas principales** de volverlo vulnerable:

### A) Subiendo una web vulnerable

La forma más común y realista.  

Ejemplos típicos:

- Formularios sin sanitizar  
- Subida de archivos sin validar (RCE en 2 clics)  
- `index.php` ejecutando comandos del sistema  
- Archivos `config.php` con credenciales expuestas  
- Directorios con *directory listing* activado  
- Carpeta `/uploads` accesible públicamente  
- Uso de `allow_url_fopen` o `include` sin control  
- Páginas de depuración olvidadas (`phpinfo()`, `debug.php`, etc.)

> **Esta es la fuente del 80% de vulnerabilidades en la vida real.**
> Es también lo que genera eventos interesantes para Wazuh y cualquier SIEM.

### B) Configurando mal Apache adrede

Una mala configuración convierte Apache en un colador.

Ejemplos:

- Directory listing habilitado por error  
- Permitir `.htaccess` con reglas peligrosas  
- Activar módulos innecesarios (o directamente inseguros)  
- Permisos 777 en carpetas críticas  
- Falta total de headers de seguridad  
- Logs accesibles públicamente  
- Permitir ejecución de scripts en carpetas públicas  
- DocumentRoot mal establecido

Esta parte es ideal para laboratorios:  
rompes la configuración para ver qué detecta Wazuh.


### En este laboratorio SIEM haremos **las dos**:

1. **Una web vulnerable** (PHP inseguro, uploads sin filtrar, rutas expuestas…).  
2. **Una configuración débil de Apache** (directory listing, permisos amplios, módulos activos sin control…).

El objetivo:  
**generar actividad real que un SIEM pueda detectar, analizar y correlacionar.**

---
## ⚠️ Advertencia 
---

Esto está pensado **para laboratorio**, no para la vida real.  
No configures jamás un apache así.

---
