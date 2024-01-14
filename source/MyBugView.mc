using Toybox.Graphics as Gc;
using Toybox.Lang as L;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Timer as Ti;
using Toybox.Application.Storage as Ast;
using Toybox.Weather as W;
using Toybox.ActivityMonitor as AM;
using Toybox.Math as M;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.UserProfile as UP;
using Toybox.Activity as A;
 
//Font
var FT_MyBug;
var FT_MyBug_BT_AL;
var FT_MyBug_Time;
//Koordinaten Sachen
var X,Y;//Für die Winkelberechnungen
var r;//Displayradius
var ViewStat=1;//Ansichts-Status
var dis;//Koordiatenberechnungen
var Wi;
var radWi;
var langi;//Sprache aus String.xml
var Stunde;//Zeitsachen
var Minute;
var Jahr;
//Diverses
var schnarch=false;//Sleep Modus
var ortCount=0;//Counter für die WebOrt-Laufschrift
var textCount=0;//Counter für die Wettertext-Laufschrift
var aP=[:X99,:Y99];//Array mit Dummies füllen
var precMax=0.0;//Niederschlag vordefinieren
var FT_WIN,FT_AVA,FT_COA,FT_FLO,FT_FIR,FT_FOG,FT_HIG,FT_LOW,FT_RAF,FT_RAI,FT_SNI,FT_THU;
var ViewStateAlert=0;
var futureStat=1; //Vorhersagestatus
 
class MyBugView extends Ui.WatchFace { 
 var myCount=0;//Counter für den Timer
 var ampmIst;//ampm Zustand
 var langi;//Sprache aus String.xml und string aus System
 var MT;//240=0/260=1 und 280=2

 function getScreen() {
  r=Sys.getDeviceSettings().screenWidth/2; 
  aP=[:MT,:MT];
  MT=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
 }

 function getLastPos() { 
  //Falls eine Höhe aus GPS der Uhr,dann diese hier auslesen. Ansonsten kann es leere Höhen geben
  alti=A.getActivityInfo().altitude.toNumber();
  if(alti!=null){Ast.setValue("alti",alti);}
  var hf=W.getCurrentConditions();
  if(hf!=null){
   var GWLati=hf.observationLocationPosition.toDegrees()[0];
   var GWLongi=hf.observationLocationPosition.toDegrees()[1];
   Ast.setValue("lastLong",GWLongi);
   Ast.setValue("lastLat",GWLati);
   //Darstellung in °'''
   var VorZ="N ";
   if(Ast.getValue("lastLat")<0){VorZ="S ";}
   var tempLat=Ast.getValue("lastLat").abs()+0.0000001;
   var tempLatGrad=tempLat.format("%d");
   var tempLatMin=60*(tempLat-tempLatGrad.toDouble());
   var tempLatSek=60*(tempLatMin-tempLatMin.format("%d").toDouble());
   Ast.setValue("lastLat1",tempLatGrad+"°"+tempLatMin.format("%2d")+"'"+tempLatSek.format("%2d")+"'' "+VorZ);
   if(Ast.getValue("langi").equals("de")){   
    VorZ="O ";
   }else{
    VorZ="E ";
   }
   if(Ast.getValue("lastLong")<0){VorZ="W ";}
   var tempLong=Ast.getValue("lastLong").abs()+0.0000001;
   var tempLongGrad=tempLong.format("%d");
   var tempLongMin=60*(tempLong-tempLongGrad.toDouble());
   var tempLongSek=60*(tempLongMin-tempLongMin.format("%d").toDouble());
   Ast.setValue("lastLong1",tempLongGrad+"°"+tempLongMin.format("%2d")+"'"+tempLongSek.format("%2d")+"'' "+VorZ);
  } 
 }
    
 //Herzschlag
 function getHeartRate(dc){
  var hr="";
  var hrGet=A.getActivityInfo().currentHeartRate;
  if (hrGet!=null&&hrGet<250&&hrGet>20){hr=hrGet.toString();}
  else {hr="";}
  return hr;
 }
 
 //Koordinatenberechnung
 function Koord(){
  Wi=Wi-90;//Null bei Garmin ist bei 3 Uhr
  if(Wi<0){Wi=Wi+360;}//< 0 abfangen
  Wi=Wi*(-1)+360;//Umkehren
  radWi=M.toRadians(Wi);//in Rad
  X=M.cos(radWi)*dis;
  Y=M.sin(radWi)*dis;
  //Schauen,an welchen Quadrant die Koo liegt
  if(Wi>0&&Wi<=90){X=r+X;Y=r-Y;}
  else if(Wi>90&&Wi<=180){X=r+X;Y=r-Y;}
  else if(Wi>180&&Wi<=270){X=r+X;Y=r-Y;}
  else if(Wi>270&&Wi<=360){X=r+X;Y=r-Y;}
 }
 
 function aniDigi(dc){
  var zufall; 
  aP=[:X11,:Y11];
  var oG=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
  var yA=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
  for(var i=r-(r*0.38);i<=r+(r*0.38);++i){
   zufall=Math.rand()%+oG+1;
   dc.drawLine(i,r+yA,i,r+yA-zufall);
   dc.drawLine(i,r+yA,i,r+yA+zufall);
  }
  for(var i=r-(r*0.38);i<=r+(r*0.38);++i){
   zufall=Math.rand()%+oG+1;
   dc.drawLine(i,r-yA,i,r-yA-zufall);
   dc.drawLine(i,r-yA,i,r-yA+zufall);
  }
 }
 
 function aniAna(dc,u1,u2){
  var aniFakt=r*0.45;
  var zufall,uX,uY;
  aP=[:rA,:rA];
  var rA=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
  for(var u=u1;u<=u2;++u){ 
   zufall=Math.rand()%+rA+1;
   dis=aniFakt+zufall;
   Wi=u;
   Koord();
   uX=X;
   uY=Y;
   zufall=M.rand()%+rA+1;
   dis=aniFakt-zufall;
   Wi=u;
   Koord();
   dc.drawLine(uX,uY,X,Y);
  }
 } 

 function initialize(){WatchFace.initialize();}

 // Load your resources here
 function onLayout(dc as Dc) as Void{
  langi=Ui.loadResource(Rez.Strings.langi);	
  Ast.setValue("langi",langi);
  getLastPos();
  getScreen();
  setLayout(Rez.Layouts.WatchFace(dc));
  FT_MyBug=Ui.loadResource(Rez.Fonts.FT_MyBug);
  FT_MyBug_BT_AL=Ui.loadResource(Rez.Fonts.FT_MyBug_BT_AL);
  FT_MyBug_Time=Ui.loadResource(Rez.Fonts.FT_MyBug_Time);
  FT_AVA=WatchUi.loadResource(Rez.Fonts.FT_AVA);
  FT_COA=WatchUi.loadResource(Rez.Fonts.FT_COA);
  FT_FIR=WatchUi.loadResource(Rez.Fonts.FT_FIR);
  FT_FOG=WatchUi.loadResource(Rez.Fonts.FT_FOG); 
  FT_FLO=WatchUi.loadResource(Rez.Fonts.FT_FLO);
  FT_HIG=WatchUi.loadResource(Rez.Fonts.FT_HIG);
  FT_LOW=WatchUi.loadResource(Rez.Fonts.FT_LOW);
  FT_RAF=WatchUi.loadResource(Rez.Fonts.FT_RAF);
  FT_RAI=WatchUi.loadResource(Rez.Fonts.FT_RAI);
  FT_SNI=WatchUi.loadResource(Rez.Fonts.FT_SNI);
  FT_THU=WatchUi.loadResource(Rez.Fonts.FT_THU);
  FT_WIN=WatchUi.loadResource(Rez.Fonts.FT_WIN);
 }

 function onShow() as Void {}

 // Update the view
 function onUpdate(dc as Dc) as Void { 
//Ast.clearValues();
 //Geräteeinstellungen und Aktivität ansprechen
 var DevStat=Sys.getDeviceSettings();
 var AktiMonInfo=AM.getInfo();
 var SysStat=Sys.getSystemStats();
 var ProfInfo=UP.getProfile();
 var AnzAlarm=DevStat.alarmCount;
 var BattStat=SysStat.battery.toNumber();
 var TelConn=DevStat.phoneConnected;
 var AnzNach=DevStat.notificationCount;
 var Schritte=AktiMonInfo.steps;
 var schritteGoal;
 var etaPlus=0;
 var etaMinus=0;
 var etaPlusGoal=0;
 var Kalo=AktiMonInfo.calories;
 var Dist=AktiMonInfo.distance;
 var Cm=ProfInfo.height.toFloat();
 var Kg=ProfInfo.weight.toFloat();
 var Birth=ProfInfo.birthYear;
 var Gender=ProfInfo.gender;
 var restBPM=ProfInfo.restingHeartRate;
 var ampm=DevStat.is24Hour;
 var dndSys=DevStat.doNotDisturb;
 var arrWTag=[:d1,:d2,:d3,:d4,:d5,:d6,:d7];
 var arrMonat=[:m1,:m2,:m3,:m4,:m5,:m6,:m7,:m8,:m9,:m10,:m11,:m12];

 // Wochentag und Zeit 
 var Zeit=T.now();
 var Datum= Gregorian.info(Zeit,T.FORMAT_SHORT);
 Stunde=L.format("$1$",[Datum.hour.format("%02d")]);
 Minute=L.format("$1$",[Datum.min.format("%02d")]);

 //AM / PM Angabe
 if(ampm==false) {
  var numStunde=Stunde.toNumber(); //Stunde als Number
  if(numStunde>=12){
   ampmIst="p";
   if(numStunde>12){numStunde=numStunde-12;}
  }else{
   ampmIst="a";
   if(numStunde==0){numStunde=12;}
  }Stunde=numStunde.toString();
 }


 //ForeCast zurücksetzen um Mitternacht
 if(Stunde.toNumber()==0&&Minute.toNumber()==0&&Ast.getValue("ModelCheck")==true){
  if(Ast.getValue("WebForeD0T")){
   Ast.deleteValue("WebForeD0T");
  }
 }

//Hauptteil
 if(dndSys==true&&dnd==true){ //Bei DnD wird nur ein Text gezeichnet
  //Display leeren
  dc.setColor(MyTimeBg,MyTimeBg);
  dc.clear();
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  if(dndList==0){
   dc.drawText(r,r,Gc.FONT_LARGE,"DnD",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  }else{
   var Jetzt=Stunde+":"+Minute;
   dc.drawText(r,r,dndList+13,Jetzt,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  }
  return;
 }else{  
 //FG- und BG-Farbe nach Sonnenuntergang tauschen 
  if(sw==true){
   if(Ast.getValue("WebSunrise")&&Ast.getValue("WebSunset")){
    var swSunriseMom=new T.Moment(Ast.getValue("WebSunrise"));
    var swSunsetMom=new T.Moment(Ast.getValue("WebSunset"));  
    var swNow=new T.Moment(T.now().value());
    if (swNow.greaterThan(swSunsetMom)||swNow.lessThan(swSunriseMom)) { //Also Nacht
     MyTimeFg=Ast.getValue("BgCol");
     MyTimeBg=Ast.getValue("FgCol"); 
     Ast.setValue("DayNight",false);
    }else{
     MyTimeFg=Ast.getValue("FgCol"); 
     MyTimeBg=Ast.getValue("BgCol"); 
     Ast.setValue("DayNight",true);
    }
   }
  }else{
   MyTimeFg=Ast.getValue("FgCol"); 
   MyTimeBg=Ast.getValue("BgCol"); 
   Ast.setValue("DayNight",true);
  }

  //Display leeren
  dc.setColor(MyTimeBg,MyTimeBg);
  dc.clear();
   
  //Design/Hintergrund zeichnen
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT); 
     
  //var DesignTyp=2; //1=Linie/2=Punkte
  draw_Design(dc,DesignTyp,MT);
   
  //Zentrumsfeld mit Zeit(dig und ana)/Datum/KW/ampm/sek
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  var Sekunde=L.format("$1$",[Datum.sec.format("%02d")]);
  var WTagTemp=L.format("$1$",[Datum.day_of_week]).toNumber()-2;
  if(WTagTemp < 0){WTagTemp=WTagTemp+7;}
  var Tag=L.format("$1$",[Datum.day.format("%02d")]);
  Jahr=L.format("$1$",[Datum.year]);
  var WTag=Ui.loadResource(Rez.Strings[arrWTag[WTagTemp]]);//Array=0 bis 6,Tage 1 - 7
  var Monat=Ui.loadResource(Rez.Strings[arrMonat[L.format("$1$",[Datum.month]).toNumber()-1]]);//Array=0 bis 11,Monate 1 - 12

  //Alle Stunde die Daily Abfrage setzen
  if(Minute.toNumber()>0&&Minute.toNumber()<6&&Ast.getValue("ModelCheck")==true){
   Ast.setValue("ForeDay",true);
  }
  
  //OWM Minuten Vorhersage zeichnen
  if(owmMin==true&&Ast.getValue("ModelCheck")==true&&weathTime==true){
   draw_weath_minut(dc,ClockTyp); 
   dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
   if(Ast.getValue("precMax")){
    if(Ast.getValue("precMax")!=null){
     precMax=Ast.getValue("precMax"); //Maximaler Precefrirj
    }
   }
  }
  if(ani>0){ 
   dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
   if(ClockTyp==0&&precMax==0.0||ClockTyp==0&&weathTime==false){//Digitale Anzeige und Animationen/Koordinaten
    aP=[:X65,:Y65];
    var ForeOben=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
    var ForeUnten=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
    if(ani==1){ //Immer Animation
     aniDigi(dc);
    }else if(ani==2){ //Nur im Schnarchmodus
     if(schnarch==true){aniDigi(dc);}
    }else if(ani==3){ //Koordinaten
     dc.drawText(r,ForeOben,FT_MyBug,"Lat "+Ast.getValue("lastLat").format("%.5f")+"°",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     dc.drawText(r,ForeUnten,FT_MyBug,"Long "+Ast.getValue("lastLong").format("%.5f")+"°",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    }else if(ani==4){ //Koordinaten
     dc.drawText(r,ForeOben,FT_MyBug,Ast.getValue("lastLat1"),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     dc.drawText(r,ForeUnten,FT_MyBug,Ast.getValue("lastLong1"),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    }else if(ani==5){ //Freier Text
     if(indiText.length()==0){
      if(Ast.getValue("langi").equals("de")){   
      dc.drawText(r,ForeOben,Gc.FONT_XTINY,"Kein Text!",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }else{
      dc.drawText(r,ForeOben,Gc.FONT_XTINY,"No text!",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }
     }else{
      var textSep=indiText.find("/");
      if (textSep!=null){ 
       var indiText1=indiText.substring(0,textSep);
       var indiText2=indiText.substring(textSep+1,99);
       dc.drawText(r,ForeOben,Gc.FONT_XTINY,indiText1,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
       dc.drawText(r,ForeUnten,Gc.FONT_XTINY,indiText2,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }else{
       dc.drawText(r,ForeOben,Gc.FONT_XTINY,indiText,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }
     } 
    }else if(ani==6&&Ast.getValue("ModelCheck")==true){ //Wetter Vorhersage wenn supported by model
     if(Ast.getValue("WebForeD0T")){
      dc.drawText(r,ForeOben,FT_MyBug,Ast.getValue("WebForeD0T").format("%d")+"° - "+Ast.getValue("WebForeD0T1").format("%d")+"° | "+Ast.getValue("WebForeD0pop").toFloat().format("%.1f"),Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      var WebIcon=Ast.getValue("WebForeD"+futureStat+"I");
      WebIcon=WebIcon.substring(0,2);
      if(WebIcon.equals("01")){ 
       draw_icon_01(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("02")){ 
       draw_icon_02(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("03")){
       draw_icon_03(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("04")){
       draw_icon_04(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("09")){
       draw_icon_09(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("10")){
       draw_icon_10(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("11")){
       draw_icon_11(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("13")){
       draw_icon_13(dc,r+(r*0.2),ForeUnten);
      }else if(WebIcon.equals("50")){
       draw_icon_50(dc,r+(r*0.2),ForeUnten);
      }
      dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
      var WTagForeTemp=WTagTemp+futureStat;
      if(WTagForeTemp>6){WTagForeTemp=WTagForeTemp-7;}
      var WTagFore=Ui.loadResource(Rez.Strings[arrWTag[WTagForeTemp]]);//Array=0 bis 6,Tage 1 - 7
      dc.drawText(r+(r*0.11),ForeUnten,FT_MyBug,WTagFore.substring(0,2)+": "+Ast.getValue("WebForeD"+futureStat+"T").format("%d")+"-"+Ast.getValue("WebForeD"+futureStat+"T1").format("%d")+"°",Gc.TEXT_JUSTIFY_RIGHT|Gc.TEXT_JUSTIFY_VCENTER);
      dc.drawText(r+(r*0.2)+15,ForeUnten,FT_MyBug,(Ast.getValue("WebForeD"+futureStat+"pop").toFloat()).format("%.1f"),Gc.TEXT_JUSTIFY_LEFT|Gc.TEXT_JUSTIFY_VCENTER);
      //Vorhersagetageanzeige wechseln
      if(futureStat==future+1){
       futureStat=1;
      }else{
       futureStat=futureStat+1;
      }
     }else{
      if(Ast.getValue("langi").equals("de")){   
	   dc.drawText(r,ForeOben,FT_MyBug,"Tagesprognose",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
	   var tillUpdate=70-Minute.toNumber();
	   if(tillUpdate>=60){tillUpdate=tillUpdate-60;}
       dc.drawText(r,ForeUnten,FT_MyBug,"in ca. "+tillUpdate+" min",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }else{
	   dc.drawText(r,ForeOben,FT_MyBug,"next daily update",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
	   var tillUpdate=70-Minute.toNumber();
	   if(tillUpdate>=60){tillUpdate=tillUpdate-60;}
       dc.drawText(r,ForeUnten,FT_MyBug,"in about "+tillUpdate+"min",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
      }
     }
    }else if(ani>6){histo(dc);}
   }
   if(ClockTyp==1){ //Analog
    var u1=55,u2=125;
    dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
    if(ani==1){
     aniAna(dc,u1,u2);
     aniAna(dc,u1+180,u2+180);
    }else{//Dann muss es 2 sein
     if(schnarch==true){
      aniAna(dc,u1,u2);
      aniAna(dc,u1+180,u2+180);
     }
    }
   }   
  } 
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);

   //Datum zeichnen
   var Heute;
   if(dateView==0){//Normale Datumsansicht
    Heute=WTag+" "+Tag+". "+Monat;
   }else{
    Heute=Monat+" "+Tag+". "+WTag;
   }
   //UhrenTypen
   if(ClockTyp==0){//Digital
    //Zeit
    var Jetzt=Stunde+":"+Minute; 
    aP=[:X9,:Y9];
    dc.drawText(Ui.loadResource(Rez.Strings[aP[0]]).toNumber(),Ui.loadResource(Rez.Strings[aP[1]]).toNumber(),FT_MyBug_Time,Jetzt,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    var timeWidth=dc.getTextWidthInPixels(Jetzt,FT_MyBug_Time)/2;
    if(ampm==false){
     if(ampmIst.equals("a")){
      dc.drawText(r-timeWidth-6,r-2,FT_MyBug,ampmIst,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     }else{
      dc.drawText(r+timeWidth+6,r-2,FT_MyBug,ampmIst,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
     }
    }
    if(owmMin==true&&Ast.getValue("ModelCheck")==true&&precMax!=0.0&&weathTime==true||ani>6){//Falls die Minutenanzeige gewollt,dann das Datum verschieben
     aP=[:X55,:Y55];
     dc.drawText(Ui.loadResource(Rez.Strings[aP[0]]).toNumber(),Ui.loadResource(Rez.Strings[aP[1]]).toNumber(),FT_MyBug,Heute,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    }else{
     aP=[:X8,:Y8];
     dc.drawText(Ui.loadResource(Rez.Strings[aP[0]]).toNumber(),Ui.loadResource(Rez.Strings[aP[1]]).toNumber(),FT_MyBug,Heute,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    }
   }else if(ClockTyp==1){//Analog Small
    var H=Stunde.toNumber();
    if(H>=12){H=H-12;}
    var M=Minute.toNumber();
    aP=[:X8,:Y8];
    dc.drawText(Ui.loadResource(Rez.Strings[aP[0]]).toNumber(),Ui.loadResource(Rez.Strings[aP[1]]).toNumber(),FT_MyBug,Heute,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    dc.setAntiAlias(true);
    //Stundenzeiger
    dis=r/10*1.9; 
    Wi=(H*30)+(M/10*5);
    Koord();
    dc.setPenWidth(5); 
    dc.setColor(MyTimeBg,MyTimeBg);
    dc.drawLine(r,r,X,Y);
    dc.setPenWidth(3); 
    dc.setColor(MyTimeFg,dc.COLOR_TRANSPARENT);
    dc.drawLine(r,r,X,Y); 
    //Minutenzeiger
    dis=r/10*2.6; 
    Wi=M*6;
    Koord();
    dc.setPenWidth(5); 
    dc.setColor(MyTimeBg,MyTimeBg);
    dc.drawLine(r,r,X,Y);
    dc.setPenWidth(3); 
    dc.setColor(MyTimeFg,dc.COLOR_TRANSPARENT);
    dc.drawLine(r,r,X,Y); 
    var anaX,anaY;
    dc.setPenWidth(2);
    dc.setAntiAlias(false);
    //5 Min Striche
    for(var w=1;w<=12;w=w+1){
     dis=r/10*3;
     Wi=w*30;
     Koord();
     anaX=X;
     anaY=Y;
     dis=r/10*2.5;
     Wi=w*30;
     Koord();
     dc.drawLine(anaX,anaY,X,Y);
    }
   }
   
  //Topfeld mit BT/AL/Batterie/Nachrichten
   draw_batt(dc,BattStat);
   draw_bt(dc,TelConn);
   draw_mess(dc,AnzNach);
   draw_ala(dc,AnzAlarm);
  
   Dist=Dist.toFloat()/10/10000;
   Dist=Dist.format("%.1f");
   schritteGoal=AktiMonInfo.stepGoal;
   if(AktiMonInfo has :floorsClimbed){
    etaPlus=AktiMonInfo.floorsClimbed;
    etaMinus=AktiMonInfo.floorsDescended;
    etaPlusGoal=AktiMonInfo.floorsClimbedGoal;
   }
   
   var hr=getHeartRate(dc);
   
   if(ViewStat>(Speed+1)*3){ViewStat=1;}
   
   //1. Sequenz 
   if(ViewStat<=(Speed+1)*1){
    draw_dist(dc,Dist,schritteGoal);
    draw_Cal(dc,Kalo,Gender,Birth,Kg,Cm);
    draw_Hoe(dc);
    draw_wind(dc);
    ViewStateAlert=1;
   }
   //2. Sequenz
   else if(ViewStat<=(Speed+1)*2){
    draw_step(dc,Schritte,schritteGoal); 
    draw_bmi(dc,Kg,Cm);
    draw_sun(dc);
    draw_press(dc);
    ViewStateAlert=2;
   }
   //3. Sequenz
   else if(ViewStat<=(Speed+1)*3){
    draw_Tr(dc,etaPlus,etaMinus,etaPlusGoal);
    draw_bpm(dc,hr,Birth,Datum,restBPM);
    draw_moon(dc); 
    drawKW(dc,Jahr,WTag);
    draw_wet(dc);
    ViewStateAlert=3;
   }
   
   ViewStat=ViewStat+1;

   //Wetter von heute zeichnen
   draw_weath_today(dc,MT);
   
   if(moveBar){
    dc.setAntiAlias(true);
    dc.setColor(MyTimeBg,Gc.COLOR_TRANSPARENT);
    dc.setPenWidth(9);
    dc.drawArc(r,r,r-3,1,110,70);//Dekolinie überzeichnen
    dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
    var moveBarL=AktiMonInfo.moveBarLevel;
    dis=r-3;
    dc.setPenWidth(1);
    Wi=339;
    Koord();
    dc.drawArc(X,Y,3,0,111,291);
    Wi=357;
    Koord();
    dc.drawArc(X,Y,3,1,93,273);
    dc.drawArc(r,r,r-6,1,111,93);
    dc.drawArc(r,r,r,1,111,93);
    for(var c=3;c<=21;c=c+6){
     Wi=c;
     Koord();
     dc.drawCircle(X,Y,3);
    }  
    if(moveBarL>0){
     dc.setPenWidth(2);
     dc.drawArc(r,r,r-1,1,111,93);
     dc.setPenWidth(4);
     dc.drawArc(r,r,r-3,1,111,93);
     dc.setPenWidth(2);
     dc.drawArc(r,r,r-5,1,111,93);
     dc.setPenWidth(1);
     Wi=339;
     Koord();
     dc.fillCircle(X,Y,3);
     Wi=357;
     Koord();
     dc.fillCircle(X,Y,3);
    }if(moveBarL>1){
     Wi=3;
     Koord();
     dc.fillCircle(X,Y,3);
    }if(moveBarL>2){
     Wi=9;
     Koord();
     dc.fillCircle(X,Y,3);
    }if(moveBarL>3){
     Wi=15;
     Koord();
     dc.fillCircle(X,Y,3);
    }if(moveBarL>4){
     Wi=21;
     Koord();
     dc.fillCircle(X,Y,3);
    }
    dc.setAntiAlias(false);
    dc.setPenWidth(1);
    dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
   }
   
   if(hr.equals("")&&schnarch==true&&RIP==true){//Wenn kein Herzschlag gemessen wird, dann einen Grabstein zeichnen
    rip(dc,Birth,Datum);
   }
       
   //dnd als PSSTTT
   if(dndSys==true){
    aP=[:X49,:Y49];
    dc.setColor(MyTimeBg,MyTimeBg);
    dc.fillRectangle(Ui.loadResource(Rez.Strings[aP[0]]).toNumber()-(r/2),Ui.loadResource(Rez.Strings[aP[1]]).toNumber()-8,r,18);
    dc.setColor(0xff0000,Gc.COLOR_TRANSPARENT);
    dc.drawText(Ui.loadResource(Rez.Strings[aP[0]]).toNumber(),Ui.loadResource(Rez.Strings[aP[1]]).toNumber(),FT_MyBug,"PSSST...!",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
    dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT); 
   }
   //Sekundenpunkt
   if(schnarch==false){
    dis=r-3;
    Wi=Sekunde.toNumber()*6;
    Koord();
    dc.fillCircle(X,Y,3);
   }
   if(Ast.getValue("ModelCheck")==true){
    dc.setColor(Gc.COLOR_RED,Gc.COLOR_WHITE);
    dc.drawText(r,r,10,"CHANGE TO V2!!",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
   }
  }
 }

 function onHide() as Void {}

 function onExitSleep() as Void {
  schnarch=false;
  ortCount=0;
  textCount=0;
  getLastPos();
 }

 function onEnterSleep() as Void {
  schnarch=true;
  getLastPos();
  Ui.requestUpdate();
 }
}

class MyBugDelegate extends Ui.WatchFaceDelegate {
 function initialize() {
  WatchFaceDelegate.initialize();
 }
}