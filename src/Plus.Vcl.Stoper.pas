unit Plus.Vcl.Stoper;

interface

uses
  System.Classes, System.SysUtils, System.TimeSpan {reqired XE2+} ,
  System.Generics.Collections,
  Vcl.ExtCtrls;

type
  TStoperC = class;
  TProxyTimer = class;

  TStoperFactory = class
  private
  strict private
    class var FInitialized: boolean;
    class var FOwner: TComponent;
    class var FNextID: Integer;
    class var FIntervals: TDictionary<Integer, TProxyTimer>;
    class procedure Initialize;
  public
    class function SetTimeout(const delayMs: Integer;
      onIntervalProc: TProc): Integer;
    class function SetInterval(const delayMs: Integer;
      onIntervalProc: TProc): Integer;
    class procedure clearInterval(intervalID: Integer);
    class function StartStoperC(AOwner: TComponent): TStoperC;
    class procedure GarbageCollector;
  end;

  TStoperC = class(TComponent)
  public
    function getLapTimeMs: Integer;
    function getLapTime: TTimeSpan;
    function Stop: Integer;
    function Reset: Integer;
  end;

  TTimerMode = (tmOnce, tmLoop);

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
  FIntervals := TDictionary<Integer, TProxyTimer>.Create;
  FOwner := TComponent.Create(nil);
  FNextID := 1;
  FInitialized := true;
end;

class function TStoperFactory.SetInterval(const delayMs: Integer;
  onIntervalProc: TProc): Integer;
var
  tmr: TProxyTimer;
begin
  if not FInitialized then
    Initialize();
  tmr := TProxyTimer.Create(FOwner);
  FIntervals.Add(FNextID, tmr);
  Result := FNextID;
  FNextID := FNextID + 1;
  with tmr do
  begin
    OnTimerProc := onIntervalProc;
    Mode := tmLoop;
    StartTimer(delayMs);
  end;
end;

class function TStoperFactory.SetTimeout(const delayMs: Integer;
  onIntervalProc: TProc): Integer;
var
  tmr: TProxyTimer;
begin
  if not FInitialized then
    Initialize();
  tmr := TProxyTimer.Create(FOwner);
  FIntervals.Add(FNextID, tmr);
  Result := FNextID;
  FNextID := FNextID + 1;
  with tmr do
  begin
    OnTimerProc := onIntervalProc;
    Mode := tmOnce;
    StartTimer(delayMs);
  end;
end;

class procedure TStoperFactory.clearInterval(intervalID: Integer);
var
  AInterval: TProxyTimer;
begin
  if FInitialized and FIntervals.TryGetValue(intervalID, AInterval) then
  begin

  end;
end;

class function TStoperFactory.StartStoperC(AOwner: TComponent): TStoperC;
begin
  Result := nil;
end;

class procedure TStoperFactory.GarbageCollector;
begin

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
