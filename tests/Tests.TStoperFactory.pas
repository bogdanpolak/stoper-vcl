unit Tests.TStoperFactory;

interface

uses
  DUnitX.TestFramework,
  System.Classes, System.SysUtils,
  Vcl.Forms,
  Windows,
  Plus.Vcl.Stoper;

{$TYPEINFO ON}  { Requred for old RTTI metadata form published section }

type

  [TestFixture]
  TStoperFactoryTests = class(TObject)
  strict private
    procedure DelayMs(delay: Integer);
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure SetTimeout10ms;
    procedure SetInterval10ms;
    procedure SetAndClearInterval10ms;
    procedure CheckGarbageCollector;
  end;

implementation

// ------------------------------------------------------------------------
// TStoperFactoryTests
// ------------------------------------------------------------------------
{$REGION 'TStoperFactoryTests -'}

procedure TStoperFactoryTests.Setup;
begin
end;

procedure TStoperFactoryTests.TearDown;
begin
end;

procedure TStoperFactoryTests.DelayMs(delay: Integer);
var
  start: Cardinal;
  tick: Cardinal;
begin
  start := getTickCount;
  tick := start;
  while (start <= tick) and (tick - start < delay) do
  begin
    Application.ProcessMessages;
    Sleep(1);
    tick := getTickCount;
  end;
end;

procedure TStoperFactoryTests.SetInterval10ms;
var
  Counter: Integer;
begin
  TStoperFactory.SetInterval(10,
    procedure
    begin
      Counter := Counter + 1;
    end);
  DelayMs(50);
  Assert.IsTrue(Counter>1);
end;

procedure TStoperFactoryTests.SetTimeout10ms;
var
  Counter: Integer;
begin
  TStoperFactory.SetTimeout(10,
    procedure
    begin
      Counter := Counter + 1;
    end);
  DelayMs(50);
  Assert.AreEqual(1,Counter);
end;

procedure TStoperFactoryTests.SetAndClearInterval10ms;
var
  Counter: Integer;
  id: Integer;
begin
  id := TStoperFactory.SetInterval(10,
    procedure
    begin
      Counter := Counter + 1;
    end);
  TStoperFactory.clearInterval(id);
  DelayMs(50);
  Assert.AreEqual(0,Counter);
end;

procedure TStoperFactoryTests.CheckGarbageCollector;
begin
  TStoperFactory.GarbageCollector;
  // test SetInterval10ms do not clearInterval - then this timer is still ticking
  Assert.AreEqual(1,TStoperFactory.CountTimers);
end;

// ------------------------------------------------------------------------
// ------------------------------------------------------------------------

initialization

TDUnitX.RegisterTestFixture(TStoperFactoryTests);

end.
