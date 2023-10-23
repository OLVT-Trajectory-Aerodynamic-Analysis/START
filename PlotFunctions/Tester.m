%Tester file
clc;close all
a = readstruct('EasyMiniStruct.xml');
a.atmosphere.density =  a.atmosphere.pressure ./  (a.atmosphere.temperature + 273.15) / 287.5;
b = a; b.time = a.time + 5;

plotFlights([a,b])