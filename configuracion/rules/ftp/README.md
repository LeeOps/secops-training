# Reglas FTP para Wazuh

---
## ¿Dónde están las reglas?
---

Ruta:  
`rules/ftp/ftp-events.xml`

Dentro tienes:

✔️ Login fallido  
✔️ Fuerza bruta (fallos repetidos)  
✔️ Login correcto  
✔️ Login correcto tras bruteforce  
✔️ Subida de archivos  
✔️ Subida de ejecutables o scripts  
✔️ Descargas  
✔️ Eliminaciones sospechosas

---
## 1. Copiar el archivo de reglas a Wazuh
---
Solo si no lo has hecho antes
```
git clone https://github.com/LeeOps/secops-training
cd secops-training

# Copia el archivo de reglas al Wazuh Manager
sudo cp configuracion/rules/ftp/ftp-events.xml /var/ossec/etc/rules
```

Esto deja las reglas ya cargadas en el Manager.

---
## 2. Activar los logs en vsftpd
---

Sí, esta configuración debe añadirse ahora en el mismo archivo que configuramos anteriormente, en la sección de Servicios.

“Log completo de todo lo que el usuario hace dentro del FTP”

En `/etc/vsftpd.conf` añade o deja así: 

```
log_ftp_protocol=YES 
```

![Reglas ftp](img/logs_detallados.png)

---
## 3. Reiniciar vsftpd
---

Para que empiece a generar los logs que Wazuh necesita

```
sudo systemctl restart vsftpd
sudo systemctl status vsftpd
```

![Reglas ftp](img/restart.png)

---
## 4. Reiniciar Wazuh Manager
----

Para que cargue las reglas nuevas.

```

sudo systemctl restart wazuh-manager
```

---
