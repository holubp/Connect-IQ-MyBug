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
 //var arrMond = [1673046472, 1675621711, 1678192818, 1680755668, 1683308040, 1685850101, 1688384318, 1690914696, 1693445733, 1695981449, 1698524640, 1701076576, 1703637190, 1706205237, 1708777822, 1711350016, 1713916135, 1716472385, 1719018468, 1721557024, 1724091944, 1726626864, 1729164381, 1731706108, 1734253298, 1736807211, 1739368399, 1741935275, 1744503732, 1747068952, 1749627825, 1752179802, 1754726098, 1757268529, 1759808853, 1762348755, 1764890040, 1767434570, 1769983750, 1772537869, 1775095914, 1777656186, 1780217107, 1782777395, 1785335737, 1787890706, 1790441337, 1792987904, 1795532009, 1798075689, 1800620238, 1803165814, 1805712223, 1808260024, 1810810735, 1813365854, 1815925488, 1818487715, 1821049406, 1823608015, 1826162750, 1828714122, 1831262579, 1833807820, 1836349559, 1838888791, 1841428130, 1843970921, 1846519841, 1849075782, 1851637649, 1854203093, 1856769435, 1859334008, 1861894105, 1864447410, 1866993009, 1869531978, 1872067001, 1874601442, 1877138532, 1879680937, 1882230665, 1884788951, 1887355647, 1889928171, 1892501184, 1895068455, 1897625981, 1900173382, 1902712793, 1905247140, 1907779252, 1910311910, 1912848255, 1915391866, 1917946002, 1920511810, 1923086419, 1925663142, 1928234764, 1930796970, 1933348870, 1935891583, 1938427102, 1940958072, 1943487926, 1946020821, 1948561062, 1951111952, 1953674299, 1956245572, 1958820740, 1961394184, 1963961168, 1966518571, 1969065423, 1971603142, 1974135083, 1976665600, 1979199005, 1981738678, 1984286513, 1986842930, 1989407216, 1991977441, 1994549834, 1997119032, 1999680153, 2002231141, 2004773302, 2007310050, 2009845222, 2012381877, 2014921915, 2017466514, 2020016815, 2022573861, 2025137397, 2027704721, 2030271331, 2032833228, 2035388660, 2037938056, 2040482944, 2043024997, 2045565739, 2048106719, 2050649657, 2053196183, 2055747222, 2058302515, 2060860833, 2063420735, 2065981035, 2068540598, 2071098004, 2073651799, 2076201321, 2078747321, 2081291578, 2083835754, 2086380509, 2088925756, 2091471740, 2094019759, 2096571705, 2099128744, 2101690122, 2104253121, 2106814496, 2109372243, 2111926097, 2114476503, 2117023435, 2119566476, 2122105999, 2124644019, 2127183833, 2129728780, 2132280893, 2134840145, 2137404687, 2139971777, 2142538500, 2145101903, 2147659182, 2150208549, 2152750160, 2155286145, 2157819796, 2160354615, 2162893678, 2165439392, 2167993448, 2170556495, 2173127215, 2175701409, 2178272715, 2180835537, 2183387682, 2185930348, 2188466383, 2190998843, 2193530591, 2196064581, 2198604195, 2201152979, 2203713358, 2206284557, 2208861446, 2211436463, 2214003554, 2216560283, 2219107053, 2221645606, 2224178338, 2226708317, 2229239360, 2231775747, 2234321371, 2236878350, 2239445725, 2242019463, 2244594055, 2247164327, 2249726418, 2252278322, 2254820301, 2257354828, 2259885859, 2262417809, 2264954539, 2267498588, 2270050912, 2272611214, 2275178245, 2277749374, 2280320134, 2282885293, 2285441275, 2287987741, 2290527176, 2293063317, 2295599636, 2298138481, 2300681139, 2303228542, 2305781775, 2308341454, 2310906355, 2313472959, 2316036995, 2318595614, 2321148228, 2323695847, 2326240001, 2328782118, 2331323526, 2333865697, 2336410245, 2338958483, 2341510847, 2344066726, 2346624976, 2349184543, 2351744496, 2354303608, 2356860240, 2359412980, 2361961581, 2364507211, 2367051604, 2369595907, 2372140335, 2374684955, 2377230706, 2379779519, 2382333322, 2384892609, 2387455634, 2390019068, 2392579847, 2395136588, 2397689330, 2400238253, 2402783032, 2405323591, 2407861239, 2410398890, 2412940174, 2415488074, 2418043779, 2420606335, 2423173251, 2425741441, 2428307700, 2430868853, 2433422362, 2435967392, 2438505289, 2441039039, 2443572264, 2446108400, 2448650280, 2451200022, 2453758894, 2456326660, 2458900477, 2461474596, 2464042428, 2466599857, 2469146633, 2471685148, 2474218604, 2476750054, 2479282403, 2481818798, 2484362761, 2486917466, 2489483940, 2492059121, 2494636114, 2497207613, 2499769365, 2502320649, 2504862793, 2507397975, 2509928945, 2512459141, 2514992629, 2517533563, 2520085042, 2522647650];
 var arrMond = [1695981449, 1698524640, 1701076576, 1703637190, 1706205237, 1708777822, 1711350016, 1713916135, 1716472385, 1719018468, 1721557024, 1724091944, 1726626864, 1729164381, 1731706108, 1734253298, 1736807211, 1739368399, 1741935275, 1744503732, 1747068952, 1749627825, 1752179802, 1754726098, 1757268529, 1759808853, 1762348755, 1764890040, 1767434570, 1769983750, 1772537869, 1775095914, 1777656186, 1780217107, 1782777395, 1785335737, 1787890706, 1790441337, 1792987904, 1795532009, 1798075689, 1800620238, 1803165814, 1805712223, 1808260024, 1810810735, 1813365854, 1815925488, 1818487715, 1821049406, 1823608015, 1826162750, 1828714122, 1831262579, 1833807820, 1836349559, 1838888791, 1841428130, 1843970921, 1846519841, 1849075782, 1851637649, 1854203093, 1856769435, 1859334008, 1861894105, 1864447410, 1866993009, 1869531978, 1872067001, 1874601442, 1877138532, 1879680937, 1882230665, 1884788951, 1887355647, 1889928171, 1892501184];


 var vm;
 var vmOld=0;
 var vmPhase=0;
 var m=0;

 for(m=1;m<arrMond.size();m=m+1){
  vm=arrMond[m];
  vmOld = arrMond[m-1];
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
 var vmMoment = Gregorian.info(new T.Moment(vm), T.FORMAT_SHORT);
 var vmTxt=vmMoment.day.toString() + "." + vmMoment.month.toString() + ".";
 dc.drawText(xMondZahl,yMondZahl, FT_MyBug,vmTxt ,Gc.TEXT_JUSTIFY_CENTER|Gc.TEXT_JUSTIFY_VCENTER);
}