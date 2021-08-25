$workFolder = 'C:\Users\Serge\Documents\Killme\longnames'
$saltLen = 4 # длина случайной вставки ("соли") в имя файла
$tailLen = 4 # количество сохраняемых оригинальных символов в конце имени файла
$maxPathLen = 50

<#
for ($i = 0; $i -lt 20; $i++) {
    # $lslsls = "{0:x}" -f (Get-Random -Minimum 0x1000000000000 -Maximum 0xfffffffffffff)
    $fnm = ("{0:x}" -f (Get-Random -Minimum 0x1000000000000 -Maximum 0xfffffffffffff)).SubString(0, (Get-Random -Minimum 9 -Maximum 13))
    $xtn = ("{0:x}" -f (Get-Random -Minimum 0x100000 -Maximum 0xffffff)).SubString(0, (Get-Random -Minimum 1 -Maximum 6))
    $tmpname = "{0}.{1}" -f $fnm, $xtn
    New-Item -Path $workFolder -Name $tmpname
}
#>

Get-ChildItem $workFolder -Recurse | Where-Object {
    $curFile = $_
    $extLen = $curFile.Extension.Length
    $dirLen = $curFile.DirectoryName.Length

    if ($maxPathLen - $dirLen - $extLen -lt $saltLen + 2) {  
        # если длина пути (которую не трогаем) плюс расширение (которое не трогаем) меньше длины "соли" плюс скобочки
        # значит, для имени файла места уже не остаётся -- пропускаем его.
        # TODO: пишем в лог
        "Not processed {0} -- directory name too long" -f $curFile.FullName
    }
    elseif ($curFile.FullName.Length -gt $maxPathLen) {
        # генерируем "соль" от 0x1000  до 0xFFFF
        $salt =Get-Random -Minimum ((1 -shl ($saltLen - 1) * 4) + 1) -Maximum (1 -shl ($saltLen * 4) - 1)
        
        $fnLen = $curFile.Name.Length
        
        $nuName = "{0}\" -f $curFile.Directory
        $nuName +=  $curFile.Name.Substring(0, $fnLen - $saltLen-2 - $tailLen - $extLen)
        $nuName += "={0:x}=" -f $salt
        $nuName += $curFile.Name.Substring($fnLen - $tailLen - $extLen)

        Rename-Item  $curFile.FullName -NewName $nuName #-WhatIf
    }
}

