unit Plus.Vcl.Stoper;

interface

uses
  System.Classes, System.SysUtils, System.TimeSpan {reqired XE2+} ,
  System.Generics.Collections,
  Vcl.ExtCtrls;

type
  TStoperC = class;
  TProxyTimer = class;
  TTimerMode = (tmOnce, tmLoop);

  TStoperFactory = class
  strict private
    class var FInitialized: boolean;
    class var FOwner: TComponent;
    class var FNextID: Integer;
    class var FTimers: TDictionary<Integer, TProxyTimer>;
    class procedure Initialize;
    class function StartNewProxyTimer(const delayMs: Integer; aMode: TTimerMode; onIntervalProc: TProc): Integer; static;
  public
    class function SetTimeout(const delayMs: Integer;
      onIntervalProc: TProc): Integer;
    class function SetInterval(const delayMs: Integer;
      onIntervalProc: TProc): Integer;
    class procedure clearInterval(intervalID: Integer);
    class function StartStoperC(AOwner: TComponent): TStoperC;
    class procedure GarbageCollector;
    class function CountTimers: integer;
  end;

  TStoperC = class(TComponent)
  public
    function getLapTimeMs: Integer;
    function getLapTime: TTimeSpan;
    function Stop: Integer;
    function Reset: Integer;
  end;

  TProxyTimer = class(TComponent)
  strict private
    FTimer: TTimer;
    FOnTimerProc: TProc;
    FMode: TTimerMode;
    procedure OnTimerEvent(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    procedure StartTimer(interval: Integer);
    property Timer: TTimer read FTimer write FTimer;
    property OnTimerProc: TProc read FOnTimerProc write FOnTimerProc;
    property Mode: TTimerMode read FMode write FMode;
  end;

implementation

{ TStoperFactory }

class procedure TStoperFactory.Initialize;
begin
  FTimers := TDictionary<Integer, TProxyTimer>.Create;
  FOwner := TComponent.Create(nil);
  FNextID := 1;
  FInitialized := true;
end;

class function TStoperFactory.StartNewProxyTimer(const delayMs: Integer; aMode:TTimerMode; onIntervalProc: TProc): Integer;
var
  tmr: TProxyTimer;
begin
  GarbageCollector;
  if not FInitialized then
    Initialize();
  tmr := TProxyTimer.Create(FOwner);
  FTimers.Add(FNextID, tmr);
  Result := FNextID;
  FNextID := FNextID + 1;
  with tmr do
  begin
    OnTimerProc := onIntervalProc;
    Mode := aMode;
    StartTimer(delayMs);
  end;
end;

class function TStoperFactory.SetInterval(const delayMs: Integer;
  onIntervalProc: TProc): Integer;
begin
  Result := StartNewProxyTimer (delayMs, tmLoop, onIntervalProc);
end;

class function TStoperFactory.SetTimeout(const delayMs: Integer;
  onIntervalProc: TProc): Integer;
begin
  Result := StartNewProxyTimer (delayMs, tmOnce, onIntervalProc);
end;

class procedure TStoperFactory.clearInterval(intervalID: Integer);
var
  timer: TProxyTimer;
begin
  if FInitialized and FTimers.TryGetValue(intervalID, timer) then
  begin
    timer.Timer.Enabled := False;
  end;
  GarbageCollector;
end;

class function TStoperFactory.StartStoperC(AOwner: TComponent): TStoperC;
begin
  Result := nil;
end;

class function TStoperFactory.CountTimers: integer;
begin
  if FInitialized then
    Result := FTimers.Count
  else
    Result := 0;
end;

class procedure TStoperFactory.GarbageCollector;
var
  pair: TPair<Integer, TProxyTimer>;
  keys: TArray<Integer>;
  i: Integer;
begin
  if FInitialized then
  begin
    keys := FTimers.Keys.ToArray;
    for i := Low(keys) to High(keys) do
    begin
      if not FTimers[keys[i]].Timer.Enabled then
      begin
        FTimers[keys[i]].Free;
        FTimers.Remove(keys[i]);
      end;
    end;
  end;
end;

{ TStoperC }

function TStoperC.getLapTime: TTimeSpan;
begin

end;

function TStoperC.getLapTimeMs: Integer;
begin
  Result := -1;
end;

function TStoperC.Reset: Integer;
begin
  Result := -1;
end;

function TStoperC.Stop: Integer;
begin
  Result := -1;
end;

{ TInterval }

constructor TProxyTimer.Create(AOwner: TComponent);
begin
  inherited;
  Timer := TTimer.Create(Self);
end;

procedure TProxyTimer.OnTimerEvent(Sender: TObject);
begin
  if Mode = tmOnce then
    FTimer.Enabled := False;
  if Assigned(OnTimerProc) then
    OnTimerProc();
end;

procedure TProxyTimer.StartTimer(interval: Integer);
begin
  FTimer.interval := interval;
  FTimer.OnTimer := OnTimerEvent;
  FTimer.Enabled := true;
end;

end.
