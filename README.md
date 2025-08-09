# SpaceFn-Evdev Auto

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Based on](https://img.shields.io/badge/Based%20on-spacefn--evdev-blue.svg)](https://github.com/abrasive/spacefn-evdev)
[![Platform](https://img.shields.io/badge/Platform-Linux-green.svg)](https://www.linux.org/)
[![GitHub release](https://img.shields.io/github/v/release/BrandonTrigueros/spacefn-auto)](https://github.com/BrandonTrigueros/spacefn-auto/releases)

Una versión mejorada y automatizada de [spacefn-evdev](https://github.com/abrasive/spacefn-evdev) con detección automática de múltiples teclados y gestión avanzada de procesos.

> **⚠️ Importante**: Este proyecto está basado en el trabajo original de **James Laird-Wah** ([@abrasive](https://github.com/abrasive)). El repositorio original se encuentra en: https://github.com/abrasive/spacefn-evdev

## ⚡ Instalación rápida

```bash
# Clonar el repositorio
git clone https://github.com/BrandonTrigueros/spacefn-auto.git
cd spacefn-auto

# Instalación automática
./install.sh
```

## 🚀 Características

- **Detección automática de múltiples teclados**: Detecta y configura spacefn para todos los teclados conectados
- **Instalación completamente automatizada**: Script que instala dependencias automáticamente
- **Gestión de procesos avanzada**: Control inteligente de múltiples procesos spacefn
- **Servicio systemd**: Inicio automático al arrancar el sistema
- **Logs organizados**: Sistema de logging centralizado
- **Desinstalación limpia**: Script de desinstalación completa

## 📦 Instalación

### Automática (Recomendada)

```bash
./install.sh
```

Este script automáticamente:
- Detecta tu distribución Linux
- Instala las dependencias necesarias (`libevdev-dev`, `build-essential`, etc.)
- Compila el binario
- Configura el servicio systemd
- Inicia spacefn para todos los teclados detectados

### Manual

```bash
# Instalar dependencias (Ubuntu/Debian)
sudo apt-get install build-essential libevdev-dev pkg-config

# Compilar
cc `pkg-config --cflags libevdev` spacefn.c -o spacefn `pkg-config --libs libevdev`

# Iniciar manualmente
./spacefn-auto.sh start
```

## 🎮 Uso

### Gestión de spacefn

```bash
./spacefn-auto.sh start    # Iniciar para todos los teclados
./spacefn-auto.sh stop     # Detener todos los procesos
./spacefn-auto.sh restart  # Reiniciar
./spacefn-auto.sh status   # Ver estado
```

### Gestión con systemd

```bash
sudo systemctl start spacefn-auto     # Iniciar servicio
sudo systemctl stop spacefn-auto      # Detener servicio
sudo systemctl status spacefn-auto    # Ver estado
```

## ⌨️ Mapeo de teclas (con Espacio presionado)

| Tecla | Función |
|-------|---------|
| `j` | ← (Izquierda) |
| `k` | ↓ (Abajo) |
| `i` | ↑ (Arriba) |
| `l` | → (Derecha) |
| `u` | Home |
| `o` | End |
| `,` | Page Down |
| `.` | Page Up |
| `b` | Espacio |

## 🔧 Personalización

Edita la función `key_map()` en `spacefn.c` para personalizar el mapeo de teclas:

```c
unsigned int key_map(unsigned int code) {
    switch (code) {
        case KEY_J:
            return KEY_LEFT;
        // Agregar más mapeos aquí
    }
    return 0;
}
```

## 📁 Estructura del proyecto

```
spacefn-evdev-auto/
├── spacefn.c                 # Código fuente principal (basado en trabajo de James Laird-Wah)
├── spacefn                   # Binario compilado (auto-generado)
├── spacefn-auto.sh          # Script de gestión principal (nuevo)
├── install.sh               # Instalador automatizado (nuevo)
├── uninstall.sh             # Desinstalador (nuevo)
├── spacefn-auto.service     # Servicio systemd (nuevo)
├── 99-spacefn-keyboards.rules # Reglas udev opcionales (nuevo)
├── README.md                # Documentación
├── LICENSE.md               # Licencia (original: dominio público, modificaciones: MIT)
└── .gitignore               # Configuración de Git
```

## 📊 Logs y Debugging

```bash
# Ver logs en tiempo real
sudo tail -f /var/log/spacefn/spacefn.log

# Ver estado detallado
./spacefn-auto.sh status

# Debugging de dispositivos
ls -la /dev/input/by-id/ | grep kbd
```

## 🗑️ Desinstalación

```bash
./uninstall.sh
```

## 🔄 Diferencias con el proyecto original

Esta versión incluye mejoras significativas sobre el [spacefn-evdev original de James Laird-Wah](https://github.com/abrasive/spacefn-evdev):

### ✨ **Nuevas características**:
1. **Gestión automática de múltiples teclados** - El original solo maneja un teclado
2. **Instalación automatizada de dependencias** - El original requiere instalación manual
3. **Servicio systemd para inicio automático** - El original no incluye gestión de servicios
4. **Sistema de logging centralizado** - El original no tiene logs organizados
5. **Scripts de gestión avanzados** - El original solo tiene el binario básico
6. **Detección inteligente de dispositivos** - El original requiere especificar el dispositivo manualmente

### �️ **Código base**:
- El núcleo de `spacefn.c` mantiene la lógica original de James Laird-Wah
- Se agregaron scripts de automatización y gestión (`spacefn-auto.sh`, `install.sh`, `uninstall.sh`)
- Se mejoró la experiencia de usuario con instalación y configuración automática

## 📜 Licencia

- **Código original**: Dominio público (James Laird-Wah, 2018)
- **Modificaciones y mejoras**: MIT License (Brandon Trigueros, 2025)

Ver `LICENSE.md` para detalles completos.

## 🙏 Reconocimientos

### Autor Original
- **James Laird-Wah** ([@abrasive](https://github.com/abrasive))
- **Repositorio original**: https://github.com/abrasive/spacefn-evdev
- **Año**: 2018
- **Concepto**: Implementación de SpaceFn para Linux usando evdev

### Modificaciones
- **Brandon Trigueros** - Automatización, gestión multi-teclado, y mejoras de UX
- **Año**: 2025

## 🐛 Solución de problemas

### Problema: No detecta teclados
```bash
# Verificar dispositivos disponibles
ls -la /dev/input/by-id/ | grep kbd

# Reiniciar detección
./spacefn-auto.sh restart
```

### Problema: Permisos insuficientes
```bash
# Agregar usuario al grupo input
sudo usermod -a -G input $USER
# Luego logout/login
```

### Problema: Procesos duplicados
```bash
# Limpiar y reiniciar
./spacefn-auto.sh stop
./spacefn-auto.sh start
```
