%{
READ THIS
---------------------------------------------------------------------------
> This code extracts individual MI events and it's respective classes 
and adds them to a struct variable along with some other data.

> For each individual, the original dataset has 9 sessions, the 1st 3 are
EOG and the next 6 are EEG. We take the the EEG sessions (4 - 9) and EEG 
channels only (1 - 22).

> Each MI event lasts ~8 sec and the 3rd-6th sec window is the MI event.
Sampling is 250Hz, so the window for an MI event is 751 frames.
Therefore, from every 752nd frame, a new MI event starts.

> The MI events which are other than left/right hand or are indicated to 
have an artefact as per the original dataset are skipped.

> All temp variables are removed but if you want to see the intermediate
variables then you can comment the last line.

> We're using A02T.mat for no specific reason. I just like that number.
---------------------------------------------------------------------------
%}

clc; clear;

% Load data
load("A02T.mat");

% Creates an empty 1 by 6 cell space
mi_event = cell(1,6);

% Iterate through all the cells in the dataset except the EOG ones
for dset_num = 4:9
    % Add necessary data into a struct
    s = struct;
    X1 = data{1,dset_num};

    % Channels 23 - 25 are EOG, excluding that
    X = X1.X(:,1:22);

    % Selecting only the left/right hand events without artifacts
    s.mi_events_class = X1.y(ismember(X1.y, [1;2]) & X1.artifacts == 0);

    % Not required but just for clarity in future plots
    s.session_duration = size(X,1) / X1.fs;
    s.trial_duration = s.session_duration / size(X1.trial,1);

    % MI is from 3 - 6 second window
    % Every MI event starts from {trial} and goes on for '{trial} + 3' seconds
    op = zeros(1,22);
    s.num_events = 0;

    % For each trial
    for i = (1 : length(X1.trial))
        % Skips events that have artifacts
        if X1.artifacts(i) == 0 && ismember(X1.y(i),[1;2])
            trial_start = X1.trial(i);
            trial_end = (3 * X1.fs) + trial_start;
            trial_1 = X(trial_start:trial_end,:);
            s.num_events = s.num_events + 1;
            op = [op;trial_1];
        end
    end

    s.mi_events = op(2:end,:);
    s.event_window = trial_end - trial_start + 1;
    % +1 to include the last reading too
    s.trials = (1:s.event_window:s.event_window*s.num_events)';

    mi_event{1,dset_num-3} = s;

end

% Clear temp variables
clear X trial trial_size trial_1 trial_start trial_end i op dset_num num_events;

% If you want to see the intermediate outputs then comment the next line
% NOTE: It will only show the last iteration values
clear data X1 s;

