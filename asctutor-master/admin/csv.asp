<!-- 
   Name:        Tutor Schedule Upload
   Written By:  Carel ten Hove 
   System:      Part of the Tutor Schedule Update component of the ASC Tutor Schedule Portal 
   Added:       Spring 2015
   Purpose:     Reads the data in the file uploaded to the system so that it can be inserted into the database.
   How:         ASP script that parses through the data in a file and stores it in an array.
-->


<%
function SplitCSV(ByVal LineToSplit,Splitter)

DIM ReturnValue(),Counter

Counter = 0
if Mid(LineToSplit,1,1) = Splitter then
  REDIM preserve ReturnValue(Counter)
  ReturnValue(Counter) = ""
  Counter = Counter + 1
end if 
WHILE Len(LineToSplit) > 0
  if Mid(LineToSplit,1,1) = Splitter then
    LineToSplit = Right(LineToSplit,Len(LineToSplit)-1)
  end if 
  if Mid(LineToSplit,1,1) = Splitter then
    REDIM preserve ReturnValue(Counter)
    ReturnValue(Counter) = ""
    Counter = Counter + 1
  else
    if Mid(LineToSplit,1,1) = chr(34) then
      Counter2 = 2
      WHILE Counter2 < Len(LineToSplit) and Mid(LineToSplit,Counter2,1) <> CHR(34)
        Counter2 = Counter2 + 1
      WEND
      REDIM preserve ReturnValue(Counter)
      ReturnValue(Counter) = Left(LineToSplit,Counter2)
      LineToSplit = Right(LineToSplit,Len(LineToSplit)-Counter2)
      Counter = Counter + 1
    else
      Counter2 = 1
      WHILE Counter2 <= Len(LineToSplit) and Mid(LineToSplit,Counter2,1) <> Splitter
        Counter2 = Counter2 + 1
      WEND
      REDIM preserve ReturnValue(Counter)
      ReturnValue(Counter) = Left(LineToSplit,Counter2-1)
      if Counter2 <= len(LineToSplit) then
        LineToSplit = Right(LineToSplit,Len(LineToSplit)-Counter2+1)
      else
        LineToSplit = ""
      end if
      Counter = Counter + 1
    end if  
  end if
WEND
SplitCSV = ReturnValue
end function


function CSVRead(CSVFileName,ByRef CsvArray,ByRef ItemsCount,Splitter)
DIM TempArray(),ReturnValue(),CSVLine
DIM Counter,Counter2,LinesCount
Counter = -1
ItemsCount = 0
Set CSVObj = Server.CreateObject("Scripting.FileSystemObject")
if CSVObj.FileExists(Server.MapPath(CSVFileName)) then
  Set FileObject = CSVObj.OpenTextFile(Server.MapPath(CSVFileName))
  WHILE NOT FileObject.AtEndOfStream
    CSVLine = FileObject.readline
    if trim(CSVLine) <> "" then
      Counter = Counter + 1
      REDIM Preserve TempArray(Counter)
      TempArray(Counter) = SplitCSV(CSVLine,Splitter)
      if UBound(TempArray(Counter)) > ItemsCount then
        ItemsCount = UBound(TempArray(Counter))
      end if  
    end if
  WEND
  FileObject.Close
end if
LinesCount = Counter
if LinesCount > -1 then
  REDIM Preserve CsvArray(LinesCount,ItemsCount) 
  for Counter = 0 to LinesCount
    ItemsCount = UBound(TempArray(Counter))
    for Counter2 = 0 to ItemsCount
      if Left(TempArray(Counter)(Counter2),1) = chr(34) then
        if Right(TempArray(Counter)(Counter2),1) = chr(34) then
          TempValue = Left(TempArray(Counter)(Counter2),Len(TempArray(Counter)(Counter2))-1)
          TempValue = Right(TempValue,Len(TempValue)-1)
          TempArray(Counter)(Counter2) = TempValue
        end if
      end if  
      CsvArray(Counter,Counter2) = TempArray(Counter)(Counter2)
    next  
  next
end if
CSVRead = LinesCount
Set IniObj = nothing  
end function


function CSVWrite(CSVFileName,ByVal Value,ItemCount,Splitter)

DIM Counter,Counter2

Set CSVObj = Server.CreateObject("Scripting.FileSystemObject")
Set TargetObj = CSVObj.CreateTextFile(Server.MapPath(CSVFileName))
for Counter = 0 to UBound(Value)
  for Counter2 = 0 to ItemCount-1
    if instr(Value(Counter,Counter2),Splitter) <> 0 then
      if Left(Value(Counter,Counter2),1) <> chr(34) then
        Value(Counter,Counter2) = chr(34) + Value(Counter,Counter2) + chr(34)
      end if
    end if    
    TargetObj.Write(Value(Counter,Counter2) & Splitter)
  next
  TargetObj.WriteLine(Value(Counter,ItemCount))
next  
TargetObj.Close

end function


%>