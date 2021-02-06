{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit mungo.components.bgrabitmap;

{$warn 5023 off : no warning about unused units}
interface

uses
  mungo.components.bgrabitmap.BGRACanvas, 
  mungo.components.bgrabitmap.Canvas2D, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('mungo.components.bgrabitmap', @Register);
end.
