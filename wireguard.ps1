# Ruta al ejecutable de WireGuard CLI
$wireguardCli = "C:\Program Files\WireGuard\wg.exe"

# Nombre de la conexión de WireGuard
$vpnName = "server"

# Verificar el estado de la conexión
$status = & $wireguardCli show $vpnName | Select-String "interface: $vpnName"

if (-not $status) {
    # Si el estado indica que no está conectado, intenta reconectarlo
    & $wireguardCli up $vpnName
}
