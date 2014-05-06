function rotcol_experiment( file, fps )
%ROTATING_EXPERIMENT A template of how to present the rotating column
%stimuli using Psychtoolbox (http://psychtoolbox.org/)
%
% ROTATING_EXPERIMENT(FILE,FPS) shows a motionstimulus created by
% rotcol_create located in FILE (a filename such as stimulus_1) using
% psychtoolbox. An optional FPS can be given depicting the frames
% per second rate at which the motionstimulus is shown (default is set to 
% 40fps).
%
% NOTE: in order for this to work psychtoolbox needs to be installed. Visit
% http://psychtoolbox.org/ for instructions.
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
%   rotcol_experiment(file,15);
%
% or with the default fps of 40 by not giving the delay argument:
%
%   rotcol_experiment(file);
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

% turned on for debuggin purposes
Screen('Preference', 'SkipSyncTests', 1);

%% SETUP THE SCREEN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% this might need to be adjusted depending on your needs
screens=Screen('Screens');    %how many screens available?
chosenDisplayNumber = max(screens); % %use highest numbered screen 
[windowPtr,screen_size] = Screen('OpenWindow', chosenDisplayNumber, [], [], [], 2, 8, 16);`
HideCursor;

%% SHOW THE STIMULUS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load stimulus
load(file);

% generate the texture from stimulus
stimulus_texture = zeros(1,size(stimulus,3));
for q = 1:size(stimulus,3)
    stimulus_texture(q) = Screen(windowPtr, 'MakeTexture', stimulus(:,:,q));
end

% show these stimulus
q = 0;
for index = stimulus_texture(1:end)
    % draw bg
    Screen('FillRect',windowPtr,.5*[255,255,255],screen_size);
    
    % draw stimulus frame
    Screen('DrawTexture',windowPtr,index,[0,0,size(stimulus,2),size(stimulus,1)]);
    
    q = q+1;
    if q == 1
        vbl = Screen('Flip',windowPtr);
    else
        vbl = Screen('Flip',windowPtr,vbl+1/fps);
    end
    
    % close texture -- dont need it in the buffer anymore
    Screen('Close',index);
end

% close
Screen('CloseAll')
end

