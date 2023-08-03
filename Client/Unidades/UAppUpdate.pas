unit UAppUpdate;

interface
uses
  System.Classes, System.Types, System.SysConst, System.SysUtils,
  System.Generics.Collections, System.NetEncoding;

type TAppUpdate = record
  private
  public
    Nombre: string;
    Version: string;
    NotasVersion: string;
    base64: string;
end;

implementation

end.
