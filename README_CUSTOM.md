# SpaceFn-Evdev Auto

Una versión mejorada y automatizada de spacefn-evdev con detección automática de múltiples teclados y gestión avanzada de procesos.

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
make

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
spacefn-evdev/
├── spacefn.c                 # Código fuente principal
├── spacefn                   # Binario compilado
├── spacefn-auto.sh          # Script de gestión principal
├── install.sh               # Instalador automatizado
├── uninstall.sh             # Desinstalador
├── spacefn-auto.service     # Servicio systemd
└── Makefile                 # Configuración de compilación
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

Esta versión incluye mejoras significativas sobre el spacefn-evdev original:

1. **Gestión automática de múltiples teclados**
2. **Instalación automatizada de dependencias**
3. **Servicio systemd para inicio automático**
4. **Sistema de logging centralizado**
5. **Scripts de gestión avanzados**
6. **Detección inteligente de dispositivos**

## 📜 Licencia

Este proyecto mantiene la licencia del proyecto original. Ver `LICENSE.md`.

## 🙏 Reconocimientos

Basado en el proyecto original [spacefn-evdev](https://github.com/abrasive/spacefn-evdev) por James Laird-Wah.

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
