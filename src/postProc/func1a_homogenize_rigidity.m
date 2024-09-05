clear all
close all

load("testframe.mat")
%% Inputs
%px2meter = 7.0141e-05;
int_area = 50;

ell = 1000*int_area*px2meter;
fprintf('approximate size of mesh (critical overlap lengths): %4.4f\n',ell/1.3603)

domainlengths = [1080 1080];
%% External variables
figure(1)
imshow(frame)
hold on

[w,xgrid,ygrid,NXY,X,Y] = getWeights(px2meter,int_area,domainlengths,coords,pairlist);


domainweights = sum(w,1)/sum(w,"all");
domainweights(end) = [];
domainweightgrid = reshape(domainweights,2*(NXY+1));

figure(2)
surfc(X,Y,domainweightgrid)