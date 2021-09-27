
function [headmodelstruc,vertices] = getHeadmodel(path)
%% GetHeadmodel.m returns a struct of the headmodel file and variable with the location of 15.000 vertices, given the path to the headmodel file. 
% by: N.Hagopian

headmodelstruc = load(path); %path is string with path to headmodel file
vertices = headmodelstruc.GridLoc;  % 15.000 vertices with x,y,z coordinates
end

