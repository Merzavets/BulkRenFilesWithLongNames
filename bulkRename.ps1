Get-ChildItem '..\..\..\' -Recurse | Where-Object {
    if (($_.Name).Length -gt 20) {
        $salt =Get-Random -Minimum 0x10001 -Maximum 0xfffff 
        $nuName =  "{0}\{1}[{2:X}]{3}" -f $_.DirectoryName, ($_.Name).Substring(0, 7), $salt, ($_.Name).Substring($_.Name.Length-9, 9), $_.Extension 
        Rename-Item $_.FullName -NewName $nuName -WhatIf
    }
}