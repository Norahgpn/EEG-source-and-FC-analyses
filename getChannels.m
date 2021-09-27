function [channelsofinterest] = getChannels(allchannels,channelnames)
%% getChannels.m returns a struct of all channels and variables containing fields of channels of interest
% Channels in channel file .loc for coordinates of every electrode channel
% by: N.Hagopian

% Choose channels
channelselection = find(ismember({allchannels(1:64).Name},channelnames)); %channels of interest by name
%channelsofinterest = allchannels([channelselection]);
%channelsofinterest = cell2struct({allchannels([channelselection]).Name});
channelsofinterest = cell2struct({allchannels([channelselection]).Name}, 'Name',1);
channelselectcell = num2cell(channelselection);
[channelsofinterest.Num] = channelselectcell{:};
%names = {allchannels([channelselection]).Name};    [channelsofinterest.Name] = names{:};
locations = {allchannels([channelselection]).Loc};  [channelsofinterest.Loc] = locations{:};

% Split locations in X, Y, Z fields
for i = 1:length(channelselection)
    channelsofinterest(i).X = channelsofinterest(i).Loc(1);
    channelsofinterest(i).Y = channelsofinterest(i).Loc(2);
    channelsofinterest(i).Z = channelsofinterest(i).Loc(3);
end
end

