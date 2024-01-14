using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Math as M;
using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

function draw_wind(dc){
 aP=[:X37,:Y37];
 var xWind=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yWind=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X38,:Y38];
 var xWindZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yWindZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X39,:Y39];
 var xWindKmh=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yWindKmh=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Richtungs-Symbol
 dc.setAntiAlias(true);
 if(Ast.getValue("WebWindDeg")){
  var WebWindDeg=Ast.getValue("WebWindDeg").toNumber()-50-180;//Die Richtung um 180 Grad drehen
  if(WebWindDeg<0){WebWindDeg=WebWindDeg+360;}
   var arrWindDis=[9,12,3,12]; //4 Distanzen,um den Pfeil zu zeichnen
   var arrWindWiDef=[0,135,180,225]; //Vier Wi für den Pfeil
   var arrWindWi=new[4];
   for(var w=0;w<4;w=w+1){
    arrWindWi[w]=WebWindDeg+arrWindWiDef[w]; //Wi zur Windrichtung dazuzählen
    if(arrWindWi[w]>360){arrWindWi[w]=arrWindWi[w]-360;}
  }
  //Mehrdim Array muss vordefiniert werden
  var arrWindPts=[[1,1],[1,1],[1,1],[1,1]];
  for(var w=0; w<4; w=w+1){
   dis=arrWindDis[w];
   Wi=arrWindWi[w];
   Wi=Wi-90; //Null bei Garmin ist bei 3 Uhr
   if(Wi<0){Wi=Wi+360;} //Unter 0 abfangen
   Wi=Wi*(-1)+360; //Umkehren
   radWi=M.toRadians(Wi); //an Rad
   X=M.cos(radWi)*dis;
   Y=M.sin(radWi)*dis;
   //Schauen,an welchen Quadrant die Koo liegt
   if(Wi>0&&Wi<=90){X=r+X;Y=r-Y;}
   else if (Wi>90&&Wi<=180){X=r+X;Y=r-Y;}
   else if (Wi>180&&Wi<=270){X=r+X;Y=r-Y;}
   else if (Wi>270&&Wi<=360){X=r+X;Y=r-Y;}
   arrWindPts[w][0]=X-r+xWind;
   arrWindPts[w][1]=Y-r+yWind;
  }
  dc.fillPolygon(arrWindPts);
 }
 dc.setAntiAlias(false);
 //Text
 if (Ast.getValue("WebWindSpeed")) {
  var WebWindSpeed=(Ast.getValue("WebWindSpeed")-50); //-50 ist ein Wert den ich beim Speichern dazuzähle aus irgendwelchen Gründen
  if(beau==true){
  	if(Ast.getValue("tempUnits").equals("metric")){
  	 WebWindSpeed=(WebWindSpeed*3.6).toNumber();
  	 var arrBeau=[0,1,5,11,19,28,38,49,61,74,88,102,117,999];//kmh
  	 for(var w=0;w<arrBeau.size();++w){
  	  if(WebWindSpeed>=arrBeau[w]&&WebWindSpeed<=arrBeau[w+1]){
  	   dc.drawText(xWindZahl,yWindZahl,FT_MyBug,w,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  	   break;
  	  }
  	 }
  	}else{
  	 var arrBeau=[0.0,1.2,4.6,8.1,12.7,18.4,25.3,32.2,39.1,47.2,55.2,64.4,73.6,999.0];//mph
  	 for(var w=0;w<arrBeau.size();++w){
  	  if(WebWindSpeed>=arrBeau[w]&&WebWindSpeed<arrBeau[w+1]){
  	   dc.drawText(xWindZahl,yWindZahl,FT_MyBug,w,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  	   break;
  	  }
  	 }
  	}
    dc.drawText(xWindKmh,yWindKmh,FT_MyBug,"Bft",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  }else{
   if(Ast.getValue("tempUnits").equals("metric")){
    WebWindSpeed=(WebWindSpeed*3.6).toNumber();
    dc.drawText(xWindKmh,yWindKmh,FT_MyBug,"km/h",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    dc.drawText(xWindZahl,yWindZahl,FT_MyBug,WebWindSpeed.toString(),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }else{
    WebWindSpeed=WebWindSpeed.toNumber();
    dc.drawText(xWindKmh,yWindKmh,FT_MyBug,"mph",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    dc.drawText(xWindZahl,yWindZahl,FT_MyBug,WebWindSpeed.toString(),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }
  }
 }else{
  dc.drawText(xWind,yWind,FT_MyBug,"",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}

function draw_press(dc) {
 aP=[:X40,:Y40];
 var xPress=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yPress=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X41,:Y41];
 var xPressZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yPressZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X42,:Y42];
 var xPresshPa=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yPresshPa=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 if (Ast.getValue("WebPressure") ) { 
  var WebPress=Ast.getValue("WebPressure");
  //Druck
  dc.drawCircle(xPress,yPress,7);
  dc.drawArc(xPress,yPress,5,1,225,315);
  dc.fillCircle(xPress,yPress,1);
  dc.setColor(Gc.COLOR_RED,Gc.COLOR_TRANSPARENT);
  dc.setPenWidth(2);
  dc.drawLine(xPress,yPress,xPress+5,yPress-5);
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.setPenWidth(1);
  dc.drawText(xPressZahl,yPressZahl,FT_MyBug,WebPress,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xPresshPa,yPresshPa,FT_MyBug,"hPa",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(xPress,yPress,FT_MyBug,"",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}

function draw_wet(dc) {
 aP=[:X43,:Y43];
 var xWet=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yWet=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X44,:Y44];
 var xWetZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yWetZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X45,:Y45];
 var xWetPro=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yWetPro=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 if (Ast.getValue("WebHumidity") ) { 
  var WebHumi=Ast.getValue("WebHumidity");
  //Feuchtigkeit
  dc.drawArc(xWet,yWet+2,5,1,45,135);
  dc.fillCircle(xWet,yWet+2,3);
  dc.drawLine(xWet,yWet-7,xWet-4,yWet-1);
  dc.drawLine(xWet,yWet-6,xWet+4,yWet-1);
  dc.drawText(xWetZahl,yWetZahl,FT_MyBug,WebHumi,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xWetPro,yWetPro,FT_MyBug,"%",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(xWet,yWet,FT_MyBug,"",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
}
