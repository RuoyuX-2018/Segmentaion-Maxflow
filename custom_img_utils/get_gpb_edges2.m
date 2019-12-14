% FOR CREATING CUSTOM INPUT IMAGES
%
% Finds edges for all all images in the given folder, using the gPB boundary detector.
% Expects the GPB library in the parent directory.  Find the GPB code here:
%       http://www.eecs.berkeley.edu/Research/Projects/CS/vision/grouping/BSR/BSR_code.tgz
% Warning, this might take a looooong time.
% On an i7-8700K, one 800x500 image took ~5 minutes. (No GPU support!)
%
% Only tested this on Linux, but should work on Mac/PC.
%
% CMSC426 Project 3 Starter Code
% Author:  Jack Rasiel

addpath(fullfile('../BSR_code/BSR/grouping/','lib'));
disp('Please do not include the BSR library when you submit your project!') % pretty pls

clear all; close all; clc;

frames_dir = './custom_img_utils/*.jpg';
[filepath,name,ext] = fileparts(frames_dir);
files = dir(frames_dir);
for file = files'
        % 1. compute globalPb on image 
        name = file.name;
        imgFile = strcat(filepath,'/',name);
        [fp,name_no_ext,xt] = fileparts(imgFile);
        fprintf('Processing file %s', imgFile);
        outFile = strcat(filepath,'/',name_no_ext,'_gPb.mat');

        gPb_orient = globalPb(imgFile, outFile);

        % 2. compute Hierarchical Regions for boundaries
        edgeGrad = contours2ucm(gPb_orient, 'imageSize');
        save(outFile, 'edgeGrad');
        fprintf('    Saved to %s', outFile);
        
end

