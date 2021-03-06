VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "Dimension"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

'================================================================================
' Events
'================================================================================

'================================================================================
' Constants
'================================================================================

Private Const ModuleName                As String = "Dimension"

Private Const ConfigSettingScaleUnit    As String = "&ScaleUnit"
Private Const ConfigSettingLength       As String = "&Length"

'================================================================================
' Enums
'================================================================================

'================================================================================
' Types
'================================================================================

'================================================================================
' Member variables
'================================================================================

Private mLength As Double

Private mScaleUnit As ScaleUnits

Private mConfig As ConfigurationSection

'================================================================================
' Class Event Handlers
'================================================================================

'================================================================================
' xxxx Event Handlers
'================================================================================

'================================================================================
' Properties
'================================================================================

Public Property Let ConfigurationSection( _
                ByVal Value As ConfigurationSection)

Const ProcName As String = "ConfigurationSection"
Dim failpoint As String
On Error GoTo Err

If Value Is Nothing Then
    RemoveFromConfig
    Exit Property
End If

Set mConfig = Value


mConfig.SetSetting ConfigSettingLength, mLength
mConfig.SetSetting ConfigSettingScaleUnit, mScaleUnit

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName

End Property

Public Property Get Length() As Double
Length = mLength
End Property

'================================================================================
' Methods
'================================================================================

Public Function Equals(ByVal aDim As Dimension) As Boolean
Const ProcName As String = "Equals"
Dim failpoint As String
On Error GoTo Err

If aDim Is Nothing Then Exit Function
If aDim Is Me Then
    Equals = True
    Exit Function
End If
If aDim.Length <> mLength Then Exit Function
Equals = True

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Friend Sub Initialise( _
                ByVal pLength As Double, _
                ByVal pScaleUnit As ScaleUnits)
mLength = pLength
mScaleUnit = pScaleUnit
End Sub

Public Function LengthLogicalX( _
                ByVal pGraphics As Graphics) As Double
Const ProcName As String = "LengthLogicalX"
Dim failpoint As String
On Error GoTo Err

Select Case mScaleUnit
Case ScaleUnitLogical
    LengthLogicalX = mLength
Case ScaleUnitRelative
    LengthLogicalX = pGraphics.ConvertRelativeToLogicalX(mLength)
Case ScaleUnitCm
    LengthLogicalX = pGraphics.ConvertDistanceToLogicalX(mLength)
Case ScaleUnitPixels
    LengthLogicalX = pGraphics.ConvertPixelsToLogicalX(mLength)
End Select

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Public Function LengthLogicalY( _
                ByVal pGraphics As Graphics) As Double
Const ProcName As String = "LengthLogicalY"
Dim failpoint As String
On Error GoTo Err

Select Case mScaleUnit
Case ScaleUnitLogical
    LengthLogicalY = mLength
Case ScaleUnitRelative
    LengthLogicalY = pGraphics.ConvertRelativeToLogicalY(mLength)
Case ScaleUnitCm
    LengthLogicalY = pGraphics.ConvertDistanceToLogicalY(mLength)
Case ScaleUnitPixels
    LengthLogicalY = pGraphics.ConvertPixelsToLogicalY(mLength)
End Select

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Friend Sub LoadFromConfig( _
                ByVal pConfig As ConfigurationSection)

Const ProcName As String = "LoadFromConfig"
Dim failpoint As String
On Error GoTo Err

Set mConfig = pConfig
mLength = mConfig.GetSetting(ConfigSettingLength, "0")
mScaleUnit = mConfig.GetSetting(ConfigSettingScaleUnit, "0")

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub RemoveFromConfig()
Const ProcName As String = "RemoveFromConfig"
Dim failpoint As String
On Error GoTo Err

If Not mConfig Is Nothing Then mConfig.Remove
Set mConfig = Nothing

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

'================================================================================
' Helper Functions
'================================================================================







