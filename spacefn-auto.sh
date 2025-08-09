#!/bin/bash

# Script para iniciar spacefn automáticamente para todos los teclados conectados
# Se ejecuta como daemon en segundo plano y se puede usar al arranque del sistema

SPACEFN_DIR="/home/brandontrigueros/spacefn-evdev"
SPACEFN_BIN="$SPACEFN_DIR/spacefn"
PIDFILE_DIR="/var/run/spacefn"
LOG_DIR="/var/log/spacefn"

# Crear directorios si no existen
sudo mkdir -p "$PIDFILE_DIR" "$LOG_DIR"
sudo chown brandontrigueros:brandontrigueros "$LOG_DIR"

# Función para log
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | sudo tee -a "$LOG_DIR/spacefn.log"
}

# Función para detener todos los procesos spacefn
stop_all() {
    log "Deteniendo todos los procesos spacefn..."
    sudo pkill -f "spacefn /dev/input"
    sudo rm -f "$PIDFILE_DIR"/*.pid
    log "Todos los procesos spacefn detenidos"
}

# Función para iniciar spacefn para un dispositivo específico
start_spacefn_for_device() {
    local device="$1"
    local device_name="$2"
    local pidfile="$PIDFILE_DIR/spacefn-$(basename "$device").pid"
    local logfile="$LOG_DIR/spacefn-$(basename "$device").log"
    
    log "Iniciando spacefn para $device_name ($device)"
    
    # Verificar si ya está corriendo para este dispositivo
    if [[ -f "$pidfile" ]] && kill -0 "$(cat "$pidfile")" 2>/dev/null; then
        log "spacefn ya está corriendo para $device"
        return
    fi
    
    # Iniciar spacefn como daemon
    cd "$SPACEFN_DIR"
    nohup sudo "$SPACEFN_BIN" "$device" >> "$logfile" 2>&1 &
    local pid=$!
    
    # Guardar PID
    echo "$pid" | sudo tee "$pidfile" > /dev/null
    
    # Verificar que se inició correctamente
    sleep 1
    if kill -0 "$pid" 2>/dev/null; then
        log "spacefn iniciado exitosamente para $device_name (PID: $pid)"
    else
        log "ERROR: No se pudo iniciar spacefn para $device_name"
        sudo rm -f "$pidfile"
    fi
}

# Función para detectar y iniciar spacefn en todos los teclados
start_all() {
    log "Iniciando detección automática de teclados..."
    
    # Buscar todos los dispositivos de teclado
    local keyboards=()
    while IFS= read -r -d '' device; do
        keyboards+=("$device")
    done < <(find /dev/input/by-id/ -name "*kbd" -print0 2>/dev/null)
    
    if [[ ${#keyboards[@]} -eq 0 ]]; then
        log "No se encontraron teclados en /dev/input/by-id/"
        # Buscar en /dev/input/eventX como fallback
        log "Buscando teclados en /dev/input/event*..."
        for event_device in /dev/input/event*; do
            if [[ -c "$event_device" ]]; then
                # Verificar si es un teclado usando /proc/bus/input/devices
                local event_num=$(basename "$event_device" | sed 's/event//')
                if grep -A 10 "Handlers.*event$event_num" /proc/bus/input/devices | grep -q "kbd"; then
                    local device_name=$(grep -B 5 "Handlers.*event$event_num" /proc/bus/input/devices | grep "Name=" | cut -d'"' -f2)
                    keyboards+=("$event_device")
                    log "Encontrado teclado: $device_name ($event_device)"
                fi
            fi
        done
    fi
    
    if [[ ${#keyboards[@]} -eq 0 ]]; then
        log "ERROR: No se encontraron dispositivos de teclado"
        exit 1
    fi
    
    # Iniciar spacefn para cada teclado encontrado
    for device in "${keyboards[@]}"; do
        # Obtener nombre del dispositivo
        local device_name="Desconocido"
        if [[ "$device" == /dev/input/by-id/* ]]; then
            device_name=$(basename "$device" | sed 's/-event-kbd$//' | sed 's/usb-//' | sed 's/_/ /g')
        else
            # Para /dev/input/eventX, buscar el nombre en /proc/bus/input/devices
            local event_num=$(basename "$device" | sed 's/event//')
            device_name=$(grep -B 5 "Handlers.*event$event_num" /proc/bus/input/devices | grep "Name=" | cut -d'"' -f2 2>/dev/null || echo "Event $event_num")
        fi
        
        start_spacefn_for_device "$device" "$device_name"
    done
    
    log "Proceso de inicio completado"
}

# Función para mostrar estado
status() {
    echo "Estado de spacefn:"
    echo "=================="
    
    local running=0
    
    # Buscar procesos spacefn activos directamente
    local spacefn_processes=$(ps aux | grep -v grep | grep "$SPACEFN_BIN /dev/input")
    
    if [[ -n "$spacefn_processes" ]]; then
        while IFS= read -r line; do
            if [[ -n "$line" ]]; then
                local pid=$(echo "$line" | awk '{print $2}')
                local device=$(echo "$line" | grep -o '/dev/input/[^ ]*')
                local device_display=$(basename "$device")
                
                # Obtener nombre del dispositivo si es posible
                local device_name="$device_display"
                if [[ "$device" == *"by-id"* ]]; then
                    device_name=$(basename "$device" | sed 's/-event-kbd$//' | sed 's/usb-//' | sed 's/_/ /g')
                fi
                
                echo "✓ Corriendo: $device_display ($device_name) (PID: $pid)"
                running=$((running + 1))
            fi
        done <<< "$spacefn_processes"
    fi
    
    # También verificar archivos PID obsoletos y limpiarlos
    if [[ -d "$PIDFILE_DIR" ]]; then
        for pidfile in "$PIDFILE_DIR"/*.pid; do
            if [[ -f "$pidfile" ]]; then
                local pid=$(cat "$pidfile" 2>/dev/null)
                if [[ -n "$pid" ]] && ! kill -0 "$pid" 2>/dev/null; then
                    sudo rm -f "$pidfile"
                fi
            fi
        done
    fi
    
    if [[ $running -eq 0 ]]; then
        echo "No hay procesos spacefn corriendo"
    else
        echo "Total: $running procesos corriendo"
    fi
}

# Función para restart
restart() {
    log "Reiniciando spacefn..."
    stop_all
    sleep 2
    start_all
}

# Procesamiento de argumentos
case "${1:-start}" in
    start)
        start_all
        ;;
    stop)
        stop_all
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    *)
        echo "Uso: $0 {start|stop|restart|status}"
        echo ""
        echo "  start   - Iniciar spacefn para todos los teclados detectados"
        echo "  stop    - Detener todos los procesos spacefn"
        echo "  restart - Reiniciar spacefn"
        echo "  status  - Mostrar estado de los procesos spacefn"
        exit 1
        ;;
esac
