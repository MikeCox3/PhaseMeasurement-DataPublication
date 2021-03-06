clc
clear
close all

run('ColorMap.m')

cs = crystalSymmetry('m-3m');
%ss = specimenSymmetry('triclinic');
%ss = specimenSymmetry('orthorhombic');
ss = specimenSymmetry('mmm');
%set to mmm should default to quarter pole figures

r = xvector;

pfAnnotations = @(varargin) [];
setMTEXpref('pfAnnotations',pfAnnotations);

% pole figure indexes
h_ferrite = {Miller(1,1,0,cs),Miller(2,0,0,cs),Miller(2,1,1,cs),Miller(2,2,0,cs),Miller(3,1,0,cs),Miller(2,2,2,cs)} ;
h_austenite = {Miller(1,1,1,cs),Miller(2,0,0,cs),Miller(2,2,0,cs),Miller(3,1,1,cs),Miller(2,2,2,cs),Miller(4,0,0,cs),Miller(3,3,1,cs),Miller(4,2,0,cs)} ;

% Create save paths (if the don't exist)
AddFiguresDir='ODFFigures';
MtexDataDir='MtexData';
mkdir(AddFiguresDir)
mkdir(MtexDataDir)
savepath='G:\Research\Texture-Sampling-PhaseMeasurement-BiasErrors-master\Matlab\Simulated PFs'
%% Define orientations 

disp('Define Orientations')

Cube = orientation.byMiller([0 0 1],[1 0 0],cs,ss);
Goss = orientation.byMiller([0 1 1],[1 0 0],cs,ss);
Shear = orientation.byMiller([0 0 1],[1 -1 0],cs,ss);
RGoss = orientation.byEuler(0*degree,90*degree,45*degree,cs,ss);

alpha1=orientation.byMiller([1 1 5],[1 -1 0],cs,ss);
alpha2=orientation.byMiller([1 1 3],[1 -1 0],cs,ss);
alpha3=orientation.byMiller([1 1 2],[1 -1 0],cs,ss);
alpha4=orientation.byMiller([2 2 3],[1 -1 0],cs,ss);

o554=orientation.byMiller([5 5 4],[-2 -2 5],cs,ss);

Copper = orientation.byEuler(90*degree,35.264*degree,45*degree,cs,ss);
CopperS=orientation.byEuler(74.49*degree,35.982*degree,54.2175*degree,cs,ss);
S = orientation.byEuler(58.98*degree,36.699*degree,63.435*degree,cs,ss);
BrassS=orientation.byEuler(47.122*degree,40.85*degree,76.718*degree,cs,ss);
Brass = orientation.byEuler(35.264*degree,45*degree,90*degree,cs,ss);

gamma1 = orientation.byEuler(0*degree,54.736*degree,45*degree,cs,ss);
gamma2 = orientation.byEuler(30*degree,54.736*degree,45*degree,cs,ss);

% Fiber textures are not working properly in mtex when created with fibre()
% command
% Fiber textures will be created by a series of unimodal orientations





%% open file to save the Name, texture intex and Entropy
fileID = fopen(fullfile(MtexDataDir,'ComputedTextureIndexValues.txt'),'w');

fprintf(fileID,'%12s\t %5s\t %5s\n','Name','TI', 'Ent');
%fmt = '] ] ] ]\n';
fclose(fileID);



%% Define kernal and halfwidth %%

%a series of halfwidths is possible, but need to remove comment at end of
%code
%for hw=[10 20 30 40 50] 
%for HW=[10*degree 15*degree 20*degree 25*degree 30*degree 35*degree 40*degree 45*degree 50*degree]

%single halfwidth
HW=20*degree;

tmp=num2str(round(HW/degree));
disp(['Halfwidth: ', tmp, ' Degrees'])

disp(HW)
psi = deLaValleePoussinKernel('HALFWIDTH',HW);
%psi = vonMisesFisherKernel('HALFWIDTH',HW);

%% Start for loop of different orientaions
% Define ODFs
for i=1:21

    %% uniform distributions - creates lots of them, but I couldn't find an elegant way to stop that from happening
    
if i==1
%uniform ODF
        disp('Uniform Austenite')
        bname='UniformA';
        phase ='austenite';
        pname ='A';
        odf=uniformODF(cs,ss);

elseif i==2
%uniform ODF
        disp('Uniform Ferrite')
        bname='UniformF';
        phase ='ferrite';
        pname ='F';
        odf=uniformODF(cs,ss); 
    
       %% fiber distributions
elseif i==3
% ferrite alpha fiber 110 || RD
    bname='AlphaFiberF';
    phase ='ferrite';
    pname ='F';
    %gamma= fibre.gamma(cs);
    %ah=alphaFiber.h
    %ar=alphaFiber.r
    %odf = fibreODF(Miller(times(ah,o),cs),Miller(times(ar,o),cs),'halfwidth',HW)
    
    %h = Miller(1,1,0,cs);
    %r = xvector;
    %odf = fibreODF(h,r,ss,psi);
    sixth=(1.0/6.0)
    odf1 = (sixth)*unimodalODF(Shear,'halfwidth',HW,cs,ss,psi);
    odf2 = (sixth)*unimodalODF(alpha1,'halfwidth',HW,cs,ss,psi);
    odf3 = (sixth)*unimodalODF(alpha2,'halfwidth',HW,cs,ss,psi);
    odf4 = (sixth)*unimodalODF(alpha3,'halfwidth',HW,cs,ss,psi);
    odf5 = (sixth)*unimodalODF(alpha4,'halfwidth',HW,cs,ss,psi);
    odf6 = (sixth)*unimodalODF(gamma1,'halfwidth',HW,cs,ss,psi);

    odf=odf1+odf2+odf3+odf4+odf5+odf6;
    
elseif i==4
% ferrite fiber - gamma 111 || ND
    bname='GammaFiber2F';
    phase ='ferrite';
    pname ='F';
    
    odf1=.5*unimodalODF(gamma1,'halfwidth',HW,cs,ss,psi);
    odf2=.5*unimodalODF(gamma2,'halfwidth',HW,cs,ss,psi);
    odf=odf1+odf2;
    
elseif i==5
% austenite fiber - beta fiber, Brass -> Copper via S
%Not working well using the defined beta fiber in mtex
    phase ='austenite';
    pname ='A';
    bname='BetaFiberA';

    odf1 = .2*unimodalODF(Brass,'halfwidth',HW,cs,ss);
    odf2 = .2*unimodalODF(S,'halfwidth',HW,cs,ss);
    odf3 = .2*unimodalODF(Copper,'halfwidth',HW,cs,ss);
    odf4 = .2*unimodalODF(CopperS,'halfwidth',HW,cs,ss);
    odf5 = .2*unimodalODF(BrassS,'halfwidth',HW,cs,ss);

    odf=odf1+odf2+odf3+odf4+odf5;

    %% single orientations
 
% austenite single orientations
elseif i==6
    bname='BrassA';
    phase ='austenite';
    pname ='A';
    odf = unimodalODF(Brass,'halfwidth',HW,cs,ss);

elseif i==7
    bname='CubeA';
    phase ='austenite';
    pname ='A';
    odf = unimodalODF(Cube,'halfwidth',HW,cs,ss);

elseif i==8
    bname='CopperA';
    phase ='austenite';
    pname ='A';
    odf = unimodalODF(Copper,'halfwidth',HW,cs,ss);
    
elseif i==9
    bname='SA';
    phase ='austenite';
    pname ='A';
    odf = unimodalODF(S,'halfwidth',HW,cs,ss);

elseif i==10
    bname='GossA';
    phase ='austenite';
    pname ='A';
    odf = unimodalODF(Goss,'halfwidth',HW,cs,ss);   
    
% ferrite single orientation
elseif i==11
    bname='Gamma1F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(gamma1,'halfwidth',HW,cs,ss)

elseif i==13
    bname='Gamma2F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(gamma2,'halfwidth',HW,cs,ss)
    
elseif i==14
    bname='GossF';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(Goss,'halfwidth',HW,cs,ss)
    
elseif i==15
    bname='ShearF';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(Shear,'halfwidth',HW,cs,ss)    
    
elseif i==16
    bname='o554F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(o554,'halfwidth',HW,cs,ss)    
    
elseif i==17
    bname='alpha1F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(alpha1,'halfwidth',HW,cs,ss)    
    
elseif i==18
    bname='alpha2F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(alpha2,'halfwidth',HW,cs,ss) 
    
elseif i==19
    bname='alpha3F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(alpha3,'halfwidth',HW,cs,ss)    
    
elseif i==20
    bname='alpha4F';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(alpha4,'halfwidth',HW,cs,ss)    

elseif i==21
    bname='RGossF';
    phase ='ferrite';
    pname ='F';
    odf = unimodalODF(RGoss,'halfwidth',HW,cs,ss)  
    
    
end
    

%% Create Plots
disp('Create Plots')

figure; 
plot(odf,'phi2',[45]*degree,'projection','plain','silent',cs,ss,'FontSize',20);
CLim(gcm,[0, 4]);
fig = gcf;
fig.PaperPositionMode = 'auto';
saveas(fig,fullfile(AddFiguresDir,strcat(bname,'-HW', tmp,'-phi2ODF.png')))


%saveas(fig,fullfile(AddFiguresDir,strcat(bname,'-HW', tmp,'-phi2ODF.png')))

%gcf=plot(alpha1F,'phi2',[45]*degree,'projection','plain','silent',cs,ss,'FontSize',20)
%fig = gcf;


pf = calcPoleFigure(odf,h_ferrite);
if pname=='F'
    figure; plotPDF(odf,h_ferrite, cs,ss, 'projection','eangle', 'antipodal','smooth','noLabel');CLim(gcm,[0, 4]);mtexColorbar;
else
    figure; plotPDF(odf,h_austenite, cs,ss, 'projection','eangle', 'antipodal','smooth','noLabel');CLim(gcm,[0, 4]);mtexColorbar;
end    
export_fig(strcat(savepath,'/',bname,'-PF.tiff'),'-r150')
%export_fig(strcat(savepath,'/',pname,'-PF.tiff'),'-r150')
%figure; plot(odf,'phi2',[45]*degree,'projection','plain','silent',cs,ss,'FontSize',20);CLim(gcm,[0, 4]);mtexColorbar;
%export_fig(strcat(savepath,'/',bname,'-phi2-45ODF.png'),'-r300')  


%ODF plot
%figure; plot(odf,'phi2','sections',18,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;
%fig = gcf;
%fig.PaperPositionMode = 'auto';
%saveas(fig,fullfile(AddFiguresDir,strcat(bname,'-HW', tmp,'-phi2ODF.png')))

%Save 45 cross section

%% Commands for output
%disp('Output ODFs to .maa and mtex')
disp('Output ODFs to .maa')

arg= cell(1,2);
arg{1}= 'resolution';
arg{2}= degree ;

csplot = crystalSymmetry('m-3m');
ssplot = specimenSymmetry('triclinic');
S3G = getClass(arg,'SO3Grid',regularSO3Grid(csplot,ssplot,arg));

%odf = uniformODF(cs,ss);

v = eval(odf,S3G,arg);

%v = 5*v;

%{

A custom function was created in mtex to save ODFs generated in the .maa format, which is required to import into MAUD.  The .maa format is similar to the popLA data structure (J. S. Kallend, U. F. Kocks, A. D. Rollett, and H.-R. Wenk, ???popLA - An Integrated Software System for Texture Analysis,??? Textures Microstruct., vol. 14???18, pp. 1203???1208, 1991. ), albeit with whitespace delimited data columns rather than fixed width columns.  While popLA rescaled floating point intensity values an integers (i.e. uniform texture intensity equal to 1.0 was scaled to 100) the .maa format permits floating point numbers.  The function created for .maa output truncates the floating point number to one digit after the decimal point (i.e. ###.#), matching the precision of an .maa file output from MAUD.
    
    
%}

file= fopen( strcat(MtexDataDir,'/',bname,'.maa'),'w');

fprintf(file, 'title \n');
fprintf(file, '7 5.0 \n'); % angle convention and resolution
fprintf(file, '2.86 2.86 2.86 90.00 90.00 90.00 \n');% This is generic header information, not specfic to each phase



for i=1:size(v,3) 
    for j=1:size(v,2)
       for k=1:size(v,1) 
           fprintf(file,'%2.1f ',v(k,j,i));
           
       end
       fprintf(file,'%2.1f ',v(1,j,i)); %repeat for extra term
       fprintf(file,'  \n');
    end
    
    fprintf(file,'  \n');
end

%repeat for extra data block
    for j=1:size(v,2)
       for k=1:size(v,1) 
           fprintf(file,'%2.1f ',v(k,j,1));
           
       end
       fprintf(file,'%2.1f ',v(1,j,1)); 
       fprintf(file,'  \n');
    end
        fprintf(file,'  \n');

%h = {Miller(1,1,0,cs),Miller(2,0,0,cs),Miller(2,1,1,cs)};

%figure
%plotPDF(odf30,h,'contourf',[1.87,1.25,2.5])
%plotPDF(odf,h)
%figure; plotPDF(odf,h,'contourf',[1.0,1.2,1.5,2]);CLim(gcm,[0, 2.5]);mtexColorbar;

%setMTEXpref('EulerAngleConvention','ZYZ')
%plot(odf30,'sections',18, 'colorbar')
%setMTEXpref('EulerAngleConvention','Bunge')


% Save Mtex format
%export(odf,strcat(bname,'-mtex.txt'),'resolution',5*degree)

i=i+1;

close all

end








% end halfwidth loop
%end
