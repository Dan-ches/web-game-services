Param(
  [Parameter(Mandatory=$true)][ValidateSet('sdk','port','perf')] [string]$type,
  [Parameter(Mandatory=$true)] [string]$client,
  [Parameter(Mandatory=$true)] [string]$project,
  [Parameter(Mandatory=$false)] [string]$engine = 'Unity WebGL'
)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$tplMap = @{ sdk = 'sdk_integration_proposal.md'; port = 'webgl_port_proposal.md'; perf = 'performance_optimization_proposal.md' }
$tpl = Join-Path (Join-Path $root '..\proposals') $tplMap[$type]
if (!(Test-Path $tpl)) { Write-Error "Template not found: $tpl"; exit 1 }

$outDir = Join-Path $root '..\proposals\generated'
if (!(Test-Path $outDir)) { New-Item -ItemType Directory -Force -Path $outDir | Out-Null }

$content = Get-Content $tpl -Raw
$content = $content -replace '<ИМЯ/СТУДИЯ>',$client -replace '<НАЗВАНИЕ ИГРЫ>',$project -replace '<Unity WebGL / Godot HTML5 / JS-Phaser / Другое>',$engine -replace '<Unity / Godot / Другое>',$engine

$ts = Get-Date -Format 'yyyyMMdd_HHmm'
$outFile = Join-Path $outDir ("${type}_$($project)_$ts.md")
Set-Content -Path $outFile -Value $content -Encoding UTF8
Write-Output "Generated: $outFile"
