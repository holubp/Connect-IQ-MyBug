using Toybox.Graphics as Gc;
using Toybox.WatchUi as Ui;

function draw_batt(dc,battStat){
 aP=[:X2,:Y2];
 var xBatt=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yBatt=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X3,:Y3];
 var xBattText=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yBattText=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Kritische Zustände anders einfärben
 if( battStat>20){
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
 }else if(battStat>10){
  dc.setColor(Gc.COLOR_RED,Gc.COLOR_TRANSPARENT);
 }else if(battStat>0){
  dc.setColor(Gc.COLOR_DK_RED,Gc.COLOR_TRANSPARENT);
 }
 dc.setPenWidth(1);
 dc.fillRoundedRectangle(xBatt+1,yBatt+1,0.4*battStat.toFloat(),14,2);
 //Symbolumrisse
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 dc.drawRoundedRectangle(xBatt,yBatt,41,16,3);
 dc.fillRoundedRectangle(xBatt+40,yBatt+4,5,8,1);
 //Batteriestriche
 for (var i=1;i<(battStat/10).toNumber()+1; i=i+1){
  dc.drawLine(xBatt+(i*4),yBatt+3,xBatt+(i*4),yBatt+13);
 }
 dc.drawText(xBattText,yBattText,FT_MyBug,battStat+"%",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER); 
}

function draw_bt(dc,telConn){
 //Ausgefüllt oder leer
 aP=[:X4,:Y4];
 var btX=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
 var btY=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 dc.setPenWidth(1);
 if(telConn==true){
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
  dc.drawText(btX,btY,FT_MyBug_BT_AL,"BT",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(btX,btY,FT_MyBug_BT_AL,"BT",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}

function draw_mess(dc,AnzNach){
 aP=[:X5,:Y5];
 var mX=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var mY=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X6,:Y6];
 var mXAnz=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var mYAnz=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X52,:Y52];
 var mXNull=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var mYNull=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 if(AnzNach>0){
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
  dc.fillRoundedRectangle( mX-17,mY-9,35,19,3);
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.drawRoundedRectangle( mX-17,mY-9,35,19,3);
  dc.drawLine(mX-15,mY-7,mX,mY+3);
  dc.drawLine(mX,mY+3,mX+15,mY-7);
  dc.drawLine(mX-15,mY+7,mX-4,mY);
  dc.drawLine(mX+4,mY,mX+15,mY+7);
  dc.drawText(mXAnz,mYAnz,FT_MyBug,AnzNach,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  mX=mXNull;
  mY=mYNull;
  dc.drawRoundedRectangle(mX-17,mY-9,35,19,3);
  dc.drawLine(mX-15,mY-7,mX,mY+3);
  dc.drawLine(mX,mY+3,mX+15,mY-7);
  dc.drawLine(mX-15,mY+7,mX-4,mY);
  dc.drawLine(mX+4,mY,mX+15,mY+7);
 }
}

function draw_ala(dc,AnzAlarm){
 aP=[:X7,:Y7];
 var alX=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var alY=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 //Wecker zeichnen
 if(AnzAlarm > 0){ 
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
  dc.drawText(alX,alY,FT_MyBug_BT_AL,"AL",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(alX,alY,FT_MyBug_BT_AL,"AL",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}