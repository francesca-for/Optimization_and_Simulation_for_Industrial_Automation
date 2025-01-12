clear all
close all
clc
a = 1;

out = sim("lab03es1_sim");
y_data = out.y.Data;

x0 = [0:0.01:10];
y0 = exppdf(x0,1);

figure(1)
plot(x0,y0)
hold on
%y = histogram(y_data, x0);
y = hist(y_data, x0);
plot(x0,y)
hold off

