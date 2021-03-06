VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "TaskController"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit

''
' An instance of this class enables Progress and completion of a task to be
' notified to interested objects, and allows the task to be cancelled.
'
' Note that instances of this class cannot be created using the <code>New</code>
' operator. They are only obtained on return from a call to the global <code>StartTask</code>
' method.
'
'@/

'@================================================================================
' Interfaces
'@================================================================================


'@================================================================================
' Events
'@================================================================================

''
' Fired when processing of the task has completed.
'
' @param ev
'   A <code>TaskCompletionEventData</code> value containing details of how the task
'   completed.
'@/
Event Completed( _
                ev As TaskCompletionEventData)

''
' Fired when the task reports the occurrence of a significant event.
'
' @param ev
'   A <code>TaskNotificationEventData</code> value containing details of the event.
'@/
Event Notification( _
                ev As TaskNotificationEventData)

''
' Fired when the task reports Progress through the processing.
'
' @param ev
'   A <code>TaskProgressEventData</code> value containing details of Progress.
'@/
Event Progress( _
                ev As TaskProgressEventData)

''
' Fired when the task's State changes.
'
' @param ev
'   A <code>StateChangeEventData</code> value containing the new State.
'@/
Event StateChange( _
                ev As TaskStateChangeEventData)

'@================================================================================
' Constants
'@================================================================================


Private Const ModuleName                As String = "TaskController"

'@================================================================================
' Enums
'@================================================================================

'@================================================================================
' Types
'@================================================================================

'@================================================================================
' Member variables
'@================================================================================

Private mTaskCompletionListeners        As Listeners
Private mTaskProgressListeners          As Listeners
Private mTaskStateChangeListeners       As Listeners
Private mTaskNotificationListeners      As Listeners

Private mTarget                         As ITask
Private mCookie                         As Variant
Private mTaskName                       As String

Private mTaskContext                    As TaskContext

'@================================================================================
' Class Event Handlers
'@================================================================================

Private Sub Class_Initialize()
Set mTaskCompletionListeners = New Listeners
Set mTaskProgressListeners = New Listeners
Set mTaskStateChangeListeners = New Listeners
Set mTaskNotificationListeners = New Listeners
End Sub

Private Sub Class_Terminate()
Debug.Print "TaskController terminated"
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

''
' Returns the pCookie value passed to the <code>StartTask</code> method.
'
' @return
'   The pCookie value.
'@/
Public Property Get Cookie() As Variant
gSetVariant Cookie, mCookie
End Property

''
' Returns the task's name.
'
' @return
'   The name of the task.
'@/
Public Property Get TaskName() As String
TaskName = mTaskName
End Property

''
' Returns the task's current State.
'
' @return
'   The task's current State.
'@/
Public Property Get TaskState() As TaskStates
TaskState = mTaskContext.State
End Property

'@================================================================================
' Methods
'@================================================================================

''
' Registers an object to act as a listener for events occurring during execution
' of the task.
'
' @remarks
'   The listener object must implement the <code>ITaskNotificationListener</code>
'   interface.
' @param listener
'   The object which is to act as a listener.
'@/
Public Sub AddTaskNotificationListener(ByVal pListener As ITaskNotificationListener)
Const ProcName As String = "AddTaskNotificationListener"
On Error GoTo Err

mTaskNotificationListeners.Add pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Registers an object to act as a listener for changes in the task's State.
'
' @remarks
'   The listener object must implement the <code>ITaskStateChangeListener</code>
'   interface.
'
'   Note that State <code>TaskStateCompleted</code> is always notified to the listener
'   before the <code>Completed</code> event is fired.
' @param listener
'   The object which is to act as a listener.
'@/
Public Sub AddTaskStateChangeListener(ByVal pListener As ITaskStateChangeListener)
Const ProcName As String = "AddTaskStateChangeListener"
On Error GoTo Err

mTaskStateChangeListeners.Add pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Registers an object to act as a listener for completion of the task.
'
' @remarks
'   The listener object must implement the <code>ITaskCompletionListener</code>
'   interface.
' @param listener
'   The object which is to act as a listener.
'@/
Public Sub AddTaskCompletionListener(ByVal pListener As ITaskCompletionListener)
Const ProcName As String = "AddTaskCompletionListener"
On Error GoTo Err

mTaskCompletionListeners.Add pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Registers an object to act as a listener for Progress of the task.
'
' @remarks
'   The listener object must implement the <code>ITaskProgressListener</code>
'   interface.
' @param listener
'   The object which is to act as a listener.
'@/
Public Sub AddTaskProgressListener(ByVal pListener As ITaskProgressListener)
Const ProcName As String = "AddTaskProgressListener"
On Error GoTo Err

mTaskProgressListeners.Add pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Requests the task to cancel further processing.
'
' @remarks
'   Note that cancellation depends on the task periodically checking
'   whether cancellation has been requested.
'
'   If cancellation succeeds, then the <code>Cancelled</code> field in
'   the <code>TaskCompletionEventData</code> notified to listeners is
'   set to <code>True</code>.
'@/
Public Sub CancelTask()
Const ProcName As String = "CancelTask"
On Error GoTo Err

mTaskContext.Cancel

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Friend Sub FireCompletion( _
                ByVal pResult As Variant, _
                ByVal pCancelled As Boolean, _
                ByVal pErrorNumber As Long, _
                ByVal pErrorMessage As String, _
                ByVal pErrorSource As String)
Const ProcName As String = "FireCompletion"
On Error GoTo Err

Dim failPoint As String

Dim ev As TaskCompletionEventData
failPoint = "Setting result"
If IsError(pResult) Then
    gLogger.Log "Task " & mTaskName & " (" & TypeName(mTarget) & ") is setting an Error variant as its result", ProcName, ModuleName
Else
    gSetVariant ev.Result, pResult
End If
ev.Cancelled = pCancelled
ev.ErrorMessage = pErrorMessage
ev.ErrorNumber = pErrorNumber
ev.ErrorSource = pErrorSource
Set ev.Source = Me
ev.TaskName = mTaskName
failPoint = "Setting cookie: " & TypeName(mCookie)
If IsError(mCookie) Then
    gLogger.Log "Task " & mTaskName & " (" & TypeName(mTarget) & ") is using an Error variant for a cookie", ProcName, ModuleName
Else
    gSetVariant ev.Cookie, mCookie
End If

failPoint = "Notifying listeners"

Static sInit As Boolean
Static sCurrentListeners() As Object
Static sSomeListeners As Boolean

If Not sInit Or Not mTaskCompletionListeners.Valid Then
    sInit = True
    sSomeListeners = mTaskCompletionListeners.GetCurrentListeners(sCurrentListeners)
End If
If sSomeListeners Then
    Dim lListener As ITaskCompletionListener
    Dim i As Long
    For i = 0 To UBound(sCurrentListeners)
        Set lListener = sCurrentListeners(i)
        lListener.TaskCompleted ev
    Next
End If

failPoint = "Raising event"
RaiseEvent Completed(ev)
Set mTaskCompletionListeners = Nothing
Set mTaskProgressListeners = Nothing

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName, failPoint
End Sub

Friend Sub FireNotification( _
                ByVal EventCode As Long, _
                ByVal EventMessage As String)
Const ProcName As String = "FireNotification"
On Error GoTo Err

Dim ev As TaskNotificationEventData
ev.EventCode = EventCode
ev.EventMessage = EventMessage
Set ev.Source = Me

gSetVariant ev.Cookie, mCookie
    
Static sInit As Boolean
Static sCurrentListeners() As Object
Static sSomeListeners As Boolean

If Not sInit Or Not mTaskNotificationListeners.Valid Then
    sInit = True
    sSomeListeners = mTaskNotificationListeners.GetCurrentListeners(sCurrentListeners)
End If
If sSomeListeners Then
    Dim lListener As ITaskNotificationListener
    Dim i As Long
    For i = 0 To UBound(sCurrentListeners)
        Set lListener = sCurrentListeners(i)
        lListener.Notify ev
    Next
End If
RaiseEvent Notification(ev)

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Friend Sub FireProgress( _
                ByVal pProgressPercent As Single, _
                ByVal pInterimResult As Variant)
Const ProcName As String = "fireProgress"
On Error GoTo Err

' need the following otherwise an error occurs when a program is
' closed while it is still processing tasks
On Error Resume Next

Dim ev As TaskProgressEventData
ev.Progress = pProgressPercent
Set ev.Source = Me

gSetVariant ev.Cookie, mCookie
gSetVariant ev.InterimResult, pInterimResult
    
Static sInit As Boolean
Static sCurrentListeners() As Object
Static sSomeListeners As Boolean

If Not sInit Or Not mTaskProgressListeners.Valid Then
    sInit = True
    sSomeListeners = mTaskProgressListeners.GetCurrentListeners(sCurrentListeners)
End If
If sSomeListeners Then
    Dim lListener As ITaskProgressListener
    Dim i As Long
    For i = 0 To UBound(sCurrentListeners)
        Set lListener = sCurrentListeners(i)
        lListener.Progress ev
    Next
End If
RaiseEvent Progress(ev)

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Friend Sub fireStateChange( _
                ByVal State As TaskStates)
Const ProcName As String = "fireStateChange"
On Error GoTo Err

' need the following otherwise an error occurs when a program is
' closed while it is still processing tasks
On Error Resume Next

Dim ev As TaskStateChangeEventData
ev.State = State
Set ev.Source = Me

gSetVariant ev.Cookie, mCookie
    
Static sInit As Boolean
Static sCurrentListeners() As Object
Static sSomeListeners As Boolean

If Not sInit Or Not mTaskStateChangeListeners.Valid Then
    sInit = True
    sSomeListeners = mTaskStateChangeListeners.GetCurrentListeners(sCurrentListeners)
End If
If sSomeListeners Then
    Dim lListener As ITaskStateChangeListener
    Dim i As Long
    For i = 0 To UBound(sCurrentListeners)
        Set lListener = sCurrentListeners(i)
        lListener.Change ev
    Next
End If
RaiseEvent StateChange(ev)

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

Friend Sub Initialise( _
                ByVal pTarget As ITask, _
                ByVal pCookie As Variant, _
                ByVal pTaskName As String, _
                ByVal pTC As TaskContext)
Const ProcName As String = "Initialise"

On Error GoTo Err

Set mTarget = pTarget
gSetVariant mCookie, pCookie
mTaskName = pTaskName
Set mTaskContext = pTC

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Unregisters a <code>TaskStateChangeListener</code> object.
'
' @remarks
'   No error occurs if the object to be unregistered is not
'    actually registered.
' @param listener
'   The listener object to be unregistered.
' @see
'
'@/
Public Sub RemoveTaskStateChangeListener( _
                ByVal pListener As ITaskStateChangeListener)
Const ProcName As String = "RemoveTaskStateChangeListener"
On Error GoTo Err

mTaskStateChangeListeners.Remove pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Unregisters a <code>TaskCompletionListener</code> object.
'
' @remarks
'   No error occurs if the object to be unregistered is not
'    actually registered.
' @param listener
'   The listener object to be unregistered.
' @see
'
'@/
Public Sub RemoveTaskCompletionListener( _
                ByVal pListener As ITaskCompletionListener)
Const ProcName As String = "RemoveTaskCompletionListener"
On Error GoTo Err

mTaskCompletionListeners.Remove pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Unregisters a <code>TaskNotificationListener</code> object.
'
' @remarks
'   No error occurs if the object to be unregistered is not
'    actually registered.
' @param listener
'   The listener object to be unregistered.
' @see
'
'@/
Public Sub RemoveTaskNotificationListener( _
                ByVal pListener As ITaskNotificationListener)
Const ProcName As String = "RemoveTaskNotificationListener"
On Error GoTo Err

mTaskNotificationListeners.Remove pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

''
' Unregisters a <code>TaskProgressListener</code> object.
'
' @remarks
'   No error occurs if the object to be unregistered is not
'   actually registered.
' @param listener
'   The listener object to be unregistered.
' @see
'
'@/
Public Sub RemoveTaskProgressListener( _
                ByVal pListener As ITaskProgressListener)
Const ProcName As String = "RemoveTaskProgressListener"
On Error GoTo Err

mTaskProgressListeners.Remove pListener

Exit Sub

Err:
gHandleUnexpectedError ProcName, ModuleName
End Sub

'@================================================================================
' Helper Functions
'@================================================================================

