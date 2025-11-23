#  **Cómo comprobar que un agente funciona**

Guía paso a paso para verificar que un agente Wazuh está enviando datos correctamente al Manager.

---
## 1. Verificar el estado del servicio del agente
---
###  Windows

Abrir: `services.msc`

Buscar **Wazuh Agent**.: Debe estar en **Running**.

Si no:
- clic derecho → **Start**
    
![agentes](img/ejecucion.png)

---
## 2. Ver los logs del agente
---

Los logs te dicen si el agente está conectado, si hay errores o si está enviando eventos.

### Windows

Ruta del log:

`C:\Program Files (x86)\ossec-agent\logs\2025\Nov\ossec-21.log.gz`

En Windows, el agente Wazuh **rota los logs automáticamente** por:

- Año
- Mes
- Día
Y los guarda **comprimidos en .gz**


#### Cómo ver los logs**
 **Descomprimir con 7-Zip**

1. Clic derecho
2. **7-Zip → Extract here**
3. Aparecerá el archivo:

`ossec-21.log`

#### ¿Qué deberías ver dentro del log?

Mensajes normales:
`Agent started Connected to server Sending keep alive Keep alive sent successfully`

Errores típicos:
`Invalid key Unable to connect Connection refused`

Ejemplos:

![agentes](img/logs.png)

---
## 3. Confirmar que el agente aparece en el Dashboard
---
Entra en: `https://TU-IP:5601`

Ir a:
**Wazuh → Management → Agents**

✔ Estado debe ser **Active**  
❌ Si sale en **Pending** → la clave no está bien  
❌ Si no aparece → no está conectado

![agentes](img/active.png)

---
## 4. Probar que envía eventos (prueba rápida)
---
### Windows:

Simplemente reinicia el servicio:

`services.msc → Wazuh Agent → Restart`

![agentes](img/reiniciar.png)

Verás en el Dashboard:

- Último check-in actualizado
- Estado en verde

Pulsa en vista para abrir el panel

![agentes](img/restart1.png)

Arriba a la izquierda veras el "last keep alive" actualizado

![agentes](img/restart2.png)

---
## 5. Señales de que el agente funciona correctamente
---

- Aparece **ACTIVE** en el Dashboard
- “Last keep alive” se actualiza cada pocos segundos
- No hay mensajes de error en `ossec.log`
- El Manager recibe alertas cuando reinicias el servicio
- El agente no reaparece con ID nuevo

---
