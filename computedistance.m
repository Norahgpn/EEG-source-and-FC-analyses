function [closestRegion] = computedistance(channelsofinterest,seeds,scouts,vertices,extended)
% Euclidian distance computed between chosen electrodes and every Region seed.
% Distance (d) between p and q is d(p,q) = sqrt((qx - px)^2 + (qy - py)^2 + (qz - pz)^2).
% Returns structure containing closest atlas region to channels of interest.
%
% Inputs:
%
%
% Alternative inputs:
%   'extension'     - [boolean] if == 1, also compute 2nd and 3d closest
%                     distance

if ~exist('extended', 'var')
        extended = 0;
end

% ClosestRegion: structure with additional field of closest region per channel
%add channel namese
closestRegion = cell2struct({channelsofinterest(:).Name},'Channels',1);
%add channel index numbers
channelselect = {channelsofinterest(:).Num};
[closestRegion(:).ChannelIndex] = channelselect{:};

% For all channels of interest compute Euclidian distance to seed of all regions
for i = 1:length(channelselect)
    %for channel, set coordinates
    Xchannel = channelsofinterest(i).X;     Ychannel = channelsofinterest(i).Y;     Zchannel = channelsofinterest(i).Z;
   
    %for every seed, set coordinates
    ED = zeros(1,length(seeds));
    for j = 1:length(seeds)
        Xseed = vertices(seeds(j),1);       Yseed = vertices(seeds(j),2);          Zseed = vertices(seeds(j),3);
        %compute distance
        ED(j) =  sqrt(((Xseed - Xchannel)^2) + ((Yseed - Ychannel)^2) + ((Zseed - Zchannel)^2));    % Euclidian Distance (ED)
    end
    
    %find region with minimum distance to channel i  
    minRegion = (find(ED == min(ED)));
    %add index and name of region minimum distance to channel in struct
    [closestRegion(i).EDsort, closestRegion(i).sortIndices]     = sort(ED);
    closestRegion(i).Region = scouts(minRegion).Label; 
    closestRegion(i).RegionIndex = minRegion;
    %%%
    if extended == 1
    secondRegion = closestRegion(i).sortIndices(i+1);
    thirdRegion  = closestRegion(i).sortIndices(i+2);
    closestRegion(i).secondRegion = scouts(secondRegion).Label; 
    closestRegion(i).thirdRegion = scouts(thirdRegion).Label; 
    closestRegion(i).RegionIndex(i+1) = secondRegion;
    closestRegion(i).RegionIndex(i+2) = thirdRegion;
    closestRegion(i).RegionIndex(closestRegion(i).RegionIndex == 0) = [];
    end
    %%%
end

end


