$workFolder = 'C:\Users\Serge\Documents\Killme\longnames'
$saltLen = 4 # длина случайной вставки в имя файла
$tailLen = 4 # количество сохраняемых оригинальных символов в конце имени файла
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
        
        $nuName = "{0}\" -f $tmpfn.Directory
        $nuName +=  $tmpfn.Name.Substring(0, $fnLen - $saltLen-2 - $tailLen - $extLen)
        $nuName += "={0:x}=" -f $salt
        $nuName += $tmpfn.Name.Substring($fnLen - $tailLen - $extLen)

        Rename-Item  $tmpfn.FullName -NewName $nuName #-WhatIf
    }
}

