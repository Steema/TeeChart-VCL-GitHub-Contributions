unit Themes;

interface

uses Vcl.Graphics;

type
  TTheme = record
    Background: TColor;
    Text: TColor;
    Meta: TColor;
    Grades: array [0 .. 4] of TColor;
  end;

const
  StandardTheme: TTheme = (
    Background: $FFFFFF;
    Text: $000000;
    Meta: $666666;
    Grades: ($F0EDEB, $A8E99B, $63C440, $4EA130, $396E21);
  );

  GithubDarkTheme: TTheme = (
    Background: $101217;
    Text: $FFFFFF;
    Meta: $DDDDDD;
    Grades: ($221B16, $203800, $2D6000, $3D9810, $45D527);
  );

implementation

end.
