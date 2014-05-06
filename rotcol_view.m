function rotcol_view(file,fps)
%ROTCOL_VIEW View the motion stimulus created using rotcol_create
%
% ROTCOL_VIEW(FILE,FPS) shows a motionstimulus created by
% rotcol_create located in FILE (a filename such as stimulus_1) and shows
% it in a figure window. An optional FPS can be given depicting the frames
% per second rate at which the motionstimulus is shown (default is set to 
% 40fps).
%
% Example:
%
% Make sure you first run rotcol_create to create the motion stimuli,
% e.g.:
%
%   cpath = './images/example.jpg';
%   rotcol_create(cpath);
%
% This will result in the motionstimulus to be saved in stimulus_1.mat in
% the current folder. The stimulus can then be shown with 15 fps using:
%
%   file = 'stimulus_1';
%   rotcol_view(file,15);
%
% or with the default fps of 40 by not giving the delay argument:
%
%   rotcol_view(file);
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

if nargin == 0
    error('no file supplied')
elseif nargin == 1
    fps = 40;
end

% load the file
load(file)

% display the stimulus
figure(1)
for q = 1:size(stimulus,3)

    imshow(stimulus(:,:,q)/255);
    pause(1/fps);

end