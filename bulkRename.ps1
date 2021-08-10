$workFolder = 'C:\Users\Serge\Documents\Killme\longnames'
$saltLen = 4
$mxLen = 58
<#
for ($i = 0; $i -lt 20; $i++) {
    $fnm = "{0:x}" -f (Get-Random -Minimum 0x1000000000000 -Maximum 0xfffffffffffff)
    $xtn = ("{0:x}" -f (Get-Random -Minimum 0x10 -Maximum 0xffffff)).SubString((Get-Random -Minimum 1 -Maximum 6))
    $tmpname = "{0}.{1}" -f $fnm, $xtn
    New-Item -Path $workFolder -Name $tmpname
}
#>

Get-ChildItem $workFolder -Recurse | Where-Object {
    if ((($tmpfn = $_).FullName).Length -gt $mxLen) {
        $salt =Get-Random -Minimum ((1 -shl ($saltLen - 1) * 4) + 1) -Maximum (1 -shl ($saltLen * 4) - 1)
        $extLen = $tmpfn.Extension.Length
        $fnLen = $tmpfn.Name.Length
        #$nuName = $tmpfn.Name.Substring(

        $nuName =  "{0}\{1}[{2:X}]{3}" -f $_.DirectoryName, ($_.Name).Substring(0, 7), $salt, ($_.Name).Substring($_.Name.Length-9, 9), $_.Extension 
        Rename-Item $_.FullName -NewName $nuName -WhatIf
    }
}

