Copy-Item -Path ImGui.Net/src/ImGui.NET/* -Destination ../Runtime/ImGui.NET/ -PassThru –Recurse -Force
Remove-Item -Path ../Runtime/ImGui.NET/build -Force -Recurse
Remove-Item -Path ../Runtime/ImGui.NET/ImGui.NET.csproj

$files = Get-ChildItem ../Runtime/ImGui.NET/*.cs -Recurse

foreach ($file in $files)
{
    ((Get-Content -Path $file -Raw) -replace 'using System.Numerics','using UnityEngine') | Set-Content -Path $file
}