{...Трехмерная графика....}
{Автором этой программы является Дятченко Дмитрий Владимирович, СОФМШ, Самара}
uses crt,graph,mouse;
type
  pp=record
  x:real;
  y:real;
end;

type
  dir=record
  x:integer;
  y:integer;
  z:integer;
  f:real;
end;
type
  dtype=record
  sx,sy:integer;
  rx,ry,rz:real;
end;

var

xt,zt,yt: real;
Boofer:array[-240..240,-320..320] of real;
p,a,ay,hx,hy,u:real;
i,id,h,ut:integer;
s,s1,s2,s3,s4,s5,s6:string;
page:boolean;
c:char;
mx,my,mx0,my0:integer;
procedure MakeArrow(x1,y1,z1, x2,y2,z2:real; color:byte);
  var
    xs,ys,zs:real;
    l,xd,yd,zd:real;
    Sx1,Sy1,Sx2,Sy2:integer;
    ap,l1:real;
  begin
    xs:=-(xt-x1);
    ys:=-(yt-y1);
    zs:=-(zt-z1);

    Zd:=zs*cos(a)+xs*sin(a);
    Xd:=zs*sin(a)-xs*cos(a);
    Yd:=Zd*sin(ay)-ys*cos(ay);
    l:=Zd*cos(ay)+ys*sin(ay);
    l1:=l;

    Sx1:=-round(Xd/(l+h)*400)+320;
    Sy1:=round(Yd/(l+h)*400)+240;

    xs:=-(xt-x2);
    ys:=-(yt-y2);
    zs:=-(zt-z2);

    Zd:=zs*cos(a)+xs*sin(a);
    Xd:=zs*sin(a)-xs*cos(a);
    Yd:=Zd*sin(ay)-ys*cos(ay);
    l:=Zd*cos(ay)+ys*sin(ay);

    Sx2:=-round(Xd/(l+h)*400)+320;
    Sy2:=round(Yd/(l+h)*400)+240;

    setcolor(color);
    if (l1+h>50)and(l+h>50) then Line(sx1,sy1,sx2,sy2);

    if sy1<>sy2 then ap:=arctan((Sx2-Sx1)/(Sy1-Sy2))
    else begin
      if Sx2>Sx1 then ap:=4.71;
      if Sx1>Sx2 then ap:=1.57;
    end;

    if (l1+h>50)and(l+h>50) then begin
      if (Sy1-Sy2)>0 then begin
        line(Sx2,Sy2,round(sx2-10*sin(ap-0.35)),round(sy2+10*cos(ap-0.35)));
        line(Sx2,Sy2,round(sx2-10*sin(ap+0.35)),round(sy2+10*cos(ap+0.35)));
      end
      else begin
        line(Sx2,Sy2,round(sx2+10*sin(ap-0.35)),round(sy2-10*cos(ap-0.35)));
        line(Sx2,Sy2,round(sx2+10*sin(ap+0.35)),round(sy2-10*cos(ap+0.35)));
      end;
    end;
  end;

procedure MakeWrldStm;
begin
  MakeArrow(-100,0,0,100,0,0,red);
  MakeArrow(0,-100,0,0,100,0,green);
  MakeArrow(0,0,-100,0,0,100,yellow);
end;

{Вывод на экран точки с тремя координатами(x,y,z) и цветом Сolor   }
Procedure Put3DPixel(x,y,z:real; color:byte);
var
  xs,ys,zs:real;
  xd,yd,zd:real;
  Sx,Sy:integer;
  Xk,Yk,Zk:real;
begin
  xs:=x-xt;
  ys:=y-yt;
  zs:=z-zt;

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=-zs*sin(a)+xs*cos(a);
  Yd:=-Zd*sin(ay)+ys*cos(ay);
  Zk:=Zd*cos(ay)+ys*sin(ay);

  Xk:= Xd*cos(u) - Yd*sin(u);
  Yk:= Xd*sin(u) + Yd*cos(u);

  if Zk+h>10 then begin
    Sx:=round(Xk/(Zk+h)*400)+320;
    Sy:=-round(Yk/(Zk+h)*400)+240;

    PutPixel(Sx,Sy,Color);
  end;
end;

{....Создание в пространстве сплошного треугольника....}
Procedure MakeFillTriangle(x1,y1,z1, x2,y2,z2, x3,y3,z3:real; color:byte);
var
  i,id:integer;
  xs,ys,zs:real;
  m:array[1..3] of dtype;
  d:dtype;
  n:boolean;
  k1,k2,k3,k4:real;
  xn,xk:real;
  lk1,lk2,lk3,lk4:real;
  wn,wk,wd,wi:real;
  wk1,wk2,wk3:real;
  j1,j2,j3,j4:real;
  xrn,xrk:real;
begin

  xs:=-(xt-x1);
  ys:=-(yt-y1);
  zs:=-(zt-z1);

  m[1].rz:=zs*cos(a)+xs*sin(a);
  m[1].rx:=-zs*sin(a)+xs*cos(a);
  m[1].ry:=-m[1].rz*sin(ay)+ys*cos(ay);
  m[1].rz:=m[1].rz*cos(ay)+ys*sin(ay)+h;

  n:=true;
  if m[1].rz>10 then begin
    m[1].sx:=round(m[1].rx/m[1].rz*400);
    m[1].sy:=round(m[1].ry/m[1].rz*400);
  end else n:=false;

  xs:=-(xt-x2);
  ys:=-(yt-y2);
  zs:=-(zt-z2);

  m[2].rz:=zs*cos(a)+xs*sin(a);
  m[2].rx:=-zs*sin(a)+xs*cos(a);
  m[2].ry:=-m[2].rz*sin(ay)+ys*cos(ay);
  m[2].rz:=m[2].rz*cos(ay)+ys*sin(ay)+h;

  if m[2].rz>10 then begin
    m[2].sx:=round(m[2].rx/m[2].rz*400);
    m[2].sy:=round(m[2].ry/m[2].rz*400);
  end else n:=false;

  xs:=-(xt-x3);
  ys:=-(yt-y3);
  zs:=-(zt-z3);

  m[3].rz:=zs*cos(a)+xs*sin(a);
  m[3].rx:=-zs*sin(a)+xs*cos(a);
  m[3].ry:=-m[3].rz*sin(ay)+ys*cos(ay);
  m[3].rz:=m[3].rz*cos(ay)+ys*sin(ay)+h;

  if m[3].rz>10 then begin
    m[3].sx:=round(m[3].rx/m[3].rz*400);
    m[3].sy:=round(m[3].ry/m[3].rz*400);
  end else n:=false;

IF N THEN BEGIN

{///////////////////////////////////////////////////////////////////////////////////////////////}
  for i:=1 to 2 do
    for id:=1 to 2 do
      if m[id].sy>m[id+1].sy then begin
        d:=m[id];
        m[id]:=m[id+1];
        m[id+1]:=d;
      end;

  if m[1].sy=m[2].sy then
    if m[1].sx>m[2].sx then begin
      d:=m[1];
      m[1]:=m[2];
      m[2]:=d;
    end;
  if m[2].sy=m[3].sy then
    if m[2].sx<m[3].sx then begin
      d:=m[2];
      m[2]:=m[3];
      m[3]:=d;
    end;
{////////////////////////////////////////////////////////////////////////////////////////////////}

  if(m[3].sy<>m[1].sy) then begin
    k3:=(m[3].sx-m[1].sx)/(m[3].sy-m[1].sy);
    k4:=m[1].sx-m[1].sy*k3;
    if ((m[3].rz)<>(m[1].rz))then
      lk3:=(m[3].ry-m[1].ry)/(m[3].rz-m[1].rz);
    if (m[3].ry)<>0 then
      lk4:=0.0025/(m[3].ry-lk3*m[3].rz);
    lk3:=-lk4*400*lk3;
  end;

  if (m[1].sy<>m[2].sy) then begin
    k1:=(m[2].sx-m[1].sx)/(m[2].sy-m[1].sy);
    k2:=m[1].sx-m[1].sy*k1;
    if ((m[2].rz)<>(m[1].rz))then
      lk1:=(m[2].ry-m[1].ry)/(m[2].rz-m[1].rz);
    if (m[2].ry)<>0 then
      lk2:=0.0025/(m[2].ry-lk1*m[2].rz);
    lk1:=-lk2*400*lk1;

    for i:=m[1].sy to m[2].sy do begin
      if (i>-240)and(i<240) then begin
        xn:=(i*k1+k2);
        xk:=(i*k3+k4);
        wn:=i*lk2+lk1;
        if m[2].rz=m[1].rz then
          wn:=m[2].rz;
        wk:=i*lk4+lk3;
        if m[1].rz=m[3].rz then
          wk:=m[3].rz;
        if xn>xk then begin
          xn:=xn-xk;
          xk:=xk+xn;
          xn:=xk-xn;
          wd:=wn;
          wn:=wk;
          wk:=wd;
        end;
        if xn<>xk then begin
          j3:=1/(xn-xk);
          j1:=(wn-wk)*j3;
          j2:=(xn*wk-xk*wn)*j3;
        end;
        for id:=round(xn) to round(xk) do
          if (id>-320)and(id<320) then begin
            wi:=(id*j1+j2);
            if xn=xk then wi:=wk;
            if (boofer[i][id]=0)or(boofer[i][id]<wi)then begin
              putpixel(id+320,-i+240,color);
              boofer[i][id]:=wi;
            end;
          end;
      end;
    end;
  end;

  if (m[2].sy<>m[3].sy) then begin
    k1:=(m[3].sx-m[2].sx)/(m[3].sy-m[2].sy);
    k2:=m[2].sx-m[2].sy*k1;
    if ((m[2].rz)<>(m[3].rz)) then
      lk1:=(m[3].ry-m[2].ry)/(m[3].rz-m[2].rz);
    if (m[3].ry)<>0 then
      lk2:=0.0025/(m[3].ry-lk1*m[3].rz);
    lk1:=-lk2*400*lk1;

    for i:=m[2].sy to m[3].sy do begin
      if (i>-240)and(i<240) then begin
        xn:=(i*k1+k2);
        xk:=(i*k3+k4);
        wn:=i*lk2+lk1;
        if m[2].rz=m[3].rz then
          wn:=m[2].rz;
        wk:=i*lk4+lk3;
        if m[1].rz=m[3].rz then
          wk:=m[3].rz;
        if xn>xk then begin
          xn:=xn-xk;
          xk:=xk+xn;
          xn:=xk-xn;
          wd:=wn;
          wn:=wk;
          wk:=wd;
        end;
        if xn<>xk then begin
          j3:=1/(xn-xk);
          j1:=(wn-wk)*j3;
          j2:=(xn*wk-xk*wn)*j3;
        end;
        for id:=round(xn) to round(xk) do
          if (id>-320)and(id<320) then begin
            wi:=(id*j1+j2);
            if xn=xk then wi:=wk;
            if (boofer[i][id]=0)or(boofer[i][id]<wi)then begin
              putpixel(id+320,-i+240,color);
              boofer[i][id]:=wi;
            end;
          end;
      end;
    end;
  end;

END;

end;

procedure MakeNorTriangle(x1,y1,z1, x2,y2,z2, x3,y3,z3:real);
var
xs,ys,zs:real;
l:array[1..3] of real;
Xd,Yd,Zd:real;
sx1,sy1,sx2,sy2,sx3,sy3:integer;

begin

  xs:=-(xt-x1);
  ys:=-(yt-y1);
  zs:=-(zt-z1);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l[1]:=Zd*cos(ay)+ys*sin(ay);

  sx1:=-round(Xd/(l[1]+h)*400)+320;
  sy1:=round(Yd/(l[1]+h)*400)+240;

  xs:=-(xt-x2);
  ys:=-(yt-y2);
  zs:=-(zt-z2);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l[2]:=Zd*cos(ay)+ys*sin(ay);

  sx2:=-round(Xd/(l[2]+h)*400)+320;
  sy2:=round(Yd/(l[2]+h)*400)+240;

  xs:=-(xt-x3);
  ys:=-(yt-y3);
  zs:=-(zt-z3);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l[3]:=Zd*cos(ay)+ys*sin(ay);

  sx3:=-round(Xd/(l[3]+h)*400)+320;
  sy3:=round(Yd/(l[3]+h)*400)+240;

  setcolor(green);

  line(sx1,sy1,sx2,sy2);
  line(sx1,sy1,sx3,sy3);
  line(sx3,sy3,sx2,sy2);

end;

{...Создание в пространстве сплошного четырехугольника....}
procedure MakeFillPlane(x,y,z:real; a,b:real; rx,ry:real; cl:byte);
begin                       {Длины сторон^^}  {^^Углы поворота}
  MakeFillTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x+a*cos(rx*p), y, z+a*sin(rx*p), cl);
  MakeFillTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x, y+b*cos(ry*p), z+b*sin(ry*p), cl);
end;

{....Создание в пространстве сплошного прямоугольного восьмиугольника....}
procedure MakeFillNonagon(x,y,z:real; a,b,h:real);
begin
  MakeFillPlane(x,y,z, a, b, 0,0, blue);
  MakeFillPlane(x,y,z, h, b, 90,0,red);
  MakeFillPlane(x,y,z+h, a, b, 0,0, yellow);
  MakeFillPlane(x+a,y,z, h, b, 90,0,green);
  MakeFillPlane(x,y+b,z, a, h, 0, 90, brown);
  MakeFillPlane(x,y,z, a, h, 0, 90, black);
end;

{....Создание в пространстве сплошной правильной пирамиды.... }
procedure MakeFillPiramide(x,y,z,h:real);
begin
  MakeFillPlane(x,y,z,200,200,0,90,79);
  MakeFillTriangle(x,y,z,  x+100,y+150,z+100,  x+200,y,z,567);
  MakeFillTriangle(x,y,z,  x+100,y+150,z+100,  x,y,z+200,756);
  MakeFillTriangle(x,y,z+200,  x+100,y+150,z+100,  x+200,y,z+200, 389);
  MakeFillTriangle(x+200,y,z, x+100,y+150,z+100, x+200,y,z+200,123);
end;

procedure MakeNorPiramide(x,y,z,h:real);
begin
  MakeFillplane(x,y,z,200,200,0,90,lightgray);
  MakeNorTriangle(x,y,z,  x+100,y+150,z+100,  x+200,y,z);
  MakeNOrTriangle(x,y,z,  x+100,y+150,z+100,  x,y,z+200);
  MakeNorTriangle(x,y,z+200,  x+100,y+150,z+100,  x+200,y,z+200);
  MakeNOrTriangle(x+200,y,z, x+100,y+150,z+100, x+200,y,z+200);
end;

{Рисование мушки}
procedure DrawFly;
begin
    setcolor(White);
    line(312,241,317,241);
    line(323,241,328,241);
    line(320,233,320,238);
    line(320,244,320,249);
end;

{...Посылка мыши на центр...}
procedure MoveMouseCenter;
begin
  if (mx=640)or(mx=0)or(my=0)or(my=480) then begin
    SetMousePos(GetMaxX div 2,240);
    mx0:=GetMouseX;
    my0:=getmousey;
  end;
end;

{....Чтение данных с клавиатуры.....}
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
               h:=h-30;
             end;
        'e': begin
               h:=h+30;
             end;
        'z': begin
               xt:=65;
               zt:=67;
               a:=279*p;
               ay:=-68*p;
             end;
        'x': begin
               xt:=235;
               zt:=50;
               ay:=-47*p;
               a:=291*p;
             end;
        'r': yt:=yt+5;
        'f': yt:=yt-5;
      end;
    end;
end;

{...Обнуление Z-буфера и смена графических страниц...}
procedure Draw;
begin
  str(xt:5:3,s1);
  s1:='X t.p.='+s1;
  str(yt:5:3,s2);
  s2:='Y t.p.='+s2;
  str(zt:5:3,s3);
  s3:='Z t.p.='+s3;
  str(a*57.3:3:3,s4);
  str(ay*57.3:3:3,s5);

  outtextxy(10,10,s1);
  outtextxy(10,23,s2);
  outtextxy(10,36,s3);
  outtextxy(10,49,s4);
  outtextxy(10,62,s5);

  if Page then begin
    SetActivePage(0);
    SetVisualPage(1,true);
    Page:=false;
  end else begin
    SetActivePage(1);
    SetVisualPage(0,true);
    Page:=true;
  end;
  ClearPage;

  mx0:=mx;
  my0:=my;
  for i:=-240 to 240 do
    for id:=-320 to 320 do
      if boofer[i][id]<>0 then boofer[i][id]:=0;

end;

{...Чтение данных с мыши...}
Procedure ReadMouse;
begin
  mx:=GetmouseX;
  my:=GetmouseY;

  hx:=(mx-mx0)/10;
  hy:=-(my-my0)/10;
  ay:=ay+hy*p;
  a:=a+hx*p;
  if (a>2*pi)or(a<-2*pi) then a:=0;
  if (ay>2*pi)or(ay<-2*pi) then ay:=0;
end;

{...Инициализация мыши...}
procedure InitializeMouse;
begin
  InitMouse;
  HideMouse;
  SetMouseRange(0, 0, 640, 480);
  SetMousePos(GetMaxX div 2, GetMaxY div 2);

  mx0:=GetmouseX;
  my0:=GetmouseY;
end;

{....Инициализация граф. режима....}
procedure InitializeGraph;
begin
  SetSVGAMode(640, 480, 8 ,LfbOrBanked);
  setbkcolor(black);
end;

begin

  InitializeGraph;

  p:=pi/180;

  InitializeMouse;

  h:=800;
  xt:=235;
  zt:=50;
  ay:=-47*p;
  a:=291*p;

  repeat

    ReadMouse;

    inc(ut,2);
    if ut=360 then ut:=0;

    ReadKeyDown;

    makefilltriangle(-100,-100,110,300,-100,120,100,300,130,green);
    makefilltriangle(-100,round(130+100*cos(ut*pi/180)),round(340+100*sin(ut*pi/180)),350,round(-20+100*cos(ut*pi/180)),
      round(360+100*sin(ut*pi/180)),150,round(150+100*cos(ut*pi/180)),round(-100+100*sin(ut*pi/180)),lightgray);

    Draw;

    MoveMouseCenter;

  until c=#27;

  restorecrtmode;
end.






