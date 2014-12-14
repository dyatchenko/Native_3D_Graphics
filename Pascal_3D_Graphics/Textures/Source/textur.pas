uses DDraw,crt,graph;

type
  SpaceType=record
  x,y,z:real;
end;

type
  DrawingType=record
  l:real;
  x,y,xt,yt:integer;
  Xd,Yd:real;
end;

var
  p1,p2,p3:SpaceType;
  c1,c2,c3:pointtype;
  pp1,pp2,pp3:SpaceType;
  cc1,cc2,cc3:PointType;
  i,id:integer;
  Texture:array[0..100,0..100] of integer;
  n,k:pointtype;

procedure MakeWrldStm;
begin
  MakeArrow(-100,0,0,100,0,0,red);
  MakeArrow(0,-100,0,0,100,0,green);
  MakeArrow(0,0,-100,0,0,100,yellow);
end;

{<><><><><<><><><><>><><><><><><><><}
procedure DrawTexHorLine(sy,x1,x2:integer;ln,lk:real;cn,ck:PointType);
var
  d:real;
  l:real;
  i:integer;
  d1,d2:real;
  Color:byte;
  ix1:integer;
  x,y:integer;
begin

  if (sy+240>0)and(sy+240<480) then begin

    if x1>x2 then begin
      d:=((ln-lk)/(x2-x1));
      d1:=(ck.y-cn.y)/(x1-x2);
      d2:=(cn.x-ck.x)/(x1-x2);
      for i:=x2 to x1 do
        if (i+320>0)and(i+320<640)and(i mod 1 =0) then begin
          ix1:=round((i-x2));
          l:=lk-(d*ix1);
          Color:=texture[round(ck.x+d2*ix1)][round(ck.y-d1*ix1)];
          if l<>0 then begin
             x:=round(i*400/l+320);
             y:=round(sy*400/l+240);
          end;
          if (x>0)and(x<640)and(y>0)and(y<480) then
            if (boofer[y][x]>l)or(boofer[y][x]=0) then begin
              putpixel(x,y,Color);
              boofer[y][x]:=l;
            end;
        end;
    end;


    if x1<x2 then begin
      d:=((ln-lk)/(x2-x1));
      d1:=(cn.y-ck.y)/(x2-x1);
      d2:=(ck.x-cn.x)/(x2-x1);
      for i:=x1 to x2 do
        if (i+320>0)and(i+320<640)and(i mod 1 = 0) then begin
          ix1:=round((i-x1));
          l:=ln-(d*ix1);
          if x2<>x1 then
          Color:=texture[round(cn.x+d2*ix1)][round(cn.y-d1*ix1)];
          if l<>0 then begin
            x:=round(i*400/l+320);
            y:=round(sy*400/l+240);
          end;
          if (x>0)and(x<640)and(y>0)and(y<480) then
          if (boofer[y][x]>l)or(boofer[y][x]=0) then begin
            putpixel(x,y,Color);
            boofer[y][x]:=l;
          end;
        end;
    end;

  end;
end;

{<><><><><><><><><><><><><><><><><><><><><}

procedure DrawTexTriangle(p1,p2,p3:DrawingType);
var
  max,min,ser:pointtype;
  i,id:integer;
  lsr,lmn,lmx,ln,lk:real;
  Dn,Dlk,Dln1,Dln2:integer;
  Dn1,Dn2,Dk:real;
  imr,isr:integer;
  Cn,Ck:PointType;
  Cmx,Cmn,Csr:PointType;
  k:integer;
  DopCkX,DopCkY,DopCn1X,
  DopCn1Y,DopCn2X,DopCn2Y:real;
begin

  if (p1.l=0)and(p2.l=0)and(p3.l=0) then begin
    p1.l:=1;
    p2.l:=1;
    p3.l:=1;
  end;


  min.y:=p1.y;
  min.x:=p1.x;
  lmn:=p1.l;
  Cmn.x:=p1.xt;
  Cmn.y:=p1.yt;
  if p2.y<min.y then begin
    min.y:=p2.y;
    min.x:=p2.x;
    lmn:=p2.l;
    Cmn.x:=p2.xt;
    Cmn.y:=p2.yt;
  end;
  if p3.y<min.y then begin
    min.y:=p3.y;
    min.x:=p3.x;
    lmn:=p3.l;
    Cmn.x:=p3.xt;
    Cmn.y:=p3.yt;
  end;

  max.y:=p1.y;
  max.x:=p1.x;
  lmx:=p1.l;
  Cmx.x:=p1.xt;
  Cmx.y:=p1.yt;
  if p2.y>max.y then begin
    max.y:=p2.y;
    max.x:=p2.x;
    lmx:=p2.l;
    Cmx.x:=p2.xt;
    Cmx.y:=p2.yt;
  end;
  if p3.y>max.y then begin
    max.y:=p3.y;
    max.x:=p3.x;
    lmx:=p3.l;
    Cmx.x:=p3.xt;
    Cmx.y:=p3.yt;
  end;

  ser.x:=p1.x;
  ser.y:=p1.y;
  lsr:=p1.l;
  Csr.x:=p1.xt;
  Csr.y:=p1.yt;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=p2.x;
    ser.y:=p2.y;
    lsr:=p2.l;
    Csr.x:=p2.xt;
    Csr.y:=p2.yt;
  end;
  if ((ser.y=min.y)and(ser.x=min.x))or((ser.y=max.y)and(ser.x=max.x)) then begin
    ser.x:=p3.x;
    ser.y:=p3.y;
    lsr:=p3.l;
    Csr.x:=p3.xt;
    Csr.y:=p3.yt;
  end;

  if ser.y=min.y then ser.y:=min.y+1;
  if ser.y=max.y then ser.y:=max.y-1;

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

  if (max.y<>min.y)and(max.y<>ser.y)and(ser.y<>min.y) then begin
    DopCkX :=(Cmx.x-Cmn.x)/(max.y-min.y);
    DopCkY :=(Cmn.y-Cmx.y)/(max.y-min.y);
    DopCn1X:=(Cmx.x-Csr.x)/(max.y-ser.y);
    DopCn1Y:=(Csr.y-Cmx.y)/(max.y-ser.y);
    DopCn2X:=(Cmn.x-Csr.x)/(ser.y-min.y);
    DopCn2Y:=(Cmn.y-Csr.y)/(ser.y-min.y);
  end;

  for i:=min.y to max.y do begin
    imr:=(i-min.y);
    isr:=(i-ser.y);

      IF i>ser.y then begin

        if max.y<>ser.y then ln:=lsr-Dn1*isr
          else ln:=lsr;
        if max.y<>min.y then lk:=lmn-Dk*imr
          else lk:=lmn;

        Cn.x:=round(Csr.x+DopCn1X*isr);
        Cn.y:=round(Csr.y-DopCn1Y*isr);

        Ck.x:=round(Cmn.x+DopCkX*imr);
        Ck.y:=round(Cmn.y-DopCkY*imr);

        if min.y<>max.y then
          DrawTexHorLine(i,round(ser.x-Dln1/1000*isr),
            round(min.x-Dlk/1000*imr),ln,lk,Cn,Ck);

      END

      ELSE BEGIN

        if min.y<>ser.y then ln:=lmn-Dn2*imr
            else ln:=lmn;
        if max.y<>min.y then lk:=lmn-Dk*imr
            else lk:=lmn;

        Cn.x:=round(Cmn.x-DopCn2X*imr);
        Cn.y:=round(Cmn.y-DopCn2Y*imr);

        Ck.x:=round(Cmn.x+DopCkX*imr);
        Ck.y:=round(Cmn.y-DopCkY*imr);

        if (ser.y<>min.y) then
          DrawTexHorLine(i,round(min.x-Dln2/1000*imr),
            round(min.x-Dlk/1000*imr),ln,lk,Cn,Ck);
      END;

  end;
end;


procedure MakeTexTriangle(p1,p2,p3:SpaceType; c1,c2,c3:PointType);
var
  xs,ys,zs:real;
  Xd,Yd,Zd:real;
  s1,s2,s3:DrawingType;

begin

  xs:=-(xt-p1.x);
  ys:=-(yt-p1.y);
  zs:=-(zt-p1.z);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  s1.l:=Zd*cos(ay)+ys*sin(ay)+h;
  s1.xd:=xd;
  s1.yd:=yd;

  s1.x:=-{round(Xd/s1.l*400)}round(xd);
  s1.y:={round(Yd/s1.l*400)}round(yd);
  s1.xt:=c1.x;
  s1.yt:=c1.y;

  xs:=-(xt-p2.x);
  ys:=-(yt-p2.y);
  zs:=-(zt-p2.z);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  s2.l:=Zd*cos(ay)+ys*sin(ay)+h;
  s2.xd:=xd;
  s2.yd:=yd;

  s2.x:=-{round(Xd/s2.l*400)}round(xd);
  s2.y:={round(Yd/s2.l*400)}round(yd);
  s2.xt:=c2.x;
  s2.yt:=c2.y;

  xs:=-(xt-p3.x);
  ys:=-(yt-p3.y);
  zs:=-(zt-p3.z);

  Zd:=zs*cos(a)+xs*sin(a);
  Xd:=zs*sin(a)-xs*cos(a);
  Yd:=Zd*sin(ay)-ys*cos(ay);
  s3.l:=Zd*cos(ay)+ys*sin(ay)+h;
  s3.xd:=xd;
  s3.yd:=yd;

  s3.x:=-{round(Xd/s3.l*400)}round(xd);
  s3.y:={round(Yd/s3.l*400)}round(yd);
  s3.xt:=c3.x;
  s3.yt:=c3.y;

  if (s1.l>0)and(s2.l>0)and(s3.l>0)then
    DrawTexTriangle(s1,s2,s3);
end;

begin
  initializegraph;
  initializemouse;

  SetColor(White);
  rectangle(100,100,200,200);
  SetFillColor(11);
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


  for i:=0 to 100 do
    for id:=0 to 100 do
      texture[id][i]:=getpixel(100+id,200-i);

  for i:=0 to 100 do
    for id:=0 to 100 do
      putpixel(400+id,400-i,texture[id][i]);

  cleardevice;
  yt:=50;

{  n.x:=0;
  k.x:=100;

  for i:=0 to 100 do begin
    n.y:=i;
    k.y:=i;
    DrawHorLine(300-i,300+i,200+i,1,1,k,n);
  end;
}

  p1.x:=-100+100;
  p1.y:=0;
  p1.z:=-50;
  c1.x:=0;
  c1.y:=0;

  p2.x:=0+100;
  p2.y:=0;
  p2.z:=-50;
  c2.x:=100;
  c2.y:=0;

  p3.x:=0+100;
  p3.y:=100;
  p3.z:=-50;
  c3.x:=100;
  c3.y:=100;

  zt:=-300;
  h:=0;

  pp1:=p1;
  pp2:=p2;
  pp3:=p3;

  pp2.x:=-100+100;
  pp2.y:=100;
  cc1:=c1;
  cc2:=c2;
  cc3:=c3;

  cc2.x:=0;
  cc2.y:=100;

  repeat
    readmouse;
    readkeydown;

    {makeArrow(0,0,0,100,0,100,white);}
    MakeTexTriangle(p1,p2,p3,c1,c2,c3);
    MakeTexTriangle(pp1,pp2,pp3,cc1,cc2,cc3);
    {MakeFillTriangle(0,0,0,100,0,0,100,100,0,12);
    MakeFillTriangle(0,0,0,100,0,100,100,100,100,7);
     }

    draw;
    movemousecenter;
  until c=#27;
  restorecrtmode;
end.