using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Math as M;
using Toybox.System as Sys;
using Toybox.UserProfile as UP;
using Toybox.ActivityMonitor as AM;
using Toybox.WatchUi as Ui;

function draw_dist(dc,Dist,schritteGoal) {
 aP=[:X12,:Y12];
 var xDist=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yDist=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X13,:Y13];
 var xDistKM=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yDistKM=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X14,:Y14];
 var xDistZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yDistZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 //Distanz
 if(mile==false){
  dc.drawText(xDistZahl,yDistZahl,FT_MyBug,Dist,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xDistKM,yDistKM,FT_MyBug,"km",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(xDistZahl,yDistZahl,FT_MyBug,(Dist.toFloat()*0.621371).format("%.1f"),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xDistKM,yDistKM,FT_MyBug,"mi",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
 //Distanz-Icon
 dc.setPenWidth(2);
 dc.drawCircle(xDist,yDist+2,4);
 dc.drawPoint(xDist,yDist+2);
 var poly7=[[xDist-4,yDist+6],[xDist,yDist+13],[xDist+4,yDist+6],[xDist-4,yDist+6]];
 dc.fillPolygon(poly7);
 dc.drawPoint(xDist+7,yDist+11); 
 dc.drawPoint(xDist+10,yDist+9); 
 dc.drawPoint(xDist+12,yDist+6); 
 xDist=xDist+12;
 yDist=yDist-5;
 dc.drawCircle(xDist,yDist-1,3);
 dc.drawPoint(xDist,yDist-1);
 poly7=[[xDist-3,yDist+3],[xDist,yDist+7],[xDist+3,yDist+3],[xDist-3,yDist+3]];
 dc.fillPolygon(poly7);
 dc.setPenWidth(1);
}

function draw_step(dc,Schritte,schritteGoal) {
 aP=[:X15,:Y15];
 var stepX=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var stepY=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X16,:Y16];
 var stepXZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var stepYZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X17,:Y17];
 var stepX10=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var stepY10=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Schritte
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 var strSchritte=Schritte.toString();
 //Bei Schritte>10'000 die vorderste Stelle abschneiden
 if (Schritte>9999) {
  var SchritteText=strSchritte.substring(1,strSchritte.length()); //10tausender abschneiden
  var SchritteKm=strSchritte.substring(0,1)+"0K";
  dc.drawText(stepX10,stepY10,FT_MyBug,SchritteKm,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(stepXZahl,stepYZahl,FT_MyBug,SchritteText,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 } else {
  dc.drawText(stepX10,stepY10,FT_MyBug,"-",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(stepXZahl,stepYZahl,FT_MyBug,Schritte,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
 //Schritte Fortschritt
 dc.setPenWidth(3);
 dc.setAntiAlias(true);
 dis=r*0.68;
 Wi=275;
 MyBugView.Koord();
 var anaX=X;
 var anaY=Y;
 dis=r*0.68;
 Wi=310;
 MyBugView.Koord();
 dc.drawLine(anaX,anaY,X,Y);
 if (Schritte>0) {
  if (Schritte>schritteGoal){Schritte=schritteGoal;}
  var proSchritte=Schritte.toFloat()/schritteGoal.toFloat()*100;
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT); 
  var lengthStep=M.sqrt(((X-anaX)*(X-anaX))+((Y-anaY)*(Y-anaY)));
  dis=(lengthStep/100.0*proSchritte);
  Wi=23;
  MyBugView.Koord();
  dc.drawLine(anaX,anaY,X-(r-anaX),Y-(r-anaY));
 }
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 dc.setPenWidth(1);
 //Schuh oben
 stepX=stepX+1; 
 stepY=stepY+1;
 dc.fillCircle(stepX-1,stepY,2);
 dc.fillRectangle(stepX-1,stepY-2,4,5);
 dc.fillEllipse(stepX+8,stepY,4,3);
 //Schuh unten
 stepX=stepX-8;
 stepY=stepY+7;
 dc.fillCircle(stepX-1,stepY,2);
 dc.fillRectangle(stepX-1,stepY-2,4,5);
 dc.fillEllipse(stepX+8,stepY,4,3);
 dc.setAntiAlias(false);
}

function draw_Tr(dc,etaPlus,etaMinus,etaPlusGoal) {
 aP=[:X18,:Y18];
 var xTr=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yTr=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X19,:Y19];
 var xTrPlus=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yTrPlus=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X20,:Y20];
 var xTrMinus=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yTrMinus=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Etagen plus
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 if(AM.getInfo() has :floorsClimbed){
  dc.drawText(xTrPlus,yTrPlus,FT_MyBug,etaPlus,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xTrMinus,yTrMinus,FT_MyBug,etaMinus,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(xTrPlus,yTrPlus,FT_MyBug,"-",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xTrMinus,yTrMinus,FT_MyBug,"-",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
 dc.setPenWidth(2);
 dc.drawLine(xTr-12,yTr+3,xTr-6,yTr+3);
 dc.drawLine(xTr-6,yTr+3,xTr-6,yTr-3);
 dc.drawLine(xTr-6,yTr-3,xTr,yTr-3);
 dc.drawLine(xTr,yTr-3,xTr,yTr-9);
 dc.drawLine(xTr,yTr-9,xTr+8,yTr-9);
 //Treppenfortschritt
 dc.setPenWidth(3);
 dis=r*0.68;
 Wi=275;
 MyBugView.Koord();
 var anaX=X;
 var anaY=Y;
 dis=r*0.68;
 Wi=310;
 MyBugView.Koord();
 dc.drawLine(anaX,anaY,X,Y);
 if(etaPlus>0){
  if(etaPlus>etaPlusGoal){etaPlus=etaPlusGoal;}
  var proTreppen=etaPlus.toFloat()/etaPlusGoal.toFloat()*100;
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT); 
  var stairStep=M.sqrt(((X-anaX)*(X-anaX))+((Y-anaY)*(Y-anaY)));
  dis=(stairStep/100.0*proTreppen);
  Wi=23;
  MyBugView.Koord();
  dc.drawLine(anaX,anaY,X-(r-anaX),Y-(r-anaY));
 }
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 dc.setPenWidth(1);
}