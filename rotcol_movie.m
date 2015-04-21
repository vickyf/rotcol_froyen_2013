function rotcol_movie(file,fps)
%ROTCOL_MOVIE Creates an .avi movie of the stimulus you created
%
% ROTCOL_MOVIE(FILE,FPS) saves the motionstimulus you created using
% rotcol_create located in FILE (a filename such as stimulus_1). to a
% .AVI file. This allows you to play the motion stimulus outside of matlab
% and demo it to your colleagues. Optional FPS can be given to set the
% frames per second at which the stimulus is displayed (default is 40 fps).
%
% WARNING: Do not move the figure, switch workspaces, alt-tab to other
% programs or move your mouse over the figure. All of these will corrupt
% the recording since it is recording EVERYTHING that appears on your
% screen in front of the matlab figure screen.
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
% the current folder. The stimulus can then be saved as a .avi movie with 
% 15 fps using:
%
%   file = 'stimulus_1';
%   rotcol_movie(file,15);
%
% or with the default fps of 40 by not giving the delay argument:
%
%   rotcol_movie(file);
%
% See also: rotcol_view, rotcol_movie, rotcol_experiment

% Copyright: Vicky Froyen
% Author: Vicky Froyen
% Date: Tue Apr 21 10:15:37 2015 -0400

% This code was used to generate the stimuli for the following papers:
% - Froyen, V., Singh, M., & Feldman, J. (2013). rotcol columns: relating
% structure-from-motion, accretion/deletion, and figure/ground. Journal of 
% Vision, 13(10), 1-12.

if nargin == 0
    error('no files were provided')
elseif nargin == 1
    fps = 40;
end

% load stimulus
load(file);

% show the stimulus and record
figure(2)
for q = 1:size(stimulus,3)
    imshow(stimulus(:,:,q)/255);
    F(q) = getframe;
end
cla;clf;

% now save as avi
movie2avi(F,strcat(file,'.avi'),'FPS',fps)

end

