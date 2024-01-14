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
 var arrMond=["2021.12.19.05.35.36","2022.01.18.00.48.30","2022.02.16.17.56.30","2022.03.18.07.17.36","2022.04.16.20.55.06","2022.05.16.06.14.12","2022.06.14.13.51.48","2022.07.13.20.37.42","2022.08.12.03.35.48","2022.09.10.11.59.06","2022.10.09.22.55.00","2022.11.08.12.02.12","2022.12.08.05.08.12","2023.01.07.00.07.54","2023.02.05.19.28.36","2023.03.07.13.40.24","2023.04.06.06.34.36","2023.05.05.19.34.06","2023.06.04.05.41.48","2023.07.03.13.38.42","2023.08.01.20.31.42","2023.09.29.11.57.36","2023.10.28.22.24.06","2023.11.27.10.16.24","2023.12.27.01.33.12"]; 

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