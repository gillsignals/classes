A = importdata('/projects/classes/data/7QBWx_Results.txt');
rawData = transpose(A.data);
rawF = rawData(2:74, :)

% generate DFF matrix for cell 1
cell = 1;
rawF_cell = rawF(cell, :);
rawF_rounded = round(rawF_cell/10)*10; % round to nearest multiple of 10
baseline = mode(rawF_rounded);
dff_cell = (rawF_cell - baseline)/baseline;

% plot DFF for cell 1
figure()
plot(rawF_cell)
xlabel('Time (s)')
ylabel('raw F')
axis tight

% generate DFF matrix for all cells
rawF_rounded = round(rawF/10)*10;
baseline = mode(rawF_rounded, 2);
DFF = (rawF - baseline)./baseline;

% rescale data from 3.79 fps to 5 fps using linear interpolation (interp1)
old_length = size(DFF,2); % number of columns
new_length = 2880; % 5fps * 576 seconds

for cell = 1:NumCells

   DFF_cell = DFF(cell,:); 

   % store the interpolated vector in a row of the DFF_new matrix
   DFF_new(cell,:) = interp1(DFF_cell,linspace(1,old_length,new_length));

end
DFF = DFF_new; % replace matrix with interpolated one

%Plot trial-averaged response of one cell

FrameRate = 5;
SamplesPerTrial = 96*FrameRate;
NumTrials = 6;
cell = 1; % this is the cell that we will analyze
        
dff_cell = DFF(cell,:); % extract dff trace for our cell
dff_reshaped = reshape(dff_cell,SamplesPerTrial,NumTrials);
dff_avg = mean(dff_reshaped,2);

% plot dff_avg        
t = (0:SamplesPerTrial-1)/FrameRate;
plot(t,dff_avg)
hold on;

% plot bars indicating ON period
for i = 1:12
	plot([8*i-4,8*i],min(dff_avg)*ones(1,2),'r','LineWidth',3)
end
xlabel('Time (s)')
ylabel('\DeltaF/F')
      
      
% Calculate time-averaged ON and OFF responses

SamplesPerOri = 40;
NumOrientations = 12;
NumTrials = 6;
cell = 1; % this is the cell that we will analyze
        
dff_cell = DFF(cell,:); % extract dff trace for our cell
dff_reshaped = reshape(dff_cell,SamplesPerOri,NumOrientations,NumTrials);

ON_period = 21:40;
OFF_period = 11:20;
        
AveON = mean(dff_reshaped(ON_period,:,:), 1); % split matrix into ON segment and take average SamplesPerOri
AveOFF = mean(dff_reshaped(OFF_period,:,:), 1); % split matrix into OFF segment and take average SamplesPerOri

AveON = squeeze(AveON);
AveOFF = squeeze(AveOFF);        
      

% Plot the tuning curve

NumTrials = size(AveON,2);
Orientations = 0:30:330;
        
ON_mean = mean(AveON, 2); % mean over trials of AveON
ON_sem = std(AveON, [], 2) / sqrt(NumTrials); % standard error over trials of AveON

OFF_mean = mean(mean(AveOFF)); % mean over observations and over trials of AveOFF - a single value
OFF_line = OFF_mean*ones(size(Orientations)); % this generates a baseline you can plot 

figure
hold on
errorbar(Orientations, ON_mean, ON_sem, 'b') % plot ON tuning curve       
plot(Orientations, OFF_line, 'r') % plot OFF spontaneous activity
xlim([-30 360])
ylim([min(ylim)-0.1, max(ylim)])
xlabel('Orientation (deg)')
ylabel('\DeltaF/F')
      
% Calculate time-averaged ON and OFF responses for all cells

NumCells = size(DFF,1);
SamplesPerOri = 40;
NumOrientations = 12;
NumTrials = 6;

% initialize matrices
AveON = zeros(NumCells,NumOrientations,NumTrials);
AveOFF = zeros(NumCells,NumOrientations,NumTrials);

ON_period = 21:40;
OFF_period = 11:20;

for cell = 1:NumCells            
    dff_cell = DFF(cell,:);
    dff_reshaped = reshape(dff_cell, SamplesPerOri, NumOrientations, NumTrials);
  
    AveON(cell,:,:) = mean(dff_reshaped(ON_period,:,:) ,1);
    AveOFF(cell,:,:) = mean(dff_reshaped(OFF_period,:,:),1);
end
      
% Plot tuning curves for all cells

Orientations = 0:30:330;
NumTrials = size(AveON, 3);
        
ON_mean = mean(AveON, 3); % ON average over all trials
ON_sem = std(AveON, [], 3) / sqrt(NumTrials); % ON standard error over all trials
        
OFF_mean = mean(mean(AveOFF, 3), 2); % OFF average over all trials and orientations

for cell = 1:8
    figure()
    
    OFF_line = OFF_mean(cell) *ones(size(Orientations)); %generate baseline to plot
        
	hold on
	errorbar(Orientations, ON_mean(cell,:), ON_sem(cell,:), 'b') % plot ON tuning curve       
	plot(Orientations, OFF_line,'r') % plot OFF spontaneous activity
	xlim([-30 360])
	ylim([min(ylim)-0.1, max(ylim)])
        xlabel('Orientation (deg)')
        ylabel('\DeltaF/F') 
end
      
% Subtract baseline and remove values less than zero
NumOrientations = size(ON_mean, 2);

OFF_mean = repmat(OFF_mean, 1, NumOrientations);

TC = ON_mean - OFF_mean;
TC(TC<0) = 0;  

% Plot histograms of preferred orientation (PO) and OSI

NumCells = size(TC, 1);
Orientations = 0:30:330;
AngRad = Orientations*pi/180;        

% initialize your vectors        
AllOSI = zeros(1, NumCells);
AllPO = zeros(1, NumCells);
        
for cell = 1:NumCells
    
    TC_cell = TC(cell,:);

    OSI = abs(sum(TC_cell.*exp(2.*1i.*AngRad))./sum(TC_cell));
    
    PrefOri = 0.5.*( angle( sum(TC_cell.*exp(2.*1i.*AngRad)) ) );
    PO = PrefOri.*(180/pi);
    if PO < 0
        PO = PO+180;
    end
        
    AllOSI(cell) = OSI;
    AllPO(cell) = PO;    
        
end
        
figure()       
hist(AllOSI)      
xlabel('OSI')        
figure()
hist(AllPO)  
xlabel('Preferred Orientation (deg)')


load('PopMap.mat');      

% Variables available:
% AllOSI
% AllPO
% TC
% img, the average projection image you made in Image J
% ROIs, a vector of region of interest data for each cell

NumCells = 73;        
        
% display average projection image
image(img) 
axis square

% setup colors
color = hsv(180); 

% loop for each cell
for cell = 1:NumCells
    
    % get ROI coordinates
    roi = ROIs{cell}.mnCoordinates;    
    
    % color based on preferred orientation	        
    if max(TC(cell,:)) == 0  % not visually responsive = black
        roicolor = zeros(1,3); 
        
    elseif  AllOSI(cell) < 0.25 % broadly tuned = white
        roicolor = ones(1,3); 
        
    else % not visually responsive
        roicolor = color(ceil(AllPO(cell)),:);
        
    end    
    
    % draw colored ROI
    patch(roi(:,1),roi(:,2),ones(1,size(roi,1)),'FaceColor',roicolor)    
end     
        
colormap(color)
colorbar('Ticks',[0:60:360]/180, 'TickLAbels',0:30:180)
axis off
title('Population Orientation Map')

      