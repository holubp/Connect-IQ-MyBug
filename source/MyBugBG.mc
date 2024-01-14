using Toybox.Background as Bg;
using Toybox.Communications as Comm;
using Toybox.System as Sys;
using Toybox.Application.Storage as Ast;
using Toybox.Time as T;
using Toybox.Lang;

(:background)
class MyServiceDelegate extends Sys.ServiceDelegate {
 function initialize(){ServiceDelegate.initialize();}

 var res1=null,Code1=null,res2=null,Code2=null;
 var lat=Ast.getValue("lastLat");
 var lon=Ast.getValue("lastLong");
 var appid1=Ast.getValue("appid1"); 
 var appid2=Ast.getValue("appid2"); 
 var dndOffline=Ast.getValue("dndOffline");  
 var dndSys=Sys.getDeviceSettings().doNotDisturb; 
 var owmCount=Ast.getValue("owmCount");
 var tempUnits=Ast.getValue("tempUnits");
 var langi=Ast.getValue("langi");
 var future=Ast.getValue("future"); 
   
 function onTemporalEvent() {
  if(dndOffline==true&&dndSys==true){
  }else{
   if(Sys.getDeviceSettings().phoneConnected==true){ 
    if(Ast.getValue("ModelCheck")==true&&Ast.getValue("ForeDay")==true){
     var url1="https://api.openweathermap.org/data/2.5/onecall";
     var param1={"lat"=>lat,"lon"=>lon,"exclude"=>"current,minutely,hourly,alerts","appid"=>appid1,"units"=>tempUnits};
     var opt1={};
     var met1=method(:responseCallback3);
     Comm.makeWebRequest(url1,param1,opt1,met1);
    }else{
	 if(owmCount==0){     
	  var url1="https://api.openweathermap.org/data/2.5/weather";
	  var param1={"lat"=>lat,"lon"=>lon,"appid"=>appid1,"units"=>tempUnits,"lang"=>langi};
	  var opt1={};
	  var met1=method(:responseCallback1);
	  Comm.makeWebRequest(url1,param1,opt1,met1);
	 }else if(owmCount==1&&Ast.getValue("owmMin")==true&&Ast.getValue("ModelCheck")==true&&Ast.getValue("owmAlert")==true){
	  var url1="https://api.openweathermap.org/data/2.5/onecall";
	  var param1={"lat"=>lat,"lon"=>lon,"exclude"=>"current,daily,hourly","appid"=>appid1,"units"=>tempUnits}; //,alerts,minutely
	  var opt1={};
	  var met1=method(:responseCallback3);
	  Comm.makeWebRequest(url1,param1,opt1,met1);
	 }else if(owmCount==1&&Ast.getValue("owmMin")==true&&Ast.getValue("ModelCheck")==true){
	  var url1="https://api.openweathermap.org/data/2.5/onecall";
	  var param1={"lat"=>lat,"lon"=>lon,"exclude"=>"current,daily,hourly,alerts","appid"=>appid1,"units"=>tempUnits}; //,minutely
	  var opt1={};
	  var met1=method(:responseCallback3);
	  Comm.makeWebRequest(url1,param1,opt1,met1);
	 }else if(owmCount==1&&Ast.getValue("owmAlert")==true){
	  var url1="https://api.openweathermap.org/data/2.5/onecall";
	  var param1={"lat"=>lat,"lon"=>lon,"exclude"=>"current,daily,hourly,minutely","appid"=>appid1,"units"=>tempUnits}; //,alerts
	  var opt1={};
	  var met1=method(:responseCallback3);
	  Comm.makeWebRequest(url1,param1,opt1,met1);
	 }
	}    
   }
  }
 }
    
 function responseCallback1(responseCode,data) { 
  var url2="https://api.jawg.io/elevations?locations="+lat+","+lon+"&access-token="+appid2;
  var param2={};
  var opt2={};
  var met2=method(:responseCallback2);
  Comm.makeWebRequest(url2,param2,opt2,met2);
  res1=data;
  data=null;
  Code1=responseCode;
 }
 
 function responseCallback2(responseCode,data){ 
  Code2=responseCode;
  res2=data;
  data=null;
  Background.exit([res1,Code1,res2,Code2]);
 }
 
 function responseCallback3(responseCode,data) { 
 //Kein call2,bewusst nicht
  Code1=responseCode;
  //Minutenvorhersage
  var arrMinutely=new[61];
  var precMax=0.0;
  if(data.get("minutely")!=null){
   var minutely=data.get("minutely"); 
   for(var i=0;i<minutely.size();++i){
    var minut=minutely[i];
    if(minut!=null){
     var time=minut["dt"];
     var prec=minut["precipitation"].toFloat();
     minutely[i]=null;
     arrMinutely[i]=[time,prec.format("%.2f")];
     if(prec>=precMax){precMax=prec;}
    }
   }
  }
  //OWM Meteo Alarme
  var alerts=[];
  if (data.get("alerts")!=null){alerts=data.get("alerts");}
  
  //Tägliche Vorhersage
  var arrDaily=new[future+2];
  if(data.get("daily")!=null){	
//System.println(data.get("daily"));
   var arrOWMday=data.get("daily");
   var daily=arrOWMday; 
   for(var i=0;i<=future+1;++i){
	var day=daily[i];
	if(day!=null){
	 var minTemp=day["temp"]["min"];
	 var maxTemp=day["temp"]["max"];
	 var foreIcon=day["weather"][0]["icon"];
	 var popRain=day["pop"];
	 daily[i]=null;
	 arrDaily[i]=[popRain,minTemp,maxTemp,foreIcon];
	}
   }
  }
  res1=[arrMinutely,precMax,alerts,arrDaily]; 
  data=null;
  Bg.exit([res1,Code1,res2,Code2]); //res2 ist bewusst null,gibt keinen Fehler,aber jawg.io wird nicht too much belastet
 }
}