
uses crt,graph,mouse;

var

xt,zt,yt: real;

x,y,z: array[1..400,1..8] of integer;

Boofer:array[1..480,1..640] of real;

p,a,ay,h,hy,j,o:real;
zk,yk,xk:integer;
i,id,k,d,x1,y1,z1,m:integer;
s,s1,s2,s3,s4,s5,s6:string;
pg:word;
gd,gm:integer;
c:char;


mx,my,mx0,my0:integer;

{-----------------ПРОЦЕДУРЫ------------------}

{--------------------------------------------}
{------------Рисование плоскости-------------}
{--------------------------------------------}
procedure DrawHorLine(sy,x1,x2:integer;l:real;color:byte);
var
  i:integer;
begin
  if (sy>0)and(sy<480) then begin
    if x1<x2 then for i:=x1 to x2 do
      if (i>0)and(i<640) then
        if (boofer[sy][i]>=l)or(boofer[sy][i]=0) then begin
          putpixel(i,sy,color);
          boofer[sy][i]:=l;
        end;
    if x1>x2 then for i:=x2 to x1 do
      if (i>0)and(i<640) then
        if (boofer[sy][i]>=l)or(boofer[sy][i]=0) then begin
          putpixel(i,sy,color);
          boofer[sy][i]:=l;
        end;
  end;
end;

procedure DrawTriangle(x1,y1,x2,y2,x3,y3:integer; l:real; color:byte);
var
  max,min,ser:pointtype;
  i,id:integer;
  rt:array[1..3] of pointtype;
begin

  rt[1].x:=x1;   rt[1].y:=y1;
  rt[2].x:=x2;   rt[2].y:=y2;
  rt[3].x:=x3;   rt[3].y:=y3;

  min.y:=rt[1].y;
  min.x:=rt[1].x;
  if rt[2].y<min.y then begin
    min.y:=rt[2].y;
    min.x:=rt[2].x;
  end;
  if rt[3].y<min.y then begin
    min.y:=rt[3].y;
    min.x:=rt[3].x;
  end;

  max.y:=rt[1].y;
  max.x:=rt[1].x;
  if rt[2].y>max.y then begin
    max.y:=rt[2].y;
    max.x:=rt[2].x;
  end;
  if rt[3].y>max.y then begin
    max.y:=rt[3].y;
    max.x:=rt[3].x;
  end;

  ser.x:=rt[1].x;
  ser.y:=rt[1].y;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=rt[2].x;
    ser.y:=rt[2].y;
  end;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=rt[3].x;
    ser.y:=rt[3].y;
  end;

  for i:=min.y to max.y do begin
    if i>ser.y then
      DrawHorLine(i,round(ser.x+((max.x-ser.x)/(max.y-ser.y))*(i-ser.y)),
        round(min.x+((max.x-min.x)/(max.y-min.y))*(i-min.y)),l,color);
    if i<ser.y then
      DrawHorLine(i,round(min.x+((min.x-ser.x)/(min.y-ser.y))*(i-min.y)),
        round(min.x+((max.x-min.x)/(max.y-min.y))*(i-min.y)),l,color);
  {  if (i=ser.y)and(ser.y=min.x) then
      DrawHorLine(i,ser.x,min.x,l,color);
   } if (i=ser.y)and(ser.y<>min.x) then
      DrawHorLine(i,ser.x,round(min.x+((max.x-min.x)/(max.y-min.y))*(i-min.y)),l,color);
  end;

end;

procedure MakeTriangle(x1,y1,z1, x2,y2,z2, x3,y3,z3:real; color:byte);
var
xs,ys,zs:real;
l:array[1..3] of real;
Xd,Yd,Zd:real;
sx1,sy1,sx2,sy2,sx3,sy3:integer;
lsr:real;
begin
  xs:=-(xt-x1);
  ys:=-(yt-y1);
  zs:=-(zt-z1);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l[1]:=Zd*cos(ay)+ys*sin(ay);

  sx1:=-round(Xd/(l[1]+400)*400)+320;
  sy1:=round(Yd/(l[1]+400)*400)+240;

  xs:=-(xt-x2);
  ys:=-(yt-y2);
  zs:=-(zt-z2);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l[2]:=Zd*cos(ay)+ys*sin(ay);

  sx2:=-round(Xd/(l[2]+400)*400)+320;
  sy2:=round(Yd/(l[2]+400)*400)+240;

  xs:=-(xt-x3);
  ys:=-(yt-y3);
  zs:=-(zt-z3);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l[3]:=Zd*cos(ay)+ys*sin(ay);

  sx3:=-round(Xd/(l[3]+400)*400)+320;
  sy3:=round(Yd/(l[3]+400)*400)+240;

  lsr:=(l[1]+l[2]+l[3])/3;

  DrawTriangle(sx1,sy1,sx2,sy2,sx3,sy3,lsr,color);
end;

procedure DrawPlane(xc,yc,zc,Sa,Sb:real; RotXZ,RotYZ:real; Color:Byte);
var
x,y,z:array[1..4] of real;
pl:array[1..4] of pointtype;
Xd,Yd,Zd:real;
xs,zs,ys:real;
xn,yn,yk,xk:integer;
l:array[1..5] of real;
i,j:integer;
aux,aux2:integer;
begin
  x[1]:=xc-(Sb/2)*cos(RotXZ*pi/180);
  y[1]:=yc-(Sa/2)*cos(RotYZ*pi/180);
  x[2]:=xc+(Sb/2)*cos(RotXZ*pi/180);
  y[2]:=yc-(Sa/2)*cos(RotYZ*pi/180);
  x[3]:=xc+(Sb/2)*cos(RotXZ*pi/180);
  y[3]:=yc+(Sa/2)*cos(RotYZ*pi/180);
  x[4]:=xc-(Sb/2)*cos(RotXZ*pi/180);
  y[4]:=yc+(Sa/2)*cos(RotYZ*pi/180);

  if (round(RotXZ)<>90)or(round(RotXZ)<>270)or(round(RotXZ)<>-90)
  or(round(RotXZ)<>-270) then for i:=1 to 4 do
  z[i]:=zc-((x[i]-xc)*sin(RotXZ*pi/180)/cos(RotXZ*pi/180));

  if (round(RotYZ)<>90)or(round(RotYZ)<>270)or(round(RotYZ)<>-90)
  or(round(RotYZ)<>-270) then for i:=1 to 4 do
  z[i]:=zc-((y[i]-yc)*sin(RotYZ*pi/180)/cos(RotYZ*pi/180));

  if (round(RotXZ)=90)or(round(RotXZ)=270)or(round(RotXZ)=-90)or(round(RotXZ)=-270) then begin
    z[1]:=zc-(Sb/2);
    z[2]:=zc+(Sb/2);
    z[3]:=zc+(Sb/2);
    z[4]:=zc-(Sb/2);
  end;

  {if (round(RotYZ)=90)or(round(RotYZ)=270)or(round(RotYZ)=-90)or(round(RotYZ)=-270) then begin
    z[1]:=zc-(Sb/2);
    z[2]:=zc+(Sb/2);
    z[3]:=zc+(Sb/2);
    z[4]:=zc-(Sb/2);
  end;}

  h:=400;

  setfillstyle(1,color);

  for i:=1 to 4 do begin
    xs:=-(xt-x[i]);
    ys:=-(yt-y[i]);
    zs:=-(zt-z[i]);

    Zd:=zs*cos(a)+xs*sin(a);
    Xd:=zs*sin(a)-xs*cos(a);
    Yd:=Zd*sin(ay)-ys*cos(ay);
    l[i]:=Zd*cos(ay)+ys*sin(ay);

    if l[i]<>0 then begin
      pl[i].x:=-round(h*Xd/l[i])+320;
      pl[i].y:=round(h*Yd/l[i])+240;
    end;

    if ((pl[i].x<-500)or(pl[i].x>1000))
      or((pl[i].y<-500)or(pl[i].y>1000))then break;

    if (i=4)and(l[i]>100) then FillPoly(4,pl);

  end;

end;

Procedure DrawCube(Xc,Yc,Zc,A,V,H:Real; Color:Byte);
var
lm:array[1..4] of real;
i:integer;
id:integer;
t:array[1..4] of boolean;
n:array[1..4] of integer;
f:integer;
begin
  lm[1]:=sqrt(sqr(xt-xc)+sqr(yt-yc)+sqr(zt-(zc-V/2)));
  lm[2]:=sqrt(sqr(xt-xc)+sqr(yt-yc)+sqr(zt-(zc+V/2)));
  lm[3]:=sqrt(sqr(xt-(xc+a/2))+sqr(yt-yc)+sqr(zt-zc));
  lm[4]:=sqrt(sqr(xt-(xc-a/2))+sqr(yt-yc)+sqr(zt-zc));
  for i:=1 to 4 do t[i]:=false;

  f:=0;
  for i:=1 to 4 do begin
    for id:=1 to 4 do begin
      if (lm[i]<lm[id])or(lm[i]=lm[id]) then inc(f,1);
    end;
    n[f]:=i;
    f:=0;
  end;

  for i:=1 to 4 do begin
    t[n[i]]:=true;
    if t[1]=true then DrawPlane(Xc,Yc,Zc-V/2,H,A,0,0,red);
    if t[2]=true then DrawPlane(Xc,Yc,Zc+V/2,H,A,0,0,blue);
    if t[3]=true then DrawPlane(Xc+A/2,Yc,Zc,H,V,90,0,green);
    if t[4]=true then DrawPlane(Xc-A/2,Yc,Zc,H,V,90,0,yellow);
    t[n[i]]:=false;
  end;

end;

{--------------------------------------------}
{--------------Рисование мушки---------------}
{--------------------------------------------}
procedure DrawFly;
begin
    setcolor(Black);
    line(312,241,317,241);
    line(323,241,328,241);
    line(320,233,320,238);
    line(320,244,320,249);
end;

{--------------------------------------------}
{-----------Перемещение мыши на центр--------}
{--------------------------------------------}
procedure MoveMouseCenter;
begin
  if (mx=640)or(mx=0)or(my=0)or(my=480) then begin
    SetMousePos(GetMaxX div 2,240);
    mx0:=GetMouseX;
    my0:=getmousey;
  end;
end;

Procedure ReadKeyDown;
begin
   if keypressed then begin
     c:=readkey;
     case c of
        'w': begin
               zt:=zt+5*cos(a);
               xt:=xt+5*sin(a);
             end;
        's': begin
               zt:=zt-5*cos(a);
               xt:=xt-5*sin(a);
             end;
        'd': begin
               xt:=xt+5*cos(a);
               zt:=zt-5*sin(a);
             end;
        'a': begin
               xt:=xt-5*cos(a);
               zt:=zt+5*sin(a);
             end;
        'q': begin
               yt:=yt-3;
             end;
        'e': begin
               yt:=yt+3;
             end;
      end;
    end;
end;

procedure Draw;
begin
  setactivepage(pg);
  pg:=1-pg;
  setvisualpage(pg,true);
  clearpage;
  mx0:=mx;
  my0:=my;
  for i:=1 to 480 do
    for id:=1 to 640 do
      if boofer[i][id]<>0 then boofer[i][id]:=0;
end;

Procedure ReadMouse;
begin
  mx:=GetmouseX;
  my:=GetmouseY;

  h:=(mx-mx0)/10;
  hy:=(my-my0)/10;
  ay:=ay-hy*p;
  a:=a+h*p;
  if (a>2*pi)or(a<-2*pi) then a:=0;
  if (ay>2*pi)or(ay<-2*pi) then ay:=0;
end;

procedure InitializeMouse;
begin
  InitMouse;
  HideMouse;
  SetMouseRange(0, 0, 640, 480);
  SetMousePos(GetMaxX div 2, GetMaxY div 2);

  mx0:=GetmouseX;
  my0:=GetmouseY;
end;

procedure InitializeGraph;
begin
  SetSVGAMode(640, 480, 8 ,LfbOrBanked);
  setbkcolor(lightgray);
end;

begin

  InitializeGraph;

  p:=pi/180;
  yt:=100;
  xt:=10;
  zt:=-300;

  InitializeMouse;

  repeat

    ReadMouse;

    ReadKeyDown;

    SetColor(red);
    SetFillStyle(1,red);
    MakeTriangle(0,0,0,100,100,100,100,0,0,red);
    MakeTriangle(0,0,-10,100,100,90,100,0,-10,blue);

    outtextxy(10,10,s1);
    outtextxy(10,23,s2);
    outtextxy(10,36,s3);
    outtextxy(10,49,s4);
    outtextxy(10,62,s5);

    Draw;

    MoveMouseCenter;

 until c=#27;

 restorecrtmode;
end.
