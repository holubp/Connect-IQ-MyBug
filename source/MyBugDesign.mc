using Toybox.Graphics as Gc;
using Toybox.System as Sys;
using Toybox.Math as M;
using Toybox.WatchUi as Ui;

function draw_Design(dc,DesignTyp,MT){
 var f=0.65;
 var arrW=[45,90,135,225,270,315];
 dc.setPenWidth(1);
 if(DesignTyp==0){
  //Linien
  dc.setPenWidth(2);
  var arrP=new[6]; 
  for(var w=0;w<6;++w){
   dis=r;
   Wi=arrW[w];
   MyBugView.Koord();
   dc.drawLine(r,r,M.round(X),M.round(Y));
  }
  dc.setPenWidth(1);
 }else if(DesignTyp==1){ 
  //Punkte
  var arrP=[r*0.97,r*0.89,r*0.81,r*0.73];
  aP=[:rP,:rP];
  var rP=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
  for(var w=0;w<arrW.size();++w){
   for(var p=0;p<arrP.size();++p){
    dis=arrP[p];
    Wi=arrW[w];
    MyBugView.Koord();
    dc.fillCircle(M.round(X),M.round(Y),rP);
   }
  }
  if(MT!=2){
   arrW=[140,220];
   for(var w=0;w<arrW.size();++w){
    dis=r*0.97;
    Wi=arrW[w];
    MyBugView.Koord();
    dc.fillCircle(M.round(X),M.round(Y),rP);
   }
  }
 }else if(DesignTyp==2){ 
  //Quadrate
  var arrP=[r*0.97,r*0.89,r*0.81,r*0.73];
  aP=[:rP,:rP];
  var rP=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
  for(var w=0;w<arrW.size();++w){
   for(var p=0;p<arrP.size();++p){
    dis=arrP[p];
    Wi=arrW[w];
    MyBugView.Koord();
    dc.fillRectangle(M.round(X)-rP,M.round(Y)-rP,rP*2,rP*2);
   }
  }
 }
 //Seckeck
 //Detailfarbe
 dc.setAntiAlias(true);
 arrW=[45,90,135,225,270,315];
 var arrP=new [6]; 
 for(var w=0;w<arrW.size();++w){
  dis=r*f+2;
  Wi=arrW[w];
  MyBugView.Koord();
  arrP[w]=[M.round(X),M.round(Y)];
 }
 var poly=[arrP[0],arrP[1],arrP[2],arrP[3],arrP[4],arrP[5]];
 dc.fillPolygon(poly);
 //Schwarz
 dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);   
 arrW=[45,90,135,225,270,315];
 for (var w=0;w<arrW.size();++w){
  dis=r*f-1;
  Wi=arrW[w];
  MyBugView.Koord();
  arrP[w]=[M.round(X),M.round(Y)];
 }
 var poly1=[arrP[0],arrP[1],arrP[2],arrP[3],arrP[4],arrP[5]];
 dc.fillPolygon(poly1);
 dc.setAntiAlias(false);
 //Kurze vert. Linien neben BT und AL
 dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);   
 if(MT==0){
  dc.drawLine(74,43,74,24);
  dc.drawLine(166,43,166,24);
 }else if(MT==1){
  dc.drawLine(80,46,80,26);
  dc.drawLine(180,46,180,26);
 }else if(MT==2){
  dc.drawLine(86,49,86,28);
  dc.drawLine(194,49,194,28);
 }
 //Horizontale Linie ganz oben und unten
 dc.fillRectangle(r-50,0,100,4);
 dc.fillRectangle(r-50,(2*r)-4,100,4);
}

function rip(dc,Birth,Datum){
 //Schwarz
 var f=0.62;
 var arrP=new [6];
 dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);   
 var arrW=[45,90,135,225,270,315];
 for(var w=0;w<arrW.size();++w){
  dis=r*f-1;
  Wi=arrW[w];
  MyBugView.Koord();
  arrP[w]=[M.round(X),M.round(Y)]; 
 }
 var poly1=[arrP[0],arrP[1],arrP[2],arrP[3],arrP[4],arrP[5]];
 dc.fillPolygon(poly1);
 //Grabstein
 f=1.25;
 if(r==130){f=1.3;}
 if(r==140){f=1.4;}
 dc.setPenWidth(2);
 dc.setAntiAlias(true);
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 dc.drawEllipse(r,r-3-20*f,24*f,12*f); //oben
 dc.drawEllipse(r,r-3+33*f,36*f,10*f); //unten
 dc.setColor(MyTimeBg,MyTimeBg);
 dc.fillEllipse(r,r-3-20*f,22*f,10*f); //oben
 dc.fillEllipse(r,r-3+33*f,36*f,8*f); //unten
 dc.fillRectangle(r-25*f,r-3-20*f,50*f,14*f); //oben
 dc.fillRectangle(r-37*f,r-3+33*f,76*f,12*f); //unten
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 //Linke Kante
 dc.drawLine(r-24*f,r-3-20*f,r-24*f,r-3-15*f);
 dc.drawLine(r-24*f,r-3-15*f,r-20*f,r-3-13*f);
 dc.drawLine(r-20*f,r-3-13*f,r-24*f,r-3-11*f);
 dc.drawLine(r-24*f,r-3-11*f,r-24*f,r-3+25*f);
 //Rechte Kante
 dc.drawLine(r+24*f,r-3-20*f,r+24*f,r-3+2*f);
 dc.drawLine(r+24*f,r-3+2*f,r+20*f,r-3+4*f);
 dc.drawLine(r+20*f,r-3+4*f,r+24*f,r-3+8*f);
 dc.drawLine(r+24*f,r-3+8*f,r+24*f,r-3+25*f);
 //Dreckpunkte
 dc.drawPoint(r-27*f,r-3+30*f);
 dc.drawPoint(r-24*f,r-3+33*f);
 dc.drawPoint(r-20*f,r-3+34*f);
 dc.drawPoint(r-18*f,r-3+31*f);
 dc.drawPoint(r-14*f,r-3+33*f);
 dc.drawPoint(r-8*f,r-3+29*f);
 dc.drawPoint(r-2*f,r-3+33*f);
 dc.drawPoint(r+1*f,r-3+28*f);
 dc.drawPoint(r+5*f,r-3+33*f);
 dc.drawPoint(r+12*f,r-3+31*f);
 dc.drawPoint(r+16*f,r-3+34*f);
 dc.drawPoint(r+19*f,r-3+31*f);
 dc.drawPoint(r+26*f,r-3+33*f);
 //dc.drawPoint(r+13*f,r-3-11*f);
 dc.setAntiAlias(false);
 //Inschriften
 dc.drawText(r,r-3-16*f,FT_MyBug,"R.I.P.",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 dc.drawText(r-4,r-3-1*f,FT_MyBug,Birth,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 dc.drawText(r+1,r-3+12*f,FT_MyBug,"- "+ Datum.year,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 dc.setPenWidth(1);
}