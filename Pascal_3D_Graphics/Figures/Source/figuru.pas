uses crt,graph,mouse;

var

xt,zt,yt: real;

x,y,z: array[1..400,1..8] of integer;

Boofer:array[1..480,1..640] of real;

Texture:array[0..100,0..100] of byte;

p,a,ay,hx,hy,j,o:real;
zk,yk,xk:integer;
i,id,k,d,x1,y1,z1,m,h:integer;
s,s1,s2,s3,s4,s5,s6:string;
page:boolean;
gd,gm:integer;
c:char;


mx,my,mx0,my0:integer;

{-----------------ПРОЦЕДУРЫ------------------}

{--------------------------------------------}
{------------Рисование плоскости-------------}
{--------------------------------------------}
Procedure Draw3DPixel(x,y,z:real; color:byte);
var
  xs,ys,zs:real;
  l,xd,yd,zd:real;
  Sx,Sy:integer;
begin
  xs:=-(xt-x);
  ys:=-(yt-y);
  zs:=-(zt-z);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  l:=Zd*cos(ay)+ys*sin(ay);

  Sx:=-round(Xd/(l+h)*400)+320;
  Sy:=round(Yd/(l+h)*400)+240;

  PutPixel(Sx,Sy,Color);
end;

procedure DrawHorLine(sy,x1,x2:integer;ln,lk:real;color:byte);
var
  d:real;
  l:real;
  i,d1:integer;
begin
  if (sy>0)and(sy<480) then begin

    if x1<x2 then begin
      d:=((ln-lk)/(x2-x1));
      for i:=x1 to x2 do
        if (i>0)and(i<640) then begin
          l:=ln-(d*(i-x1));
          if (boofer[sy][i]>l)or(boofer[sy][i]=0) then begin
            putpixel(i,sy,color);
            boofer[sy][i]:=l;
          end;
        end;
    end;

    if x1>x2 then begin
      d:=((ln-lk)/(x2-x1));
      for i:=x2 to x1 do
        if (i>0)and(i<640) then begin
          l:=lk-(d*(i-x2));
          if (boofer[sy][i]>l)or(boofer[sy][i]=0) then begin
            putpixel(i,sy,color);
            boofer[sy][i]:=l;
          end;
        end;
    end;

  end;

end;

procedure DrawTriangle(x1,y1,x2,y2,x3,y3:integer; l1,l2,l3:real; color:byte);
var
  max,min,ser:pointtype;
  i,id:integer;
  lsr,lmn,lmx,ld,ln,lk:real;
  rt:array[1..3] of pointtype;
  Dn,Dlk,Dln1,Dln2:integer;
  Dn1,Dn2,Dk:real;
  imr,isr:integer;
begin

  rt[1].x:=x1;   rt[1].y:=y1;
  rt[2].x:=x2;   rt[2].y:=y2;
  rt[3].x:=x3;   rt[3].y:=y3;

  min.y:=rt[1].y;
  min.x:=rt[1].x;
  lmn:=l1;
  if rt[2].y<min.y then begin
    min.y:=rt[2].y;
    min.x:=rt[2].x;
    lmn:=l2;
  end;
  if rt[3].y<min.y then begin
    min.y:=rt[3].y;
    min.x:=rt[3].x;
    lmn:=l3;
  end;

  max.y:=rt[1].y;
  max.x:=rt[1].x;
  lmx:=l1;
  if rt[2].y>max.y then begin
    max.y:=rt[2].y;
    max.x:=rt[2].x;
    lmx:=l2;
  end;
  if rt[3].y>max.y then begin
    max.y:=rt[3].y;
    max.x:=rt[3].x;
    lmx:=l3;
  end;

  ser.x:=rt[1].x;
  ser.y:=rt[1].y;
  lsr:=l1;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=rt[2].x;
    ser.y:=rt[2].y;
    lsr:=l2;
  end;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=rt[3].x;
    ser.y:=rt[3].y;
    lsr:=l3;
  end;

  {+++++++++++++++++++++++++Скоростные дополнения++++++++++++++++++++++}
  if max.y<>min.y then Dk:=((lmn-lmx)/(max.y-min.y));
  if min.y<>max.y then Dlk:=round((min.x-max.x)/(max.y-min.y)*1000);
  if (ser.y<>max.y) then begin
    Dn1:=((lsr-lmx)/(max.y-ser.y));
    Dln1:=round((max.x-ser.x)/(ser.y-max.y)*1000);
  end;
  if (ser.y<>min.y) then begin
    Dn2:=((lmn-lsr)/(ser.y-min.y));
    Dln2:=round((ser.x-min.x)/(min.y-ser.y)*1000);
  end;
  {+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  for i:=min.y to max.y do begin

    imr:=(i-min.y);
    isr:=(i-ser.y);

    if i>ser.y then begin

      if max.y<>ser.y then ln:=lsr-Dn1*isr
        else ln:=lsr;
      if max.y<>min.y then lk:=lmn-Dk*imr
        else lk:=lmn;

      if min.y<>max.y then
        DrawHorLine(i,round(ser.x-Dln1/1000*isr),
          round(min.x-Dlk/1000*imr),ln,lk,color);

    end

    else begin

      if min.y<>ser.y then ln:=lmn-Dn2*imr
          else ln:=lmn;
      if max.y<>min.y then lk:=lmn-Dk*imr
          else lk:=lmn;

      if (ser.y<>min.y)and(max.y<>min.y) then
        DrawHorLine(i,round(min.x-Dln2/1000*imr),
          round(min.x-Dlk/1000*imr),ln,lk,color)
    end;

  end;

end;

procedure MakeTriangle(x1,y1,z1, x2,y2,z2, x3,y3,z3:real; color:byte);
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

  if (l[1]+h>50) and (l[2]+h>50) and (l[3]+h>50) then
    DrawTriangle(sx1,sy1,sx2,sy2,sx3,sy3,(l[1]+h),(l[2]+h),(l[3]+h),color);
end;


{--------------------------------------------}
{--------------Рисование мушки---------------}
{--------------------------------------------}
procedure MakePlane(x,y,z:real; a,b:real; rx,ry:real; cl:byte);
begin
  MakeTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x+a*cos(rx*p), y, z+a*sin(rx*p), cl);
  MakeTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x, y+b*cos(ry*p), z+b*sin(ry*p), cl);
end;

procedure MakeButagon(x,y,z:real; a,b,h:real);
begin
  MakePlane(x,y,z, a, b, 0,0, blue);
  MakePlane(x,y,z, h, b, 90,0,red);
  MakePlane(x,y,z+h, a, b, 0,0, yellow);
  MakePlane(x+a,y,z, h, b, 90,0,green);
  MakePlane(x,y+b,z, a, h, 0, 90, brown);
  MakePlane(x,y,z, a, h, 0, 90, black);
end;

procedure MakePiramide(x,y,z,h:real);
begin
  MakePlane(x,y,z,100,100,0,90,black);
  MakeTriangle(x,y,z,  x+50,y+150,z+50,  x+100,y,z,yellow);
  MakeTriangle(x,y,z,  x+50,y+150,z+50,  x,y,z+100,blue);
  MakeTriangle(x,y,z+100,  x+50,y+150,z+50,  x+100,y,z+100, white);
  MakeTriangle(x+100,y,z, x+50,y+150,z+50, x+100,y,z+100,red);

end;

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
               h:=h-30;
             end;
        'e': begin
               h:=h+30;
             end;
      end;
    end;
end;

procedure Draw;
begin
  outtextxy(10,10,s1);
  outtextxy(10,23,s2);
  outtextxy(10,36,s3);
  outtextxy(10,49,s4);
  outtextxy(10,62,s5);
  outtextxy(10,75,s6);

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
  for i:=1 to 480 do
    for id:=1 to 640 do
      if boofer[i][id]<>0 then boofer[i][id]:=0;
end;

Procedure ReadMouse;
begin
  mx:=GetmouseX;
  my:=GetmouseY;

  hx:=(mx-mx0)/10;
  hy:=(my-my0)/10;
  ay:=ay-hy*p;
  a:=a+hx*p;
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
  setbkcolor(black);
end;

begin

  InitializeGraph;

  SetColor(LightGray);
  Bar(100,100,200,200);
  setColor(Red);
  Circle(150,150,10);
  SetColor(blue);
  Circle(150,150,20);
  Circle(150,150,30);
  SetColor(green);
  Circle(150,150,40);
  Circle(150,150,50);
  setColor(red);
  OutTextXY(143,143,'10');

  For i:=0 to 100 do for id:=0 to 100 do texTure[i][id]:=getpixel(i+100,id+100);

  p:=pi/180;
  yt:=0;
  xt:=0;
  zt:=0;
 { a:=126*pi/180;
  ay:=-26*pi/180;
  }
  InitializeMouse;

  h:=400;

  repeat

    ReadMouse;

    ReadKeyDown;

    str(xt:3:3,s1);
    str(yt:3:3,s2);
    str(zt:3:3,s3);
    str(a*180/pi:3:3,s4);
    str(ay*180/pi:3:3,s5);

  {  MakeTriangle(0,0,100,100,0,100,100,100,100,white);
   }
    MakeButagon(200,0,-110,100,100,100);
    MakeButagon(300,0,300,100,200,50);
    MakeButagon(-200,-100,200,100,100,100);
    MakePiramide(0,40,500,10);

    MakePlane(0,0,-200,5,400,0,90,yellow);
    MakePlane(-200,0,0,400,5,0,90,green);
    MakePlane(0,-200,0,5,400,0,0,white);
 
    Draw;

    MoveMouseCenter;

  until c=#27;

  restorecrtmode;
end.