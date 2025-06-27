unit uTesteSimples;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTesteSimples = class
  public
    [Test]
    procedure TestarSoma;
  end;

implementation

procedure TTesteSimples.TestarSoma;
begin
  Assert.AreEqual(4, 2 + 2);
end;

initialization
  TDUnitX.RegisterTestFixture(TTesteSimples);

end.

