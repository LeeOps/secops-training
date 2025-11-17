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

Este laboratorio se encuentra en desarrollo activo.
Las guías de instalación, configuración, ataques controlados y detección se irán incorporando progresivamente a medida que se finalicen las pruebas y validaciones.
El contenido crecerá de forma continua a medida que se completen las máquinas y los casos prácticos.

# Descripción general

Este repositorio no es una guía rápida ni un listado de comandos sin contexto.
El objetivo es construir un entorno completo de Seguridad Operacional (SecOps) donde se documenta:

- qué ocurre internamente en cada sistema
- por qué sucede
- cómo se generan y procesan los eventos
- cómo se detectan y analizan
- cómo se responde y se mitiga

Todo ello dentro de un entorno aislado, seguro y reproducible, pensado para entrenar habilidades tanto ofensivas como defensivas de forma realista.

# Enfoque del laboratorio
🟦 Blue Team

- Análisis de logs y eventos
- Validación de reglas y alertas
- Investigación en el Dashboard
- Prácticas de detección de integridad
- Respuesta ante incidentes reales

🔴 Red Team (controlado)

- Ejecución de técnicas MITRE
- Generación de eventos intencionados
- Pruebas de persistencia y movimiento lateral
- Observación del rastro que deja cada técnica
- Evaluación de detecciones frente a evasión

# Ciclo completo

ataque → evento → alerta → análisis → respuesta → mitigación

El laboratorio está diseñado para que ambos roles puedan estudiarse de forma conjunta.

# Arquitectura prevista

El entorno base está compuesto por:

- Servidor Wazuh sobre Ubuntu Server (CLI)
- Windows Server como sistema generador de eventos y agente del SIEM
- Kali Linux como equipo atacante

# Configuración de red

Toda la infraestructura funciona en NAT, lo que permite:

- mantener el laboratorio aislado
- evitar exponer servicios
- reproducir escenarios controlados
- garantizar que las máquinas se ven entre sí sin afectar a la red real

Este diseño facilita la ejecución de ataques, la captura de eventos y el análisis de detecciones sin riesgos.

📁 Estructura del repositorio

El contenido del laboratorio se organiza en bloques claros:
```
training/
 ├── instalacion/
 │    ├── ubuntu/
 │    ├── wazuh/
 │    └── windows/
 │
 ├── configuracion/
 │    ├── wazuh/
 │    ├── windows/
 │    └── kali/
 │
 └── casos/
      ├── caso01/
      ├── caso02/
      ├── caso03/
      ├── caso04/
      └── caso05/
```
Cada carpeta contiene documentación detallada, evidencias y pasos prácticos.

# Evolución del proyecto

El laboratorio se ampliará con:

- nuevos casos prácticos (ataque → detección → respuesta)
- configuraciones avanzadas de Wazuh- 
- técnicas MITRE adicionales
- escenarios de movimiento lateral
- hardening y mitigación
- agentes adicionales (Linux y Windows)

El propósito final es crear un entorno modular, escalable y apto para formación continua.






## 📌 Estado actual del laboratorio

- ✔ Ubuntu Server instalado y documentado  
- ✔ Wazuh 4.4.x instalado correctamente  
- ✔ Certificados funcionales  
- ✔ Dashboard accesible  
- ✔ Estructura del repositorio creada  
- ⏳ Windows Server en preparación  
- ⏳ Kali Linux pendiente de configuración  
- ⏳ Casos prácticos en desarrollo  

## 🚧 Próximamente

Los siguientes módulos están en desarrollo y se publicarán a medida que se completen:

- Instalación y configuración de Windows Server como agente
- Primeros casos prácticos (Caso 01, Caso 02…)
- Integración de Sysmon + detecciones en tiempo real
- Escenarios iniciales Red Team
- Alertas personalizadas en Wazuh



