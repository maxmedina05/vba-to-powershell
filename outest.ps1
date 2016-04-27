# El Codigo Fuente es: intest.bas
function Clave( $nota ) { 
switch ($nota) { 
{ $_ -lt 60 } { $Clave = "F" }
{ $_ -In 60 ..69 } { $Clave = "D" }
{ $_ -In 70 ..79 } { $Clave = "C" }
{ $_ -In 80 ..89 } { $Clave = "B" }
{ $_ -ge 90 } { $Clave = "A" }
}
return $Clave
}
