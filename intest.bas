Public Function Clave(nota)
Select Case nota
    Case Is < 60
        Clave = "F"
    Case 60 To 69.99
        Clave = "D"
    Case 70 To 79.99
        Clave = "C"
    Case 80 To 89.99
        Clave = "B"
    Case Is >= 90
        Clave = "A"
End Select
End Function

Public Function Suma(x, y)
Suma= x + y
End Function
