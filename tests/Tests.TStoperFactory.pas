unit Tests.TStoperFactory;

interface

uses
  DUnitX.TestFramework,
  System.Classes, System.SysUtils,
  Plus.Vcl.Stoper;

{$TYPEINFO ON}  { Requred for old RTTI metadata form published section }

type
  [TestFixture]
  TStoperFactoryTests = class(TObject)
  strict private
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
  published
    procedure TestName;
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

procedure TStoperFactoryTests.TestName;
begin
  Assert.Fail();
end;

// ------------------------------------------------------------------------
// ------------------------------------------------------------------------

initialization

TDUnitX.RegisterTestFixture(TStoperFactoryTests);

end.
