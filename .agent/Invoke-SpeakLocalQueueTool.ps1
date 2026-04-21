param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$QueueArgs
)

$toolPath = Join-Path $PSScriptRoot 'queue_tool.py'
$pythonCommand = Get-Command py -ErrorAction SilentlyContinue
$pythonArgs = @()

if ($pythonCommand) {
    $pythonExecutable = $pythonCommand.Source
    $pythonArgs = @('-3')
} else {
    $pythonCommand = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonCommand) {
        Write-Error 'Python launcher not found. Install `py` or `python` before invoking the queue tool wrapper.'
        exit 1
    }
    $pythonExecutable = $pythonCommand.Source
}

$launcher = @'
import importlib.util
import os
import pathlib
import sys

tool_path = pathlib.Path(os.environ["SPEAKLOCAL_QUEUE_TOOL_PATH"])
spec = importlib.util.spec_from_file_location("speaklocal_queue_tool", tool_path)
if spec is None or spec.loader is None:
    raise SystemExit("unable to load queue tool module")
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)
raise SystemExit(module.main(sys.argv[1:]))
'@

$env:SPEAKLOCAL_QUEUE_TOOL_PATH = $toolPath
try {
    $launcher | & $pythonExecutable @pythonArgs - @QueueArgs
    exit $LASTEXITCODE
}
finally {
    Remove-Item Env:SPEAKLOCAL_QUEUE_TOOL_PATH -ErrorAction SilentlyContinue
}
