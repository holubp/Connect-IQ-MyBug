using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.Lang as L;
using Toybox.Math as M;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

function draw_Hoe(dc){
 aP=[:X29,:Y29];
 var xHoe=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yHoe=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X30,:Y30];
 var xHoeZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yHoeZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X31,:Y31];
 var xHoeAmpel=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yHoeAmpel=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 //Höhe aus GPS-Lage oder API
 dc.setAntiAlias(true);
 //Symbol
 var poly5=[[xHoe-8,yHoe+4],[xHoe -4,yHoe-4],[xHoe,yHoe-1],[xHoe+6,yHoe-10],[xHoe+12,yHoe+4]];
 dc.fillPolygon(poly5);
 dc.setColor(MyTimeBg,MyTimeBg);
 var poly6=[[xHoe+3,yHoe-2],[xHoe+6,yHoe-8],[xHoe+8,yHoe-3]];
 dc.fillPolygon(poly6);
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 dc.setAntiAlias(false);
 //Höhe Text
 var H; //Variable fürs Display
 var Hfrom;
 if(Ast.getValue("WebHfrom")){
  Hfrom=Ast.getValue("WebHfrom");
 }else{
  Hfrom="";
 }
 if(Ast.getValue("alti")){
  if(Ast.getValue("WebHCode")){
   if(Ast.getValue("WebHCode")==200){
    H=Ast.getValue("WebH").toNumber();
    dc.drawText(xHoeZahl,yHoeZahl,FT_MyBug,H,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    //Höhe Herkunft
    dc.drawText(xHoeAmpel,yHoeAmpel,FT_MyBug,Hfrom,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }else{
    H=Ast.getValue("alti").toNumber(); //Wenn es keinen Höhenkorrektur Key hat,dann die GPS Höhe
    dc.drawText(xHoeZahl,yHoeZahl,FT_MyBug,H,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    //Höhe Herkunft
    dc.drawText(xHoeAmpel,yHoeAmpel,FT_MyBug,Hfrom,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }
  } 
 }   
}

function draw_sun(dc){
 aP=[:X32,:Y32];
 var xSun=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var ySun=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X33,:Y33];
 var xSunAuf=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var ySunAuf=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X34,:Y34];
 var xSunAb=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var ySunAb=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 if(Ast.getValue("WebSunrise") && Ast.getValue("WebSunset")){
  //Symbol
  dc.fillCircle(xSun,ySun,5);
  dc.drawLine(xSun+7,ySun,xSun+9,ySun);
  dc.drawLine(xSun+5,ySun+5,xSun+7,ySun+7);
  dc.drawLine(xSun,ySun+7,xSun,ySun+9);
  dc.drawLine(xSun-5,ySun+5,xSun-7,ySun+7);
  dc.drawLine(xSun-7,ySun,xSun-9,ySun);
  dc.drawLine(xSun-5,ySun-5,xSun-7,ySun-7);
  dc.drawLine(xSun,ySun-7,xSun,ySun-9);
  dc.drawLine(xSun+5,ySun-5,xSun+7,ySun-7);
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  //Sonnenaufgang
  var sunriseMoment=new T.Moment(Ast.getValue("WebSunrise"));
  var sunriseDate= Gregorian.info(sunriseMoment,T.FORMAT_MEDIUM);
  var sunrise=L.format("$1$:$2$",[sunriseDate.hour.format("%02d"),sunriseDate.min.format("%02d")]);
  var sunsetMoment=new T.Moment(Ast.getValue("WebSunset"));
  var sunsetDate= Gregorian.info(sunsetMoment,T.FORMAT_MEDIUM);
  var sunset=L.format("$1$:$2$",[sunsetDate.hour.format("%02d"),sunsetDate.min.format("%02d")]); 
  dc.drawText(xSunAuf,ySunAuf,FT_MyBug,sunrise,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.drawText(xSunAb,ySunAb,FT_MyBug,sunset,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else{
  dc.drawText(xSun-5,ySun,FT_MyBug,"",Gc.TEXT_JUSTIFY_LEFT|Gc.TEXT_JUSTIFY_VCENTER);
 }
}

function draw_moon(dc){
 aP=[:X35,:Y35];
 var xMond=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yMond=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X36,:Y36];
 var xMondZahl=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yMondZahl=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();

 //Der erste VM muss immer kleiner sein als Heute
 var arrMond = [ "2021.09.21.01.54.42","2021.10.13.16.56.42","2021.11.19.09.57.30","2021.12.19.05.35.36","2022.01.18.00.48.30","2022.02.16.17.56.30","2022.03.18.07.17.36","2022.04.16.20.55.06","2022.05.16.06.14.12","2022.06.14.13.51.48","2022.07.13.20.37.42","2022.08.12.03.35.48","2022.09.10.11.59.06","2022.10.09.22.55.00","2022.11.08.12.02.12","2022.12.08.05.08.12","2023.01.07.00.07.54","2023.02.05.19.28.36","2023.03.07.13.40.24","2023.04.06.06.34.36","2023.05.05.19.34.06","2023.06.04.05.41.48","2023.07.03.13.38.42","2023.08.01.20.31.42","2023.09.29.11.57.36","2023.10.28.22.24.06","2023.11.27.10.16.24","2023.12.27.01.33.12", "2024.01.25.18.53.57", "2024.02.24.13.30.22", "2024.03.25.08.00.16", "2024.04.24.01.48.55", "2024.05.23.15.53.05", "2024.06.22.03.07.48", "2024.07.21.12.17.04", "2024.08.19.20.25.44", "2024.09.18.04.34.24", "2024.10.17.13.26.21", "2024.11.15.22.28.28", "2024.12.15.10.01.38", "2025.01.13.23.26.51", "2025.02.12.14.53.19", "2025.03.14.07.54.35", "2025.04.13.02.22.12", "2025.05.12.18.55.52", "2025.06.11.09.43.45", "2025.07.10.22.36.42", "2025.08.09.09.54.58", "2025.09.07.20.08.49", "2025.10.07.05.47.33", "2025.11.05.14.19.15", "2025.12.05.00.14.00", "2026.01.03.11.02.50", "2026.02.01.23.09.10", "2026.03.03.12.37.49", "2026.04.02.04.11.54", "2026.05.01.19.23.06", "2026.05.31.10.45.07", "2026.06.30.01.56.35", "2026.07.29.16.35.37", "2026.08.28.06.18.26", "2026.09.26.18.48.57", "2026.10.26.05.11.44", "2026.11.24.15.53.29", "2026.12.24.02.28.09", "2027.01.22.13.17.18", "2027.02.21.00.23.34", "2027.03.22.11.43.43", "2027.04.21.00.27.04", "2027.05.20.12.58.55", "2027.06.19.02.44.14", "2027.07.18.17.44.48", "2027.08.17.09.28.35", "2027.09.16.01.03.26", "2027.10.15.15.46.55", "2027.11.14.04.25.50", "2027.12.13.17.08.42", "2028.01.12.05.02.59", "2028.02.10.16.03.40", "2028.03.11.02.05.59", "2028.04.09.12.26.31", "2028.05.08.21.48.50", "2028.06.07.08.08.41", "2028.07.06.20.10.41", "2028.08.05.10.09.42", "2028.09.04.01.47.29", "2028.10.03.18.24.53", "2028.11.02.10.17.15", "2028.12.02.02.40.08", "2028.12.31.17.48.25", "2029.01.30.07.03.30", "2029.02.28.18.10.09", "2029.03.30.04.26.18", "2029.04.28.12.36.41", "2029.05.27.20.37.22", "2029.06.26.05.22.12", "2029.07.25.15.35.37", "2029.08.24.03.51.05", "2029.09.22.18.29.11", "2029.10.22.11.27.27", "2029.11.21.05.02.51", "2029.12.20.23.46.24", "2030.01.19.16.54.15", "2030.02.18.07.19.41", "2030.03.19.18.56.22", "2030.04.18.05.19.53", "2030.05.17.13.19.00", "2030.06.15.20.40.52", "2030.07.15.04.11.50", "2030.08.13.12.44.15", "2030.09.11.23.17.46", "2030.10.11.12.46.42", "2030.11.10.04.30.10", "2030.12.09.23.40.19", "2031.01.08.19.25.42", "2031.02.07.13.46.04", "2031.03.09.05.29.30", "2031.04.07.19.21.10", "2031.05.07.05.39.43", "2031.06.05.13.58.22", "2031.07.04.21.01.12", "2031.08.03.03.45.26", "2031.09.01.11.20.21", "2031.09.30.20.57.42", "2031.10.30.08.32.32", "2031.11.29.00.18.19", "2031.12.28.18.32.52", "2032.01.27.13.52.20", "2032.02.26.08.43.04", "2032.03.27.01.46.08", "2032.04.25.17.09.31", "2032.05.25.04.37.03", "2032.06.23.13.32.22", "2032.07.22.20.51.23", "2032.08.21.03.46.40", "2032.09.19.11.30.05", "2032.10.18.20.57.58", "2032.11.17.07.41.53", "2032.12.16.21.48.50", "2033.01.15.14.06.56", "2033.02.14.08.04.01", "2033.03.16.02.37.14", "2033.04.14.21.17.12", "2033.05.14.12.42.33", "2033.06.13.01.19.01", "2033.07.12.11.28.22", "2033.08.10.20.07.30", "2033.09.09.04.20.22", "2033.10.08.12.57.57", "2033.11.06.21.31.55", "2033.12.06.08.21.54", "2034.01.04.20.46.55", "2034.02.03.11.04.21", "2034.03.05.03.09.57", "2034.04.03.21.18.41", "2034.05.03.14.15.31", "2034.06.02.05.53.48", "2034.07.01.19.44.20", "2034.07.31.07.54.16", "2034.08.29.18.49.04", "2034.09.28.04.56.37", "2034.10.27.14.42.19", "2034.11.25.23.31.59", "2034.12.25.09.54.17", "2035.01.23.21.16.23", "2035.02.22.09.53.42", "2035.03.23.23.41.55", "2035.04.22.15.20.33", "2035.05.22.06.25.35", "2035.06.20.21.37.15", "2035.07.20.12.36.38", "2035.08.19.03.00.04", "2035.09.17.16.23.19", "2035.10.17.04.35.21", "2035.11.15.14.48.41", "2035.12.15.01.32.58", "2036.01.13.12.15.54", "2036.02.11.23.08.29", "2036.03.12.10.09.16", "2036.04.10.22.22.20", "2036.05.10.10.09.19", "2036.06.08.23.01.45", "2036.07.08.13.19.04", "2036.08.07.04.48.42", "2036.09.05.20.45.21", "2036.10.05.12.14.56", "2036.11.04.01.44.03", "2036.12.03.15.08.17", "2037.01.02.03.35.03", "2037.01.31.15.03.55", "2037.03.02.01.27.56", "2037.03.31.11.53.19", "2037.04.29.20.53.39", "2037.05.29.06.23.53", "2037.06.27.17.19.40", "2037.07.27.06.14.53", "2037.08.25.21.09.05", "2037.09.24.13.31.27", "2037.10.24.06.36.17", "2037.11.22.22.35.00", "2037.12.22.14.38.23", "2038.01.21.04.59.42", "2038.02.19.17.09.09", "2038.03.21.03.09.20", "2038.04.19.12.35.45", "2038.05.18.20.23.16", "2038.06.17.04.30.15", "2038.07.16.13.47.58", "2038.08.15.00.56.32", "2038.09.13.14.24.08", "2038.10.13.06.21.35", "2038.11.11.23.26.55", "2038.12.11.18.30.09", "2039.01.10.12.45.15", "2039.02.09.04.38.57", "2039.03.10.17.34.42", "2039.04.09.04.52.28", "2039.05.08.13.19.43", "2039.06.06.20.47.23", "2039.07.06.04.03.11", "2039.08.04.11.56.21", "2039.09.02.21.23.15", "2039.10.02.09.22.59", "2039.10.31.23.35.58", "2039.11.30.17.49.17", "2039.12.30.13.37.26", "2040.01.29.08.54.23", "2040.02.28.01.59.14", "2040.03.28.17.11.23", "2040.04.27.04.37.33", "2040.05.26.13.46.46", "2040.06.24.21.18.58", "2040.07.24.04.05.17", "2040.08.22.11.09.20", "2040.09.20.19.42.27", "2040.10.20.06.49.31", "2040.11.18.20.05.50", "2040.12.18.13.15.25", "2041.01.17.08.11.03", "2041.02.16.03.20.55", "2041.03.17.21.18.47", "2041.04.16.14.00.18", "2041.05.16.02.52.02", "2041.06.14.12.58.21", "2041.07.13.21.00.28", "2041.08.12.04.04.19", "2041.09.10.11.23.29", "2041.10.09.20.02.19", "2041.11.08.05.43.08", "2041.12.07.18.41.52", "2042.01.06.09.53.34", "2042.02.05.02.57.25", "2042.03.06.21.09.34", "2042.04.05.16.15.34", "2042.05.05.08.48.13", "2042.06.03.22.47.55", "2042.07.03.10.09.01", "2042.08.01.19.32.56", "2042.08.31.04.01.57", "2042.09.29.12.33.56", "2042.10.28.20.48.01", "2042.11.27.07.05.39", "2042.12.26.18.42.22", "2043.01.25.07.56.15", "2043.02.23.22.57.34", "2043.03.25.15.25.55", "2043.04.24.09.22.39", "2043.05.24.01.36.35", "2043.06.22.16.20.14", "2043.07.22.05.23.48", "2043.08.20.17.04.07", "2043.09.19.03.46.41", "2043.10.18.13.55.18", "2043.11.16.22.52.06", "2043.12.16.09.01.37", "2044.01.14.19.50.45", "2044.02.13.07.41.23", "2044.03.13.20.40.47", "2044.04.12.11.38.46", "2044.05.12.02.16.16", "2044.06.10.17.15.43", "2044.07.10.08.21.36", "2044.08.08.23.13.28", "2044.09.07.13.24.00", "2044.10.07.02.29.40", "2044.11.05.13.26.21", "2044.12.05.00.33.31", "2045.01.03.11.20.04", "2045.02.01.22.05.07", "2045.03.03.08.52.15", "2045.04.01.20.42.35", "2045.05.01.07.51.46", "2045.05.30.19.51.59", "2045.06.29.09.15.22", "2045.07.29.00.10.09", "2045.08.27.16.07.14", "2045.09.26.08.11.08", "2045.10.25.23.30.47", "2045.11.24.12.43.08", "2045.12.24.01.48.50", "2046.01.22.13.50.53", "2046.02.21.00.43.52", "2046.03.22.10.26.31", "2046.04.20.20.20.39", "2046.05.20.05.14.50", "2046.06.18.15.09.34", "2046.07.18.02.54.34", "2046.08.16.16.49.39", "2046.09.15.08.38.55", "2046.10.15.01.40.51", "2046.11.13.18.04.01", "2046.12.13.10.55.00", "2047.01.12.02.20.53", "2047.02.10.15.39.22", "2047.03.12.02.36.32", "2047.04.10.12.34.49", "2047.05.09.20.23.59", "2047.06.08.04.04.24", "2047.07.07.12.33.20", "2047.08.05.22.38.00", "2047.09.04.10.53.42", "2047.10.04.01.41.34", "2047.11.02.17.57.40", "2047.12.02.12.54.37", "2048.01.01.07.56.36", "2048.01.31.01.13.48", "2048.02.29.15.37.37", "2048.03.30.04.03.53", "2048.04.28.13.12.28", "2048.05.27.20.56.44", "2048.06.26.04.07.34", "2048.07.25.11.33.23", "2048.08.23.20.06.38", "2048.09.22.06.46.01", "2048.10.21.20.24.26", "2048.11.20.12.19.00", "2048.12.20.07.38.41", "2049.01.19.03.28.34", "2049.02.17.21.46.53", "2049.03.19.13.22.45", "2049.04.18.03.04.09", "2049.05.17.13.13.13", "2049.06.15.21.26.15", "2049.07.15.04.29.05", "2049.08.13.11.19.01", "2049.09.11.19.03.49", "2049.10.11.04.52.43", "2049.11.09.16.37.22", "2049.12.09.08.27.30"]; 

 var vm;
 var vmOld=0;
 var vmPhase=0;
 var m=0;

 for(m=0;m<arrMond.size();m=m+1){
  var options={
   :year => arrMond[m].substring(0,4).toNumber(),
   :month  => arrMond[m].substring(5,7).toNumber(),
   :day    => arrMond[m].substring(8,10).toNumber(),
   :hour   => arrMond[m].substring(11,13).toNumber(),
   :min    => arrMond[m].substring(14,15).toNumber(),
   :sec => arrMond[m].substring(16,17).toNumber()
  };
  vm=Gregorian.moment(options).value(); 
  if(m>0){
   var options1={
    :year => arrMond[m-1].substring(0,4).toNumber(),
    :month  => arrMond[m-1].substring(5,7).toNumber(),
    :day    => arrMond[m-1].substring(8,10).toNumber(),
    :hour   => arrMond[m-1].substring(11,13).toNumber(),
    :min    => arrMond[m-1].substring(14,15).toNumber(),
    :sec => arrMond[m-1].substring(16,17).toNumber()
   };
   vmOld=Gregorian.moment(options1).value(); 
  }
  var now=new T.Moment(T.now().value());
  var now1=now.value();
  if(vm>now1){
   var nowDays=now1.toFloat()/86400; //Den heutigen Tag berechnen,in Tagen
   var vmOldDays=vmOld.toFloat()/86400; //Letzter Vollmond in Tagen
   var vmDays=vm.toFloat()/86400;
   var lunaDiff=vmDays-vmOldDays-29.530589;
   vmPhase=(nowDays-vmOldDays)/(29.530589+lunaDiff);
   vmPhase=M.round(vmPhase*1000)/1000;
   break;
  }
 }
 if(vmPhase==0.0){vmPhase=1;} //Wenn Null dann auf Eins setzen
 
 var KlHalbaxe=99.0; //Die Default-Unsinnige-Grösse der kleinen Halbachse der Ellipse

 if(m >= arrMond.size()) {
    return;
 }
 
 if(vmPhase<0.5){
  KlHalbaxe=M.cos(vmPhase*2*M.PI);
 }else{
  KlHalbaxe=M.cos(vmPhase*2*M.PI)*(-1);
 }    
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 if(vmPhase<=0.005){  //Zeit des wirklichen Vollmonds hervorheben ca. 8 Std
  dc.setPenWidth(2);
  dc.fillCircle(xMond,yMond,10);
  dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
  dc.drawText(xMond,yMond-1,FT_MyBug,"F",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else if(vmPhase<=0.25){
  dc.fillCircle(xMond,yMond,10);
  dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
  dc.fillRectangle(xMond,yMond-10,11,21);
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.fillEllipse(xMond,yMond,KlHalbaxe.abs()*10,10);
 }else if(vmPhase<=0.490){
  dc.fillCircle(xMond,yMond,10);
  dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
  dc.fillRectangle(xMond,yMond-10,11,21);
  dc.fillEllipse(xMond,yMond,KlHalbaxe.abs()*10,10);
 }else if(vmPhase<=0.505){ 
  dc.drawCircle(xMond,yMond,10);
  dc.drawText(xMond,yMond-1, FT_MyBug,"E",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }else if(vmPhase<=0.75){
  dc.fillCircle(xMond,yMond,10);
  dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
  dc.fillRectangle(xMond-11,yMond-10,12,21);
  dc.fillEllipse(xMond,yMond,KlHalbaxe.abs()*10,10);
 }else if(vmPhase<=0.990){
  dc.fillCircle(xMond,yMond,10);
  dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
  dc.fillRectangle(xMond-11,yMond-10,12,21);
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.fillEllipse(xMond,yMond,KlHalbaxe.abs()*10,10); 
 }else if(vmPhase<=1.00){ 
  dc.setPenWidth(2);
  dc.fillCircle(xMond,yMond,10);
  dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
  dc.drawText(xMond,yMond-1, FT_MyBug,"F",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }
 dc.setPenWidth(1);
 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 var vmTxt=arrMond[m].substring(8,10)+"."+arrMond[m].substring(5,7);
 dc.drawText(xMondZahl,yMondZahl, FT_MyBug,vmTxt ,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
}