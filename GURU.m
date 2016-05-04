function GURU

warning off

I = imread('guru.jpg');
[rows columns] = size(I);
posX = 280; posY = 332;
fig1 = figure (1);
%set(0,'DefaultFigureMenu','none');
imagesc(I);
set(gcf,'Position',[posX posY columns/3 rows*1.25]);
set(gca,'units','pixels');
set(gca,'units','normalized','position',[0 0 1 1]);
axis off;
axis tight;
title('Hello! I am GURU');
%----------load previous output data automatically-------------------------
load('output_data');
%--------------------------------------------------------------------------

%-------INPUT OF DATA CONCENTRATIONS---------------------------------------
prompt = {'write here a name of an xls file to load experimental data',...
          't_max at 140°C [min]','t_max at 150°C [min]','t_max at 160°C [min]','t_max at 170°C [min]'};
dlg_title = 'WELCOME TO GURU';
num_lines = 1;
def = {'isothermal_torque_data.xls','60','30','30','30'};%default values
answer = inputdlg(prompt,dlg_title,num_lines,def);

tmax150=str2num(answer{2});
tmax160=str2num(answer{3});
tmax170=str2num(answer{4});
tmax180=str2num(answer{5});
close(fig1);
%--------------------------------------------------------------------------
setdati=xlsread(answer{1});    
stringa_mescole=answer{1};
f = figure('units','pixels','outerposition',[0 40 1400 730]);
x0=55;
y0=270;
L=230;
H=150;
Delta=130;



%----------------------------------------------------------------------------
%140°C
%----------------------------------------------------------------------------
num0_150=select_data(setdati,1,tmax150,140);

shiftx=0;
ax0= axes('Parent',f,'units','pixel','position',[x0 y0+H+30   L H]);
plot(num0_150(:,1),num0_150(:,2),'Linewidth',2);
hold on;
title('140°C')
ylabel('Torque [dNm]')


[Tor_ts,indice_N]=eval_tor(ts_150,num0_150);
hplot0=plot(ts_150,Tor_ts,'o','MarkerFaceColor','y','MarkerEdgeColor','k');
ylim([0 max(num0_150(:,2))+1]);
xlim([0 tmax150]);
%-----------------initial and maximum values to inspect for Ki-------------
K1_max_150=0.6;
K1_max_160=0.6;
K1_max_170=1;
K1_max_180=1;
K2_max_150=0.35;
K2_max_160=0.40;
K2_max_170=0.7;
K2_max_180=0.9;
K3_max_150=0.025;
K3_max_160=0.05;
K3_max_170=0.07;
K3_max_180=0.1;
%-------------END initial and maximum values to inspect for Ki-------------
K1=K1_150;
K2=K2_150;
K3=K3_150;
%prepars the initial experimental data
XX=num0_150(:,1);
YY=(num0_150(:,2)-min(num0_150(:,2)))/(max(num0_150(:,2))-min(num0_150(:,2)));
Torque_max_mintemp=max(num0_150(:,2));
Torque_min_mintemp=min(num0_150(:,2));
x=XX;
ax = axes('Parent',f,'units','pixel','position',[x0 y0   L H]);
hplot3= plot(XX,YY,'-','Linewidth',2);
hold on;
hplot = plot(x,K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x)-exp(-(K1+K2)*x)),'--k','Linewidth',2);
ylabel('Vulcanization degree \alpha [ ]')
legend('Experimental','Numerical','Location','SouthEast')
% addlistener(h0,'ActionEvent',@(hObject, event0) makeplot0(f,hObject, ax0,ax,hplot0,hplot3,event0,num0));
% 

ax1 = axes('Parent',f,'units','pixel','position',[x0 y0-Delta L H/2]);
hplot1 = plot(x,abs(YY-(K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x))-exp(-(K1+K2)*x))),'--','Linewidth',2);
xlabel('Time t [min]'),ylabel('Abs. error e=|f_{exp}-f_{num}|')
ylim([0 0.2])

axfin = axes('Parent',f,'units','pixel','position',[x0+1110 1.15*y0 0.8*L 2*H]);

%-------------------Arrhenius space initial plot---------------------------
logK1=2.3026*log([1.2*K1-1.7782 1.1*K1-1.7782 1.0*K1-1.7782 0.9*K1-1.7782]);
logK2=2.3026*log([1.3*K2-1.7782 1.2*K2-1.7782 1.1*K2-1.7782 0.9*K2-1.7782]);
logK3=2.3026*log([1.2*K3-1.7782 1.1*K3-1.7782 1.0*K3-1.7782 0.9*K3-1.7782]);
% 
hplot1fin = plot([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],logK1,'s','MarkerFaceColor','w');
hold on;
hplot2fin = plot([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],logK2,'^','MarkerFaceColor','c');
hold on;
hplot3fin = plot([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],logK3,'d','MarkerFaceColor','g');
hold on;
uno_su_T_min=1/(180+273);
uno_su_T_max=1/(130+273);
x_interp=uno_su_T_min:(uno_su_T_max-uno_su_T_min)/100:uno_su_T_max;

P=polyfit([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],logK1,1);
y1_interp=P(1)*x_interp+P(2);
hplot1fin_interp=plot(x_interp,y1_interp,'--','Linewidth',2);
hold on;

P=polyfit([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],logK2,1);
y2_interp=P(1)*x_interp+P(2);
hplot2fin_interp=plot(x_interp,y2_interp,'-','Linewidth',2);
hold on;


P=polyfit([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],logK3,1);
y3_interp=P(1)*x_interp+P(2);
hplot3fin_interp=plot(x_interp,y3_interp,':','Linewidth',2);
hold on;

xlabel('1/T [1/K]'),title('ln(K_i) K_i in 1/sec');
legend('K_1','K_2','K_3','K_1 linear regression','K_2 linear regression','K_3 linear regression','Location','SouthOutside');
xlim([1/(180+273) 1/(130+273)]);
hold on;

%-------------------sliders for fitting------------------------------------
h0 = uicontrol('style','slider','units','pixel','position',[90 630 190 20],'value',ts_150, 'min',0, 'max',tmax150/3);
bl00= uicontrol('Parent',f,'Style','text','Position',[10,630,23,23],'String','ts','BackgroundColor','w');
h1 = uicontrol('style','slider','units','pixel','position',[90 70 190 20],'value',K1_150, 'min',0, 'max',K1_max_150);
% bl1 =
% uicontrol('Parent',f,'Style','text','Position',[120,100,23,23],'String','0','BackgroundColor','w');
bl11= uicontrol('Parent',f,'Style','text','Position',[10,70,23,23],'String','K1=','BackgroundColor','w');
h2 = uicontrol('style','slider','units','pixel','position',[90 40 190 20],'value',K2_150, 'min',0, 'max',K2_max_150);
bl22= uicontrol('Parent',f,'Style','text','Position',[10,40,23,23],'String','K2=','BackgroundColor','w');
h3 = uicontrol('style','slider','units','pixel','position',[90 10 190 20],'value',K3_150, 'min',0, 'max',K3_max_150);
bl33= uicontrol('Parent',f,'Style','text','Position',[10,10,23,23],'String','K3=','BackgroundColor','w');

%save data


%-------------------END sliders for fitting--------------------------------

%------------------final table with K values-------------------------------

bl20= uicontrol('Parent',f,'Style','text','Position',[70+1100,20,23,23],'String','K1','BackgroundColor','w');
bl30= uicontrol('Parent',f,'Style','text','Position',[70+1160,20,23,23],'String','K2','BackgroundColor','w');
bl40= uicontrol('Parent',f,'Style','text','Position',[70+1220,20,23,23],'String','K3','BackgroundColor','w');

bl20= uicontrol('Parent',f,'Style','text','Position',[70+1155,225,60,23],'String','T=140°C','BackgroundColor','w');
bl20= uicontrol('Parent',f,'Style','text','Position',[70+1155,175,60,23],'String','T=150°C','BackgroundColor','w');
bl20= uicontrol('Parent',f,'Style','text','Position',[70+1155,125,60,23],'String','T=160°C','BackgroundColor','w');
bl20= uicontrol('Parent',f,'Style','text','Position',[70+1155, 75,60,23],'String','T=170°C','BackgroundColor','w');


bl33_180= uicontrol('Parent',f,'Style','text','Position',[20+1155,255,160,23],'String',stringa_mescole,'BackgroundColor','y');
%------------------END final table with K values---------------------------


%----------------------------------------------------------------------------
%150°C
%----------------------------------------------------------------------------
K1=K1_160;
K2=K2_160;
K3=K3_160;


num0_160=select_data(setdati,1,tmax160,150);

shiftx=280;
ax0_160= axes('Parent',f,'units','pixel','position',[x0+shiftx y0+H+30   L H]);
plot(num0_160(:,1),num0_160(:,2),'Linewidth',2);
hold on;
title('150°C')



[Tor_ts,indice_N]=eval_tor(ts_160,num0_160);
hplot0_160=plot(ts_160,Tor_ts,'o','MarkerFaceColor','y','MarkerEdgeColor','k');
ylim([0 max(num0_160(:,2))+1]);
xlim([0 tmax160]);

%prepara il dato sperimentale in entrata
XX=num0_160(:,1);
YY=(num0_160(:,2)-min(num0_150(:,2)))/(max(num0_150(:,2))-min(num0_150(:,2)));
x=XX;
ax_160= axes('Parent',f,'units','pixel','position',[x0+shiftx y0   L H]);
hplot3_160= plot(XX,YY,'-','Linewidth',2);
hold on;

hplot_160= plot(x,K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x)-exp(-(K1+K2)*x)),'--k','Linewidth',2);

legend('Experimental','Numerical','Location','SouthEast')
% addlistener(h0,'ActionEvent',@(hObject, event0) makeplot0(f,hObject, ax0,ax,hplot0,hplot3,event0,num0));
% 

ax1_160= axes('Parent',f,'units','pixel','position',[x0+shiftx y0-Delta L H/2]);
hplot1_160= plot(x,abs(YY-(K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x))-exp(-(K1+K2)*x))),'--','Linewidth',2);
xlabel('Time t [min]')
ylim([0 0.2])

%-------------------sliders for fitting------------------------------------
h0_160= uicontrol('style','slider','units','pixel','position',[90+shiftx 630 190 20],'value',ts_160, 'min',0, 'max',tmax160/3);
bl00_160= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,630,23,23],'String','ts','BackgroundColor','w');
h1_160= uicontrol('style','slider','units','pixel','position',[90+shiftx 70 190 20],'value',K1_160, 'min',0, 'max',K1_max_160);
bl11_160= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,70,23,23],'String','K1=','BackgroundColor','w');
h2_160= uicontrol('style','slider','units','pixel','position',[90+shiftx 40 190 20],'value',K2_160, 'min',0, 'max',K2_max_160);
bl22_160= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,40,23,23],'String','K2=','BackgroundColor','w');
h3_160= uicontrol('style','slider','units','pixel','position',[90+shiftx 10 190 20],'value',K3_160, 'min',0, 'max',K3_max_160);
bl33_160= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,10,23,23],'String','K3=','BackgroundColor','w');
%--------------END--sliders for fitting------------------------------------
%----------------------------------------------------------------------------
%160°C
%----------------------------------------------------------------------------
K1=K1_170;
K2=K2_170;
K3=K3_170;
num0_170=select_data(setdati,1,tmax170,160);



shiftx=280*2;
ax0_170= axes('Parent',f,'units','pixel','position',[x0+shiftx y0+H+30   L H]);
plot(num0_170(:,1),num0_170(:,2),'Linewidth',2);
hold on;
title('160°C')


[Tor_ts,indice_N]=eval_tor(ts_170,num0_170);
hplot0_170=plot(ts_170,Tor_ts,'o','MarkerFaceColor','y','MarkerEdgeColor','k');
ylim([0 max(num0_170(:,2))+1]);
xlim([0 tmax170]);

%prepara il dato sperimentale in entrata
XX=num0_170(:,1);
YY=(num0_170(:,2)-min(num0_170(:,2)))/(max(num0_150(:,2))-min(num0_150(:,2)));
x=XX;
ax_170= axes('Parent',f,'units','pixel','position',[x0+shiftx y0   L H]);
hplot3_170= plot(XX,YY,'-','Linewidth',2);
hold on;
hplot_170= plot(x,K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x)-exp(-(K1+K2)*x)),'--k','Linewidth',2);

legend('Experimental','Numerical','Location','SouthEast')
% addlistener(h0,'ActionEvent',@(hObject, event0) makeplot0(f,hObject, ax0,ax,hplot0,hplot3,event0,num0));
% 

ax1_170= axes('Parent',f,'units','pixel','position',[x0+shiftx y0-Delta L H/2]);
hplot1_170= plot(x,abs(YY-(K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x))-exp(-(K1+K2)*x))),'--','Linewidth',2);
xlabel('Time t [min]')
ylim([0 0.2])

%-------------------sliders for fitting------------------------------------
h0_170= uicontrol('style','slider','units','pixel','position',[90+shiftx 630 190 20],'value',ts_170, 'min',0, 'max',tmax170/3);
bl00_170= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,630,23,23],'String','ts','BackgroundColor','w');
h1_170= uicontrol('style','slider','units','pixel','position',[90+shiftx 70 190 20],'value',K1_170, 'min',0, 'max',K1_max_170);
% bl1 = uicontrol('Parent',f,'Style','text','Position',[120,100,23,23],'String','0','BackgroundColor','w');
bl11_170= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,70,23,23],'String','K1=','BackgroundColor','w');
h2_170= uicontrol('style','slider','units','pixel','position',[90+shiftx 40 190 20],'value',K2_170, 'min',0, 'max',K2_max_170);
bl22_170= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,40,23,23],'String','K2=','BackgroundColor','w');
h3_170= uicontrol('style','slider','units','pixel','position',[90+shiftx 10 190 20],'value',K3_170, 'min',0, 'max',K3_max_170);
bl33_170= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,10,23,23],'String','K3=','BackgroundColor','w');

%---------------END sliders for fitting------------------------------------

%----------------------------------------------------------------------------
%170°C
%----------------------------------------------------------------------------
K1=K1_180;
K2=K2_180;
K3=K3_180;
num0_180=select_data(setdati,1,tmax180,170);

shiftx=280*3;
ax0_180= axes('Parent',f,'units','pixel','position',[x0+shiftx y0+H+30   L H]);
plot(num0_180(:,1),num0_180(:,2),'Linewidth',2);
hold on;
title('170°C')



[Tor_ts,indice_N]=eval_tor(ts_180,num0_180);
hplot0_180=plot(ts_180,Tor_ts,'o','MarkerFaceColor','y','MarkerEdgeColor','k');
ylim([0 max(num0_180(:,2))+1]);
xlim([0 tmax180]);

%prepara il dato sperimentale in entrata
XX=num0_180(:,1);
YY=(num0_180(:,2)-min(num0_180(:,2)))/(max(num0_150(:,2))-min(num0_150(:,2)));
x=XX;
ax_180= axes('Parent',f,'units','pixel','position',[x0+shiftx y0   L H]);
hplot3_180= plot(XX,YY,'-','Linewidth',2);
hold on;
hplot_180= plot(x,K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x)-exp(-(K1+K2)*x)),'--k','Linewidth',2);

legend('Experimental','Numerical','Location','SouthEast')
% addlistener(h0,'ActionEvent',@(hObject, event0) makeplot0(f,hObject, ax0,ax,hplot0,hplot3,event0,num0));
% 

ax1_180= axes('Parent',f,'units','pixel','position',[x0+shiftx y0-Delta L H/2]);
hplot1_180= plot(x,abs(YY-(K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x))-exp(-(K1+K2)*x))),'--','Linewidth',2);
xlabel('Time t [min]')
ylim([0 0.2])


%-------------------sliders for fitting------------------------------------
h0_180= uicontrol('style','slider','units','pixel','position',[90+shiftx 630 190 20],'value',ts_180, 'min',0, 'max',tmax180/3);
bl00_180= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,630,23,23],'String','ts','BackgroundColor','w');
h1_180= uicontrol('style','slider','units','pixel','position',[90+shiftx 70 190 20],'value',K1_180, 'min',0, 'max',K1_max_180);
% bl1 = uicontrol('Parent',f,'Style','text','Position',[120,100,23,23],'String','0','BackgroundColor','w');
bl11_180= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,70,23,23],'String','K1=','BackgroundColor','w');
h2_180= uicontrol('style','slider','units','pixel','position',[90+shiftx 40 190 20],'value',K2_180, 'min',0, 'max',K2_max_180);
bl22_180= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,40,23,23],'String','K2=','BackgroundColor','w');
h3_180= uicontrol('style','slider','units','pixel','position',[90+shiftx 10 190 20],'value',K3_180, 'min',0, 'max',K3_max_180);
bl33_180= uicontrol('Parent',f,'Style','text','Position',[10+shiftx,10,23,23],'String','K3=','BackgroundColor','w');
%------------END-----sliders for fitting-----------------------------------


shiftx=0;
addlistener(h0,'ActionEvent',@(hObject, event0) makeplot(f,hObject, event0,x,YY,hplot,hplot1,h1,h2,0,h3,hplot0,hplot3,num0_150,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,150,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h1,'ActionEvent',@(hObject, event1) makeplot(f,hObject, event1,x,YY,hplot,hplot1,h2,h3,1,h0,hplot0,hplot3,num0_150,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,150,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h2,'ActionEvent',@(hObject, event2) makeplot(f,hObject, event2,x,YY,hplot,hplot1,h1,h3,2,h0,hplot0,hplot3,num0_150,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,150,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h3,'ActionEvent',@(hObject, event3) makeplot(f,hObject, event3,x,YY,hplot,hplot1,h1,h2,3,h0,hplot0,hplot3,num0_150,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,150,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));

shiftx=280;
addlistener(h0_160,'ActionEvent',@(hObject, event0) makeplot(f,hObject, event0,x,YY,hplot_160,hplot1_160,h1_160,h2_160,0,h3_160,hplot0_160,hplot3_160,num0_160,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,160,h1,h2,h3,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h1_160,'ActionEvent',@(hObject, event1) makeplot(f,hObject, event1,x,YY,hplot_160,hplot1_160,h2_160,h3_160,1,h0_160,hplot0_160,hplot3_160,num0_160,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,160,h1,h2,h3,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h2_160,'ActionEvent',@(hObject, event2) makeplot(f,hObject, event2,x,YY,hplot_160,hplot1_160,h1_160,h3_160,2,h0_160,hplot0_160,hplot3_160,num0_160,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,160,h1,h2,h3,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h3_160,'ActionEvent',@(hObject, event3) makeplot(f,hObject, event3,x,YY,hplot_160,hplot1_160,h1_160,h2_160,3,h0_160,hplot0_160,hplot3_160,num0_160,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,160,h1,h2,h3,h1_170,h2_170,h3_170,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));

shiftx=280*2;
addlistener(h0_170,'ActionEvent',@(hObject, event0) makeplot(f,hObject, event0,x,YY,hplot_170,hplot1_170,h1_170,h2_170,0,h3_170,hplot0_170,hplot3_170,num0_170,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,170,h1_160,h2_160,h3_160,h1,h2,h3,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h1_170,'ActionEvent',@(hObject, event1) makeplot(f,hObject, event1,x,YY,hplot_170,hplot1_170,h2_170,h3_170,1,h0_170,hplot0_170,hplot3_170,num0_170,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,170,h1_160,h2_160,h3_160,h1,h2,h3,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h2_170,'ActionEvent',@(hObject, event2) makeplot(f,hObject, event2,x,YY,hplot_170,hplot1_170,h1_170,h3_170,2,h0_170,hplot0_170,hplot3_170,num0_170,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,170,h1_160,h2_160,h3_160,h1,h2,h3,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h3_170,'ActionEvent',@(hObject, event3) makeplot(f,hObject, event3,x,YY,hplot_170,hplot1_170,h1_170,h2_170,3,h0_170,hplot0_170,hplot3_170,num0_170,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,170,h1_160,h2_160,h3_160,h1,h2,h3,h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));

shiftx=280*3;
addlistener(h0_180,'ActionEvent',@(hObject, event0) makeplot(f,hObject, event0,x,YY,hplot_180,hplot1_180,h1_180,h2_180,0,h3_180,hplot0_180,hplot3_180,num0_180,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,180,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1,h2,h3,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h1_180,'ActionEvent',@(hObject, event1) makeplot(f,hObject, event1,x,YY,hplot_180,hplot1_180,h2_180,h3_180,1,h0_180,hplot0_180,hplot3_180,num0_180,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,180,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1,h2,h3,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h2_180,'ActionEvent',@(hObject, event2) makeplot(f,hObject, event2,x,YY,hplot_180,hplot1_180,h1_180,h3_180,2,h0_180,hplot0_180,hplot3_180,num0_180,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,180,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1,h2,h3,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));
addlistener(h3_180,'ActionEvent',@(hObject, event3) makeplot(f,hObject, event3,x,YY,hplot_180,hplot1_180,h1_180,h2_180,3,h0_180,hplot0_180,hplot3_180,num0_180,shiftx,...
    hplot1fin,hplot2fin,hplot3fin,180,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,h1,h2,h3,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp));

%Button for dataset saving
SaveButton=uicontrol('style', 'pushbutton', 'string', 'Save Data','callback',{@saveData,h0,h1,h2,h3,h0_160,h1_160,h2_160,h3_160,h0_170,h1_170,h2_170,h3_170,h0_180,h1_180,h2_180,h3_180},'position',[1180 640 150 20]);

end

%-------------------------plot Ki in the Arrhenius Space (lnKi in 1/sec)
function makeplot(f,hObject,event,x,YY,hplot,hplot1,h2,h3,flag,h0,hplot0,hplot3,num0,shiftx,hplot1fin,hplot2fin,hplot3fin,temp,h1_160,h2_160,h3_160,h1_170,h2_170,h3_170,...
    h1_180,h2_180,h3_180,x_interp,hplot1fin_interp,hplot2fin_interp,hplot3fin_interp,Torque_max_mintemp,Torque_min_mintemp)



if flag==0
    ts=get(hObject,'Value');
[Tor_ts,indice_N]=eval_tor(ts,num0);
XX=num0(indice_N:size(num0,1),1)-num0(indice_N,1);
YY=(num0(indice_N:size(num0,1),2)-num0(indice_N,2))/(Torque_max_mintemp-1*num0(indice_N,2));
x=XX;
% set(f,'CurrentAxes',ax0)
set(hplot0,'xdata',ts,'ydata',Tor_ts);
% set(f,'CurrentAxes',ax)
K1 = get(h2,'Value');
K2=get(h3,'Value');
K3=get(h0,'Value');

set(hplot3,'xdata',XX,'ydata',YY);


% alfa_num=K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x)-exp(-(K1+K2)*x));
% set(hplot,'xdata',x,'ydata',alfa_num);
% set(hplot1,'xdata',x,'ydata',abs(YY-alfa_num));

bl00= uicontrol('Parent',f,'Style','text','Position',[30+shiftx,630,50,23],'String',num2str(ts),'BackgroundColor','w');
drawnow;
else
 ts=get(h0,'Value');   
[Tor_ts,indice_N]=eval_tor(ts,num0);
XX=num0(indice_N:size(num0,1),1)-num0(indice_N,1);
YY=(num0(indice_N:size(num0,1),2)-num0(indice_N,2))/(Torque_max_mintemp-1*num0(indice_N,2));
x=XX;
if flag==1
K1 = get(hObject,'Value');
K2=get(h2,'Value');
K3=get(h3,'Value');
end
if flag==2
K2 = get(hObject,'Value');
K1=get(h2,'Value');
K3=get(h3,'Value');
end
if flag==3
K3 = get(hObject,'Value');
K1=get(h2,'Value');
K2=get(h3,'Value');
end

if temp==180
logK1(4)=log10(get(h1_180,'Value'));
logK2(4)=log10(get(h2_180,'Value'));
logK3(4)=log10(get(h3_180,'Value'));
logK1(3)=log10(get(h1_160,'Value'));
logK2(3)=log10(get(h2_160,'Value'));
logK3(3)=log10(get(h3_160,'Value'));
logK1(2)=log10(get(h1_170,'Value'));
logK2(2)=log10(get(h2_170,'Value'));
logK3(2)=log10(get(h3_170,'Value'));
logK1(1)=log10(K1);
logK2(1)=log10(K2);
logK3(1)=log10(K3);
set(hplot1fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK1-1.7782));
set(hplot2fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK2-1.7782));
set(hplot3fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK3-1.7782));
end



if temp==170
logK1(4)=log10(get(h1_170,'Value'));
logK2(4)=log10(get(h2_170,'Value'));
logK3(4)=log10(get(h3_170,'Value'));
logK1(3)=log10(get(h1_160,'Value'));
logK2(3)=log10(get(h2_160,'Value'));
logK3(3)=log10(get(h3_160,'Value'));
logK1(2)=log10(K1);
logK2(2)=log10(K2);
logK3(2)=log10(K3);
logK1(1)=log10(get(h1_180,'Value'));
logK2(1)=log10(get(h2_180,'Value'));
logK3(1)=log10(get(h3_180,'Value'));
set(hplot1fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK1-1.7782));
set(hplot2fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK2-1.7782));
set(hplot3fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK3-1.7782));
end

if temp==160
logK1(4)=log10(get(h1_160,'Value'));
logK2(4)=log10(get(h2_160,'Value'));
logK3(4)=log10(get(h3_160,'Value'));
logK1(3)=log10(K1);
logK2(3)=log10(K2);
logK3(3)=log10(K3);
logK1(2)=log10(get(h1_170,'Value'));
logK2(2)=log10(get(h2_170,'Value'));
logK3(2)=log10(get(h3_170,'Value'));
logK1(1)=log10(get(h1_180,'Value'));
logK2(1)=log10(get(h2_180,'Value'));
logK3(1)=log10(get(h3_180,'Value'));
set(hplot1fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK1-1.7782));
set(hplot2fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK2-1.7782));
set(hplot3fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK3-1.7782));
end

if temp==150
logK1(4)=log10(K1);
logK2(4)=log10(K2);
logK3(4)=log10(K3);
logK1(3)=log10(get(h1_160,'Value'));
logK2(3)=log10(get(h2_160,'Value'));
logK3(3)=log10(get(h3_160,'Value'));
logK1(2)=log10(get(h1_170,'Value'));
logK2(2)=log10(get(h2_170,'Value'));
logK3(2)=log10(get(h3_170,'Value'));
logK1(1)=log10(get(h1_180,'Value'));
logK2(1)=log10(get(h2_180,'Value'));
logK3(1)=log10(get(h3_180,'Value'));
set(hplot1fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK1-1.7782));
set(hplot2fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK2-1.7782));
set(hplot3fin,'xdata',[1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],'ydata',2.3026*(logK3-1.7782));
end


%-------linear best fitting of K1 K2 and K3--------------------------------
P=polyfit([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],2.3026*(logK1-1.7782),1);
y1_interp=P(1)*x_interp+P(2);
set(hplot1fin_interp,'xdata',x_interp,'ydata',y1_interp);

P=polyfit([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],2.3026*(logK2-1.7782),1);
y2_interp=P(1)*x_interp+P(2);
set(hplot2fin_interp,'xdata',x_interp,'ydata',y2_interp);


P=polyfit([1/(170+273) 1/(160+273) 1/(150+273) 1/(140+273)],2.3026*(logK3-1.7782),1);
y3_interp=P(1)*x_interp+P(2);
set(hplot3fin_interp,'xdata',x_interp,'ydata',y3_interp);
%--------------------------------------------------------------------------


% set(hplot2fin,'xdata',[1/(160+273) 1/(150+273)],'ydata',logK2);
% set(hplot3fin,'xdata',[1/(160+273) 1/(150+273)],'ydata',logK3);

%values of Ki near the slider
bl11= uicontrol('Parent',f,'Style','text','Position',[30+shiftx,70,50,23],'String',num2str(K1),'BackgroundColor','w');
bl22= uicontrol('Parent',f,'Style','text','Position',[30+shiftx,40,50,23],'String',num2str(K2),'BackgroundColor','w');
bl33= uicontrol('Parent',f,'Style','text','Position',[30+shiftx,10,50,23],'String',num2str(K3),'BackgroundColor','w');

if temp==150
bl11= uicontrol('Parent',f,'Style','text','Position',[70+1100,200,50,23],'String',num2str(K1),'BackgroundColor','w');
bl22= uicontrol('Parent',f,'Style','text','Position',[70+1160,200,50,23],'String',num2str(K2),'BackgroundColor','w');
bl33= uicontrol('Parent',f,'Style','text','Position',[70+1220,200,50,23],'String',num2str(K3),'BackgroundColor','w');
end
if temp==160
bl11= uicontrol('Parent',f,'Style','text','Position',[70+1100,150,50,23],'String',num2str(K1),'BackgroundColor','w');
bl22= uicontrol('Parent',f,'Style','text','Position',[70+1160,150,50,23],'String',num2str(K2),'BackgroundColor','w');
bl33= uicontrol('Parent',f,'Style','text','Position',[70+1220,150,50,23],'String',num2str(K3),'BackgroundColor','w');
end
if temp==170
bl11= uicontrol('Parent',f,'Style','text','Position',[70+1100,100,50,23],'String',num2str(K1),'BackgroundColor','w');
bl22= uicontrol('Parent',f,'Style','text','Position',[70+1160,100,50,23],'String',num2str(K2),'BackgroundColor','w');
bl33= uicontrol('Parent',f,'Style','text','Position',[70+1220,100,50,23],'String',num2str(K3),'BackgroundColor','w');
end
if temp==180
bl11= uicontrol('Parent',f,'Style','text','Position',[70+1100,50,50,23],'String',num2str(K1),'BackgroundColor','w');
bl22= uicontrol('Parent',f,'Style','text','Position',[70+1160,50,50,23],'String',num2str(K2),'BackgroundColor','w');
bl33= uicontrol('Parent',f,'Style','text','Position',[70+1220,50,50,23],'String',num2str(K3),'BackgroundColor','w');
end

drawnow;
end
alfa_num=K1/(K1+K2)*(1-exp(-(K1+K2)*(x)))+K2/(K1+K2-K3)*(exp(-K3*x)-exp(-(K1+K2)*x));
%alfa_num=alfa_num/max(alfa_num);
%evaluation of the numerical curve
set(hplot,'xdata',x,'ydata',alfa_num);

%evaluation of the numerical absolute error
set(hplot1,'xdata',x,'ydata',abs(YY-alfa_num));

end


% function makeplot0(f,hObject, ax0,ax,hplot0,hplot,event0,num0)
% 
% ts=get(hObject,'Value');
% [Tor_ts,indice_N]=eval_tor(ts,num0);
% XX=num0(indice_N:size(num0,1),1)-num0(indice_N,1);
% YY=num0(indice_N:size(num0,1),2)/(max(num0(:,2))-1*num0(indice_N,2));
% set(f,'CurrentAxes',ax0)
% set(hplot0,'xdata',ts,'ydata',Tor_ts);
% set(f,'CurrentAxes',ax)
% set(hplot,'xdata',XX,'ydata',YY);
% 
% bl00= uicontrol('Parent',f,'Style','text','Position',[30,610,30,23],'String',num2str(ts),'BackgroundColor','w');
% drawnow;
% end


function [Tor_ts,indice_N]=eval_tor(ts,num0)
indice_N=1;
Tor_ts=num0(1,2);
for i=1:size(num0,1)-1
    if ts>=num0(i,1)&ts<=num0(i+1,1)
        Tor_ts=(num0(i+1,2)+num0(i,2))/2;
        indice_N=i;
    end
end
end


function num0=select_data(setdati,flag,tmax,Temp)

   if Temp==140%°C
   XX=setdati(:,1)/60;
   YY=setdati(:,2);
   end
   if Temp==150%°C
   XX=setdati(:,3)/60;
   YY=setdati(:,4);
   end
   if Temp==160%°C
   XX=setdati(:,5)/60;
   YY=setdati(:,6);
   end
   if Temp==170%°C
   XX=setdati(:,7)/60;
   YY=setdati(:,8);
   end
   cont=0;
   for i=1:size(XX,1)
       if XX(i)<tmax
          cont=cont+1;
          num_app(cont,:)=[XX(i) YY(i)];
       end
       if i>1
           if XX(i-1)<tmax&XX(i)>=tmax
           cont=cont+1;
          num_app(cont,:)=[XX(i) YY(i)]; 
          break
           end
       end
   end
   
% [A1, index] = sort(num_app(:,1))
% A2          = num_app(index, 2)

[xx,id]=unique(num_app(:,1));

% Value       = interp1(A1(uniq), A2(uniq), 15.0000);   
id=sort(id);
for j=1:size(id,1)
num_appfin(j,1)=num_app(id(j),1);
num_appfin(j,2)=num_app(id(j),2);
end
num_app=num_appfin;

num0(:,1)=0:tmax/1000:tmax;

num0(:,2)=interp1(num_app(:,1),num_app(:,2),num0(:,1));
end

function saveData(SaveButton,event,h0_150,h1_150,h2_150,h3_150,h0_160,h1_160,h2_160,h3_160,...
    h0_170,h1_170,h2_170,h3_170,h0_180,h1_180,h2_180,h3_180)

ts_150=get(h0_150,'Value');
ts_160=get(h0_160,'Value');
ts_170=get(h0_170,'Value');
ts_180=get(h0_180,'Value');

K1_150=get(h1_150,'Value');
K1_160=get(h1_160,'Value');
K1_170=get(h1_170,'Value');
K1_180=get(h1_180,'Value');

K2_150=get(h2_150,'Value');
K2_160=get(h2_160,'Value');
K2_170=get(h2_170,'Value');
K2_180=get(h2_180,'Value');

K3_150=get(h3_150,'Value');
K3_160=get(h3_160,'Value');
K3_170=get(h3_170,'Value');
K3_180=get(h3_180,'Value');

uisave({'ts_150','ts_160','ts_170','ts_180','K1_150','K1_160','K1_170','K1_180','K2_150','K2_160','K2_170','K2_180','K3_150','K3_160','K3_170','K3_180'}, 'output_data');
end

