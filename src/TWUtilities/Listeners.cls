VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Listeners"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

''
' Description here
'
'@/

'@================================================================================
' Interfaces
'@================================================================================

'@================================================================================
' Events
'@================================================================================

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ModuleName                            As String = "Listeners"

'@================================================================================
' Member variables
'@================================================================================

Private mListeners                                  As Collection

Private mCurrentListeners()                         As Object
Private mCurrentListenersValid                      As Boolean

Private mCount                                      As Long

'@================================================================================
' Class Event Handlers
'@================================================================================

Private Sub Class_Initialize()
Initialise
End Sub

'@================================================================================
' XXXX Interface Members
'@================================================================================

'@================================================================================
' XXXX Event Handlers
'@================================================================================

'@================================================================================
' Properties
'@================================================================================

Public Function GetCurrentListeners(ByRef pListeners() As Object) As Boolean
If Not mCurrentListenersValid Then SetCurrentListeners

If mCount = 0 Then
    GetCurrentListeners = False
Else
    pListeners = mCurrentListeners
    GetCurrentListeners = True
End If
End Function

Public Property Get Valid() As Boolean
Valid = mCurrentListenersValid
End Property

'@================================================================================
' Methods
'@================================================================================

Public Sub Add(ByVal pListener As Object)
Const ProcName As String = "Add"
On Error GoTo Err

gAssertArgument Not pListener Is Nothing, "pListener is Nothing"

mListeners.Add pListener, gGetObjectKey(pListener)
mCount = mCount + 1
mCurrentListenersValid = False

Exit Sub

Err:
If Err.number = VBErrorCodes.VbErrElementAlreadyExists Then Exit Sub
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub Clear()
Initialise
End Sub

Public Function Count() As Long
Count = mCount
End Function

Public Sub Remove(ByVal pListener As Object)
Const ProcName As String = "Remove"
On Error GoTo Err

gAssertArgument Not pListener Is Nothing, "pListener is Nothing"

mListeners.Remove gGetObjectKey(pListener)
mCount = mCount - 1
mCurrentListenersValid = False

Exit Sub

Err:
If Err.number = VBErrorCodes.VbErrInvalidProcedureCall Then Exit Sub
gHandleUnexpectedError ProcName, ModuleName
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

Private Sub Initialise()
Set mListeners = New Collection
mCurrentListenersValid = False
mCount = 0
End Sub

Private Sub SetCurrentListeners()
If mCurrentListenersValid Then Exit Sub

If mCount = 0 Then
    mCurrentListenersValid = True
    Exit Sub
End If

ReDim mCurrentListeners(mCount - 1) As Object

Dim lListener As Object
Dim i As Long
For Each lListener In mListeners
    Set mCurrentListeners(i) = lListener
    i = i + 1
Next
mCurrentListenersValid = True
End Sub



