using Toybox.System as Sys;
using Toybox.Graphics as Gc;
using Toybox.Application.Storage as Ast;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;
using Toybox.WatchUi as Ui;
using Toybox.Lang;

function webAlertIcon(dc) {

 aP=[:X56,:Y56];
 var xalI=Ui.loadResource(Rez.Strings[aP[0]]).toNumber(); 
 var yalI=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();
 aP=[:X57,:Y57];
 var xalT=Ui.loadResource(Rez.Strings[aP[0]]).toNumber();
 var yalT=Ui.loadResource(Rez.Strings[aP[1]]).toNumber();

 var alertCount=Ast.getValue("alertCount");
 
 if(ViewStateAlert!=StateOld){
  AlertNr=AlertNr+1;
  if(AlertNr+1>alertCount){AlertNr=0;}
 }
 StateOld=ViewStateAlert;

 var WebAlertEvent=Ast.getValue("WebAlertEvent"+AlertNr);
 if (!(WebAlertEvent instanceof Lang.String)) {
    return;
 }
 var WebAlertStartUTC=Ast.getValue("WebAlertStart"+AlertNr);
 var WebAlertEndUTC=Ast.getValue("WebAlertEnd"+AlertNr);
 var now=new Time.Moment(Time.now().value());	
 var alertDuration;
 try {
    alertDuration=Math.round(((WebAlertEndUTC.toLong()-now.value())/3600));
 }
 catch (ex) {
    return;
 }


 //Farbe(Text/Icon) festlegen
 if (WebAlertEvent.find("Yellow")!=null||WebAlertEvent.find("yellow")!=null||WebAlertEvent.find("oderate")!=null||WebAlertEvent.find("Light")!=null||WebAlertEvent.find("light")!=null){
  dc.setColor(0xffff00,Gc.COLOR_TRANSPARENT);
 }else if(WebAlertEvent.find("Orange")!=null||WebAlertEvent.find("orange")!=null||WebAlertEvent.find("evere")!=null){
  dc.setColor(0xff5500,Gc.COLOR_TRANSPARENT);
 }else if(WebAlertEvent.find("Red")!=null||WebAlertEvent.find("red")!=null||WebAlertEvent.find("xtreme")!=null||WebAlertEvent.find("eavy")!=null){
  dc.setColor(Gc.COLOR_RED,Gc.COLOR_TRANSPARENT);
 }else if(WebAlertEvent.find("Violet")!=null){
  dc.setColor(0xaa00aa,Gc.COLOR_TRANSPARENT);
 }else{
  dc.setColor(Gc.COLOR_WHITE,Gc.COLOR_TRANSPARENT);
 }

 if(alertDuration>=0){//Alte Alarme nicht darstellen, bzw. ein "..."
  //Zeitdauer darstellen
  if(now.value()>WebAlertStartUTC.toLong()){//Zeitdauer nur anzeigen, wenn Now im Zeitbereich liegt
   dc.drawText(xalT,yalT,FT_MyBug,"-"+alertDuration,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  }else{
   var alertBeginn=Math.round(((WebAlertStartUTC.toLong()-now.value())/3600));//Zeitdauer bis Beginn
   dc.drawText(xalT,yalT,FT_MyBug,"("+alertBeginn+")",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  }
  //Event abfangen
  if(WebAlertEvent.find("Snow-Ice")!=null||WebAlertEvent.find("Snow")!=null||WebAlertEvent.find("snow")!=null||WebAlertEvent.find("Ice")!=null||WebAlertEvent.find("nowfall")!=null||WebAlertEvent.find("Icing")!=null){
   snow_ice(dc,xalI,yalI);
  }else if(WebAlertEvent.find("Wind")!=null||WebAlertEvent.find("Storm")!=null||WebAlertEvent.find("wind")!=null){
   wind(dc,xalI,yalI);
  }else if(WebAlertEvent.find("hunderstorm")!=null){
   thunder(dc,xalI,yalI);
  }else if(WebAlertEvent.find("Fog")!=null||WebAlertEvent.find("fog")!=null){
   fog(dc,xalI,yalI);
  }else if(WebAlertEvent.find("igh temperature")!=null||WebAlertEvent.find("igh Temperature")!=null||WebAlertEvent.find("igh-temperature")!=null||WebAlertEvent.find("igh-Temperature")!=null){
   high(dc,xalI,yalI);
  }else if(WebAlertEvent.find("ow temperature")!=null||WebAlertEvent.find("ow Temperature")!=null||WebAlertEvent.find("ow-temperature")!=null||WebAlertEvent.find("ow-Temperature")!=null||WebAlertEvent.find("oldwarning")!=null||WebAlertEvent.find("Frost")!=null||WebAlertEvent.find("frost")!=null){
   low(dc,xalI,yalI);
  }else if(WebAlertEvent.find("oastal Event")!=null||WebAlertEvent.find("oastalevent")!=null){
   coast(dc,xalI,yalI);
  }else if(WebAlertEvent.find("orestfire")!=null){
   fire(dc,xalI,yalI);
  }else if(WebAlertEvent.find("valanches")!=null){
   ava(dc,xalI,yalI);
  }else if(WebAlertEvent.find("ain-Flood")!=null||WebAlertEvent.find("ain-flood")!=null||WebAlertEvent.find("ainflood")!=null){
   rainflood(dc,xalI,yalI);
  }else if(WebAlertEvent.find("Rain")!=null || WebAlertEvent.find("ainfall")!=null || WebAlertEvent.find("rain")!=null){
   rain(dc,xalI,yalI);
  }else if(WebAlertEvent.find("lood")!=null){
   flood(dc,xalI,yalI);
  }else{
   dc.drawText(xalI,yalI,FT_MyBug,"!!",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
  }
 }else{
  dc.setColor(Gc.COLOR_WHITE,Gc.COLOR_TRANSPARENT);
  dc.drawText(xalI,yalI,FT_MyBug,"..old..",Gc.TEXT_JUSTIFY_LEFT|Gc.TEXT_JUSTIFY_VCENTER);
 }
}

function ava(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_AVA,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function coast(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_COA,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function flood(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_FLO,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function fog(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_FOG,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function fire(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_FIR,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function high(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_HIG,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function low(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_LOW,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function rainflood(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_RAF,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function rain(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_RAI,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function snow_ice(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_SNI,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function thunder(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_THU,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}
function wind(dc,xalI,yalI){dc.drawText(xalI,yalI,FT_WIN,"G",Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);}