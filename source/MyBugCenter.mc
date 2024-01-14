using Toybox.Graphics as Gc;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.System as Sys;
using Toybox.Lang as L;
using Toybox.Application.Storage as Ast;
using Toybox.WatchUi as Ui;
using Toybox.SensorHistory;

function draw_weath_minut(dc,CLockTyp) {
 //Minutenlichle Vorhersage
 if(Ast.getValue("minutely")){
  if(Ast.getValue("minutely")!=null){
   aP=[:X54,:Y54];
   var xMin=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
   var yMin=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
   var arrMinutely=Ast.getValue("minutely");
   var precMax=Ast.getValue("precMax"); //Maximaler Precefrirj
   var precMaxLine=0.00;
   var precF=0.00;
   if (precMax!=null){
    if(precMax>0.00&&weathTime==true){//Bei 0.00 und älter 1 Std. muss gar nix gezeichnet werden/Akku freut sich
     precMaxLine=precMax.toNumber()+1; //Maximale Linie zeichnen/+1 verhindert auch Division durch 0
     precF=20/precMaxLine; //Faktor auf 20 Pixel
     dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
     if(ClockTyp==0){//Bei digitaler Anzeige alles horizontal zeichnen
      if(arrMinutely!=null){
       dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
       for(var arrTemp=0;arrTemp<arrMinutely.size();++arrTemp){
        if(arrMinutely[arrTemp]!=null){
         if(arrMinutely[arrTemp][1]!=null){dc.drawLine(xMin-1+arrTemp,yMin,xMin-1+arrTemp,yMin-(arrMinutely[arrTemp][1].toFloat()*precF));}
        }
       }
      }
      //Wassertropfen
      aP=[:X63,:Y63];
      var xDrop=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
      var yDrop=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
	  dc.drawArc(xDrop,yDrop+2,5,1,45,135);
	  dc.fillCircle(xDrop,yDrop+2,2);
	  dc.drawLine(xDrop,yDrop-7,xDrop-4,yDrop-1);
	  dc.drawLine(xDrop,yDrop-6,xDrop+4,yDrop-1);
      
      dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
      dc.drawLine(xMin-2,yMin,xMin+61,yMin); //Horizontale Skala
      dc.drawLine(xMin-1,yMin-2,xMin-1,yMin+2); 
      dc.drawLine(xMin-1+15,yMin-2,xMin-1+15,yMin+2); 
      dc.drawLine(xMin-1+30,yMin-2,xMin-1+30,yMin+2); 
      dc.drawLine(xMin-1+45,yMin-2,xMin-1+45,yMin+2); 
      dc.drawLine(xMin-1+60,yMin-2,xMin-1+60,yMin+2);  
      //Aktueller Zeitpunkt als vert. weisse Linie  
      var now=new T.Moment(T.now().value());
      var now1=now.value();
      if(arrMinutely[0]!=null){
       if(arrMinutely[0][0]!=null){
        var precFirst=arrMinutely[0][0];
        var precDiff=(now1-precFirst)/60;
        if(precDiff>60){precDiff=60;}
         dc.setPenWidth(2);
         dc.drawLine(xMin-1+precDiff,yMin-21,xMin-1+precDiff,yMin+3); //Vertikale wo Jetzt ist
         dc.setPenWidth(1);
        }
       }
       //Max Linie zeichnen
       if(precMax!=null&&arrMinutely!=null){
        for(var del=0;del<60; del=del+6) { //gestrichelte Linie
         dc.drawLine(xMin+del,yMin-(precMaxLine*precF),xMin+del+3,yMin -(precMaxLine*precF));
        }
        aP=[:X64,:Y64];
        var xmm=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
        var ymm=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();  
        dc.drawText(xmm,ymm,FT_MyBug,"mm",Gc.TEXT_JUSTIFY_LEFT|Gc.TEXT_JUSTIFY_VCENTER);
        aP=[:X66,:Y66];
        var xprecMax=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
        var yprecMax=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();  
        dc.drawText(xprecMax,yprecMax,FT_MyBug,precMaxLine,Gc.TEXT_JUSTIFY_LEFT|Gc.TEXT_JUSTIFY_VCENTER);
       }
     }else{//Bei analoger Anzeige alles radial zeichnen
      //Zeitdifferenz zwischen jetzt und forecast ermitteln
      var now=new T.Moment(T.now().value());
      var now1=now.value();
      var precDiff=0.0;
      if(arrMinutely[0]!=null){
       if(arrMinutely[0][0]!=null){
        var precFirst=arrMinutely[0][0];
        precDiff=(now1-precFirst)/60;
       }
      }
      precDiff=precDiff.toNumber();
      //Niederschlag zeichnen
      if(arrMinutely!=null){
       dc.setPenWidth(2);
       dc.setColor(Gc.COLOR_DK_GRAY,Gc.COLOR_TRANSPARENT); //Rest bis volle Stunde füllen
       for(var arrTemp=60-precDiff+1;arrTemp<60;++arrTemp) {
          dis=r/10*0.3;
          Wi=arrTemp*6;
          MyBugView.Koord();
          var anaX=X;
          var anaY=Y;
          dis=r/10*0.3+(precMax*precF/2);
          Wi=arrTemp*6;
          MyBugView.Koord();
          dc.drawLine(anaX,anaY,X,Y);
       }
       dc.setPenWidth(3);
       dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
       for(var arrTemp=0+precDiff;arrTemp<arrMinutely.size();++arrTemp) {
        if(arrMinutely[arrTemp]!=null){
         if(arrMinutely[arrTemp][1]!=null){
          dis=r/10*0.3;
          Wi=(arrTemp*6)-(precDiff*6);
          MyBugView.Koord();
          var anaX=X;
          var anaY=Y;
          dis=r/10*0.3+(arrMinutely[arrTemp][1].toFloat()*precF);
          Wi=(arrTemp*6)-(precDiff*6);
          MyBugView.Koord();
          dc.drawLine(anaX,anaY,X,Y);
         }
        }
       }
       dc.setPenWidth(1);
       dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
      }
      //Max Linie zeichnen
      dc.setAntiAlias(true);
      if(precMax!=null&&arrMinutely!=null){
       dc.setPenWidth(2);
       for(var del=0; del<60;del=del+3){ //gestrichelte Linie
        dis=r/10*0.3+(precMaxLine*precF);
        Wi=del*6;
        MyBugView.Koord();
        dc.drawPoint(X,Y);
       }
       dc.setPenWidth(1);
       if(ClockTyp==1){ //MaxZahl schieben
        if(ani>0){
         dc.drawText(r+r/10*4-5,r-2,FT_MyBug,precMaxLine,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER); 
        }else{
         dc.drawText(r+r/10*4,r-2,FT_MyBug,precMaxLine,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
        }
       }else{
        dc.drawText(r,r-r/10*2.8,FT_MyBug,precMaxLine,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
       }
       dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
      }
      dc.setAntiAlias(false);
     }
    }
   }
   dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  }
 }
}

function drawKW(dc,Jahr,WTag){
 aP=[:X10,:Y10];
 var xKW=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();  
 var yKW=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();

 dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
 //Den Wochentag des 1. Jan vom jetztigen Jahr ermitteln
 var options={
  :year => Jahr.toNumber(),
  :month  => 1,
  :day    => 1,
 };
 var KW1Jan=Gregorian.moment(options); 
 var Datum= Gregorian.info(KW1Jan,T.FORMAT_SHORT);
 var WTagTemp=L.format("$1$",[Datum.day_of_week]).toNumber();
 var WTagKW=WTagTemp-1;
 if (WTagKW<0) {WTagKW=WTagKW+7;}
 
 //Anz Tage von jetzt zum 1. Jan des Jahres
 var now=new T.Moment(T.now().value());
 var now1=now.value();
 var KWdiff=(now1-KW1Jan.value())/86400; //Differenz in Tagen
 KWdiff=KWdiff.toNumber(); //Ganze Tage ermitteln
 
 //Wenn der Wochentag des 1. Jan>als Donnerstag ist(Typisch DE/A/CH),dann
 var BasisWoche=1;
 if (WTagKW>4){BasisWoche=0;}
 var WAnz=(KWdiff/7)+BasisWoche;
 var KWmod=KWdiff-(KWdiff/7*7)+WTagKW;
 if (KWmod>7){WAnz=WAnz+1;}
 
 if (WAnz==0){WAnz=KW_alt;} //KW0 Bug abfangen
 dc.drawText(xKW,yKW,FT_MyBug,WAnz,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 if (WAnz!=0){KW_alt=WAnz;} //KW0 Bug abfangen
}

function histo(dc){
 var Iterator=null;
 var sample=null;
 var actVal=0;
 var errVal="";
 var val=0;

 if(ani==7){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getBodyBatteryHistory)) {
   Iterator=Toybox.SensorHistory.getBodyBatteryHistory({});
  }else{errVal="No Body-Data";}
 }
 if(ani==8){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getHeartRateHistory)) {
   Iterator=Toybox.SensorHistory.getHeartRateHistory({});
  }else{errVal="No Heart-Data";}
 }
 if(ani==9){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getOxygenSaturationHistory)) {
   Iterator=Toybox.SensorHistory.getOxygenSaturationHistory({});
  }else{errVal="No Oxygen-Data";}
 }
 if(ani==10){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getStressHistory)) {
   Iterator=Toybox.SensorHistory.getStressHistory({});
  }else{errVal="No Stress-Data";} 
 }
 if(ani==11){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getElevationHistory)) {
   Iterator=Toybox.SensorHistory.getElevationHistory({});
  }else{errVal="No Height-Data";}
 }
 if(ani==12){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getTemperatureHistory)) {
   Iterator=Toybox.SensorHistory.getTemperatureHistory({});
  }else{errVal="No Temperatur-Data";}
 }
 if(ani==13){
  if((Toybox has :SensorHistory)&&(Toybox.SensorHistory has :getPressureHistory)) {
   Iterator=Toybox.SensorHistory.getPressureHistory({});
  }else{errVal="No Pressure-Data";}
 }

 if(Iterator!=null){
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  var hCount=0;
  var getNext=true;
  var hMax=Iterator.getMax().toNumber();
  var hMin=Iterator.getMin().toNumber();
  if(ani==13){
   hMax=hMax/100;
   hMin=hMin/100;
  }
  var leftB=r-(r*0.425).toNumber();
  var rightB=r+(r*0.425).toNumber();
  var anzVal=rightB-leftB;//Anz max. Pixel
  var bottomB=r-(r*0.21).toNumber();
  if(hMin-hMax==0){hMin=hMin-1;}
  dc.drawLine(rightB,bottomB+1,rightB,bottomB-26);
  dc.drawLine(leftB,bottomB+1,leftB,bottomB-26);
  dc.drawLine(leftB-1,bottomB,rightB+1,bottomB);
  dc.drawText(r,bottomB-25,Gc.FONT_XTINY,hMin+" - "+hMax,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  dc.setPenWidth(2);
  dc.setColor(mainCol,Gc.COLOR_TRANSPARENT);
  while(getNext){
   sample=Iterator.next();
   if(sample!=null){
    if(sample.data!=null){
     val=sample.data.toNumber();
     if(ani==13){val=val/100;}
     dc.drawPoint(rightB-(hCount*anzVal/anzData).toNumber(),bottomB-(25*(val-hMin)/(hMax-hMin)));
    }
    hCount=hCount+1;
    if(hCount>anzData){getNext=false;}
   }else{getNext=false;}
  }
  dc.setColor(MyTimeFg,Gc.COLOR_TRANSPARENT);
  dc.setPenWidth(1);
 }else{
  dc.drawText(r,r-(r*0.3),Gc.FONT_XTINY,errVal,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
 }

}