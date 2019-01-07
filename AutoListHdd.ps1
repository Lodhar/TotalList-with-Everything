$drives = gwmi win32_volume | Select-Object label,driveletter,serialnumber | Where-Object label -like 'HDD-*'

$drives | ForEach-Object -process {
  $_.label -match "(?'name'\w{3}-\d{2})\s.{1,}"
  $args = " -p "+$_.driveletter+"\ -s -size -efu -export-efu "+$matches.name+".efu"    
  
  #Write-Host $args
  $Command = 'C:\Program Files (x86)\Everything\es.exe'
     
  Start-Process -FilePath $Command -WorkingDirectory "D:\_Lodhar\Desktop\Listes" -ArgumentList $args -WindowStyle Hidden
  Wait-Process (get-process es).Id
  
}