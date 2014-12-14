uses Crt,Graph,Mouse,Trig;
type
 ZBoof = record
   x:real;
   y:real;
   z:real;
   Sa:real;
   Sb:real;
   RotXZ:real;
   RotYZ:real;
  end;

  Zboof2 = record
    d:real;
  end;

var
 Plane: array[1..10000] of ^Zboof;

 xt,zt,yt: real;

 MaxN:integer;
x,y,z: array[1..400,1..8] of integer;
l,l0,ly,l0y: real;

j:integer;
xf,yf,zf:integer;
xo,zo,yo,ao,r:real;
p,a,ay,h,hy,o:real;
zk,yk,xk:integer;
i,k,d,x1,y1,z1,m:integer;
s,s1,s2,s3,s4,s5,s6:string;
pg:word;
gd,gm:integer;
c:char;


mx,my,mx0,my0:integer;

{-----------------ПРОЦЕДУРЫ------------------}

{--------------------------------------------}
{----------Добавление треугольника-----------}
{--------------------------------------------}
procedure DrawPixel(x1,y1,z1:real; color:byte);
var

pl:array[1..4] of pointtype;
l,m,k,k1:real;
f:real;

begin
   f:=90+TDetXAngle(xt,zt,x1,z1);

   k:=sqrt(sqr(xt-x1)+sqr(zt-z1))*TCos(-a+f);
   k1:=sqrt(sqr(xt-x1)+sqr(zt-z1))*TSin(-a+f);
   m:=k*TSin(ay)/TCos(ay)-(yt-y1);
   l:=k/TCos(ay)-m*TSin(ay);
   pl[1].y:=round(-400*m*TCos(ay)/l)+240;
   pl[1].x:=round(400*k1/l)+320;

   PutPixel(pl[1].x,pl[1].y,color);

end;

procedure DrawTriangle(x1,y1,z1,x2,y2,z2,x3,y3,z3:real; color:byte; sokrat:boolean);
var

pl:array[1..4] of pointtype;
l,m,k,k1:real;
f:real;

begin
   f:=90+TDetXAngle(xt,zt,x1,z1);

   k:=sqrt(sqr(xt-x1)+sqr(zt-z1))*TCos(-a+f);
   k1:=sqrt(sqr(xt-x1)+sqr(zt-z1))*TSin(-a+f);
   m:=k*TSin(ay)/TCos(ay)-(yt-y1);
   l:=k/TCos(ay)-m*TSin(ay);
   pl[1].y:=round(-400*m*TCos(ay)/l)+240;
   pl[1].x:=round(400*k1/l)+320;

   f:=90+TDetXAngle(xt,zt,x2,z2);

   k:=sqrt(sqr(xt-x2)+sqr(zt-z2))*TCos(-a+f);
   k1:=sqrt(sqr(xt-x2)+sqr(zt-z2))*TSin(-a+f);
   m:=k*TSin(ay)/TCos(ay)-(yt-y2);
   l:=k/TCos(ay)-m*TSin(ay);
   pl[2].y:=round(-400*m*TCos(ay)/l)+240;
   pl[2].x:=round(400*k1/l)+320;

   f:=90+TDetXAngle(xt,zt,x3,z3);

   k:=sqrt(sqr(xt-x3)+sqr(zt-z3))*TCos(-a+f);
   k1:=sqrt(sqr(xt-x3)+sqr(zt-z3))*TSin(-a+f);
   m:=k*TSin(ay)/TCos(ay)-(yt-y3);
   l:=k/TCos(ay)-m*TSin(ay);
   pl[3].y:=round(-400*m*TCos(ay)/l)+240;
   pl[3].x:=round(400*k1/l)+320;

   SetColor(Color);
   SetFillColor(Color);
   if (pl[1].x>-500)and(pl[1].x<1000)and(l>0) then begin
     if sokrat=true then FillTriangle(pl[1].x,pl[1].y, pl[2].x,pl[2].y, pl[3].x,pl[3].y)
       else Triangle(pl[1].x,pl[1].y, pl[2].x,pl[2].y, pl[3].x,pl[3].y);
   end;
end;

procedure DrawPiramide(x1,y1,z1, x2,y2,z2, x3,y3,z3, x4,y4,z4:real; color:byte; sokrat:boolean);
begin
  DrawTriangle(x1,y1,z1, x2,y2,z2, x3,y3,z3, color, sokrat);
  DrawTriangle(x1,y1,z1, x2,y2,z2, x4,y4,z4, color, sokrat);
  DrawTriangle(x1,y1,z1, x3,y3,z3, x4,y4,z4, color, sokrat);
end;
{--------------------------------------------}
{-----------Добавление плоскости-------------}
{--------------------------------------------}
Procedure MakePlane(x0,y0,z0,Sa,Sb,RotXZ,RotYZ:real);
begin
  Inc(MaxN);
  Plane[MaxN]^.x:=x0;
  Plane[MaxN]^.y:=y0;
  Plane[MaxN]^.z:=z0;
  Plane[MaxN]^.Sa:=Sa;
  Plane[MaxN]^.Sb:=Sb;
  Plane[MaxN]^.RotXZ:=RotXZ;
  Plane[MaxN]^.RotYZ:=RotYZ;
end;

procedure DrawPlane({xc,yc,zc,Sa,Sb:real; RotXZ,RotYZ:real; Color:Byte}nomber:integer; color:byte);
var
x,y,z:array[1..4] of real;
pl:array[1..4] of pointtype;
l,m,k,k1:real;
xtd,ztd,ytd:real;
l0,l0y,ly,h,f:real;
xn,yn,yk,xk:integer;
i,j:integer;
Zd,Xd,Yd,r:real;
begin
  x[1]:=Plane[nomber]^.x-(Plane[nomber]^.Sb/2)*TCos(Plane[nomber]^.RotXZ);
  y[1]:=Plane[nomber]^.y-(Plane[nomber]^.Sa/2)*TCos(Plane[nomber]^.RotYZ);
  x[2]:=Plane[nomber]^.x+(Plane[nomber]^.Sb/2)*TCos(Plane[nomber]^.RotXZ);
  y[2]:=Plane[nomber]^.y-(Plane[nomber]^.Sa/2)*TCos(Plane[nomber]^.RotYZ);
  x[3]:=Plane[nomber]^.x+(Plane[nomber]^.Sb/2)*TCos(Plane[nomber]^.RotXZ);
  y[3]:=Plane[nomber]^.y+(Plane[nomber]^.Sa/2)*TCos(Plane[nomber]^.RotYZ);
  x[4]:=Plane[nomber]^.x-(Plane[nomber]^.Sb/2)*TCos(Plane[nomber]^.RotXZ);
  y[4]:=Plane[nomber]^.x+(Plane[nomber]^.Sa/2)*TCos(Plane[nomber]^.RotYZ);

  if (round(Plane[nomber]^.RotXZ)<>90)or(round(Plane[nomber]^.RotXZ)<>270)or(round(Plane[nomber]^.RotXZ)<>-90)
  or(round(Plane[nomber]^.RotXZ)<>-270) then for i:=1 to 4 do
  z[i]:=Plane[nomber]^.z-((x[i]-Plane[nomber]^.x)*TTan(Plane[nomber]^.RotXZ));

  if (round(Plane[nomber]^.RotYZ)<>90)or(round(Plane[nomber]^.RotYZ)<>270)or(round(Plane[nomber]^.RotYZ)<>-90)
  or(round(Plane[nomber]^.RotYZ)<>-270) then for i:=1 to 4 do
  z[i]:=Plane[nomber]^.z-((y[i]-Plane[nomber]^.y)*TTan(Plane[nomber]^.RotYZ));

  if (round(Plane[nomber]^.RotXZ)=90)or(round(Plane[nomber]^.RotXZ)=270)or(round(Plane[nomber]^.RotXZ)=-90)or(round(Plane[nomber]^.RotXZ)=-270) then begin
    z[1]:=Plane[nomber]^.z-(Plane[nomber]^.Sb/2);
    z[2]:=Plane[nomber]^.z+(Plane[nomber]^.Sb/2);
    z[3]:=Plane[nomber]^.z+(Plane[nomber]^.Sb/2);
    z[4]:=Plane[nomber]^.z-(Plane[nomber]^.Sb/2);
  end;

  if (round(Plane[nomber]^.RotYZ)=90)or(round(Plane[nomber]^.RotYZ)=270)or(round(Plane[nomber]^.RotYZ)=-90)or(round(Plane[nomber]^.RotYZ)=-270) then begin
    z[1]:=Plane[nomber]^.z-(Plane[nomber]^.Sa/2);
    z[2]:=Plane[nomber]^.z-(Plane[nomber]^.Sa/2);
    z[3]:=Plane[nomber]^.z+(Plane[nomber]^.Sa/2);
    z[4]:=Plane[nomber]^.z+(Plane[nomber]^.Sa/2);
  end;

  for i:=1 to 4 do begin
    if z[i]<>zt then f:=(TArcTan((xt-x[i])/(zt-z[i])));
    if ((xt-x[i])<0)and((zt-z[i])=0)then f:=-90;
    if ((xt-x[i])>0)and((zt-z[i])=0)then f:=90;
    if ((zt-z[i])>0)and((xt-x[i])<>0)then f:=f+180;

    k:=sqrt(sqr(xt-x[i])+sqr(zt-z[i]))*TCos(-a+f);
    k1:=sqrt(sqr(xt-x[i])+sqr(zt-z[i]))*TSin(-a+f);
    m:=k*TSin(ay)/TCos(ay)-(yt-y[i]);
    l:=k/TCos(ay)-m*TSin(ay);
    pl[i].y:=round(-400*m*TCos(ay)/l)+240;
    pl[i].x:=round(400*k1/l)+320;

     if i=4 then begin
       setfillstyle(1,Color);
       if (pl[1].x>-550)and(pl[1].x<1700)and(pl[2].x>-550)and(pl[2].x<1700)
       and(pl[3].x>-550)and(pl[3].x<1700)and(pl[4].x>-550)and(pl[4].x<1700)
       and(pl[1].y>-550)and(pl[1].y<1500)and(pl[2].y>-550)and(pl[2].y<1500)
       and(pl[3].y>-550)and(pl[3].y<1500)and(pl[4].y>-550)and(pl[4].y<1500)and(l>0)
       then FillPoly(4,pl);
     end;
  end;

end;

Procedure MakeCube(Xc,Yc,Zc,A,V,H:Real);
var
lm:array[1..6] of real;
i:integer;
id:integer;
r:real;
VecCol2,VecCol3,VecCol4,VecCol1,VecCol5,VecCol6:byte;
t:array[1..6] of boolean;
n:array[1..6] of integer;
f:integer;
begin
    MakePlane(Xc,Yc,Zc-V/2,H,A,0,0);
    MakePlane(Xc,Yc,Zc+V/2,H,A,0,0);
    MakePlane(Xc+A/2,Yc,Zc,H,V,90,0);
    MakePlane(Xc-A/2,Yc,Zc,H,V,90,0);
    MakePlane(Xc,Yc+h/2,Zc,H,V,0,90);
    MakePlane(Xc,Yc-h/2,Zc,H,V,0,90);
end;


Procedure Draw;
var
l: array[1..10] of real;
i,id:integer;
f,k:integer;
mx:integer;
max:integer;
dop:integer;
n:array[1..100] of integer;
begin
 { for i:=1 to 1000 do
    getmem(dim[i],sizeof(real));
  }
  mx:=MaxN;
  For i:=1 to mx do begin
    n[i]:=i;
    l[i]:=sqrt( sqr(plane[i]^.x-xt) + sqr(plane[i]^.y-yt) + sqr(plane[i]^.z-zt) );
  end;

  for i:=1 to mx-1 do
    for id:=1 to mx-i do
      if l[i]<l[i+1] then
        begin
          dop:=n[i];
          n[i]:=n[i+1];
          n[i+1]:=dop;
        end;
      {str(n[1],s1);
      str(n[2],s2);
      str(n[3],s3);
      str(n[4],s4);
      str(n[5],s5);
       }
  for i:=1 to MaxN do
    DrawPlane(n[i],i);
 { str(dim[1]^.n,s1);
  Str(dim[2]^.n,s2);
  str(dim[3]^.n,s3);
  str(dim[4]^.n,s4);
  str(dim[5]^.n,s5);

  for i:=1 to MaxN do begin
    dim[dim[i].n].t:=true;

    for id:=1 to maxN do
      if dim[id].t=true then DrawPlane(Plane[id]^.x,Plane[id]^.y,Plane[id]^.z,
        Plane[id]^.Sa,Plane[id]^.Sb,Plane[id]^.RXZ,Plane[id]^.RYZ,id*5);

    dim[dim[i].n].t:=false;
  end;
     }
  setactivepage(pg);
  pg:=1-pg;
  setvisualpage(pg,true);

  {for i:=1 to 1000 do
    freemem(dim[i],sizeof(real));
   }
  clearpage;
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

{--------------------------------------------}
{--------------Основная программа------------}
{--------------------------------------------}

begin

  {---Инициализация графического режима------}

  SetSVGAMode(640, 480, 8 ,LfbOrBanked);
  setbkcolor(LightGray);
  {------------------------------------------}

  yt:=0;
  xt:=0;
  zt:=-500;
  a:=0;
  ay:=0;

{  for i:=1 to 640 do begin
   setcolor(1000*i);
   line(i,0,i,480);
  end;

  {------------Инициализация мыши-----------}
  InitMouse;
  HideMouse;
  SetMouseRange(0, 0, 640, 480);
  SetMousePos(GetMaxX div 2, GetMaxY div 2);

  mx0:=GetmouseX;
  my0:=GetmouseY;
  {-----------------------------------------}
  for i:=1 to 10000 do GetMem(plane[i],7*sizeof(real));
  {  for i := 1 to 160 do
    SetRGBPalette (i,0,0,0);

  repeat
    SetFillColor(13);
    Bar(0,0,640,480);
    if keypressed then begin
      c:=readkey;
      case c of
        'k': j:=j+1;
        'f': j:=j-1;
      end;
      setrgbPalette(13,j,j,j);
    end;

  until c=#27;

   readkey;
  {--------------------------------------------}
  {--------------Основной цикл-----------------}
  {--------------------------------------------}
  {MakePlane(0,0,0,600,10,0,0);
  MakePlane(0,0,0,10,600,0,0);
  MakePlane(0,0,0,600,10,0,90);  }
 { MakeCube(xf-111,yf,zf-101,200,200,200);
  }


  repeat

    {j:=j+1;
     if (j=360)or(j=-360) then j:=0;

    {-----Вычисление изменения углов----}
    {-----По горизонтали и вертикали----}
      mx:=GetmouseX;
      my:=GetmouseY;

      h:=(mx-mx0)/10;
      hy:=(my-my0)/10;
      ay:=ay+hy;
      a:=a+h;

      if (ay<-80) then ay:=-80;
      if (ay>80) then ay:=80;
    {-----------------------------------}
    {-----------------------------------}

   { r:=400;
    xo:=r*TCos(j);
    zo:=r*TSin(j)+100;
    yo:=100;

   { str(xo:3:3,s1);
    str(zo:3:3,s2);
    {--------Чтение нажатых клавиш----------}
    k:=1;
    if keypressed then begin
     c:=readkey;
     case c of
        'w': begin
               zt:=zt+5*TCos(a);
               xt:=xt+5*TSin(a);
             end;
        's': begin
               zt:=zt-5*TCos(a);
               xt:=xt-5*TSin(a);
             end;
        'd': begin
               xt:=xt+5*TCos(a);
               zt:=zt-5*TSin(a);
             end;
        'a': begin
               xt:=xt-5*TCos(a);
               zt:=zt+5*TSin(a);
             end;
        'q': begin
               yt:=yt-3;
             end;
        'e': begin
               yt:=yt+3;
             end;
        '8': zf:=zf+4;
        '2': zf:=zf-4;
        '6': inc(xf,4);
        '4': dec(xf,4);
        'r': inc(j,1);
        'f': dec(j,1);
      end;
    end;


    {----Выведение графики на экран----}
    {--С помощью графических страниц---}

    {MakePlane(xo,yo,zo,10,10,0,0,black);   }

    textcolor(123);
    outtextxy(10,10,s1);
    outtextxy(10,23,s2);
    outtextxy(10,36,s3);
    outtextxy(10,49,s4);
    outtextxy(10,62,s5);

    DrawFly;

    DrawPiramide(0,0,0, 100,0,0, 50,0,50+j, 50,50,25, black, false);
    DrawPixel(0,0,0,red);

    Draw;
    {------------------------------------}
    {------------------------------------}

    mx0:=mx;
    my0:=my;
    MoveMouseCenter;

 until c=#27;

 restorecrtmode;
end.

{for i:=1 to 100 do PointPlane(-1000,100,-1500+i*30,200,30,90,54);
 for i:=1 to 100 do PointPlane(-1000+i*30,100,1500,200,30,0,103);
 for i:=1 to 100 do PointPlane(2000,100,1500-i*30,200,30,90,398);
 for i:=1 to 100 do PointPlane(-1000+i*30,100,-1500,200,30,0,1000);  }