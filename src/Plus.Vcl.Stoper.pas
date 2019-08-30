unit Plus.Vcl.Stoper;

interface

uses
  System.Classes, System.SysUtils, System.TimeSpan {reqired XE2+};

type
  TStoperC = class;

  TStoperFactory = class
  private
  strict private
  public
    class procedure SetInterval(const delayMs: integer; onIntervalProc: TProc);
    class procedure SetTick(const delayMs: integer; var setStopTick: boolean;
      onIntervalProc: TProc);
    class function StartStoperC(AOwner: TComponent): TStoperC;
  end;

  TStoperC = class(TComponent)
  public
    function getLapTimeMs: integer;
    function getLapTime: TTimeSpan;
    function Stop: integer;
    function Reset: integer;
  end;

implementation

{ TStoperFactory }

class procedure TStoperFactory.SetInterval(const delayMs: integer;
  onIntervalProc: TProc);
begin

end;

class procedure TStoperFactory.SetTick(const delayMs: integer;
  var setStopTick: boolean; onIntervalProc: TProc);
begin

end;

class function TStoperFactory.StartStoperC(AOwner: TComponent): TStoperC;
begin

end;

{ TStoperC }

function TStoperC.getLapTime: TTimeSpan;
begin

end;

function TStoperC.getLapTimeMs: integer;
begin

end;

function TStoperC.Reset: integer;
begin

end;

function TStoperC.Stop: integer;
begin

end;

end.
