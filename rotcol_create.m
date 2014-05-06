function rotcol_create(cpath, contrast, T)
%ROTCOL_CREATE  Creates the motion stimuli given a file or folder path
%for batch processing.
%
% ROTCOL_CREATE(CPATH, CONTRAST, T) creates motionstimuli for the images
% pointed to by CPATH. This CPATH can either be a direct pointer to the file
% or a folder containing several images. These images should be of the
% .jpg, .png ,or .tiff file type. CONTRAST sets if you want the first color
% patch the algorithm encounters counting from the left to be displayed as
% dark(CONTRAST=0) or light (CONTRAST=1). T depicts the amount of frames 
% that a motion stimulus contains (default is set to 100 frames). Note that 
% the larger you set this number the larger the size of the file will 
% become and the longer it will take to generate the stimulus. For each
% image a .mat file containing the motionstimulus will be created. This
% file is needed to subsequently run rotcol_view, rotcol_movie and
% rotcol_experiment.
%
% Example:
%
% If cpath = './images' we will convert all images in the folder images
% inside the current folder into motion stimuli by running
% 
%   cpath = './images';
%   rotcol_create(cpath,0,200);
%
% This will also make the first column of the example image in images dark 
% and generate 200 frames of the motion stimulus.
%
% If cpath = './images/example.jpg', only this particular file will be
% converted into a motionstimulus (using default values for T and contrast)
%
%   cpath = './images/example.jpg';
%   rotcol_create(cpath);
%
% Once created the motionstimulus for each of the images can be showed
% using:
%
%   file = 'stimulus_1' % name of the mat file containing the stimulus
%   delay = .025; % duration of each frame
%   rotcol_view(file,delay)
%
% For more information about rotcol_view see that functions description.
%
% See also: rotcol_view, rotcol_movie, rotcol_experiment

% Copyright: Vicky Froyen
% Author: Vicky Froyen
% Date: 2010/10/01 18:23:52
% Git commit: 

% This code was used to generate the stimuli for the following papers:
% - Froyen, V., Singh, M., & Feldman, J. (2013). rotcol columns: relating
% structure-from-motion, accretion/deletion, and figure/ground. Journal of 
% Vision, 13(10), 1-12.


%% IF NO VARIABLES ARE GIVEN RETURN ERROR %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
    error('Please input a file or folder path.')
% if T is not assigned set to default value
elseif nargin == 1
    T = 100;
    contrast = 0;
elseif nargin == 2
    T = 100;
end


%% IS THE PATH A FILE OR A FOLDER PATH? %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isdir(cpath)
    files{1} = cpath;
else
    all_files = dir(cpath);
    for q = 1:length(all_files)
        files{q} = strcat(cpath,all_files(q).name);
    end
end


%% CREATE THE STIMULI AND SAVE THE FILE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% keep track of failed files
count = 0;

% count the stimuli
n_stimuli = 0;

% show message
disp('Creating stimuli ... (be patient)')

for q = 1:length(files)
    % is it an image file?
    if ~strcmp(files{q}(end-3:end),'.jpg') && ~strcmp(files{q}(end-3:end),'.tif') && ...
            ~strcmp(files{q}(end-3:end),'.png')
        count = count+1;
        continue
    end
    
    n_stimuli = n_stimuli + 1;
    
    % if it is an image file load the file
    A = imread(files{q});
    I = max(A(:,:,:),3);
    
    % create the noise frames
    frames_a = texture_updater(size(I,1),size(I,2),-1,abs(0-contrast),T);
    frames_b = texture_updater(size(I,1),size(I,2),1,abs(1-contrast),T);
    
    % generate the stimuli
    stimulus = create_motionstimulus(I,frames_a,frames_b);
    
    % save the stimulus
    save(strcat('stimulus_',num2str(n_stimuli)),'stimulus');
end

% if none of the files were image files
if count == length(files)
    error('No stimuli were created because none of the files given were image files with extension .png/.tif/.jpg')
else
    disp('Stimuli were succesfully created.')
end

end

%% SUPPORT FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function frames = texture_updater( heigth, width, dir, color, nrep )
%TEXTURE_UPDATER Summary of this function goes here
%   Detailed explanation goes here

if color == 0
    a = 6; b = 2; % dark
else
    a = 2; b = 6; % brigth
end

% initial random dot
frames(:,:,1) = random('beta',a,b,heigth,width)*255;%rand(heigth,width)*255;

% create motion random dots
for q = 2:nrep

    if dir == 1
        frames(:,2:width,q) = frames(:,1:width-1,q-1);
        frames(:,1,q) = random('beta',a,b,heigth,1)*255;%rand(heigth,1)*255;
    elseif dir == -1
        frames(:,1:width-1,q) = frames(:,2:width,q-1);
        frames(:,width,q) = random('beta',a,b,heigth,1)*255;%rand(heigth,1)*255;
    end
    

end
end

function newI = create_motionstimulus( I, frames_a, frames_b)

% thresholding to get rid of noise
I(find(I>126)) = 255; I(find(I<=126)) = 0;

newI = zeros(size(frames_a));

% AND SAVE
for q = 1:size(frames_a,3)
    % figureframes will always be pasted on the white area, groundframes on
    % the black area.
    newI(:,:,q) = update_region(I,I,frames_a(:,:,q),frames_b(:,:,q),[255,0]);
end

end

function outI = update_region(inI,refI,text1,text2,comp)
    outI = zeros(size(inI,1),size(inI,2));
    for i = 1:size(refI,1)
        for j = 1:size(refI,2)
            if refI(i,j) == comp(1)
                outI(i,j) = text1(i,j);
            elseif refI(i,j) == comp(2)
                outI(i,j) = text2(i,j);
            else
                outI(i,j) = 0;                
            end
        end
    end
end
