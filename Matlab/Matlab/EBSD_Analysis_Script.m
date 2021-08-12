%% Import Script for EBSD Data
%
% This script was automatically created by the import wizard. You should
% run the whoole script or parts of it in order to import your data. There
% is no problem in making any changes to this script.

%% Specify Crystal and Specimen Symmetries

% crystal symmetry
CS = {... 
  'notIndexed',...
  crystalSymmetry('432', [3.6 3.6 3.6], 'mineral', 'Austenite', 'color', [0.53 0.81 0.98]),...
  crystalSymmetry('432', [3.6 3.6 3.6], 'mineral', 'Ferrite', 'color', [0.56 0.74 0.56])};

% plotting convention
setMTEXpref('xAxisDirection','north');
setMTEXpref('zAxisDirection','outOfPlane');

%% Specify File Names

% path to files
pname = 'F:\M Cox\DB_Files\mrupinen\Cole\Mapping\Ebsd\New Project\New Sample\Area 6';

% which files to be imported
fname = [pname '\map20210423182356249.osc'];

%% Import the Data

% create an EBSD variable containing the data
ebsd = EBSD.load(fname,CS,'interface','osc',...
  'convertEuler2SpatialReferenceFrame');

ipfKey = ipfColorKey(ebsd('Austenite'));
ipfKey.inversePoleFigureDirection = vector3d.Y;
plot(ipfKey)
colors = ipfKey.orientation2color(ebsd('Austenite').orientations);
plot(ebsd('Austenite'),colors)
figure()
plot(ipfKey)


figure()
ipfKey2 = ipfColorKey(ebsd('Ferrite'));
ipfKey2.inversePoleFigureDirection = vector3d.Y;
plot(ipfKey2)
colors = ipfKey2.orientation2color(ebsd('Ferrite').orientations);
plot(ebsd('Ferrite'),colors)
figure()
plot(ipfKey2)