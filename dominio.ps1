# Función para verificar si la versión de Windows es válida para unirse a un dominio
function VerificarVersionWindows {
    $edicion = (Get-CimInstance -ClassName Win32_OperatingSystem).Caption
    if ($edicion -match "Professional|Enterprise|Education|Pro") {
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
    $caracteresInvalidos = '[\\/:*?"<>|]'
    do {
        $nombreEquipoInput = Read-Host -Prompt "Ingrese el nuevo nombre del equipo (máximo 15 caracteres)"
        if ($nombreEquipoInput.Length -le 15 -and -not ($nombreEquipoInput -match $caracteresInvalidos)) {
            # Convertir el nombre del equipo a mayúsculas
            $nombreEquipo = $nombreEquipoInput.ToUpper()
            return $nombreEquipo
        } else {
            Write-Host "El nombre del equipo debe tener como máximo 15 caracteres y no contener los siguientes caracteres: \ / : * ? "" < > |. Intente de nuevo." -ForegroundColor Red
        }
    } while ($true)
}

# Solicitar y validar el nombre del equipo
$nombreEquipo = SolicitarNombreEquipo

# Cambiar el nombre del equipo
try {
    Rename-Computer -NewName $nombreEquipo -Force -ErrorAction Stop
    Write-Host "El nombre del equipo ha sido cambiado a $nombreEquipo." -ForegroundColor Green
} catch {
    Write-Host "Error al cambiar el nombre del equipo: $_" -ForegroundColor Red
    exit
}

# Solicitar la unión al dominio
$dominio = "sistemas.private"

# Intentar unir el equipo al dominio
try {
    $credenciales = Get-Credential -Message "Ingrese las credenciales para unir al dominio $dominio"
    Add-Computer -DomainName $dominio -Credential $credenciales -Force -ErrorAction Stop
    Write-Host "El equipo se ha unido al dominio $dominio con éxito." -ForegroundColor Green

    # Reiniciar el equipo solo si la unión al dominio fue exitosa
    Restart-Computer -Force
} catch {
    Write-Host "Error al intentar unir el equipo al dominio: $_" -ForegroundColor Red
    exit
}
