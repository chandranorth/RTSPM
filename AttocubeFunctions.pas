unit AttocubeFunctions;

{$MODE Delphi}

interface
  uses GlobalVariables, Synaser;


var
  AttocubeSerial       : TBlockSerial;

  procedure InitializeAttocube;
  procedure FreeAttocube;
  procedure AttocubePlusMove(WhichAxis: Axis);
  procedure AttocubeMinusMove(WhichAxis: Axis);
  procedure AttocubeStop(WhichAxis:Axis);
  procedure AttocubeTimedPlusMove(WhichAxis:Axis; MoveTime:integer);
  procedure AttocubeTimedMinusMove(WhichAxis:Axis; MoveTime: integer);
  procedure AttocubeTimedZApproach(MoveTime:integer);
  procedure AttocubeTimedZRetract(MoveTime:integer);

implementation
 uses SPM_Main, SysUtils, GlobalFunctions,SdpoSerial;
{ --------------------------------------------------------------------------}
procedure InitializeAttocube;
var
  s : string;
begin
  //Set the Com Port
  AttocubeSerial:=TBlockSerial.Create;
  try
    AttocubeSerial.RaiseExcept := False;
    AttocubeSerial.LinuxLock := False;
    AttocubeSerial.Connect('/dev/ttyS'+IntToStr(AttocubeComPortNumber-1));
    AttocubeSerial.Config(9600, 8, 'N', 1, FALSE, FALSE);
    s := AttocubeSerial.LastErrorDesc;
  except
    FreeAndNil(AttocubeSerial);
  end;

  AttocubeSerial.SendString('setm 1 stp'+Chr(13));
  AttocubeSerial.SendString('setm 2 stp'+Chr(13));
  AttocubeSerial.SendString('setm 3 stp'+Chr(13));
end;
procedure FreeAttocube;
begin
  if AttocubeSerial<>nil then
   begin
     AttocubeSerial.Purge;
     AttocubeSerial.Free;
   end;
end;

{----------------------------------------------------------------------------}
procedure AttocubePlusMove(WhichAxis: Axis);
  begin
    if WhichAxis=XAxis then
      begin
        AttocubeSerial.SendString('setm 1 stp'+Chr(13));
        AttocubeSerial.SendString('stepu 1 c'+Chr(13));
      end
     else if WhichAxis=YAxis then
      begin
        AttocubeSerial.SendString('setm 2 stp'+Chr(13));
        AttocubeSerial.SendString('stepu 2 c'+Chr(13));
      end
     else if WhichAxis=ZAxis then
      begin
        AttocubeSerial.SendString('setm 3 stp'+Chr(13));
        AttocubeSerial.SendString('stepu 3 c'+Chr(13));
      end;
  end;
{-----------------------------------------------------------------------------}
procedure AttocubeMinusMove(WhichAxis: Axis);
  begin
    if WhichAxis=XAxis then
      begin
        AttocubeSerial.SendString('setm 1 stp'+Chr(13));
        AttocubeSerial.SendString('stepd 1 c'+Chr(13));
      end
     else if WhichAxis=YAxis then
      begin
        AttocubeSerial.SendString('setm 2 stp'+Chr(13));
        AttocubeSerial.SendString('stepd 2 c'+Chr(13));
      end
     else if WhichAxis=ZAxis then
      begin
        AttocubeSerial.SendString('setm 3 stp'+Chr(13));
        AttocubeSerial.SendString('stepd 3 c'+Chr(13));
      end;
  end;
{------------------------------------------------------------------------------}
procedure AttocubeStop(WhichAxis:Axis);
  begin
    if WhichAxis=XAxis then
      begin
        AttocubeSerial.SendString('stop 1'+Chr(13));
        AttocubeSerial.SendString('setm 1 gnd'+Chr(13));
      end
     else if WhichAxis=YAxis then
      begin
        AttocubeSerial.SendString('stop 2'+Chr(13));
        AttocubeSerial.SendString('setm 2 gnd'+Chr(13));
      end
     else if WhichAxis=ZAxis then
      begin
        AttocubeSerial.SendString('stop 3'+Chr(13));
        AttocubeSerial.SendString('setm 3 gnd'+Chr(13));
      end;
  end;
{---------------------------------------------------------------------------}
procedure AttocubeTimedPlusMove(WhichAxis:Axis; MoveTime:integer);
  begin
    AttocubePlusMove(WhichAxis);
    delay(MoveTime);
    AttocubeStop(WhichAxis);
  end;
{---------------------------------------------------------------------------}
procedure AttocubeTimedMinusMove(WhichAxis:Axis; MoveTime: integer);
  begin
    AttocubeMinusMove(WhichAxis);
    delay(MoveTime);
    AttocubeStop(WhichAxis);
  end;
{---------------------------------------------------------------------------}
procedure AttocubeTimedZApproach(MoveTime:integer);
  begin
    AttocubeSerial.SendString('setm 3 stp'+Chr(13));
    AttocubeSerial.SendString('stepu 3 c'+Chr(13));
    delay(MoveTime);
    AttocubeSerial.SendString('stop 3'+Chr(13));
    AttocubeSerial.SendString('setm 3 gnd'+Chr(13));
  end;
{---------------------------------------------------------------------------}
procedure AttocubeTimedZRetract(MoveTime:integer);
  begin
    AttocubeSerial.SendString('setm 3 stp'+Chr(13));
    AttocubeSerial.SendString('stepd 3 c'+Chr(13));
    delay(MoveTime);
    AttocubeSerial.SendString('stop 3'+Chr(13));
    AttocubeSerial.SendString('setm 3 gnd'+Chr(13));
  end;
end.
