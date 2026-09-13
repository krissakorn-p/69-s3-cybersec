# โหลดคีย์-ค่าจาก .env ไปเป็น Windows User environment variables
# (REST Client อ่านค่าด้วย {{$processEnv VAR}} ต้องโหลดก่อนแล้ว restart VS Code)
$envFile = Join-Path $PSScriptRoot '.env'
if (-not (Test-Path -LiteralPath $envFile)) { Write-Error "ไม่พบไฟล์ $envFile"; exit 1 }

Get-Content -LiteralPath $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith('#')) {
        $idx = $line.IndexOf('=')
        if ($idx -gt 0) {
            $key = $line.Substring(0, $idx).Trim()
            $val = $line.Substring($idx + 1).Trim()
            if ($val.StartsWith('"') -and $val.EndsWith('"') -and $val.Length -ge 2) {
                $val = $val.Substring(1, $val.Length - 2)
            }
            [Environment]::SetEnvironmentVariable($key, $val, 'User')
        }
    }
}
Write-Host "Loading done. Restart VS Code to pick up new env vars."