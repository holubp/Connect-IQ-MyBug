using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.Math as M;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

function draw_weath_today(dc,MT){

var xAmp=99;
var yAmp=99;
var xTemp=99;
var yTemp=99;
var xI=99;
var yI=99;
if(Ast.getValue("WebAlert")==true&&Ast.getValue("owmAlert")==true){
 aP=[:X62,:Y62];
 xAmp=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 yAmp=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X60,:Y60];
 xTemp=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 yTemp=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X61,:Y61];
 xI=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 yI=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
//Alarme zeichnen
 webAlertIcon(dc);
}else{
 aP=[:X46,:Y46];
 xAmp=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 yAmp=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X58,:Y58];
 xTemp=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 yTemp=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X59,:Y59];
 xI=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 yI=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
}
aP=[:X47,:Y47];
var xText=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
var yText=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
aP=[:X48,:Y48];
var xLoc=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
var yLoc=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
aP=[:X49,:Y49];
var xFeels=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
var yFeels=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();

dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);

//Wetter 
if(appid1.equals("")){ //Hier gehts nur rein,wenn ein openweathermap vorhanden ist
 dc.drawText(r,r+(r*0.7),FT_MyBug,"OpenWeatherMap-Key!",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
}else{
 if(Ast.getValue("WebWeatherCode")){ //Sobald der WebRequest dieses Feld erzeugt hat
  if(Ast.getValue("WebWeatherCode")!=null){
   if(Ast.getValue("WebWeatherCode")==200){ //Falls erfolgreich
    //Aktuelles Wetter Temp und Ort
    var WebTemp=Ast.getValue("WebTemp");
    var WebOrt=Ast.getValue("WebOrt");
    var textToday=Ast.getValue("WebWeatText");
    var feelsToday=Ast.getValue("WebTempFeel");
    var ortLen=WebOrt.length();//Anz Zeichen des WebOrtes auslesen
    var textLen=textToday.length();//Anz Zeichen des Wetter Text auslesen
    var OrtLenMax=14; 
    var textLenMax=19;
    //Ortsangabe kürzen
    if(ortLen>OrtLenMax && schnarch==false){ 
     var sekWake=8;// 8=Anz. Sekunden des WakeUp
     var LenDiff=WebOrt.length()-OrtLenMax; //Differenz Anz. Zeichen zwischen ist und Max
     var LenDiffFaktor=(LenDiff/sekWake).toNumber()+1; 
     var WebOrtText=WebOrt.substring(LenDiffFaktor*ortCount,OrtLenMax+(LenDiffFaktor*ortCount));
     dc.drawText(xLoc,yLoc,FT_MyBug,WebOrtText,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     ortCount=ortCount+1;
     if(ortCount>7||LenDiffFaktor*ortCount>WebOrt.length()-OrtLenMax){ortCount=0;}
    }else{
     //Wenn länger Max aber schlaf,dann kürzen
     if(ortLen>OrtLenMax){
      dc.drawText(xLoc,yLoc,FT_MyBug,WebOrt.substring(0,OrtLenMax-1)+"..",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     }else{
      dc.drawText(xLoc,yLoc,FT_MyBug,WebOrt,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     }
    }
    //Wettertext kürzen
     if(textLen>textLenMax&&schnarch==false){ 
      var sekWake=8;// 8=Anz. Sekunden des WakeUp
      var LenDiff=textToday.length()-textLenMax; //Differenz Anz. Zeichen zwischen ist und Max
      var LenDiffFaktor=(LenDiff/sekWake).toNumber()+1; 
      var textTodayText=textToday.substring(LenDiffFaktor*textCount,textLenMax+(LenDiffFaktor*textCount));
      dc.drawText(xText,yText,FT_MyBug,textTodayText,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      textCount=textCount+1;
      if(textCount>7||LenDiffFaktor*textCount>textToday.length()-textLenMax){textCount=0;}
     }else{
      //Wenn länger Max aber schlaf,dann kürzen
      if(textLen>textLenMax){
       dc.drawText(xText,yText,FT_MyBug,textToday.substring(0,textLenMax-1)+"..",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }else{
       dc.drawText(xText,yText,FT_MyBug,textToday,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }
     }
     //Temperatur und feels zeichnen
     dc.drawText(xTemp,yTemp,FT_MyBug,WebTemp.toNumber()+"°",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     if(Ast.getValue("langi").equals("de")){
      dc.drawText(xFeels,yFeels,FT_MyBug,"gefühlt: "+M.round(feelsToday).toNumber()+"°",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     }else{
      dc.drawText(xFeels,yFeels,FT_MyBug,"feels: "+M.round(feelsToday).toNumber()+"°",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     }
     //Icon
     var WebIcon=Ast.getValue("WebIcon");
     WebIcon=WebIcon.substring(0,2);
     if(WebIcon.equals("01")){ 
      draw_icon_01(dc,xI,yI);
     }else if(WebIcon.equals("02")){ 
      draw_icon_02(dc,xI,yI);
     }else if(WebIcon.equals("03")){
      draw_icon_03(dc,xI,yI);
     }else if(WebIcon.equals("04")){
      draw_icon_04(dc,xI,yI);
     }else if(WebIcon.equals("09")){
      draw_icon_09(dc,xI,yI);
     }else if(WebIcon.equals("10")){
      draw_icon_10(dc,xI,yI);
     }else if(WebIcon.equals("11")){
      draw_icon_11(dc,xI,yI);
     }else if(WebIcon.equals("13")){
      draw_icon_13(dc,xI,yI);
     }else if(WebIcon.equals("50")){
      draw_icon_50(dc,xI,yI);
     }
     dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT); 
    }
   }
  }else{
   if(Ast.getValue("langi").equals("de")){   
    dc.drawText(r,r+(r*0.7),FT_MyBug,"...Moment bitte...",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }else{
    dc.drawText(r,r+(r*0.7),FT_MyBug,"...just a moment...",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }
  }
 }
 //Aktualität der positiven Webabfragen,Ampel
 if(Ast.getValue("WebWeatherCode")){ 
  if(Ast.getValue("WebWeatherCode")!=null ){ 
   if(Ast.getValue("WebWeatherCode")==200 ){ 
    //Zeitdifferenz zu den geglückten Abfragen für die Ampel
    var WebWeatherTR=Ast.getValue("WebWeatherTR"); //Letzte erfolgreiche Antwort
    var alertCount=Ast.getValue("alertCount");
    if(alertCount==null){alertCount=0;}
    var diffWeather=T.now().value()-WebWeatherTR;
    if(diffWeather<=3600){//Sonst Grün
     dc.setColor(Gc.COLOR_GREEN,Gc.COLOR_TRANSPARENT);
     if(alertCount>0){
      dc.fillCircle(xAmp,yAmp,4);
     }else{
      dc.fillCircle(xAmp-(r*0.1)+(2*r*0.1)/60*diffWeather/60,yAmp,4);
     }
     if(owmMin==true){weathTime=true;}
    }else if(diffWeather>7200){//Grösser 2 Std Rot
     dc.setColor(Gc.COLOR_RED,Gc.COLOR_TRANSPARENT);
     if(diffWeather>10800){diffWeather=10800;}
     if(alertCount>0){
      dc.fillCircle(xAmp,yAmp,4);
     }else{
      dc.fillCircle(xAmp-(r*0.1)+(2*r*0.1)/60*(diffWeather-7200)/60,yAmp,4);
     }
     weathTime=false;
     precMax=0.0;
    }else if(diffWeather>3600){//Grösser 1 Std. Orange
     dc.setColor(0xff5500,Gc.COLOR_TRANSPARENT);
     if(alertCount>0){
      dc.fillCircle(xAmp,yAmp,4);
     }else{
      dc.fillCircle(xAmp-(r*0.1)+(2*r*0.1)/60*(diffWeather-3600)/60,yAmp,4);
     }
     weathTime=false;
     precMax=0.0;
    }
    dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
    if(alertCount==0||owmAlert==false){
     dc.drawLine(xAmp-(r*0.1),yAmp,xAmp+(r*0.1),yAmp);
     dc.drawLine(xAmp-(r*0.1),yAmp+3,xAmp-(r*0.1),yAmp-3);
     dc.drawLine(xAmp+(r*0.1),yAmp+3,xAmp+(r*0.1),yAmp-3);
    }
   }
  }
 } 
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
}