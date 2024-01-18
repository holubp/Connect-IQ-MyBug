using Toybox.Application as App;
using Toybox.Application.Storage as Ast;
using Toybox.Background as Bg;
using Toybox.Time as T;
using Toybox.Time.Gregorian;
using Toybox.Communications as Comm;
using Toybox.Lang as L;
using Toybox.Weather as W;
using Toybox.System as Sys;

var mainCol,indiCol;
var appid1,appid2,indiText;
var longi,lati,alti;
var MyTimeBg,MyTimeFg;
var dnd,sw,dndOffline,owmMin,owmAlert,dateView,ani,ModelCheck,RIP;
var ClockTyp,DesignTyp,Speed,moveBar,beau,mile,future,dndList,anzData;
var KW_alt=99;
var AlertNr=0;
var StateOld=1;
var weathTime=false;//Ist die Webabfrage < 1 Std 
 
(:background) 
class MyBugApp extends App.AppBase {

 const X_MINUTES=new T.Duration(5*60);
 
 function initialize() {AppBase.initialize();}

 function onSettingsChanged(){

  var arrmainCol=[Graphics.COLOR_WHITE,Graphics.COLOR_BLUE,Graphics.COLOR_DK_BLUE,Graphics.COLOR_RED,Graphics.COLOR_DK_RED,Graphics.COLOR_GREEN,Graphics.COLOR_DK_GREEN,Graphics.COLOR_ORANGE,Graphics.COLOR_YELLOW,Graphics.COLOR_PINK,Graphics.COLOR_PURPLE,Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLACK];
  mainCol=arrmainCol[getProperty("mainCol")];
  
  indiCol=getProperty("indiCol");
  if(indiCol.length()>0){
   var arrindiCol=["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];
   var indiCount=0;
   var arrCount=["x","x","x","x","x","x"];
   for(var ii=0;ii<6;++ii){
    for(var i=0;i<arrindiCol.size();++i){
     if(indiCol.substring(ii+2,ii+3).equals(arrindiCol[i])){
      arrCount[indiCount]=i;
      indiCount=indiCount+1;
      break;
     }
    }
   }
   if(indiCol.substring(0,2).equals("0x")&&indiCount==6){
    mainCol=(arrCount[0]*16+arrCount[1])*256*256+(arrCount[2]*16+arrCount[3])*256+(arrCount[4]*16+arrCount[5]);
   }
  }

  var arrModelCheck=["006-B3907-00","006-B3905-00","006-B3906-00","006-B3499-00","006-B3501-00","006-B3225-00"];
  for(var m=0;m<arrModelCheck.size();++m){
   if(Sys.getDeviceSettings().partNumber.equals(arrModelCheck[m])){
    ModelCheck=true;
    Ast.setValue("ModelCheck",ModelCheck);
    break;
   }else{
    ModelCheck=false;
    Ast.setValue("ModelCheck",ModelCheck);
   }
  }

  appid1=getProperty("appid1");
  Ast.setValue("appid1",appid1);

  appid2=getProperty("appid2");
  Ast.setValue("appid2",appid2);

  ClockTyp=getProperty("ClockTyp");

  DesignTyp=getProperty("DesignTyp");

  Speed=getProperty("Speed");

  future=getProperty("future");//Wenn dieser Eintrag verändert wird, dann muss Daily neu geladen werden
  if(Ast.getValue("future")){
   if(future!=Ast.getValue("future")){
    if(Ast.getValue("WebForeD0T")){Ast.deleteValue("WebForeD0T");}
   }
  }
  Ast.setValue("future",future);
  
  anzData=getProperty("anzData");

  dndList=getProperty("dndList");

  dnd=getProperty("dnd");
  
  dateView=getProperty("dateView");

  moveBar=getProperty("moveBar");
  
  ani=getProperty("ani");
  
  beau=getProperty("beau");
  
  mile=getProperty("mile");
  
  RIP=getProperty("RIP");
  
  indiText=getProperty("indiText");
  
  if(Ast.getValue("ForeDay")){
  }else{Ast.setValue("ForeDay",false);}
  
  owmMin=getProperty("owmMin");
  Ast.setValue("owmMin",owmMin);
  if(owmMin==false){weathTime=false;}

  if(Ast.getValue("owmCount")){
  }else{
   Ast.setValue("owmCount",0);//Startwert für OWM Download
  }

  owmAlert=getProperty("owmAlert");
  Ast.setValue("owmAlert",owmAlert);
  
  dndOffline=getProperty("dndOffline");
  Ast.setValue("dndOffline",dndOffline);

  sw=getProperty("sw");
  
  var arrlowCol=[Graphics.COLOR_WHITE,Graphics.COLOR_BLUE,Graphics.COLOR_DK_BLUE,Graphics.COLOR_RED,Graphics.COLOR_DK_RED,Graphics.COLOR_GREEN,Graphics.COLOR_DK_GREEN,Graphics.COLOR_ORANGE,Graphics.COLOR_YELLOW,Graphics.COLOR_PINK,Graphics.COLOR_PURPLE,Graphics.COLOR_LT_GRAY,Graphics.COLOR_DK_GRAY,Graphics.COLOR_BLACK];
  
  MyTimeFg=arrlowCol[getProperty("MyTimeFg")];
  Ast.setValue("FgCol",MyTimeFg);
  MyTimeBg=arrlowCol[getProperty("MyTimeBg")];
  Ast.setValue("BgCol",MyTimeBg);
  
  var tempUnits=Sys.getDeviceSettings().temperatureUnits;
  if(tempUnits==0){tempUnits="metric";}else{tempUnits="imperial";}
  Ast.setValue("tempUnits",tempUnits);
  
  registerEvents();     
  WatchUi.requestUpdate();
 }
 
 function onStart(state) {registerEvents();}

 function onStop(state) {}

 function getInitialView() {
  onSettingsChanged();
  return [new MyBugView()];
 }
        
 function onBackgroundData(data) {
//System.println("data: "+Stunde+":"+Minute+"=> "+ data);
  if(Ast.getValue("ModelCheck")==true&&Ast.getValue("ForeDay")==true){
   if(data[0]!=null){
    if(data[1].toNumber()==200){ //data 1=responseCode des Wetters
	 //Tages Vorhersage
	 for(var i=0;i<=future+1;++i){
	  Ast.setValue("WebForeD"+i+"pop",data[0][3][i][0]);
	  Ast.setValue("WebForeD"+i+"T",data[0][3][i][1]);
	  Ast.setValue("WebForeD"+i+"T1",data[0][3][i][2]);
	  Ast.setValue("WebForeD"+i+"I",data[0][3][i][3]);
	 }
	}
   }
   Ast.setValue("ForeDay",false);
  }else{
   var owmCount=Ast.getValue("owmCount");
   if(owmCount==0){
    if(data[0]!=null) {
     if(data[1].toNumber()==200) { //data 1=responseCode des Wetters
      Ast.setValue("WebWeatherCode",data[1]);
      Ast.setValue("WebWeatherTR",data[0]["dt"]); //Zeit der letzten erfolgreichen Antwort
      Ast.setValue("WebTemp",data[0]["main"]["temp"]);
      Ast.setValue("WebOrt",data[0]["name"]);
      Ast.setValue("WebIcon",data[0]["weather"][0]["icon"]);
      Ast.setValue("WebWindDeg",data[0]["wind"]["deg"] + 50);
      Ast.setValue("WebWindSpeed",data[0]["wind"]["speed"] + 50);
      Ast.setValue("WebSunrise",data[0]["sys"]["sunrise"]);
      Ast.setValue("WebSunset",data[0]["sys"]["sunset"]);
      Ast.setValue("WebPressure",data[0]["main"]["pressure"]);
      Ast.setValue("WebHumidity",data[0]["main"]["humidity"]);
      Ast.setValue("WebCountry",data[0]["sys"]["country"]);
      Ast.setValue("WebTempFeel",data[0]["main"]["feels_like"]);
      Ast.setValue("WebWeatText",data[0]["weather"][0]["description"]);
     }
    }
   }else if(owmCount==1){
    if(data[1].toNumber()==200){ //data 1=responseCode des Wetters
     if(data[0][0]!=null){
      Ast.setValue("minutely",data[0][0]);
      Ast.setValue("precMax",data[0][1]);
     }
     if(data[0][2]!=null){//Wenns Alarm Info hat
   	 //Alte Alarme löschen
      if(Ast.getValue("alertCount")){
       var oldAlertCount=Ast.getValue("alertCount");
       for(var tempOld=0;tempOld<oldAlertCount;tempOld=tempOld+1){
        Ast.deleteValue("WebAlertEvent"+tempOld);
       }
      }
      //Alles für die Alarme auszulesen
      var AlertString="";
      if(data[0][2]!=null){AlertString=data[0][2].toString();}
      if(AlertString.find("sender_name=>")!=null){
       Ast.setValue("WebAlert",true);
       Ast.setValue("alertCount",0);
       var alertCount=0;
       //Anzahl Alarme suchen
       while(AlertString.find("sender_name=>")!=null){
        AlertString=AlertString.substring(AlertString.find("sender_name=>")+20,9999);
        alertCount=alertCount+1;
       }
       for(var del=0;del<alertCount;del=del+1){
        Ast.setValue("WebAlertEvent"+del,data[0][2][del]["event"]);
        Ast.setValue("WebAlertStart"+del,data[0][2][del]["start"]);
        Ast.setValue("WebAlertEnd"+del,data[0][2][del]["end"]);
       }
       Ast.setValue("alertCount",alertCount);
      }else{
       Ast.setValue("WebAlert",false);
       Ast.setValue("alertCount",0);
      }
     }else{
      Ast.setValue("WebAlert",false);
      Ast.setValue("alertCount",0);
     }
    }
   }
   if(owmCount==0&&Ast.getValue("ModelCheck")==true||owmCount==0&&Ast.getValue("ModelCheck")==false&&Ast.getValue("owmAlert")==true){
    Ast.setValue("owmCount",1);
   }else if(owmCount==1){
    Ast.setValue("owmCount",0);
   }
  }

  if(data[2]!=null){
   if(data[3].toNumber()==200){ //data 3 = responseCode der Geo Höhe
    Ast.setValue("WebHCode",data[3]);
    Ast.setValue("WebH",data[2][0]["elevation"]);
    Ast.setValue("WebHfrom","API");
   }else{
    Ast.setValue("WebHCode",data[3]);
    Ast.setValue("WebHfrom","GPS");
   }
  }

  WatchUi.requestUpdate();registerEvents();
 }

  function registerEvents(){
  var lastTime=Bg.getLastTemporalEventTime();
  if(lastTime!=null){
   // Events scheduled for a time in the past trigger immediately
   var nextTime=lastTime.add(X_MINUTES);
   Bg.registerForTemporalEvent(nextTime);
  }else{
   Bg.registerForTemporalEvent(T.now());
  }
 }

 function getServiceDelegate(){return [new MyServiceDelegate()];}
}