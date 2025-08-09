#!/bin/bash

# Script de instalación automática para spacefn-auto
# Configura spacefn para detectar automáticamente todos los teclados
# Incluye instalación automática de dependencias

SPACEFN_DIR="/home/brandontrigueros/spacefn-evdev"

echo "=== Instalador Automático de SpaceFn Auto ==="
echo ""

# Función para detectar el gestor de paquetes
detect_package_manager() {
    if command -v apt-get >/dev/null 2>&1; then
        echo "apt"
    elif command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v pacman >/dev/null 2>&1; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Instalar dependencias automáticamente
echo "1. Instalando dependencias del sistema..."
PACKAGE_MANAGER=$(detect_package_manager)

case "$PACKAGE_MANAGER" in
    "apt")
        echo "Detectado: Sistema basado en Debian/Ubuntu"
        sudo apt-get update
        sudo apt-get install -y build-essential libevdev-dev pkg-config
        ;;
    "dnf")
        echo "Detectado: Sistema basado en Fedora"
        sudo dnf install -y gcc make libevdev-devel pkgconfig
        ;;
    "yum")
        echo "Detectado: Sistema basado en RHEL/CentOS"
        sudo yum install -y gcc make libevdev-devel pkgconfig
        ;;
    "pacman")
        echo "Detectado: Sistema basado en Arch"
        sudo pacman -S --needed gcc make libevdev pkgconfig
        ;;
    *)
        echo "⚠️  Gestor de paquetes no detectado. Instala manualmente:"
        echo "   - build-essential / gcc make"
        echo "   - libevdev-dev / libevdev-devel"
        echo "   - pkg-config / pkgconfig"
        read -p "¿Continuar asumiendo que las dependencias están instaladas? (y/N): " continue_install
        if [[ ! "$continue_install" =~ ^[yY] ]]; then
            echo "Instalación cancelada"
            exit 1
        fi
        ;;
esac
echo "✓ Dependencias instaladas/verificadas"
echo ""

# Verificar que el binario spacefn existe o compilarlo
echo "2. Compilando spacefn..."
if [[ ! -f "$SPACEFN_DIR/spacefn" ]]; then
    echo "Compilando binario spacefn..."
    cd "$SPACEFN_DIR"
    make
    if [[ $? -ne 0 ]]; then
        echo "ERROR: No se pudo compilar spacefn"
        echo "Verifica que las dependencias estén correctamente instaladas"
        exit 1
    fi
    echo "✓ spacefn compilado exitosamente"
else
    echo "✓ Binario spacefn ya existe"
fi

echo ""

# Detener servicios existentes si están corriendo
echo "3. Deteniendo servicios existentes..."
sudo systemctl stop spacefn-auto.service 2>/dev/null || true
sudo pkill -f spacefn 2>/dev/null || true
sudo rm -rf /var/run/spacefn/*.pid 2>/dev/null || true
echo "✓ Servicios existentes detenidos"
echo ""

# Instalar servicio systemd
echo "4. Instalando servicio systemd..."
sudo cp "$SPACEFN_DIR/spacefn-auto.service" /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable spacefn-auto.service
echo "✓ Servicio systemd instalado y habilitado"
echo ""

# NO instalar reglas udev por ahora (causan bucles)
echo "5. Configurando reglas udev..."
echo "⚠️  Reglas udev de hot-plug deshabilitadas temporalmente"
echo "   (Para evitar bucles de reinicio)"
echo "✓ Configuración udev completada"
echo ""

# Crear directorios necesarios
echo "6. Creando directorios del sistema..."
sudo mkdir -p /var/run/spacefn /var/log/spacefn
sudo chown brandontrigueros:brandontrigueros /var/log/spacefn
echo "✓ Directorios creados"
echo ""

# Verificar permisos
echo "7. Verificando permisos de usuario..."
if ! groups brandontrigueros | grep -q input; then
    echo "Agregando usuario al grupo 'input'..."
    sudo usermod -a -G input brandontrigueros
    echo "✓ Usuario agregado al grupo input (requiere logout/login para tomar efecto)"
else
    echo "✓ Usuario ya está en el grupo input"
fi
echo ""

# Iniciar el servicio
echo "8. Iniciando spacefn-auto..."
"$SPACEFN_DIR/spacefn-auto.sh" start
echo ""

# Mostrar estado
echo "9. Verificando estado final..."
"$SPACEFN_DIR/spacefn-auto.sh" status
echo ""

echo "=== Instalación Completada Exitosamente ==="
echo ""
echo "📋 Comandos disponibles:"
echo "  $SPACEFN_DIR/spacefn-auto.sh start    - Iniciar spacefn para todos los teclados"
echo "  $SPACEFN_DIR/spacefn-auto.sh stop     - Detener todos los procesos spacefn"
echo "  $SPACEFN_DIR/spacefn-auto.sh restart  - Reiniciar spacefn"
echo "  $SPACEFN_DIR/spacefn-auto.sh status   - Ver estado de los procesos"
echo ""
echo "🔧 Servicios systemd:"
echo "  sudo systemctl start spacefn-auto     - Iniciar servicio"
echo "  sudo systemctl stop spacefn-auto      - Detener servicio"
echo "  sudo systemctl status spacefn-auto    - Ver estado del servicio"
echo ""
echo "📝 Información importante:"
echo "  - El servicio se iniciará automáticamente al arrancar el sistema"
echo "  - Los logs están en: /var/log/spacefn/"
echo "  - Para conectar nuevos teclados: ./spacefn-auto.sh restart"
echo "  - Hot-plug automático está deshabilitado para evitar problemas"
