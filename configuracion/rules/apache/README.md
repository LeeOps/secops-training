# Reglas Wazuh para el Apache vulnerable

En `services/apache/wazuh/apache_vuln.xml` se incluyen varias reglas específicas para este laboratorio.  
Detectan acceso a zonas y ficheros inseguros de la web:

- Acceso a `phpinfo.php`
- Uso de `upload.php` (subida insegura)
- Acceso a `/uploads/` y ejecución de `.php` allí
- Acceso a `/logs/` y a `backup_2023.txt`
- Errores 500 repetidos desde la misma IP

## Cómo activarlas en Wazuh Manager

Copiar el archivo al directorio de reglas:

```
sudo cp configuracion/rules/apache/apache_vuln.xml /var/ossec/etc/rules/
sudo systemctl restart wazuh-manager
sudo systemctl status wazuh-manager
```

Como siempre ha de quedar en "active"

---
