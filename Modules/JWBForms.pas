unit JWBForms;

{$DEFINE ANCHORFAILFIX}
{ If set: Use more visually pleasant and thorough solution to anchors breaking
 on RecreateWnd(), which might just have consequences.
 If clear: Use ugly but proven and safe solution with form blinking. }

interface
uses Types, Classes, Forms, Graphics, Controls, ExtCtrls, Messages;

{
Docking guide.

1. Every form has docked and undocked dimensions. Undocked ones are saved on dock
 and kept in UndockWidth/UndockHeight.
 TODO: Save and keep X, Y somewhere as they are lost.

2. When docking, the form is asked to provide docked dimensions it preserved.
 By default, undocked dimensions are used.

3. When undocking, the form is given the chance to preserve last docked dimensions.
 By default, they're discarded.

3a. Depending on the docking type, you may want to update not both of the docked
 dimensions. E.g. when docked left, the height is always full height of parent.

4. The type of docking is indicated with TAlign. The form can rearrange controls
 differently depending on the type.
   alLeft, alRight: horizontal docking
   alTop, alBottom: vertical docking
   alClient: expand docking (take all available space and disallow resizing)
   alCustom: as-is docking (preserve size and disallow resizing)
   alNone: undocked (when docking, equals alCustom)

5. Wakan supports "Portrait mode", this is simply re-docking the forms vertically.
 Support all types of docking and you're good to go.

6. Mind the resizing problems when rearranging controls (see below).
}

const
  WM_GET_DOCKED_W = WM_APP + 1; { Docker calls these to get docked control sizes before docking }
  WM_GET_DOCKED_H = WM_APP + 2;
  WM_SAVE_DOCKED_WH = WM_APP + 3; { Docker calls this to save docked sizes before undocking }
  WM_SET_DOCK_MODE = WM_APP + 4; { Docker calls this before docking or after undocking. Use this chance to prepare the form by rearranging controls }

function DockProc(slave: TForm; panel: TWinControl; dir: TAlign): boolean; overload;
function DockProc(slave: TForm; panel: TWinControl; dir: TAlign; dock: boolean): boolean; overload;
procedure UndockedMakeVisible(slave:TForm);


{
Many forms are built on Anchors, and those are broken. See:
  http://stackoverflow.com/questions/15062571/workaround-for-anchors-being-broken-when-recreating-a-window
Any time you recreate a window, controls which are less than 0 in size due to
anchoring get messed up.
Setting negative control sizes explicitly (.Width := -14) also breaks layout.

Be careful:
1. When you dock/undock the form.
2. When you manually rearrange the controls (e.g. set Top/Left/Width/Height from
 code)

Workaround 1. Disable UpdateAnchorRules() by setting csLoading while
 recreating the window.
Workaround 2. Make the window huge when showing it, so that all controls
 fit, then resize it back.

Workaround 2 is ugly, but you can use it to rearrange controls while hidden.
}

{
These are some helpers. Usage:
  with SafeRecreate(AForm) do try
    RecreateHandle;
  finally
    Unlock;
  end;
}
type
  TDisableAnchorRulesHelper = record
    FForm: TForm;
    procedure Lock;
    procedure Unlock;
  end;
  TTemporarilyResizeHelper = record
    FForm: TForm;
    OldSize: TPoint;
    procedure Lock;
    procedure Unlock;
    function SetWH(const wh: TPoint): TPoint;
  end;
 {$IFDEF ANCHORFAILFIX}
  TSafeRecreateHelper = TDisableAnchorRulesHelper;
 {$ELSE}
  TSafeRecreateHelper = TTemporarilyResizeHelper;
 {$ENDIF}
  TSafeRearrangeHelper = TTemporarilyResizeHelper;

function SafeRecreate(AForm: TForm): TSafeRecreateHelper;
function SafeRearrange(AForm: TForm): TSafeRearrangeHelper;


{
Scrollbox does not support mouse wheel nor even focus, so you have to handle it
manually.
Usage:
  procedure FormMouseWheel(...);
  begin
    HandleScrollboxMouseWheel(...);
  end;
}

procedure HandleScrollboxMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);


{
Common form ancestor for Wakan.
You don't *have* to inherit from TJwbForm but it does give you some benefits:
 1. Automatic translation on creation.
  It's impossible to hook creation event and translate all forms on the fly,
  but all static forms are translated at the start even without this.
}
type
  TJwbForm = class(TForm)
  protected
    procedure DoCreate; override;
  end;

implementation
uses Windows, JWBLanguage;

type
  TComponentHack = class helper for TComponent
  public
    procedure SetCsLoading(Value: boolean);
  end;

procedure TComponentHack.SetCsLoading(Value: boolean);
var i: integer;
begin
  with Self do begin
    if Value then
      FComponentState := FComponentState + [csLoading]
    else
      FComponentState := FComponentState - [csLoading];
  end;
  for i := 0 to Self.ComponentCount-1 do
    if Self.Components[i] is TControl then
      TControl(Self.Components[i]).SetCsLoading(Value);
end;

procedure TDisableAnchorRulesHelper.Lock;
begin
  FForm.SetCsLoading(true);
end;

procedure TDisableAnchorRulesHelper.Unlock;
begin
  FForm.SetCsLoading(false);
end;

function TTemporarilyResizeHelper.SetWH(const wh: TPoint): TPoint;
begin
  Result.X := FForm.ClientWidth;
  Result.Y := FForm.ClientHeight;
  FForm.ClientWidth := wh.X;
  FForm.ClientHeight := wh.Y;
end;

procedure TTemporarilyResizeHelper.Lock;
begin
  OldSize := SetWH(Point(10000,10000));
end;

procedure TTemporarilyResizeHelper.Unlock;
begin
  SetWH(OldSize);
end;

function SafeRecreate(AForm: TForm): TSafeRecreateHelper;
begin
  Result.FForm := AForm;
  Result.Lock;
end;

function SafeRearrange(AForm: TForm): TSafeRearrangeHelper;
begin
  Result.FForm := AForm;
  Result.Lock;
end;


{
- Docks the form and makes it visible, or
- Hides and undocks it, restores its permanent width and height.

What the function un/does depends on dir/panel it receives. So when undocking,
pass the same dir you used when docking.
E.g. it hides the panel.

For the same reason auto-redocking is discouraged. If you're not sure where it's
docked you don't know how to undock it. Undock manually beforehand.

panel: Where to dock (nil = undock).
dir: Dock direction/style.

Returns true if the form was docked before the call.
}
function DockProc(slave: TForm; panel: TWinControl; dir: TAlign): boolean;
var rect:TRect;
  sz: integer;
begin
  Result := slave.HostDockSite<>nil;

  if Result and (panel<>nil) and (slave.HostDockSite<>panel) then //auto-redock
    DockProc(slave, nil, alNone);
  if (not Result) and (panel=nil) then exit; //already undocked

  if panel<>nil then begin //Dock
    if dir in [alTop,alBottom,alNone] then begin
      sz := slave.Perform(WM_GET_DOCKED_H,0,0);
      if sz<=0 then sz := slave.Height;
      panel.Height := sz;
    end;
    if dir in [alLeft,alRight,alNone] then begin
      sz := slave.Perform(WM_GET_DOCKED_W,0,0);
      if sz<=0 then sz := slave.Width;
      panel.Width := sz;
    end;
    slave.Perform(WM_SET_DOCK_MODE,integer(dir),0);
    slave.Visible := false;
//    if slave.HandleAllocated then
//      TSlaveHack(slave).DestroyWindowHandle;
//   ^ don't do or some forms will lose their state (such as TCheckListBox contents)
    slave.ManualDock(panel);
   {$IFDEF ANCHORFAILFIX}
    slave.SetCsLoading(true);
    try
   {$ELSE}
    slave.Width := 10000;
    slave.Height := 10000;
   {$ENDIF}
    slave.Visible := true; //UpdateExplicitBounds!
   {$IFDEF ANCHORFAILFIX}
    finally
      slave.SetCsLoading(false);
    end;
   {$ENDIF}
    slave.Align := alClient;
  end else begin //Undock
    panel := slave.HostDockSite; //old dock site
    slave.Perform(WM_SAVE_DOCKED_WH,0,0);
    slave.Hide;
    rect.Left:=0;
    rect.Top:=0;
    rect.Right:=slave.UndockWidth; //non-docked width and height
    rect.Bottom:=slave.UndockHeight; //only available when docked
    slave.Align:=alNone;
    slave.ManualFloat(rect);
    if panel<>nil then begin
      if dir in [alTop,alBottom] then panel.height:=0;
      if dir in [alLeft,alRight] then panel.width:=0;
    end;
    slave.Perform(WM_SET_DOCK_MODE,integer(alNone),0);
  end;
end;

//Some like it stupid. You can already undock just by passing panel=nil,
//but there's code which relies on additional parameter.
function DockProc(slave: TForm; panel: TWinControl; dir: TAlign; dock: boolean): boolean;
begin
  if not dock then
    Result := DockProc(slave, nil, dir)
  else
    Result := DockProc(slave, panel, dir);
end;

{
Undocked form is hidden by default.
Call this to make it visible in a safe way which doesn't break form layout
because of anchor layout bug.
It's not compulsory, you may make it visible by yourself if you know what to
watch out for.
}
procedure UndockedMakeVisible(slave:TForm);
begin
 {$IFDEF ANCHORFAILFIX}
  slave.SetCsLoading(true);
  try
 {$ELSE}
  slave.Width := 10000;
  slave.Height := 10000;
 {$ENDIF}
  slave.Visible := true;
 {$IFDEF ANCHORFAILFIX}
  finally
    slave.SetCsLoading(false);
  end;
 {$ENDIF}
end;



//Tests if the mouse is pointing at a window, or at a child of that window etc.
function PointingAt(AHwnd: HWND; const APoint: TPoint): boolean;
var ACurHwnd: HWND;
begin
  ACurHwnd := WindowFromPoint(mouse.CursorPos);
  while ACurHwnd<>0 do
    if ACurHwnd=AHwnd then begin
      Result := true;
      exit;
    end else
      ACurHwnd := GetParent(ACurHwnd);
  Result := false;
end;

function FindControlAt(APos: TPoint; AllowDisabled: boolean = false): TControl; overload;
var wctl: TWinControl;
begin
  wctl := FindVCLWindow(APos);
  if wctl=nil then begin
    Result := nil;
    exit;
  end;

  APos := wctl.ScreenToClient(APos);
  Result := wctl.ControlAtPos(APos, AllowDisabled);
  while (Result<>nil) and (Result is TWinControl) do begin
    wctl := TWinControl(Result);
    APos := wctl.ParentToClient(APos);
    Result := wctl.ControlAtPos(APos, AllowDisabled);
  end;

  if Result=nil then
    Result := wctl;
end;

type
  CControl = class of TControl;

function FindControlAt(APos: TPoint; AClass: CControl; AllowDisabled: boolean = false): TControl; overload;
begin
  Result := FindControlAt(APos, AllowDisabled);
  while (Result<>nil) and not (Result is AClass) do
    Result := Result.Parent;
end;

procedure HandleScrollboxMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
var msg, code, i, n: integer;
  ctl: TControl;
begin
  ctl := FindControlAt(MousePos, TScrollingWinControl); //mouse.CursorPos?
  if ctl=nil then exit;

  Handled := true;
  if ssShift in Shift Then
    msg := WM_HSCROLL
  else
    msg := WM_VSCROLL;

  if WheelDelta < 0 then begin
    code := SB_LINEDOWN;
    WheelDelta := -WheelDelta;
  end else
    code := SB_LINEUP;

  n := 3* Mouse.WheelScrollLines * (WheelDelta div WHEEL_DELTA);
  for i := 1 to n do
    TScrollingWinControl(ctl).Perform(msg, code, 0);
  TScrollingWinControl(ctl).Perform(msg, SB_ENDSCROLL, 0);
end;



procedure TJwbForm.DoCreate;
begin
  inherited;
  if fLanguage<>nil then
    fLanguage.TranslateForm(Self);
end;

end.
