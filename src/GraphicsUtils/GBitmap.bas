Attribute VB_Name = "GBitmap"
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

Private Const ModuleName                            As String = "GBitmap"

'@================================================================================
' Member variables
'@================================================================================

'@================================================================================
' Class Event Handlers
'@================================================================================

'@================================================================================
' XXXX Interface Members
'@================================================================================

'@================================================================================
' XXXX Event Handlers
'@================================================================================

'@================================================================================
' Properties
'@================================================================================

'@================================================================================
' Methods
'@================================================================================

Public Function gLoadBitmap(ByVal pFilename As String) As Bitmap
Const ProcName As String = "gLoadBitmap"
On Error GoTo Err

Set gLoadBitmap = New Bitmap
gLoadBitmap.Initialise pFilename

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Public Function gLoadBitmapFromResource(ByVal pResource As StdPicture) As Bitmap
Const ProcName As String = "gLoadBitmapFromResource"
On Error GoTo Err

Set gLoadBitmapFromResource = New Bitmap
gLoadBitmapFromResource.InitialiseFromResource pResource

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Public Function gLoadBitmapFromConfig(ByVal pConfig As ConfigurationSection) As Bitmap
Const ProcName As String = "gLoadBitmapFromConfig"
On Error GoTo Err

Set gLoadBitmapFromConfig = New Bitmap
gLoadBitmapFromConfig.LoadFromConfig pConfig

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

'@================================================================================
' Helper Functions
'@================================================================================




