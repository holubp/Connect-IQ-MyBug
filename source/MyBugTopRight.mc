using Toybox.Graphics as Gc;
using Toybox.Math as M;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;
using Toybox.Application.Storage as Ast;

function draw_bpm(dc,hr,Birth,Datum,restBPM){
 aP=[:X21,:Y21];
 var heaX=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var heaY=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X22,:Y22];
 var heaXZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var heaYZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X50,:Y50];
 var heaXZahlRest=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var heaYZahlRest=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 dc.drawText(heaXZahl,heaYZahl,FT_MyBug,hr,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 if(restBPM==null){restBPM="-";}
 dc.drawText(heaXZahlRest,heaYZahlRest,FT_MyBug,restBPM,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 //Herz zeichnen
 dc.setAntiAlias(true);
 dc.fillCircle(heaX+4,heaY-6,6);
 dc.fillCircle(heaX-4,heaY-6,6); 
 var poly=[[heaX,heaY+10],[heaX-9,heaY-2],[heaX,heaY-6],[heaX+10,heaY-2]];
 dc.fillPolygon(poly);
 dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
 dc.drawLine(heaX-15,heaY-3,heaX-5,heaY-3);
 dc.drawLine(heaX-5,heaY-3,heaX-3,heaY-10);
 dc.drawLine(heaX-3,heaY-10,heaX,heaY+3);
 dc.drawLine(heaX,heaY+3,heaX+2 ,heaY-3);
 dc.drawLine(heaX+2 ,heaY-3,heaX+15 ,heaY-3);
 dc.setAntiAlias(false);
}

function draw_Cal(dc,Kalo,Gender,Birth,Kg,Cm){
 Kg=Kg/1000;
 aP=[:X23,:Y23];
 var xCal=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yCal=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X24,:Y24];
 var xCalAktiv=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yCalAktiv=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X25,:Y25];
 var xCalTotal=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yCalTotal=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Kalorien
 var actCal;
 if(Kg!=null&&Cm!=null&&Birth!=null&&Gender!=null){
  var restCalories=0;
  if(Gender==0){ //Frau
   restCalories=(-197.6)-6.116*(Jahr.toNumber()-Birth.toNumber())+7.628*Cm+12.2*Kg;
  }else{ //Mann
   restCalories=5.2-6.116*(Jahr.toNumber()-Birth.toNumber())+7.628*Cm+12.2*Kg;
  }
  restCalories=M.round((Stunde.toNumber()*60+Minute.toNumber())*restCalories/1440 ).toNumber();
  actCal=Kalo-restCalories;
  if(actCal<0){actCal=0;}
 }else{
  actCal="-";
 }
 dc.drawText(xCalTotal,yCalTotal,FT_MyBug,Kalo,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 dc.drawText(xCalAktiv,yCalAktiv,FT_MyBug,actCal,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 if(Ast.getValue("langi").equals("de")){   
  dc.drawText(xCal,yCal,FT_MyBug,"Kal",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(xCal,yCal,FT_MyBug,"cal",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}

function draw_bmi(dc,Kg,Cm){
 aP=[:X26,:Y26];
 var xBMI=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yBMI=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X27,:Y27];
 var xBMIAmpel=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yBMIAmpel=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X28,:Y28];
 var xBMIZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yBMIZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Hamburgersymbol
 dc.setAntiAlias(true);
 dc.drawLine(xBMI,yBMI-1,xBMI+15,yBMI-1);
 dc.drawArc(xBMI+7,yBMI+3,9,0,35,145);
 dc.drawRoundedRectangle(xBMI-2,yBMI,19,5,2);
 dc.drawRoundedRectangle(xBMI,yBMI+5,15,4,2);
 dc.drawPoint(xBMI+5,yBMI-3);
 dc.drawPoint(xBMI+8,yBMI-4);
 dc.setAntiAlias(false);
 if(Kg!=null&&Cm!=null){ //Nur wenn die nötigen Angaben vorhanden sind
  Cm=Cm/100; //cm in Meter
  var bmi=Kg/1000/Cm/Cm;
  if(bmi < 16){dc.setColor(Gc.COLOR_PURPLE,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 16 && bmi <= 16.9){dc.setColor(Gc.COLOR_DK_BLUE,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 17 && bmi <= 18.4){dc.setColor(Gc.COLOR_BLUE,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 18.5 && bmi <= 24.9){dc.setColor(Gc.COLOR_GREEN,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 25 && bmi <= 29.9){dc.setColor(Gc.COLOR_YELLOW,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 30 && bmi <= 34.9){dc.setColor(Gc.COLOR_ORANGE,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 35 && bmi <= 39.9){dc.setColor(Gc.COLOR_RED,Gc.COLOR_TRANSPARENT);}
  else if(bmi >= 40){dc.setColor(Gc.COLOR_DK_RED,Gc.COLOR_TRANSPARENT);}
  dc.fillCircle(xBMI-3,yBMI-18,3);
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.drawText(xBMIZahl,yBMIZahl,FT_MyBug,bmi.format("%.1f"),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.fillCircle(xBMI-3,yBMI-18,3);
  var bmi="-";
  dc.drawText(xBMIZahl,yBMIZahl,FT_MyBug,bmi,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}
