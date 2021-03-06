VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "RectangleSeries"
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

Implements IExtendedEventsSource
Implements IGraphicObjectSeries

'@================================================================================
' Events
'@================================================================================

Event Click()

Event DblCLick()

Event SelectionStateChanged()

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Constants
'@================================================================================

Private Const ModuleName                            As String = "RectangleSeries"

'@================================================================================
' Member variables
'@================================================================================

Private mController                                 As Controller
Private mModel                                      As LayeredGraphicsModel

Private WithEvents mGraphics                        As Graphics
Attribute mGraphics.VB_VarHelpID = -1
Private mGraphicsUpdateNumber                       As Long
Private mLastGraphicsChange                         As GraphicsChangeTypes

Private WithEvents mBase                            As GraphicObjectSeriesBase
Attribute mBase.VB_VarHelpID = -1

Private mName                                       As String
Private mSeriesID                                   As Long
Private mSeriesUpdateNumber                         As Long

Private mFinished                                   As Boolean

Private mRenderer                                   As IRenderer

Private mGraphicObjects                             As Collection

Private mStyle                                      As RectangleStyle

'@================================================================================
' Class Event Handlers
'@================================================================================

Private Sub Class_Initialize()
Const ProcName As String = "Class_Initialize"
On Error GoTo Err

Set mBase = New GraphicObjectSeriesBase

GRectangle.gRegisterProperties
GRectangle.gRegisterExtendedEvents

Set mGraphicObjects = New Collection

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Private Sub Class_Terminate()
Debug.Print "RectangleSeries terminated"
End Sub

'@================================================================================
' IExtendedEventsSource Interface Members
'@================================================================================

Private Property Get IExtendedEventsSource_Parent() As Object
Set IExtendedEventsSource_Parent = Nothing
End Property

'@================================================================================
' IGraphicObjectSeries Interface Members
'@================================================================================

Private Sub IGraphicObjectSeries_Click()
RaiseEvent Click
End Sub

Private Property Get IGraphicObjectSeries_Controller() As Controller
Set IGraphicObjectSeries_Controller = mController
End Property

Private Property Get IGraphicObjectSeries_Count() As Long
IGraphicObjectSeries_Count = mGraphicObjects.Count
End Property

Private Sub IGraphicObjectSeries_DblCLick()
RaiseEvent DblCLick
End Sub

Private Property Get IGraphicObjectSeries_ExtendedPropertyHost() As ExtendedPropertyHost
Set IGraphicObjectSeries_ExtendedPropertyHost = mBase.ExtendedPropertyHost
End Property

Private Sub IGraphicObjectSeries_Finish()
mFinished = True
End Sub

Private Property Get IGraphicObjectSeries_GraphicsUpdateNumber() As Long
IGraphicObjectSeries_GraphicsUpdateNumber = mGraphicsUpdateNumber
End Property

Private Property Get IGraphicObjectSeries_Id() As Long
IGraphicObjectSeries_Id = Id
End Property

Private Sub IGraphicObjectSeries_Initialise( _
                ByVal pName As String, _
                ByVal pLayer As LayerNumbers, _
                ByVal pSeriesID As Long, _
                ByVal pController As Controller)
mName = pName
Layer = pLayer
mSeriesID = pSeriesID
Set mController = pController
Set mModel = mController.Model
Set mGraphics = mController.Graphics
End Sub

Private Property Get IGraphicObjectSeries_IsSelectable() As Boolean
IGraphicObjectSeries_IsSelectable = IsSelectable
End Property

Private Property Let IGraphicObjectSeries_IsSelected(ByVal Value As Boolean)
If Value = mBase.ExtendedPropertyHost.GetLocalValue(GRectangle.gIsSelectedProperty) Then
Else
    mBase.ExtendedPropertyHost.SetValue GRectangle.gIsSelectedProperty, Value
    RaiseEvent SelectionStateChanged
End If
End Property

Private Property Get IGraphicObjectSeries_IsSelected() As Boolean
IGraphicObjectSeries_IsSelected = IsSelected
End Property

Private Function IGraphicObjectSeries_Item(ByVal pIndex As Long) As IGraphicObject
Const ProcName As String = "IGraphicObjectSeries_item"
Dim failpoint As String
On Error GoTo Err

Set IGraphicObjectSeries_Item = mGraphicObjects.Item(pIndex)

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

Private Property Get IGraphicObjectSeries_LastGraphicsChange() As GraphicsChangeTypes
IGraphicObjectSeries_LastGraphicsChange = mLastGraphicsChange
End Property

Private Property Get IGraphicObjectSeries_LayeredGraphicsModel() As LayeredGraphicsModel
Set IGraphicObjectSeries_LayeredGraphicsModel = mModel
End Property

Private Property Get IGraphicObjectSeries_Name() As String
IGraphicObjectSeries_Name = mName
End Property

Private Sub IGraphicObjectSeries_Remove(ByVal pIndex As Long)
mGraphicObjects.Remove pIndex
End Sub

Private Sub IGraphicObjectSeries_RemoveObject(ByVal Value As IGraphicObject)
mGraphicObjects.Remove Hex$(ObjPtr(Value))
End Sub

Private Property Let IGraphicObjectSeries_Renderer(ByVal Value As IRenderer)
Renderer = Value
End Property

Private Property Get IGraphicObjectSeries_Renderer() As IRenderer
Set IGraphicObjectSeries_Renderer = Renderer
End Property

Private Property Get IGraphicObjectSeries_SeriesID() As Long
IGraphicObjectSeries_SeriesID = mSeriesID
End Property

Private Property Get IGraphicObjectSeries_SeriesUpdateNumber() As Long
IGraphicObjectSeries_SeriesUpdateNumber = mSeriesUpdateNumber
End Property

'@================================================================================
' mBase Event Handlers
'@================================================================================

Private Sub mBase_RepaintRegion(ByVal pRecalcBoundaries As Boolean)
Const ProcName As String = "mBase_RepaintRegion"
On Error GoTo Err

RepaintRegion pRecalcBoundaries

Exit Sub

Err:
gNotifyUnhandledError ProcName, ModuleName
End Sub

'@================================================================================
' mGraphics Event Handlers
'@================================================================================

Private Sub mGraphics_Change(ev As ChangeEventData)
mGraphicsUpdateNumber = mGraphicsUpdateNumber + 1
mLastGraphicsChange = ev.ChangeType
End Sub

'@================================================================================
' Properties
'@================================================================================

Public Property Let Brush(ByVal Value As IBrush)
Const ProcName As String = "Brush"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gBrushProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Brush() As IBrush
Const ProcName As String = "Brush"
On Error GoTo Err

Set Brush = mBase.ExtendedPropertyHost.GetValue(GRectangle.gBrushProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Count() As Long
Const ProcName As String = "Count"
Dim failpoint As String
On Error GoTo Err

Count = mGraphicObjects.Count

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Friend Property Get Id() As Long
Id = mSeriesID
End Property

Public Property Let IncludeInAutoscale(ByVal Value As Boolean)
Const ProcName As String = "IncludeInAutoscale"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gIncludeInAutoscaleProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get IncludeInAutoscale() As Boolean
Const ProcName As String = "IncludeInAutoscale"
On Error GoTo Err

IncludeInAutoscale = mBase.ExtendedPropertyHost.GetValue(GRectangle.gIncludeInAutoscaleProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Let IsSelectable(ByVal Value As Boolean)
Const ProcName As String = "IsSelectable"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gIsSelectableProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get IsSelectable() As Boolean
Const ProcName As String = "IsSelectable"
On Error GoTo Err

IsSelectable = mBase.ExtendedPropertyHost.GetValue(GRectangle.gIsSelectableProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get IsSelected() As Boolean
Const ProcName As String = "IsSelected"
On Error GoTo Err

IsSelected = mBase.ExtendedPropertyHost.GetValue(GRectangle.gIsSelectedProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Let Layer(ByVal Value As LayerNumbers)
Const ProcName As String = "Layer"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gLayerProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Layer() As LayerNumbers
Const ProcName As String = "Layer"
On Error GoTo Err

Layer = mBase.ExtendedPropertyHost.GetValue(GRectangle.gLayerProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get MouseEnterEvent() As ExtendedEvent
Set MouseEnterEvent = GRectangle.gMouseEnterEvent
End Property

Public Property Get MouseLeaveEvent() As ExtendedEvent
Set MouseLeaveEvent = GRectangle.gMouseLeaveEvent
End Property

Public Property Let Orientation(ByVal Value As Double)
Const ProcName As String = "Orientation"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gOrientationProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Orientation() As Double
Const ProcName As String = "Layer"
On Error GoTo Err

Orientation = mBase.ExtendedPropertyHost.GetValue(GRectangle.gOrientationProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Let Pen(ByVal Value As Pen)
Const ProcName As String = "Pen"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gPenProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Pen() As Pen
Const ProcName As String = "Pen"
On Error GoTo Err

Set Pen = mBase.ExtendedPropertyHost.GetValue(GRectangle.gPenProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Let Position(ByVal Value As Point)
Const ProcName As String = "Position"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gPositionProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Position() As Point
Const ProcName As String = "Position"
On Error GoTo Err

Set Position = mBase.ExtendedPropertyHost.GetValue(GRectangle.gPositionProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Renderer() As IRenderer
If mRenderer Is Nothing Then
    Dim lRenderer  As RectangleDefaultRenderer
    Set lRenderer = New RectangleDefaultRenderer
    lRenderer.Graphics = mController.Graphics
    Set mRenderer = lRenderer
End If
Set Renderer = mRenderer
End Property

Public Property Let Renderer(ByVal Value As IRenderer)
Set mRenderer = Value
End Property

Public Property Let Size(ByVal Value As Size)
Const ProcName As String = "Size"
On Error GoTo Err

mBase.ExtendedPropertyHost.SetValue GRectangle.gSizeProperty, Value

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Size() As Size
Const ProcName As String = "Size"
On Error GoTo Err

Set Size = mBase.ExtendedPropertyHost.GetValue(GRectangle.gSizeProperty)

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Let Style(ByVal Value As RectangleStyle)
Const ProcName As String = "Style"
On Error GoTo Err

Set mStyle = Value
mBase.ExtendedPropertyHost.Style = mStyle.ExtendedPropertyHost

Exit Property

Err:
gHandleUnexpectedError ProcName, ModuleName
End Property

Public Property Get Style() As RectangleStyle
Set Style = mStyle
End Property

'@================================================================================
' Methods
'@================================================================================

Public Function Add(Optional ByVal pModel As IRectangleModel) As Rectangle
Const ProcName As String = "Add"
On Error GoTo Err

If mFinished Then Err.Raise ErrorCodes.ErrIllegalStateException, , "RectangleSeries is finished"

Set Add = New Rectangle
If pModel Is Nothing Then Set pModel = New RectangleDefaultModel
Add.Initialise Me, pModel
mGraphicObjects.Add Add, Hex$(ObjPtr(Add))

mModel.AddGraphicObject Add

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName

End Function

Public Sub ApplyChanges()
mBase.ApplyChanges
End Sub

Public Function Clear() As TaskController
Const ProcName As String = "Clear"
On Error GoTo Err

Set Clear = mModel.ClearGraphicObjectSeries(Me)

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName

End Function

Public Sub ClearBrush()
Const ProcName As String = "ClearBrush"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gBrushProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearIncludeInAutoscale()
Const ProcName As String = "ClearIncludeInAutoscale"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gIncludeInAutoscaleProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearIsSelectable()
Const ProcName As String = "ClearIsSelectable"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gIsSelectableProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearLayer()
Const ProcName As String = "ClearLayer"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gLayerProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearOrientation()
Const ProcName As String = "ClearOrientation"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gOrientationProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearPen()
Const ProcName As String = "ClearPen"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gPenProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearPosition()
Const ProcName As String = "ClearPosition"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gPositionProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub ClearSize()
Const ProcName As String = "ClearSize"
On Error GoTo Err

mBase.ExtendedPropertyHost.ClearValue GRectangle.gSizeProperty

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Public Sub Edit()
mBase.Edit
End Sub

Public Function NewEnum() As IUnknown
Attribute NewEnum.VB_UserMemId = -4
Attribute NewEnum.VB_MemberFlags = "40"
Const ProcName As String = "NewEnum"
Dim failpoint As String
On Error GoTo Err

Set NewEnum = mGraphicObjects.[_NewEnum]

Exit Function

Err:
gHandleUnexpectedError ProcName, ModuleName
End Function

'@================================================================================
' Helper Functions
'@================================================================================

Private Sub RepaintRegion( _
                ByVal pRecalcBoundaries As Boolean)
Const ProcName As String = "RepaintRegion"
Dim failpoint As String
On Error GoTo Err

If mGraphicObjects.Count <> 0 Then
    If pRecalcBoundaries Then
        mSeriesUpdateNumber = mSeriesUpdateNumber + 1
        mModel.RecalcBoundaryForObjectsInSeries mSeriesID
        mController.paint True
    Else
        mController.paint False
    End If
End If

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub






