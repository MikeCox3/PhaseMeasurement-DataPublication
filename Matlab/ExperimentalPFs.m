%% Program to read in experimental pole figures in the .sum file format
%{

 .sum files are generated by the program PF program 
 https://www.ncnr.nist.gov/instruments/bt8/BT8DataAnalysis.htm


Written by Adam Creuziger (adam.creuziger@nist.gov)

Oct 2017

This data was developed by employees of the National Institute of Standards and Technology (NIST), an agency of the Federal Government. Pursuant to title 17 United States Code Section 105, works of NIST employees are not subject to copyright protection in the United States and are considered to be in the public domain.

The data is provided by NIST as a public service and is expressly provided "AS IS." NIST MAKES NO WARRANTY OF ANY KIND, EXPRESS, IMPLIED OR STATUTORY, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTY OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT AND DATA ACCURACY. NIST does not warrant or make any representations regarding the use of the data or the results thereof, including but not limited to the correctness, accuracy, reliability or usefulness of the data. NIST SHALL NOT BE LIABLE AND YOU HEREBY RELEASE NIST FROM LIABILITY FOR ANY INDIRECT, CONSEQUENTIAL, SPECIAL, OR INCIDENTAL DAMAGES (INCLUDING DAMAGES FOR LOSS OF BUSINESS PROFITS, BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, AND THE LIKE), WHETHER ARISING IN TORT, CONTRACT, OR OTHERWISE, ARISING FROM OR RELATING TO THE DATA (OR THE USE OF OR INABILITY TO USE THIS DATA), EVEN IF NIST HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

To the extent that NIST may hold copyright in countries other than the United States, you are hereby granted the non-exclusive irrevocable and unconditional right to print, publish, prepare derivative works and distribute the NIST data, in any medium, or authorize others to do so on your behalf, on a royalty-free basis throughout the world.

You may improve, modify, and create derivative works of the data or any portion of the data, and you may copy and distribute such modifications or works. Modified works should carry a notice stating that you changed the data and should note the date and nature of any such change. Please explicitly acknowledge the National Institute of Standards and Technology as the source of the data: Data citation recommendations are provided below.

Permission to use this data is contingent upon your acceptance of the terms of this agreement and upon your providing appropriate acknowledgments of NIST's creation of the data.

See: https://www.nist.gov/director/licensing
%}


%% 

% set to 1 to remove extra annotations
%setMTEXpref('FontSize',1);

% Only read in TRIP 700 pole figures to plot
% austenite - 111, 200, 220
% ferrite - 110, 200, 211

% plot as quarter circles

%clear the workspace and close open windows
clc
clear
close all
%Set sample and crystal symmetry
cs = crystalSymmetry('m-3m');
ss = specimenSymmetry('orthorhombic');

% To align pole figures with mplstereonet, 
 plotx2north % X up, Y to the left

% Set colormap explicitly
run('ColorMap.m')

%austenite and ferrite pole figures to plot
h_ferrite = {Miller(1,1,0,cs),Miller(2,0,0,cs),Miller(2,1,1,cs),Miller(2,2,0,cs),Miller(3,1,0,cs),Miller(2,2,2,cs)} ;
h_austenite = {Miller(1,1,1,cs),Miller(2,0,0,cs),Miller(2,2,0,cs),Miller(3,1,1,cs),Miller(2,2,2,cs),Miller(4,0,0,cs),Miller(3,3,1,cs),Miller(4,2,0,cs)} ;

%SavePaths
savepath='ExpFigures';
mkdir(savepath)


%Create a file with the sample name, texture intex and texture entropy
fileID = fopen(strcat(savepath,'/','ExpTextureValues.txt'),'w');

fprintf(fileID,'%12s\t %5s\t %5s\n','Name','TI', 'Ent');
fclose(fileID);

%read in 4 experimental data sets
for i=1:8
    
    
    
if i==1
    disp('TRIP 700 Ferrite')
    bname='TRIP700F';
    phase ='ferrite';
    pname = './ExperimentalData/TRIP700/';
    
    pf1T=loadPoleFigure_generic([pname '110F-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname '110F-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname '200F-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname '200F-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname '211F-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname '211F-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);


    %figure; plot(odf,'phi2','sections',18,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;

elseif i==2
%TRIP 700 Austenite
    disp('TRIP 700 Austenite')
    bname='TRIP700A';
    phase ='austenite';
    pname = './ExperimentalData/TRIP700/';
    
    pf1T=loadPoleFigure_generic([pname '200A-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname '200A-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname '220A-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname '220A-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname '311A-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname '311A-d4.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);
    
elseif i==3
       
%TRIP 780 Austenite
    disp('TRIP 780 Austenite')
    bname='TRIP780A';
    phase ='austenite';
    pname = './ExperimentalData/TRIP780/';
    
    pf1T=loadPoleFigure_generic([pname '200A-Creuz427sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname '200A-Creuz427sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname '220A-Creuz429sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname '220A-Creuz429sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;


    pfF=[pf1,pf2];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);
    
    
elseif i==4
%TRIP 780 Ferrite
    disp('TRIP 780 Ferrite')
    bname='TRIP780F';
    phase ='ferrite';
    pname = './ExperimentalData/TRIP780/';
    
    pf1T=loadPoleFigure_generic([pname '110F-Creuz426sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname '110F-Creuz426sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname '200F-Creuz428sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname '200F-Creuz428sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname '211F-Creuz431sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname '211F-Creuz431sym.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);

    
elseif i==5
    %Duplex Ferrite
    disp('Duplex Ferrite')
    bname='DuplexF';
    phase ='ferrite';
    pname = './ExperimentalData/Duplex/';
    
    pf1T=loadPoleFigure_generic([pname 'F110.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname 'F110.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname 'F200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname 'F200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname 'F211.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname 'F211.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);


    %figure; plot(odf,'phi2','sections',18,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;

elseif i==6           
%Duplex Austenite
    disp('Duplex Austenite')
    bname='DuplexA';
    phase ='austenite';
    pname = './ExperimentalData/Duplex/';
    
    pf1T=loadPoleFigure_generic([pname 'A111.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname 'A111.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname 'A200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname 'A200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname 'A220.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname 'A220.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);
    
elseif i==7
    %TRIP780b Ferrite
    disp('TRIP780b Ferrite')
    bname='TRIP780bF';
    phase ='ferrite';
    pname = './ExperimentalData/TRIP780b/';
    
    pf1T=loadPoleFigure_generic([pname 'F110.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname 'F110.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname 'F200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname 'F200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname 'F211.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname 'F211.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);


    %figure; plot(odf,'phi2','sections',18,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;

elseif i==8           
    %TRIP780b Austenite
    disp('TRIP780b Austenite')
    bname='TRIP780bA';
    phase ='austenite';
    pname = './ExperimentalData/TRIP780b/';
    
    pf1T=loadPoleFigure_generic([pname 'A111.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf1B=loadPoleFigure_generic([pname 'A111.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf1 = correct(pf1T,'background',pf1B);
    pf1.SS=ss;


    pf2T=loadPoleFigure_generic([pname 'A200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf2B=loadPoleFigure_generic([pname 'A200.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf2 = correct(pf2T,'background',pf2B);
    pf2.SS=ss;

    pf3T=loadPoleFigure_generic([pname 'A220.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 3]);
    pf3B=loadPoleFigure_generic([pname 'A220.sum'], 'HEADER',1,'degree','ColumnNames',{'polar angle','azimuth angle','intensity'},'Columns',[2 1 4]);
    pf3 = correct(pf3T,'background',pf3B);
    pf3.SS=ss;

    pfF=[pf1,pf2,pf3];
    %figure; plot(pfF); colorbar;

    odf = calcODF(pfF, cs,ss, 'halfwidth',5*degree, 'resolution',5*degree);

end


%% Create Plots
disp('Create Plots')

%figure; plot(odf,'phi2','sections',18,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;
%figure; plot(odf,'phi2',[45]*degree,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;
%figure; plot(odf,'phi2',[45]*degree,'projection','plain','silent',cs,ss,'FontSize',36);CLim(gcm,[0, 4]);mtexColorbar;

%plot without colorbar
figure; plot(odf,'phi2',[45]*degree,'projection','plain','silent',cs,ss,'FontSize',1);CLim(gcm,[0, 4]);
export_fig(strcat(savepath,'/',bname,'-phi2-45ODF.tiff'),'-r150')  

%can't export vector graphics without little lines showing up...
% see discussion:
% https://github.com/altmany/export_fig/issues/44
% and work around suggested here does not work
%  https://github.com/Sbte/fix_matlab_eps


%closest plot to MAUD's, but still not quite the same, as MAUD uses beta sections
%figure; plot(odf,'gamma','sections',18,'projection','plain','minmax', 'off',cs,ss);CLim(gcm,[0, 4]);mtexColorbar;
%fig = gcf;
%fig.PaperPositionMode = 'auto';
%saveas(fig,strcat(bname,'-gammaODF.png'))

% equal area -> stereographic projection

if strcmp(phase,'austenite')
    pf = calcPoleFigure(odf,h_austenite,cs,ss);
    figure; plotPDF(odf,h_austenite,cs,ss, 'projection','eangle', 'antipodal','noLabel');CLim(gcm,[0, 4]);mtexColorbar;
    %figure; plotPDF(odf,h_austenite,cs,ss, 'antipodal','grid','grid_res',30*degree,'projection','eangle');CLim(gcm,[0, 4]);mtexColorbar;
    
elseif strcmp(phase,'ferrite')
    pf = calcPoleFigure(odf,h_ferrite);
    figure; plotPDF(odf,h_ferrite, cs,ss, 'projection','eangle', 'antipodal','noLabel');CLim(gcm,[0, 4]);mtexColorbar;
else
    'something has gone wrong'
end

export_fig(strcat(savepath,'/',bname,'-PF.tiff'),'-r150')  

%fig = gcf;
%fig.PaperPositionMode = 'auto';
%saveas(fig,strcat(bname,'-PF.png'))

%for the length of h, pick off the first row, first column values of the PF
%This is the normal direction value

%PFnumber=length(h);
%NDintensity=[];
%for n = 1:PFnumber

%    a=pf.allI;
%    b=a{n};
%    NDintensity(n)=b(1,1);
%end


%% Calculate ODF scalar values

disp('Calculate ODF scalar values')
%Tval=[textureindex(odf),entropy(odf),max(odf)];
Tval=[textureindex(odf),entropy(odf)];

fileID = fopen(strcat(savepath,'/','ExpTextureValues.txt'),'a');

% Can't output different types of data with the same command
fprintf(fileID,'%12s\t',bname);
fprintf(fileID,'%6.4f\t %6.4f\n',Tval);

fclose(fileID);

%Tval


%odf30 = fibreODF(h,r,ss,'halfwidth',10*degree);
%deg=5*(3.14159)/180;

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

A custom function was created in mtex to save ODFs generated in the .maa format, which is required to import into MAUD.  The .maa format is similar to the popLA data structure (J. S. Kallend, U. F. Kocks, A. D. Rollett, and H.-R. Wenk, “popLA - An Integrated Software System for Texture Analysis,” Textures Microstruct., vol. 14–18, pp. 1203–1208, 1991. ), albeit with whitespace delimited data columns rather than fixed width columns.  While popLA rescaled floating point intensity values an integers (i.e. uniform texture intensity equal to 1.0 was scaled to 100) the .maa format permits floating point numbers.  The function created for .maa output truncates the floating point number to one digit after the decimal point (i.e. ###.#), matching the precision of an .maa file output from MAUD.
    
    
%}

file= fopen( strcat(savepath,'/',bname,'.maa'),'w');

fprintf(file, 'title \n');
fprintf(file, '7 5.0 \n');
fprintf(file, '2.86 2.86 2.86 90.00 90.00 90.00 \n');

%need to add one to the value for Beartex - nope, scale of pole figures 
%is still messed up
%between the two programs.  Do we need to rescale?

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

%end of for loop
end

  

