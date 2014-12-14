unit Trig;

interface

  function TTan(a:real):real;
  function TSin(a:real):real;
  function TCos(a:real):real;
  function TCtg(a:real):real;
  function TArcSin(m:real):real;
  function TArcCos(m:real):real;
  function TArcTan(m:real):real;
  function TDetXAngle(x1,y1, x2,y2:real):real;
  function TDetAngle(x1,y1, x2,y2, x3,y3:real):real;

implementation

  function TTan(a:real):real;
  begin
    TTan:=sin(a*pi/180)/cos(a*pi/180);
  end;

  function TSin(a:real):real;
  begin
    TSin:=sin(a*pi/180);
  end;

  function TCos(a:real):real;
  begin
    TCos:=cos(a*pi/180);
  end;

  function TCtg(a:real):real;
  begin
    TCtg:=cos(a*pi/180)/sin(a*pi/180);
  end;

  function TArcSin(m:real):real;
  begin
    if abs(m)>1 then begin
      Writeln;
      Writeln('ERROR: Inadmissible importance ');
      Halt(1);
    end;
    if abs(m)<>1 then TArcSin:=ArcTan(m/sqrt(1-sqr(m)))*180/pi;
    if abs(m)=1 then TArcSin:=m*90;
  end;

  function TArcCos(m:real):real;
  begin
    if abs(m)>1 then begin
      Writeln;
      Writeln('ERROR: Inadmissible importance ');
      Halt(1);
    end;
    if m<>0 then TArcCos:=ArcTan(sqrt(1-sqr(m))/m)*180/pi;
    if m=0 then TArcCos:=90;
  end;

  function TArcTan(m:real):real;
  begin
    TArcTan:=ArcTan(m)*180/pi;
  end;

  function TDetXAngle(x1,y1, x2,y2:real):real;
  var
    a:real;
  begin
    if x1<>x2 then a:=ArcTan((y1-y2)/(x2-x1));
    if ((y1-y2)>0)and(x1=x2) then a:=pi/2;
    if ((y1-y2)<0)and(x1=x2) then a:=-pi/2;
    if (y1=y2)and((x2-x1)<0) then a:=pi;
    if ((y1-y2)>0)and((x2-x1)<0) then a:=a+pi;
    if ((y1-y2)<0)and((x2-x1)<0) then a:=a-pi;
    TDetXAngle:=a*180/pi;
  end;

  function TDetAngle(x1,y1, x2,y2, x3,y3:real):real;
  var
    a,a1,a2:real;
  begin
    a1:=TDetXAngle(x2,y2, x1,y1);
    a2:=TDetXAngle(x2,y2, x3,y3);
    if a1<0 then a1:=360+a1;
    if a2<0 then a2:=360+a2;
    a:=a1-a2;
    if abs(a)>180 then a:=360-a;
    TDetAngle:=abs(a);
  end;

end.