Option Explicit

Const ERR_INVALID_FILENAME = vbObjectError + 1000
Const ERR_INVALID_TARGET = vbObjectError + 1001
Const ERR_FILE_EXISTS = vbObjectError + 1002
Const ERR_UPLOAD_CALLED = vbObjectError + 1003
Const VB_ERR_PATH_NOT_FOUND = 76

Private m_objContext As ObjectContext
Private m_objRequest As ASPTypeLibrary.Request

Private m_strTarget As String
Private m_strFileName As String
Private m_blnOverWrite As Boolean
Private m_blnUploaded As Boolean
Private m_lngTotalBytes As Long

'All other form elements go here.
Private m_formCol As Scripting.Dictionary

Implements ObjectControl

Private Function ObjectControl_CanBePooled() As Boolean
  ObjectControl_CanBePooled = False
End Function

Private Sub ObjectControl_Activate()
  Set m_objContext = GetObjectContext()
  Set m_objRequest = m_objContext("Request")
  Set m_formCol = New Scripting.Dictionary
End Sub

Private Sub ObjectControl_Deactivate()
  Set m_objContext = Nothing
  Set m_objRequest = Nothing
  Set m_formCol = Nothing
End Sub

Public Sub Upload()
  
  Const DEFAULT_CHUNK_SIZE = 262144 '256kb
  
  Dim bytBeginOfChunk() As Byte
  Dim bytEndOfChunk() As Byte
  Dim bytBeginOfName() As Byte
  Dim bytEndOfName() As Byte
  Dim bytBeginOfFile() As Byte
  Dim bytEndOfFile() As Byte
  Dim bytBeginOfValue() As Byte
  Dim bytEndOfValue() As Byte
  Dim bytName() As Byte
  Dim bytValue() As Byte
  Dim bytThisChunk() As Byte
  Dim bytFileName() As Byte
  Dim lngBeginOfChunk As Long
  Dim lngEndOfChunk As Long
  
  Dim lngBeginOfAttribute As Long
  Dim lngEndOfAttribute As Long
  Dim lngBeginOfValue As Long
  Dim lngEndOfValue As Long
  Dim blnEndOfData As Boolean
  Dim lngChunkSize As Long
  Dim lngBytesLeft As Long
  Dim lngFileNum As Long
  Dim strFileName As String
  
  On Error GoTo UploadErr
  
  If Uploaded Then
    Err.Raise ERR_UPLOAD_CALLED, App.Title, "The Upload method has already been called."
  End If
     
  bytBeginOfChunk = StrConv("-----------------------------", vbFromUnicode)
  bytEndOfChunk = StrConv("-----------------------------", vbFromUnicode)
  
  bytBeginOfName = StrConv("name=", vbFromUnicode) & ChrB(34)
  bytEndOfName = ChrB(34)
  
  bytBeginOfFile = StrConv("filename=", vbFromUnicode) & ChrB(34)
  bytEndOfFile = ChrB(34)
  
  bytBeginOfValue = ChrB(13) & ChrB(10) & ChrB(13) & ChrB(10)
  bytEndOfValue = ChrB(13) & ChrB(10) & StrConv("-----------------------------", vbFromUnicode)
     
  'Initialize the chunk size.
  If m_objRequest.TotalBytes <= DEFAULT_CHUNK_SIZE Then
    lngChunkSize = m_objRequest.TotalBytes
  Else
    lngChunkSize = DEFAULT_CHUNK_SIZE
  End If
    
  'Get the chunk from the request object.
  bytThisChunk = m_objRequest.BinaryRead(CVar(lngChunkSize))

  'Initialize the value.
  lngBeginOfChunk = 1
  
  'Repeat until the end of the data.
  Do While Not blnEndOfData
    'Begin the chunk.
    lngBeginOfChunk = InStrB(lngBeginOfChunk, bytThisChunk, bytBeginOfChunk) + UBound(bytBeginOfChunk)
    
    'Get name of the item.
    lngBeginOfAttribute = InStrB(lngBeginOfChunk, bytThisChunk, bytBeginOfName) + UBound(bytBeginOfName) + 1
    lngEndOfAttribute = InStrB(lngBeginOfAttribute, bytThisChunk, bytEndOfName)
    bytName = MidB(bytThisChunk, lngBeginOfAttribute, lngEndOfAttribute - lngBeginOfAttribute)
    
    'Get the value of the item.
    lngBeginOfValue = InStrB(lngEndOfAttribute, bytThisChunk, bytBeginOfValue, vbBinaryCompare) + UBound(bytBeginOfValue) + 1
    lngEndOfValue = InStrB(lngBeginOfValue, bytThisChunk, bytEndOfValue, vbBinaryCompare)
    
    If lngEndOfValue = 0 Then
      'The item extends the past current chunk.
      bytValue = MidB(bytThisChunk, lngBeginOfValue, lngChunkSize)
    Else
      'The item value exists in the current chunk.
      bytValue = MidB(bytThisChunk, lngBeginOfValue, lngEndOfValue - lngBeginOfValue)
    End If
    
    If UCase(StrConv(bytName, vbUnicode)) = "FILE" Then
      lngBeginOfAttribute = InStrB(lngBeginOfChunk, bytThisChunk, bytBeginOfFile, vbBinaryCompare) + UBound(bytBeginOfFile) + 1
      lngEndOfAttribute = InStrB(lngBeginOfAttribute, bytThisChunk, bytEndOfFile, vbBinaryCompare)
      
      bytFileName = MidB(bytThisChunk, lngBeginOfAttribute, lngEndOfAttribute - lngBeginOfAttribute)
      
      If UBound(bytFileName) < 0 Or UBound(bytValue) < 0 Then
        Err.Raise ERR_INVALID_FILENAME, App.Title, "Invalid File Name."
      End If
      
      If Me.Target = "" Then
        Err.Raise ERR_INVALID_TARGET, App.Title, "Invalid Target."
      End If
      
      'Use the original file name.
      If Me.FileName = "" Then
      
        'Trim the path from the file name.
        While InStrB(1, bytFileName, StrConv("\", vbFromUnicode), vbBinaryCompare) > 0
          bytFileName = MidB(bytFileName, InStrB(1, bytFileName, StrConv("\", vbFromUnicode)) + 1)
        Wend
        
        'Set the property.
        Me.FileName = StrConv(bytFileName, vbUnicode)
        
        'Convert the byte to Unicode.
        strFileName = Me.Target & Me.FileName
       
      Else
        strFileName = Me.Target & Me.FileName
      End If
      
      'Check for overwrite.
      If Me.OverWrite Then
        'This is the hack check. Make sure that wildcard characters cannot be used.
        If Not InStr(1, strFileName, "*") Then
          If FileExists(strFileName) Then
            Kill strFileName
          End If
        Else
          Err.Raise ERR_INVALID_FILENAME, App.Title, "The specified file name appears to be invalid."
        End If
      Else
        If FileExists(strFileName) Then
          Err.Raise ERR_FILE_EXISTS, App.Title, "The file already exists."
        End If
      End If
      
      lngFileNum = FreeFile
      
      Open strFileName For Binary Access Write As #lngFileNum
      
      'Write the file to the destination directory.
      Put #lngFileNum, , bytValue

      'This chunk is empty. Therefore, get a new chunk.
      lngBytesLeft = m_objRequest.TotalBytes - lngChunkSize
        
      'Start the chunking machine.
      Do While lngBytesLeft > 0
      
        'Get a new chunk.
        bytThisChunk = m_objRequest.BinaryRead(CVar(lngChunkSize))
                  
          lngEndOfValue = InStrB(1, bytThisChunk, bytEndOfValue, vbBinaryCompare)
          
          If lngEndOfValue > 0 Then
            'The item value exists in the current chunk.
            bytThisChunk = MidB(bytThisChunk, 1, lngEndOfValue - 1)
          End If
          
          'Append the chunk to the file.
          Put #lngFileNum, , bytThisChunk
          
          lngBytesLeft = lngBytesLeft - lngChunkSize
          
          If lngBytesLeft < lngChunkSize Then
            lngChunkSize = lngBytesLeft
          End If
        Loop
        
        Close #lngFileNum
        
        TotalBytes = FileLen(strFileName)
        
     ' Exit Do
     Else
      If UCase(StrConv(bytName, vbUnicode)) = "SAVEAS" Then
       Me.FileName = StrConv(bytValue, vbUnicode)
      Else 
       'form field other than file, such as textboxes 
       If UBound(bytValue) > 0 And UBound(bytName) > 0 Then 
        m_formCol.Add StrConv(bytName, vbUnicode), StrConv(bytValue, vbUnicode)
       Else
        m_formCol.Add StrConv(bytName, vbUnicode), ""
       End If
      End If
     End If
    
    'Get the next chunk.
    lngBeginOfChunk = lngEndOfValue
    
    If InStrB(lngBeginOfChunk, bytThisChunk, bytBeginOfName, vbBinaryCompare) = 0 Then
      blnEndOfData = True
    End If
  Loop

  Uploaded = True
  
  Exit Sub
  
UploadErr:
  
  If Err.Number = VB_ERR_PATH_NOT_FOUND Then
    Err.Raise ERR_INVALID_TARGET, App.Title, "The Target specified does not exist."
  Else
    Err.Raise Err.Number, Err.Source, Err.Description
  End If
End Sub

Public Property Get Form() As Collection
    Set Form = m_formCol
End Property
Public Property Get FileName() As String
  FileName = m_strFileName
End Property

Public Property Let FileName(ByVal strNewValue As String)
  If Uploaded Then
    Err.Raise ERR_UPLOAD_CALLED, App.Title, "The Upload method has already been called."
  Else
    m_strFileName = strNewValue
  End If
End Property

Public Property Get OverWrite() As Boolean
  OverWrite = m_blnOverWrite
End Property

Public Property Let OverWrite(ByVal blnNewValue As Boolean)
  If Uploaded Then
    Err.Raise ERR_UPLOAD_CALLED, App.Title, "The Upload method has already been called."
  Else
    m_blnOverWrite = blnNewValue
  End If
End Property

Private Property Get Uploaded() As Boolean
  Uploaded = m_blnUploaded
End Property

Private Property Let Uploaded(ByVal blnNewValue As Boolean)
  m_blnUploaded = blnNewValue
End Property

Public Property Get Target() As String
  Target = m_strTarget
End Property

Public Property Let Target(ByVal NewValue As String)
  If Uploaded Then
    Err.Raise ERR_UPLOAD_CALLED, App.Title, "The Upload method has already been called."
  Else
    m_strTarget = NewValue
  End If
End Property

Private Function FileExists(ByVal FileName As String) As Boolean
  On Error GoTo FileExistsErr
  
  FileLen FileName
  FileExists = True
  Exit Function
  
FileExistsErr:
  If Err.Number = VB_ERR_PATH_NOT_FOUND Then
    FileExists = False
  End If
End Function

Public Property Get TotalBytes() As Long
  TotalBytes = m_lngTotalBytes
End Property

Private Property Let TotalBytes(ByVal NewValue As Long)
  m_lngTotalBytes = NewValue
End Property
