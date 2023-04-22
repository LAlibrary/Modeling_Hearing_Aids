proc import out=hear datafile="C:/Users/lynet/OneDrive/Desktop/HearingAidProject/hear_aids.csv"
dbms=csv replace;
run;

/*fitting generalized logit model*/
proc logistic;
 class Bluetooth(ref="Yes") Rechargable(ref="No") OTC(ref="Yes") / param=ref;
   model Style(ref="ITE")= Bluetooth Rechargable Warranty_Years Price OTC / link=glogit;
run;

/* prediction */
data predict;
input Bluetooth$ Rechargable$ Warranty_Years Price OTC$ ;
cards;
Yes Yes 2 7500 No
;

data hear;
set hear predict;
run;

proc logistic;
class Bluetooth(ref="Yes") Rechargable(ref="No") OTC(ref="Yes") / param=ref;
 model Style(ref="ITE")= Bluetooth Rechargable Warranty_Years Price OTC / link=glogit;
output out=outdata p=pStyle;
run;

proc print data=outdata (firstobs=154) noobs;
var _level_ pStyle;
run;
