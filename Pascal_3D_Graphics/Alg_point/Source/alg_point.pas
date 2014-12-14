uses crt,graph,mouse,Trig;

var

xt,zt,yt: real;

x,y,z: array[1..400,1..8] of integer;
l,l0,ly,l0y: real;

j:integer;
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
{------------Рисование плоскости-------------}
{--------------------------------------------}
procedure DrawPlane(xc,yc,zc,Sa,Sb:real; RotXZ,RotYZ:real; Color:Byte);
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

  if (round(RotYZ)=90)or(round(RotYZ)=270)or(round(RotYZ)=-90)or(round(RotYZ)=-270) then begin
    z[1]:=zc-(Sa/2);
    z[2]:=zc-(Sa/2);
    z[3]:=zc+(Sa/2);
    z[4]:=zc+(Sa/2);
  end;

  h:=400;
  h:=400;

  for i:=1 to 4 do begin
    if z[i]<>zt then f:=(arctan((xt-x[i])/(zt-z[i])));
    if ((xt-x[i])<0)and((zt-z[i])=0)then f:=(-pi/2);
    if ((xt-x[i])>0)and((zt-z[i])=0)then f:=(pi/2);
    if ((zt-z[i])>0)and((xt-x[i])<>0)then f:=f+(pi);

    k:=sqrt(sqr(xt-x[i])+sqr(zt-z[i]))*cos(-a*p+f);
    k1:=sqrt(sqr(xt-x[i])+sqr(zt-z[i]))*sin(-a*p+f);
    m:=k*sin(ay*p)/cos(ay*p)-(yt-y[i]);
    l:=k/cos(ay*p)-m*sin(ay*p);
    pl[i].y:=round(-400*m*cos(ay*p)/l)+240;
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
    {
  str(a:3:3,s1);
  str(f:3:3,s2);
 { str(l[3]:3:3,s3);
  str(l[4]:3:3,s4);
  str(zt:3:3,s5);
 }

end;

Procedure DrawCube(Xc,Yc,Zc,A,V,H:Real; Color:Byte);
  procedure pog(n:integer);
  begin

  end;
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
  lm[1]:=sqrt(sqr(xt-xc)+sqr(yt-yc)+sqr(zt-(zc-V/2)));
  lm[2]:=sqrt(sqr(xt-xc)+sqr(yt-yc)+sqr(zt-(zc+V/2)));
  lm[3]:=sqrt(sqr(xt-(xc+a/2))+sqr(yt-yc)+sqr(zt-zc));
  lm[4]:=sqrt(sqr(xt-(xc-a/2))+sqr(yt-yc)+sqr(zt-zc));
  lm[5]:=sqrt(sqr(xt-xc)+sqr(yt-(yc+h/2))+sqr(zt-zc));
  lm[6]:=sqrt(sqr(xt-xc)+sqr(yt-(yc-h/2))+sqr(zt-zc));

 {for i:=1 to n do begin
    t[i]:=false;

    if lm[i]>max then max:=i;
    if i=n then begin
      lm[n]:=lm[max]-lm[n];
      lm[max]:=lm[max]-lm[n];
      lm[n]:=lm[max]+lm[n];
      dec(n);
      if n>0 then goto l;
    end;
  end; }
  for i:=1 to 6 do begin
    for id:=1 to 6 do begin
      if (lm[i]<lm[id])or(lm[i]=lm[id]) then inc(f,1);
    end;
    n[f]:=i;
    f:=0;
  end;

  Str(lm[2]:4:0,s2);
  str(lm[3]:4:0,s3);
  str(lm[4]:4:0,s4);
  str(lm[5]:4:0,s5);
  Str(lm[6]:4:0,s6);

    VecCol1 := Brown;
    VecCol2 := Green;
    VecCol3 := Blue;
    VecCol4 := Yellow;
    VecCol5 := Red;
    VecCol6 := Black;

  for i:=1 to 6 do begin
    t[n[i]]:=true;


    if t[1]=true then begin
      {r:=sqrt( Sqr(xo-xc) + Sqr(yo-yc) + Sqr(zo-(zc-v/2)) );
      SetRGBPalette(VecCol1,round(8000/r),round(8000/r),round(8000/r));
      }DrawPlane(Xc,Yc,Zc-V/2,H,A,0,0,VecCol1);
    end;
    if t[2]=true then begin
      {r:=sqrt( Sqr(xo-xc) + Sqr(yo-yc) + Sqr(zo-(zc+v/2)) );
      SetRGBPalette(VecCol2,round(8000/r),round(8000/r),round(8000/r));
      }DrawPlane(Xc,Yc,Zc+V/2,H,A,0,0,VecCol2);
    end;
    if t[3]=true then begin
      {r:=sqrt( Sqr(xo-(xc+a/2)) + Sqr(yo-yc) + Sqr(zo-zc) );
      SetRGBPalette(VecCol3,round(8000/r),round(8000/r),round(8000/r));
      }DrawPlane(Xc+A/2,Yc,Zc,H,V,90,0,VecCol3);
    end;
    if t[4]=true then begin
      {r:=sqrt( Sqr(xo-(xc-a/2)) + Sqr(yo-yc) + Sqr(zo-zc) );
      SetRGBPalette(VecCol4,round(8000/r),round(8000/r),round(8000/r));
      }DrawPlane(Xc-A/2,Yc,Zc,H,V,90,0,VecCol4);
    end;
    if t[5]=true then begin
      {r:=sqrt( Sqr(xo-xc) + Sqr(yo-(yc+h/2)) + Sqr(zo-zc) );
      SetRGBPalette(VecCol5,round(8000/r),round(8000/r),round(8000/r));
      }DrawPlane(Xc,Yc+h/2,Zc,H,V,0,90,VecCol5);
    end;
    if t[6]=true then begin
      {r:=sqrt( Sqr(xo-xc) + Sqr(yo-(yc-h/2)) + Sqr(zo-zc) );
      SetRGBPalette(VecCol6,round(8000/r),round(8000/r),round(8000/r));
      }DrawPlane(Xc,Yc-h/2,Zc,H,V,0,90,VecCol6);
    end;
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

{--------------------------------------------}
{--------------Основная программа------------}
{--------------------------------------------}

begin

  {---Инициализация графического режима------}

  SetSVGAMode(640, 480, 8 ,LfbOrBanked);
  setbkcolor(lightgray);
  {------------------------------------------}

  p:=pi/180;
  yt:=300;
  xt:=-500;
  zt:=-500;

  ay:=20;
  {------------Инициализация мыши-----------}
  InitMouse;
  HideMouse;
  SetMouseRange(0, 0, 640, 480);
  SetMousePos(GetMaxX div 2, GetMaxY div 2);

  mx0:=GetmouseX;
  my0:=GetmouseY;
  {-----------------------------------------}
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

  repeat
     j:=j+1;
     xt:=600*Sin((j/2)*pi/180);
     zt:=100+600*Cos((j/2)*pi/180);
     yt:=99+600*Cos(j/2*pi/180);
     a:=TdetXangle(100,100, round(xt),round(zt))-90;
     if yt>100 then ay:=90-TArcTan(600/(yt-100));
     if yt<100 then ay:=90-(TArcTan(600/(yt-100))+180);
    {-----Вычисление изменения углов----}
    {-----По горизонтали и вертикали----}
      mx:=GetmouseX;
      my:=GetmouseY;

      h:=(mx-mx0)/10;
      hy:=(my-my0)/10;
      ay:=ay+hy;
      a:=a+h;

      {if (ay<-80) then ay:=-80;
      if (ay>80) then ay:=80;
    {-----------------------------------}
    {-----------------------------------}

    {r:=400;
    xo:=r*cos(j*p);
    zo:=r*sin(j*p)+100;
    yo:=100;
     }
   { str(xo:3:3,s1);
    str(zo:3:3,s2);
    {--------Чтение нажатых клавиш----------}
    k:=1;
    if keypressed then begin
     c:=readkey;
     case c of
        'w': begin
               zt:=zt+5*cos(a*p);
               xt:=xt+5*sin(a*p);
             end;
        's': begin
               zt:=zt-5*cos(a*p);
               xt:=xt-5*sin(a*p);
             end;
        'd': begin
               xt:=xt+5*cos(a*p);
               zt:=zt-5*sin(a*p);
             end;
        'a': begin
               xt:=xt-5*cos(a*p);
               zt:=zt+5*sin(a*p);
             end;
        'q': begin
               yt:=yt-3;
             end;
        'e': begin
               yt:=yt+3;
             end;
        'r': j:=j+1;
        'f': j:=j-1;
      end;
    end;


    {----Выведение графики на экран----}
    {--С помощью графических страниц---}

    clearpage;
    {DrawPlane(xo,yo,zo,10,10,0,0,black);  }
    DrawPlane(0,0,0,10,10,0,0,Black);

    DrawCube(0,100,100,200,200,200,151);


    DrawFly;
    {str(xo:3:3,s1);
    str(zo:3:3,s2);
    str(j,s3);

    str(a:3:3,s1);
    str(ay:3:3,s2);
    str(xt:3:3,s3);
    str(zt:3:3,s4);
       }
    outtextxy(10,10,s1);
    outtextxy(10,23,s2);
    outtextxy(10,36,s3);
    outtextxy(10,49,s4);
    outtextxy(10,62,s5);

    setactivepage(pg);
    inc(pg);
    if pg=11 then pg:=1;
    setvisualpage(pg,true);

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