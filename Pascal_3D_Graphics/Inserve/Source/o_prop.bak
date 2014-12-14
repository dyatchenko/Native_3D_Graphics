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
x,y,z: array[1..400,1..8] of integer;
Boofer:array[-240..240,-320..320] of real;
Texture:array[0..200,0..200] of byte;
p,a,ay,hx,hy,j,o,u:real;
zk,yk,xk,n:integer;
i,id,idd,k,d,x1,y1,z1,m,h,ut:integer;
s,s1,s2,s3,s4,s5,s6:string;
page:boolean;
c:char;
mx,my,mx0,my0:integer;
massiv1,massiv2:array[1..10000] of dir;

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

{Рисование горизонтальной линнии определенного цвета с учетом Z-буфера}
procedure DrawFillHorLine(sy,x1,x2:integer;ln,lk:real;Color:byte);
var
  d:real;
  l:real;
  i:integer;
  d1,d2:real;
  ix1:integer;
begin
  if (sy>-240)and(sy<240) then begin

{    if x1<x2 then begin
      d:=((ln-lk)/(x2-x1));
      l:=(ln+lk)/2;
      for i:=x1 to x2 do
        if (i>-320)and(i<320) then begin
          ix1:=(i-x1);
          {l:=ln-(d*ix1);  }
{          if (boofer[sy][i]>l)or(boofer[sy][i]=0) then begin
            putpixel(i+320,-sy+240,Color);
            boofer[sy][i]:=l;
          end;
        end;
    end;
}
      d:=((ln-lk)/(x2-x1));
      l:=(ln+lk)/2;
      for i:=x2 to x1 do
        if (i>-320)and(i<320) then begin
          ix1:=(i-x2);
          {l:=lk-(d*ix1);}
          if (boofer[sy][i]>l)or(boofer[sy][i]=0) then begin
            putpixel(i+320,-sy+240,Color);
            boofer[sy][i]:=l;
          end;
        end;
  end;

end;

{....Рисование текстурированной гор. линии.....}
procedure DrawHorLine(sy,x1,x2:integer;ln,lk:real;cn,ck:pp);
var
  d:real;
  l:real;
  i:integer;
  d1,d2:real;
  Color:byte;
  ix1:integer;
begin
  if (sy>0)and(sy<480) then begin

    if x1<x2 then begin
      d:=((ln-lk)/(x2-x1));
      d1:=(cn.y-ck.y)/(x2-x1);
      d2:=(ck.x-cn.x)/(x2-x1);
      for i:=x1 to x2 do
        if (i>0)and(i<640) then begin
          ix1:=(i-x1);
          l:=ln-(d*ix1);
          if x2<>x1 then
          Color:=texture[round(cn.y-d1*ix1)][round(cn.x+d2*ix1)];
          if (boofer[sy][i]>l)or(boofer[sy][i]=0) then begin
            putpixel(i,sy,Color);
            boofer[sy][i]:=l;
          end;
        end;
    end;

    if x1>x2 then begin
      d:=((ln-lk)/(x2-x1));
      d1:=(ck.y-cn.y)/(x1-x2);
      d2:=(cn.x-ck.x)/(x1-x2);
      for i:=x2 to x1 do
        if (i>0)and(i<640) then begin
          ix1:=(i-x2);
          l:=lk-(d*ix1);
          Color:=texture[round(ck.y-d1*ix1)][round(ck.x+d2*ix1)];
          if (boofer[sy][i]>l)or(boofer[sy][i]=0) then begin
            putpixel(i,sy,Color);
            boofer[sy][i]:=l;
          end;
        end;
    end;

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

{------------Рисование текстурированого закрашенного треугольника-----------------}
{C учетом Z-буфера}
procedure DrawTriangle(x1,y1, x2,y2, x3,y3:integer; cx1,cy1, cx2,cy2, cx3,cy3:integer; l1,l2,l3:real);
var
  max,min,ser:pointtype;
  i,id:integer;
  lsr,lmn,lmx,ld,ln,lk:real;
  rt:array[1..3] of pointtype;
  Dn,Dlk,Dln1,Dln2:integer;
  Dn1,Dn2,Dk:real;
  imr,isr:integer;
  Cn,Ck:pp;
  Cmx,Cmn,Csr:pp;
  DopCkX,DopCkY,DopCn1X,
  DopCn1Y,DopCn2X,DopCn2Y:real;
begin

  {............Сортировка вершин..............}
  rt[1].x:=x1;   rt[1].y:=y1;
  rt[2].x:=x2;   rt[2].y:=y2;
  rt[3].x:=x3;   rt[3].y:=y3;

  min.y:=rt[1].y;
  min.x:=rt[1].x;
  lmn:=l1;
  Cmn.x:=cx1;
  Cmn.y:=cy1;
  if rt[2].y<min.y then begin
    min.y:=rt[2].y;
    min.x:=rt[2].x;
    lmn:=l2;
    Cmn.x:=cx2;
    Cmn.y:=cy2;
  end;
  if rt[3].y<min.y then begin
    min.y:=rt[3].y;
    min.x:=rt[3].x;
    lmn:=l3;
    Cmn.x:=cx3;
    Cmn.y:=cy3;
  end;

  max.y:=rt[1].y;
  max.x:=rt[1].x;
  lmx:=l1;
  Cmx.x:=cx1;
  Cmx.y:=cy1;
  if rt[2].y>max.y then begin
    max.y:=rt[2].y;
    max.x:=rt[2].x;
    lmx:=l2;
    Cmx.x:=cx2;
    Cmx.y:=cy2;
  end;
  if rt[3].y>max.y then begin
    max.y:=rt[3].y;
    max.x:=rt[3].x;
    lmx:=l3;
    Cmx.x:=cx3;
    Cmx.y:=cy3;
  end;

  ser.x:=rt[1].x;
  ser.y:=rt[1].y;
  lsr:=l1;
  Csr.x:=cx1;
  Csr.y:=cy1;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=rt[2].x;
    ser.y:=rt[2].y;
    lsr:=l2;
    Csr.x:=cx2;
    Csr.y:=cy2;
  end;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=rt[3].x;
    ser.y:=rt[3].y;
    lsr:=l3;
    Csr.x:=cx3;
    Csr.y:=cy3;
  end;
  {................Конец сортировки................}

{+++++++++++++++++++++++++Константы+++++++++++++++++++++++++++++++++}
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

{  Cmn.x:=50;
  Cmn.y:=100;
  Cmx.x:=100;
  cmx.y:=0;
  Csr.x:=0;
  Csr.y:=50;
 }
  if (max.y<>min.y)and(max.y<>ser.y)and(ser.y<>min.y) then begin
    DopCkX:=(Cmx.x-Cmn.x)/(max.y-min.y);
    DopCkY:=(Cmn.y-Cmx.y)/(max.y-min.y);
    DopCn1X:=(Cmx.x-Csr.x)/(max.y-ser.y);
    DopCn1Y:=(Csr.y-Cmx.y)/(max.y-ser.y);
    DopCn2X:=(Cmn.x-Csr.x)/(ser.y-min.y);
    DopCn2Y:=(Cmn.y-Csr.y)/(ser.y-min.y);
  end;

   if (max.y=min.y)then begin
     DopCkX:=0;
     DopCkY:=0;
   end;

   if (max.y=ser.y)then begin
     DopCn1X:=0;
     DopCn1Y:=0;
   end;

   if (ser.y=min.y)then begin
     DopCn2X:=0;
     DopCn2Y:=0;
   end;
{=============Цикл рисования гор. линий=============}
  for i:=min.y to max.y do begin
    imr:=(i-min.y);
    isr:=(i-ser.y);

      IF i>ser.y then begin

        if max.y<>ser.y then ln:=lsr-Dn1*isr
          else ln:=lsr;
        if max.y<>min.y then lk:=lmn-Dk*imr
          else lk:=lmn;

        Cn.x:=Csr.x+DopCn1X*isr;
        Cn.y:=Csr.y-DopCn1Y*isr;

        Ck.x:=Cmn.x+DopCkX*imr;
        Ck.y:=Cmn.y-DopCkY*imr;

        if min.y<>max.y then
          DrawHorLine(i,round(ser.x-Dln1/1000*isr),
            round(min.x-Dlk/1000*imr),ln,lk,Cn,Ck);

      END

      ELSE begin

        if min.y<>ser.y then ln:=lmn-Dn2*imr
            else ln:=lmn;
        if max.y<>min.y then lk:=lmn-Dk*imr
            else lk:=lmn;

        Cn.x:=Cmn.x-DopCn2X*imr;
        Cn.y:=Cmn.y-DopCn2Y*imr;

        Ck.x:=Cmn.x+DopCkX*imr;
        Ck.y:=Cmn.y-DopCkY*imr;

        if (ser.y<>min.y) then
          DrawHorLine(i,round(min.x-Dln2/1000*imr),
            round(min.x-Dlk/1000*imr),ln,lk,Cn,Ck);
      END;

  end;
{============Конец цикла===========}
end;

procedure MakeNorT(x1,y1,z1, x2,y2,z2, x3,y3,z3:real);
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

{..Создание в пространстве текстурированного треугольника...}
procedure MakeTriangle(x1,y1,z1, x2,y2,z2, x3,y3,z3:real; cx1,cy1, cx2,cy2, cx3,cy3:integer);

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
    DrawTriangle(sx1,sy1,sx2,sy2,sx3,sy3, cx1,cy1, cx2,cy2, cx3,cy3,(l[1]+h),(l[2]+h),(l[3]+h));
end;

{...Создание в пространстве сплошного четырехугольника....}
procedure MakeFillPlane(x,y,z:real; a,b:real; rx,ry:real; cl:byte);
begin                       {Длины сторон^^}  {^^Углы поворота}
  MakeFillTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x+a*cos(rx*p), y, z+a*sin(rx*p), cl);
  MakeFillTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x, y+b*cos(ry*p), z+b*sin(ry*p), cl);
end;

{...Создание в пространстве четырехугольника с текстурой....}
procedure MakePlane(x,y,z:real; a,b:real; rx,ry:real;  cx1,cy1, cx2,cy2, cx3,cy3, cx4,cy4:integer);
begin                       {Длины сторон^^}  {^^Углы поворота}
  MakeTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x+a*cos(rx*p), y, z+a*sin(rx*p), cx1,cy1, cx3,cy3, cx2,cy2);
  MakeTriangle(x,y,z, x+a*cos(rx*p), y+b*cos(ry*p), z+a*sin(rx*p)+b*sin(ry*p),
    x, y+b*cos(ry*p), z+b*sin(ry*p), cx1,cy1, cx3,cy3, cx4,cy4);
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
  MakeFillPlane(x,y,z,100,100,0,90,LightGray);
  MakeFillTriangle(x,y,z,  x+50,y+150,z+50,  x+100,y,z,yellow);
  MakeFillTriangle(x,y,z,  x+50,y+150,z+50,  x,y,z+100,blue);
  MakeFillTriangle(x,y,z+100,  x+50,y+150,z+50,  x+100,y,z+100, white);
  MakeFillTriangle(x+100,y,z, x+50,y+150,z+50, x+100,y,z+100,red);
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
        'z': u:=u-3*0.017;
        'x': u:=u+3*0.017;
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
  str(u*57.3:3:3,s6);

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
  for i:=-240 to 240 do
    for id:=-320 to 320 do
      if boofer[i][id]<>0 then boofer[i][id]:=0;

  n:=0;
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

  For i:=0 to 100 do for id:=0 to 100 do texTure[i][id]:=getpixel(id+100,200-i);

  p:=pi/180;
  yt:=0;
  xt:=0;
  zt:=0;

  InitializeMouse;

  for i:=1 to 100 do begin
    for id:=1 to 100 do begin
      inc(h);
      massiv1[h].x:=(id-50)*17;
      massiv1[h].z:=(i-50)*17;
    {  massiv1[h].y:=round(100*cos(sqrt( sqr((i-50)*10/50)+sqr((id-50)*10/50) )));
      massiv1[h].y:=round(100*cos((i-50)*4/50)*sin((id-50)*4/50));
     } if (i<>50)and(id<>50) then massiv1[h].y:=round(300/(sqrt(sqr((i-50)*4/50)+sqr((id-50)*4/50))));
      {if (i<>50)and(id<>50) then massiv1[h].y:=round(300/cos(sqrt(sqr((i-50)*4/50)+sqr((id-50)*4/50))));
{      massiv[h].y:=abs(i-50)*abs(id-50);}
{      if id<>50 then massiv1[h].y:=round(100*(i-50)/(id-50))};
{      massiv[h].y:=sqr(i-50)/4+sqr(id-50)/4; }
{      if sqrt(sqr(i-50)+sqr(id-50))<50 then massiv[h].y:=round(3*sqrt(2500-sqr(i-50)-sqr(id-50)));
      if (i mod 24)and(id mod 24) = 0 then massiv[h].y:=-massiv[h].y;
      if sqrt(sqr(i-50)+sqr(id-50))>50 then massiv[h].y:=-300;
}    end;
  end;

  h:=400;
  zt:=0;

  for i:=1 to 10000 do massiv2[i]:=massiv1[i];

  a:=30*p;
  ay:=45*p;

  repeat

    ReadMouse;
    inc(ut);
    if ut=360 then ut:=0;

    ReadKeyDown;

    for i:=1 to 10000 do
      if massiv2[i].y>-300 then put3dpixel(massiv2[i].x,massiv2[i].y,massiv2[i].z,green);

    {put3dpixel(0,0,0,white);
    put3dpixel(100,0,0,white);
    put3dpixel(100,0,100,white);
    put3dpixel(0,0,100,white);
    put3dpixel(100,100,100,white);}
{   makefilltriangle(-100,-100,10,300,-100,20,100,300,30,green);
   makefilltriangle(0,round(170+100*cos(ut*pi/180)),round(100+100*sin(ut*pi/180)),200,round(10+100*cos(ut*pi/180)),
      round(100+100*sin(ut*pi/180)),100,round(190+100*cos(ut*pi/180)),round(-100+100*sin(ut*pi/180)),red);
  {  makefilltriangle(0,0,100,200,0,100,100,200,100,red);}
   { for i:=1 to 10000 do
      massiv2[i].y:=round(massiv1[i].y+50*cos(ut*pi/180+i*pi/180));
    }
    DrawFly;

    Draw;

    MoveMouseCenter;

  until c=#27;

  restorecrtmode;
end.












{MakeTriangle(0,3,0,99,0,0,100,100,0,0,0,100,0,100,100);
   { MakePlane(0,0,0, 100,100, 0,0, 0,0, 100,0, 100,100, 0,100);
    {MakeTriangle(0,0,0, 0,100,50, 0,50,100,0,100,0,0,100,0);
     }
    {
    MakeFillNonagon(200,0,-110,100,100,100);
    MakeFillNonagon(300,0,300,100,200,50);
    MakeFillNonagon(-200,-100,200,100,100,100);
    MakeFillPiramide(0,40,500,10);

    MakeFillPlane(0,0,-200,5,400,0,90,yellow);
    MakeFillPlane(-200,0,0,400,5,0,90,green);
    MakeFillPlane(0,-200,0,5,400,0,0,white);
{  filltriangle(round(m[1].sx)+320,-round(m[1].sy)+240,round(m[2].sx)+320,-round(m[2].sy)+240,round(m[3].sx)+320,-round(m[3].sy)+240);
}