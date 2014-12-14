uses Crt,Graph,Mouse,Trig;

var
  px:array[1..2000] of real;
  py:array[1..2000] of real;
  pz:array[1..2000] of real;

  xt,zt,yt: real;

  j:integer;
  a,ay,h,hy:real;
  i,k,d,m:integer;
  s,s1,s2,s3,s4,s5,s6:string;
  pg:word;
  c:char;


  mx,my,mx0,my0:integer;


procedure DrawPixel(x1,y1,z1:real; color:byte);
var

x,y:integer;
l,m,k,k1:real;
f:real;

begin
   f:=90+TDetxAngle(xt,zt,x1,z1);

   k:=sqrt(sqr(xt-x1)+sqr(zt-z1))*TCos(-a+f);
   k1:=sqrt(sqr(xt-x1)+sqr(zt-z1))*TSin(-a+f);
   m:=k*TSin(ay)/TCos(ay)-(yt-y1);
   l:=k/TCos(ay)-m*TSin(ay);
   if l>10 then y:=round(-400*m*TCos(ay)/l)+240;
   if l>10 then x:=round(400*k1/l)+320;

   if (l>10)and(x>0)and(x<640)and(y>0)and(y<480) then PutPixel(x,y,color);

end;


Procedure Draw;
begin
  setactivepage(pg);
  pg:=1-pg;
  setvisualpage(pg,true);

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
  setbkcolor(black);
  {------------------------------------------}

  yt:=0;
  xt:=0;
  zt:=0;
  a:=-135;
  ay:=0;


  {------------Инициализация мыши-----------}
  InitMouse;
  HideMouse;
  SetMouseRange(0, 0, 640, 480);
  SetMousePos(GetMaxX div 2, GetMaxY div 2);

  mx0:=GetmouseX;
  my0:=GetmouseY;
  {-----------------------------------------}


  for i:=1 to 1000 do begin
    px[i]:=1000-random(2000);
    py[i]:=1000-random(2000);
    pz[i]:=1000-random(2000);

    px[i+1000]:=500-random(1000);
    py[i+1000]:=500-random(1000);
    pz[i+1000]:=1000-random(2000);
  end;

  repeat

    mx:=GetmouseX;
    my:=GetmouseY;

    h:=(mx-mx0)/10;
    hy:=(my-my0)/10;
    ay:=ay+hy;
    a:=a+h;

    if (ay<-80) then ay:=-80;
    if (ay>80) then ay:=80;

    k:=1;
    if keypressed then begin
     c:=readkey;
    end;

    for i:=1 to 1000 do begin
      pz[i+1000]:=pz[i+1000]-15;
      pz[i]:=pz[i]-15;
      DrawPixel(px[i],py[i],pz[i],white);
      DrawPixel(px[i+1000],py[i+1000],pz[i+1000],white);
      if pz[i+1000]<-1000 then pz[i+1000]:=1000;
      if pz[i]<-1000 then pz[i]:=1000;
    end;

    Draw;
    {------------------------------------}
    {------------------------------------}

    mx0:=mx;
    my0:=my;
    MoveMouseCenter;

 until c=#27;

 restorecrtmode;
end.

