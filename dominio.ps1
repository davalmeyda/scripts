# Función para verificar si la versión de Windows es válida para unirse a un dominio
function VerificarVersionWindows {
    $edicion = (Get-WmiObject -Class Win32_OperatingSystem).Caption
    if ($edicion -match "Professional|Enterprise|Education") {
        Write-Host "La versión de Windows es válida para unirse a un dominio." -ForegroundColor Green
    } else {
        Write-Host "La versión de Windows no es válida para unirse a un dominio. Debe ser Professional, Enterprise o Education." -ForegroundColor Red
        exit
    }
}

# Verificar la versión de Windows
VerificarVersionWindows

# Función para solicitar y validar el nombre del equipo
function SolicitarNombreEquipo {
    do {
        $nombreEquipo = Read-Host -Prompt "Ingrese el nuevo nombre del equipo (máximo 15 caracteres)"
        if ($nombreEquipo.Length -le 15) {
            return $nombreEquipo
        } else {
            Write-Host "El nombre del equipo no puede tener más de 15 caracteres. Intente de nuevo." -ForegroundColor Red
        }
    } while ($true)
}

# Solicitar y validar el nombre del equipo
$nombreEquipo = SolicitarNombreEquipo()

# Cambiar el nombre del equipo
Rename-Computer -NewName $nombreEquipo -Force
Write-Host "El nombre del equipo ha sido cambiado a $nombreEquipo." -ForegroundColor Green

# Solicitar la unión al dominio
$dominio = "sistemas.private"

# Intentar unir el equipo al dominio
try {
    Add-Computer -DomainName $dominio -Credential (Get-Credential) -Force
    Write-Host "El equipo se ha unido al dominio $dominio con éxito." -ForegroundColor Green

    # Reiniciar el equipo solo si la unión al dominio fue exitosa
    Restart-Computer -Force
} catch {
    Write-Host "Error al intentar unir el equipo al dominio: $_" -ForegroundColor Red
    exit
}
