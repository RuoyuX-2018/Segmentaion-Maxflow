% For each MOV file, create a new folder with all frames, and save all flow
% in a .mat file.
%
% Also rescales frames to <=720 pixels wide/tall.
%
% Might be useful if you want to test your code on a custom video.
%
% CMSC426 Project 3 Starter Code
% Author: Jack Rasiel

FRAME_SIZE = 720; % Max dimension for frames.
files = dir('../Images/*.MOV');
for file = files' 
    file = strcat('./test_images/',file.name);
    frames_path = strcat(file(1:end-4),'/');
    fprintf('processing video %s\n',file);
    vidReader = VideoReader(file);
    fprintf('\tloaded video\n');
    mkdir(frames_path);
    opticFlow = opticalFlowLK('NoiseThreshold',0.009);
    
    allFlow = {}
    i=0;
    while hasFrame(vidReader)
        fprintf('\tProcessing frame %d\n',i);
        frameRGB = readFrame(vidReader);
        
        [nr,nc,rgb] = size(frameRGB);
        if max(nr,nc) > FRAME_SIZE
            scale_factor = FRAME_SIZE / max(nr,nc);
            frameRGB= imresize(frameRGB,scale_factor);
        end
                
        fname= strcat(frames_path, sprintf('%03d.jpg',i));
        imwrite(frameRGB, fname);
        
        frameGray = rgb2gray(frameRGB);
        
        flow = estimateFlow(opticFlow,frameGray);
        allFlow{i+1} = flow;
        
        imshow(frameRGB)
        hold on
        plot(flow,'DecimationFactor',[5 5],'ScaleFactor',10)
        hold off
        i= i+1;
    end
    save(strcat(frames_path,'flow.mat'), 'allFlow');
end
