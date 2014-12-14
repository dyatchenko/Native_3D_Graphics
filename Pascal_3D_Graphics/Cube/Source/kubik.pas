
uses crt,graph,mouse;

var

xt,zt,yt: real;

x,y,z: array[1..400,1..8] of integer;
l:array[1..100] of real;

p,a,ay,h,hy,j,o:real;
zk,yk,xk:integer;
i,k,d,x1,y1,z1,m:integer;
s,s1,s2,s3,s4,s5,s6:string;
pg:word;
gd,gm:integer;
c:char;


mx,my,mx0,my0:integer;

{-----------------ПРОЦЕДУРЫ------------------}

{--------------------------------------------}
{------------Рисование плоскости-------------}
{--------------------------------------------}
function tg(a:real):real;
begin
  tg:=sin(a)/cos(a);
end;

procedure DrawPlane(xc,yc,zc,Sa,Sb:real; RotXZ,RotYZ:real; Color:Byte);
var
x,y,z:array[1..4] of real;
pl:array[1..4] of pointtype;
Xd,Yd,Zd:real;
xs,zs,ys:real;
xn,yn,yk,xk:integer;
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
{--------------------------------------------}
{--------------Основная программа------------}
{--------------------------------------------}

begin

{  for i:=-6000 to 6000 do
    arctg[i]:=round(arctan(i/100)*18000/pi);

  for i:=-18000 to 18000 do begin
    if (i<>9000)and(i<>-9000) then
      ttg[i]:=round(tg(i*pi/18000)*10000);
  end;

  {---Инициализация графического режима------}

  SetSVGAMode(640, 480, 8 ,LfbOrBanked);
  setbkcolor(lightgray);
  {------------------------------------------}

  p:=pi/180;
  yt:=100;
  xt:=10;
  zt:=-300;

  {------------Инициализация мыши-----------}
  InitMouse;
  HideMouse;
  SetMouseRange(0, 0, 640, 480);
  SetMousePos(GetMaxX div 2, GetMaxY div 2);

  mx0:=GetmouseX;
  my0:=GetmouseY;
  {-----------------------------------------}


  {--------------------------------------------}
  {--------------Основной цикл-----------------}
  {--------------------------------------------}

  repeat
 {    j:=j+1;
     if (j=360)or(j=-360) then j:=0;

    {-----Вычисление изменения углов----}
    {-----По горизонтали и вертикали----}
      mx:=GetmouseX;
      my:=GetmouseY;

      h:=(mx-mx0)/10;
      hy:=(my-my0)/10;
      ay:=ay-hy*p;
      a:=a+h*p;

      if (a>2*pi)or(a<-2*pi) then a:=0;
      if (ay>2*pi)or(ay<-2*pi) then ay:=0;
    {-----------------------------------}
    {-----------------------------------}

    ReadKeyDown;

    {--------Чтение нажатых клавиш----------}
    k:=1;
    {----Выведение графики на экран----}
    {--С помощью графических страниц---}

    clearpage;
    DrawCube(0,100,100,200,200,200,151);

    str(a:3:3,s1);
    str(yt:3:3,s2);


    DrawFly;
    outtextxy(10,10,s1);
    outtextxy(10,23,s2);
    outtextxy(10,36,s3);
    outtextxy(10,49,s4);
    outtextxy(10,62,s5);

    setactivepage(pg);
    pg:=1-pg;
    setvisualpage(pg,true);

    {------------------------------------}
    {------------------------------------}

    mx0:=mx;
    my0:=my;
    MoveMouseCenter;

 until LeftButtonPressed;
 restorecrtmode;
end.

{for i:=1 to 100 do PointPlane(-1000,100,-1500+i*30,200,30,90,54);
 for i:=1 to 100 do PointPlane(-1000+i*30,100,1500,200,30,0,103);
 for i:=1 to 100 do PointPlane(2000,100,1500-i*30,200,30,90,398);
 for i:=1 to 100 do PointPlane(-1000+i*30,100,-1500,200,30,0,1000);  }