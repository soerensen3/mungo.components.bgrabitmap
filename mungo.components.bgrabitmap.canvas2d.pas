unit mungo.components.bgrabitmap.Canvas2D;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  BGRACanvas2D, BGRABitmapTypes, BGRAGraphics, bgrabitmap,

  mungo.components.types,
  mungo.components.renderer,
  mungo.components.geometry,
  mungo.components.styles,

  p3d.math;

type
  IDrawToCanvas = interface ['{4F5E6559-EE2E-4E3A-A7C4-A025A25CBB02}']
    procedure DrawToCanvas( ACanvas: TCanvas );
  end;
  { TStyleSheetCanvas2D }

  TStyleSheetCanvas2D = class ( TStyleSheet )
    function CreateWidgetContext( ARect: TRectF; ACaption: String ): TWidgetContext; override;
  end;

  { TWidgetContextCanvas2D }

  TWidgetContextCanvas2D = class ( TWidgetContext, IDrawToCanvas )
    private
      FOffScreen: TBGRABitmap;
      function GetCanvas: TBGRACanvas2D;

    public
      procedure UpdateRect(ARect: TRectF); override;

      function CreateRect( ARect: TRectF ): TGeometryRect; override;
      function CreateEllipse( ARect: TRectF ): TGeometryEllipse; override;
      function CreateCircle( ACenter: TVec2; ARadius: Float ): TGeometryCircle; override;
      function CreateText( ACaption: String ): TGeometryText; override;

      procedure DrawToCanvas(ACanvas: TCanvas);

      property Canvas: TBGRACanvas2D read GetCanvas;
  end;

  { TGeometryRectCanvas2D }

  TGeometryRectCanvas2D = class ( TGeometryRect )
    public
      procedure PassGeometry; override;
  end;

  { TGeometryCircleCanvas2D }

  TGeometryCircleCanvas2D = class ( TGeometryCircle )
    public
      procedure PassGeometry; override;
  end;

  { TGeometryEllipseCanvas2D }

  TGeometryEllipseCanvas2D = class ( TGeometryEllipse )
    public
      procedure PassGeometry; override;
  end;

  { TGeometryPathCanvas2D }

  TGeometryPathCanvas2D = class ( TGeometryPath )
    public
      procedure PassGeometry; override;
  end;

  { TGeometryTextCanvas2D }

  TGeometryTextCanvas2D = class ( TGeometryText )
    public
      procedure UpdateCanvasSettings;
      procedure PassGeometry; override;
      procedure UpdateGeometry; override;
  end;



  { TRendererFillColorBGRA }

  TRendererFillColorBGRA = class ( TRendererFillColor )
    procedure SetupPenBrush(ACanvas: TBGRACanvas2D);
    {procedure RenderPoints( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderBezier( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderCircle( ACanvas: TObject; Position: TVec2; Radius: Float ); override;
    procedure RenderEllipse(ACanvas: TObject; TopLeft: TVec2; BottomRight: TVec2 ); override;
    procedure RenderRectangle( ACanvas: TObject; TopLeft: TVec2; BottomRight:TVec2 ); override;
    procedure RenderText(ACanvas: TObject; APosition: TVec2; ACaption: String); override;}
    procedure RenderGeometry(AGeometry: TGeometry); override;
  end;

  { TRendererStrokeColorBGRA }

  TRendererStrokeColorBGRA = class ( TRendererStrokeColor )
    procedure SetupPenBrush(ACanvas: TBGRACanvas2D);
    {procedure RenderPoints( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderBezier( ACanvas: TObject; Points: TVec2List ); override;
    procedure RenderCircle( ACanvas: TObject; Position: TVec2; Radius: Float ); override;
    procedure RenderEllipse( ACanvas: TObject; TopLeft: TVec2; BottomRight: TVec2 ); override;
    procedure RenderRectangle( ACanvas: TObject; TopLeft: TVec2; BottomRight:TVec2 ); override;
    procedure RenderText( ACanvas: TObject; APosition: TVec2; ACaption: String); override;}
    procedure RenderGeometry(AGeometry: TGeometry); override;
  end;

  { TRendererTextFillColorBGRA }

  {TRendererTextFillColorBGRA = class ( TRendererTextFillColor )
    procedure SetupFont( ACanvas: TBGRACanvas2D );
    procedure RenderText( ACanvas: TObject; APosition: TVec2; ACaption: String); override;
  end;}


implementation

{ TWidgetContextCanvas2D }

function TWidgetContextCanvas2D.GetCanvas: TBGRACanvas2D;
begin
  Result:= FOffScreen.Canvas2D;
end;

procedure TWidgetContextCanvas2D.UpdateRect(ARect: TRectF);
begin
  inherited UpdateRect(ARect);
  BGRAReplace( FOffScreen, TBGRABitmap.Create( Rect.WidthI, Rect.HeightI, BGRA( 0, 0, 0, 0 )));
end;

function TWidgetContextCanvas2D.CreateRect(ARect: TRectF): TGeometryRect;
begin
  Result:= TGeometryRectCanvas2D.Create( Self );
  Result.Left:= ARect.Left;
  Result.Top:= ARect.Top;
  Result.Width:= ARect.Width;
  Result.Height:= ARect.Height;
end;

function TWidgetContextCanvas2D.CreateEllipse(ARect: TRectF): TGeometryEllipse;
begin
  Result:= TGeometryEllipseCanvas2D.Create( Self );
  Result.Left:= ARect.Left;
  Result.Top:= ARect.Top;
  Result.Width:= ARect.Width;
  Result.Height:= ARect.Height;
end;

function TWidgetContextCanvas2D.CreateCircle(ACenter: TVec2; ARadius: Float
  ): TGeometryCircle;
begin
  Result:= TGeometryCircleCanvas2D.Create( Self );
  Result.CenterX:= ACenter.X;
  Result.CenterY:= ACenter.Y;
  Result.Radius:= ARadius;
end;

function TWidgetContextCanvas2D.CreateText(ACaption: String): TGeometryText;
begin
  Result:= TGeometryTextCanvas2D.Create( Self );
  Result.Caption:= ACaption;
end;

procedure TWidgetContextCanvas2D.DrawToCanvas(ACanvas: TCanvas);
begin
  FOffScreen.Draw( ACanvas, 0, 0, False );
end;

{ TStyleSheetCanvas2D }

function TStyleSheetCanvas2D.CreateWidgetContext(ARect: TRectF; ACaption: String): TWidgetContext;
begin
  Result:= TWidgetContextCanvas2D.Create;
  Result.UpdateRect( ARect );
  Result.Caption:= ACaption;
end;

{ TGeometryCircleCanvas2D }

procedure TGeometryCircleCanvas2D.PassGeometry;
var
  C: TBGRACanvas2D;
begin
  C:= ( Context as TWidgetContextCanvas2D ).Canvas;
  C.beginPath;
  C.circle( CenterX, CenterY, Radius );
  C.closePath;
end;

{ TGeometryEllipseCanvas2D }

procedure TGeometryEllipseCanvas2D.PassGeometry;
var
  C: TBGRACanvas2D;
begin
  C:= ( Context as TWidgetContextCanvas2D ).Canvas;
  C.beginPath;
  C.ellipse( Left, Top, Width / 2, Height / 2 );
  C.closePath;
end;

{ TGeometryPathCanvas2D }

procedure TGeometryPathCanvas2D.PassGeometry;
begin

end;

{ TGeometryTextCanvas2D }

procedure TGeometryTextCanvas2D.UpdateCanvasSettings;
var
  C: TBGRACanvas2D;
begin
  C:= ( Context as TWidgetContextCanvas2D ).Canvas;
  C.fontName:= FontName;
  C.fontEmHeight:= FontSize;
  C.fontName:= FontName;
  C.fontStyle:= BGRAGraphics.TFontStyles( FontStyle );
end;

procedure TGeometryTextCanvas2D.PassGeometry;
var
  C: TBGRACanvas2D;
begin
  C:= ( Context as TWidgetContextCanvas2D ).Canvas;
  UpdateCanvasSettings;
  C.beginPath;
  C.text( Caption, Left, Top );
  C.closePath;
end;

procedure TGeometryTextCanvas2D.UpdateGeometry;
var
  Sz: TCanvas2dTextSize;
begin
  inherited UpdateGeometry;
  UpdateCanvasSettings;
  Sz:= ( Context as TWidgetContextCanvas2D ).Canvas.measureText( Caption );
  FWidth:= Sz.width;
  FHeight:= Sz.height;
end;

{ TGeometryRectCanvas2D }

procedure TGeometryRectCanvas2D.PassGeometry;
var
  C: TBGRACanvas2D;
begin
  C:= ( Context as TWidgetContextCanvas2D ).Canvas;
  C.beginPath;
  C.rect( Left, Top, Width, Height );
  C.closePath;
end;

{ TRendererTextFillColorBGRA }
{
procedure TRendererTextFillColorBGRA.SetupFont(ACanvas: TBGRACanvas2D);
begin
  ACanvas.fontName:= FontName;
  ACanvas.fontEmHeight:= Size;
  ACanvas.fontName:= FontName;
  ACanvas.fontStyle:= BGRAGraphics.TFontStyles( Style );
end;

procedure TRendererTextFillColorBGRA.RenderText(ACanvas: TObject;
  APosition: TVec2; ACaption: String);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupFont( C );
    C.fillText( ACaption, APosition.X, APosition.Y );
  end;
end;
}
{ TRendererStrokeColorBGRA }

procedure TRendererStrokeColorBGRA.SetupPenBrush(ACanvas: TBGRACanvas2D);
var
  C: TBGRACanvas2D absolute ACanvas;
  Cl: TIVec4;
begin
  Cl:= ivec4( Color * 255 );

  C.lineWidth:= Density;
  C.strokeStyle( BGRA( Cl.r, Cl.g, Cl.b, Cl.a ));
end;

{procedure TRendererStrokeColorBGRA.RenderPoints( ACanvas: TObject;
  Points: TVec2List );
var
  C: TBGRACanvas2D absolute ACanvas;
  i: Integer;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.moveTo( Points[ 0 ].X, Points[ 0 ].Y );
    for i:= 1 to Points.Count - 1 do
      C.lineTo( Points[ i ].X, Points[ i ].Y );
    C.closePath;
    C.stroke;
  end;
end;

procedure TRendererStrokeColorBGRA.RenderBezier(ACanvas: TObject;
  Points: TVec2List);
var
  C: TBGRACanvas2D absolute ACanvas;
  i: Integer;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.moveTo( Points[ 0 ].X, Points[ 0 ].Y );
    for i:= 1 to Points.Count - 1 do
      C.lineTo( Points[ i ].X, Points[ i ].Y );
    C.toSpline( Points[ i ] = Points[ 0 ], ssInside );
    C.closePath;
    C.stroke;
  end;
end;

procedure TRendererStrokeColorBGRA.RenderCircle(ACanvas: TObject;
  Position: TVec2; Radius: Float);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.circle( Position.X, Position.Y, Radius );
    C.closePath;
    C.stroke;
  end;
end;

procedure TRendererStrokeColorBGRA.RenderEllipse(ACanvas: TObject;
  TopLeft: TVec2; BottomRight: TVec2);
var
  C: TBGRACanvas2D absolute ACanvas;
  Ctr: TVec2;
  WH: TVec2;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    Ctr:= ( TopLeft + BottomRight ) / 2;
    WH:= ( BottomRight - TopLeft ) / 2;
    C.ellipse( Ctr.X, Ctr.Y, WH.X, WH.Y );
    C.closePath;
    C.stroke;
  end;
end;

procedure TRendererStrokeColorBGRA.RenderRectangle(ACanvas: TObject;
  TopLeft: TVec2; BottomRight: TVec2);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.rect( TopLeft.X, TopLeft.Y, BottomRight.X - TopLeft.X, BottomRight.Y - TopLeft.Y );
    C.closePath;
    C.stroke;
  end;
end;

procedure TRendererStrokeColorBGRA.RenderText(ACanvas: TObject;
  APosition: TVec2; ACaption: String);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.strokeText( ACaption, APosition.X, APosition.Y );
  end;
end;
}
procedure TRendererStrokeColorBGRA.RenderGeometry(AGeometry: TGeometry);
var
  C: TBGRACanvas2D;
begin
  C:= ( AGeometry.Context as TWidgetContextCanvas2D ).Canvas;
  SetupPenBrush( C );
  AGeometry.PassGeometry;
  C.stroke;
end;

{ TRendererFillColorBGRA }

procedure TRendererFillColorBGRA.SetupPenBrush(ACanvas: TBGRACanvas2D);
var
  C: TBGRACanvas2D absolute ACanvas;
  Cl: TIVec4;
begin
  Cl:= ivec4( Color * 255 );
  C.fillStyle( BGRA( Cl.r, Cl.g, Cl.b, Cl.a ));
//  C.font:=;
end;

{

procedure TRendererFillColorBGRA.RenderPoints(ACanvas: TObject;
  Points: TVec2List);
var
  C: TBGRACanvas2D absolute ACanvas;
  i: Integer;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.moveTo( Points[ 0 ].X, Points[ 0 ].Y );
    for i:= 1 to Points.Count - 1 do
      C.lineTo( Points[ i ].X, Points[ i ].Y );
    C.closePath;
    C.fill;
  end;
end;

procedure TRendererFillColorBGRA.RenderBezier(ACanvas: TObject;
  Points: TVec2List);
var
  C: TBGRACanvas2D absolute ACanvas;
  i: Integer;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.moveTo( Points[ 0 ].X, Points[ 0 ].Y );
    for i:= 1 to Points.Count - 1 do
      C.lineTo( Points[ i ].X, Points[ i ].Y );
    C.toSpline( Points[ i ] = Points[ 0 ], ssInside );
    C.closePath;
    C.fill;
  end;
end;

procedure TRendererFillColorBGRA.RenderCircle(ACanvas: TObject;
  Position: TVec2; Radius: Float);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.circle( Position.X, Position.Y, Radius );
    C.closePath;
    C.fill;
  end;
end;

procedure TRendererFillColorBGRA.RenderEllipse(ACanvas: TObject;
  TopLeft: TVec2; BottomRight: TVec2);
var
  C: TBGRACanvas2D absolute ACanvas;
  Ctr: TVec2;
  WH: TVec2;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    Ctr:= ( TopLeft + BottomRight ) / 2;
    WH:= ( BottomRight - TopLeft ) / 2;
    C.ellipse( Ctr.X, Ctr.Y, WH.X, WH.Y );
    C.closePath;
    C.fill;
  end;
end;

procedure TRendererFillColorBGRA.RenderRectangle(ACanvas: TObject;
  TopLeft: TVec2; BottomRight: TVec2);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.beginPath;
    C.rect( TopLeft.X, TopLeft.Y, BottomRight.X - TopLeft.X, BottomRight.Y - TopLeft.Y );
    C.closePath;
    C.fill;
  end;
end;

procedure TRendererFillColorBGRA.RenderText(ACanvas: TObject; APosition: TVec2;
  ACaption: String);
var
  C: TBGRACanvas2D absolute ACanvas;
begin
  if ( ACanvas is TBGRACanvas2D ) then begin
    SetupPenBrush( ACanvas );
    C.fillText( ACaption, APosition.X, APosition.Y );
  end;
end;
}
procedure TRendererFillColorBGRA.RenderGeometry(AGeometry: TGeometry);
var
  C: TBGRACanvas2D;
begin
  C:= ( AGeometry.Context as TWidgetContextCanvas2D ).Canvas;
  SetupPenBrush( C );
  AGeometry.PassGeometry;
  C.fill;
end;

end.

