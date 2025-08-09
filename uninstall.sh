#!/bin/bash

# Script de desinstalación completa para spacefn-auto
# Elimina todos los componentes instalados

echo "=== Desinstalador de SpaceFn Auto ==="
echo ""

echo "⚠️  Este script eliminará completamente spacefn-auto del sistema"
echo "Esto incluye:"
echo "  - Todos los procesos spacefn"
echo "  - Servicio systemd"
echo "  - Reglas udev"
echo "  - Directorios del sistema (/var/run/spacefn, /var/log/spacefn)"
echo "  - Archivos de configuración"
echo ""
read -p "¿Continuar con la desinstalación? (y/N): " confirm
if [[ ! "$confirm" =~ ^[yY] ]]; then
    echo "Desinstalación cancelada"
    exit 0
fi
echo ""

# 1. Detener todos los procesos
echo "1. Deteniendo procesos spacefn..."
sudo systemctl stop spacefn-auto.service 2>/dev/null || true
sudo pkill -9 -f spacefn 2>/dev/null || true
echo "✓ Procesos detenidos"

# 2. Deshabilitar y eliminar servicio systemd
echo "2. Eliminando servicio systemd..."
sudo systemctl disable spacefn-auto.service 2>/dev/null || true
sudo rm -f /etc/systemd/system/spacefn-auto.service
sudo systemctl daemon-reload
echo "✓ Servicio systemd eliminado"

# 3. Eliminar reglas udev
echo "3. Eliminando reglas udev..."
sudo rm -f /etc/udev/rules.d/99-spacefn-keyboards.rules
sudo rm -f /etc/udev/rules.d/60-spacefn.rules*  # También backups
sudo udevadm control --reload-rules
echo "✓ Reglas udev eliminadas"

# 4. Eliminar directorios del sistema
echo "4. Eliminando directorios del sistema..."
sudo rm -rf /var/run/spacefn
sudo rm -rf /var/log/spacefn
echo "✓ Directorios del sistema eliminados"

# 5. Limpiar binarios (opcional)
echo "5. Limpiando binarios compilados..."
if [[ -f "/home/brandontrigueros/spacefn-evdev/spacefn" ]]; then
    rm -f /home/brandontrigueros/spacefn-evdev/spacefn
    echo "✓ Binario spacefn eliminado"
else
    echo "✓ No hay binarios para eliminar"
fi

# 6. Verificación final
echo "6. Verificando desinstalación..."
processes=$(ps aux | grep -v grep | grep spacefn | wc -l)
systemd_files=$(find /etc/systemd -name "*spacefn*" 2>/dev/null | wc -l)
udev_files=$(find /etc/udev -name "*spacefn*" 2>/dev/null | wc -l)

echo "   Procesos spacefn restantes: $processes"
echo "   Archivos systemd restantes: $systemd_files"
echo "   Archivos udev restantes: $udev_files"

if [[ $processes -eq 0 && $systemd_files -eq 0 && $udev_files -eq 0 ]]; then
    echo "✅ Desinstalación completada exitosamente"
else
    echo "⚠️  Algunos archivos pueden quedar. Revisar manualmente:"
    [[ $processes -gt 0 ]] && ps aux | grep -v grep | grep spacefn
    [[ $systemd_files -gt 0 ]] && find /etc/systemd -name "*spacefn*" 2>/dev/null
    [[ $udev_files -gt 0 ]] && find /etc/udev -name "*spacefn*" 2>/dev/null
fi

echo ""
echo "=== Desinstalación Completada ==="
echo ""
echo "Para reinstalar, ejecuta: ./install.sh"
