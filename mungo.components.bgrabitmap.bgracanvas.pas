unit mungo.components.bgrabitmap.BGRACanvas;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  BGRACanvas, BGRABitmapTypes, BGRAGraphics,

  mungo.components.renderer,
  mungo.components.geometry,

  p3d.math;

type
  { TRendererFillColorBGRA }

  TRendererFillColorBGRA = class ( TRendererFillColor )
    procedure SetupPenBrush( ACanvas: TObject );
    procedure RenderPoints( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderBezier( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderCircle( ACanvas: TObject; Position: TVec2; Radius: Float ); override;
    procedure RenderRectangle( ACanvas: TObject; TopLeft: TVec2; BottomRight:TVec2 ); override;
  end;

  { TRendererStrokeColorBGRA }

  TRendererStrokeColorBGRA = class ( TRendererStrokeColor )
    procedure SetupPenBrush( ACanvas: TObject );
    procedure RenderPoints( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderBezier( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderCircle( ACanvas: TObject; Position: TVec2; Radius: Float ); override;
    procedure RenderRectangle( ACanvas: TObject; TopLeft: TVec2; BottomRight:TVec2 ); override;
  end;

implementation


{ TRendererStrokeColorBGRA }

procedure TRendererStrokeColorBGRA.SetupPenBrush( ACanvas: TObject );
var
  C: TBGRACanvas absolute ACanvas;
  Cl: TIVec4;
begin
  Cl:= ivec4( Color * 255 );
  C.Brush.Style:= bsClear;
  C.Pen.BGRAColor:= BGRA( Cl.r, Cl.g, Cl.b, Cl.a );
  C.Pen.Style:= psSolid;
  C.Pen.Width:= round( Density );
end;

procedure TRendererStrokeColorBGRA.RenderPoints( ACanvas: TObject;
  Points: TVec2List );
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.Polygon( Points.PtrTo( 0 ), Points.Count );
  end;
end;

procedure TRendererStrokeColorBGRA.RenderBezier(ACanvas: TObject;
  Points: TVec2List);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.PolyBezier( Points.PtrTo( 0 ), Points.Count );
  end;
end;

procedure TRendererStrokeColorBGRA.RenderCircle(ACanvas: TObject;
  Position: TVec2; Radius: Float);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.EllipseC( round( Position.X ), round( Position.Y ), round( Radius ), round( Radius ));
  end;
end;

procedure TRendererStrokeColorBGRA.RenderRectangle(ACanvas: TObject;
  TopLeft: TVec2; BottomRight: TVec2);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.Rectangle( round( TopLeft.X ), round( TopLeft.Y ), round( BottomRight.X ), round( BottomRight.Y ));
  end;
end;

{ TRendererFillColorBGRA }

procedure TRendererFillColorBGRA.SetupPenBrush(ACanvas: TObject);
var
  C: TBGRACanvas absolute ACanvas;
  Cl: TIVec4;
begin
  Cl:= ivec4( Color * 255 );
  C.Brush.Style:= bsSolid;
  C.Brush.BGRAColor:= BGRA( Cl.r, Cl.g, Cl.b, Cl.a );
  C.Pen.Style:= psClear;
end;

procedure TRendererFillColorBGRA.RenderPoints(ACanvas: TObject;
  Points: TVec2List);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.Polygon( Points.PtrTo( 0 ), Points.Count );
  end;
end;

procedure TRendererFillColorBGRA.RenderBezier(ACanvas: TObject;
  Points: TVec2List);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.PolyBezier( Points.PtrTo( 0 ), Points.Count, True );
  end;
end;

procedure TRendererFillColorBGRA.RenderCircle(ACanvas: TObject;
  Position: TVec2; Radius: Float);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.EllipseC( round( Position.X ), round( Position.Y ), round( Radius ), round( Radius ));
  end;
end;

procedure TRendererFillColorBGRA.RenderRectangle(ACanvas: TObject;
  TopLeft: TVec2; BottomRight: TVec2);
var
  C: TBGRACanvas absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas ) then begin
    SetupPenBrush( ACanvas );
    C.Rectangle( round( TopLeft.X ), round( TopLeft.Y ), round( BottomRight.X ), round( BottomRight.Y ));
  end;
end;

end.

