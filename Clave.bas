Attribute VB_Name = "Clave"

Public Function Clave(nota As Double) As String
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
    Case Else
        Clave = "?"
End Select
End Function
