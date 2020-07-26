%{
READ THIS
---------------------------------------------------------------------------
Input data: mi_event
Output data: final_data, CSP_data

> There's 6 sessions in the {mi_event}, this code merges them into one.

> Filter using FBCSPs using a default function "csp(A,B)".

> Splits all left and right hand events, then does a CSP transformation.

> Clubs the output as CSP_data (clubbed output of raw l/r and csp l/r of
each session, for clarity) and final_data (clubbed csp l/r of all sessions,
total trials, total events and average window size 
---------------------------------------------------------------------------
%}

num_trials = 0;
sum_window = 0;

% Extracts average window and total number of trials for the session.
for i = (1:6)
    num_trials = mi_event{1,i}.num_events + num_trials;
    sum_window = mi_event{1,i}.event_window + sum_window;
end

avg_window = round(sum_window / 6);
% Usually the average is 751, in case of problems just use 751
num_events = num_trials * avg_window;


left_hand = zeros(1,22);
right_hand = zeros(1,22);
CSP_data = cell(1,6);
s = struct;

% In each iteration
% > Data split according to classes
% > CSP predicted and applied
% > Clubs CSP data into 
for i = (1:6)
    % Adds classes to the end of each row so that the data can be separated easily later.
    cls = repelem(mi_event{1,i}.mi_events_class, avg_window);
    ith = mi_event{1,i}.mi_events;
    ith(:,23) = cls;
    left = ith(cls == 1, :);
    right = ith(cls == 2, :);
    
    % Transposing because of CSP function requirements.
    left = left(:,1:22)';
    right = right(:,1:22)';
    
    % Once filter matrix is calculated, multiply it to the signal.
    [W,~] = csp(left, right);
    csp_left = (W' * left)';
    csp_right = (W' * right)';
    
    left_hand = [left_hand;csp_left];
    right_hand = [right_hand;csp_right];
    
    % For {CSP_data}
    s.left = left';
    s.right = right';
    s.csp_left = csp_left;
    s.csp_right = csp_right;
    
    CSP_data{1,i} = s;
    
end

% For {final_data}
left_hand = left_hand(2:end,:);
right_hand = right_hand(2:end,:);

final_data = struct;
final_data.left_hand = left_hand;
final_data.right_hand = right_hand;
final_data.num_events = num_events;
final_data.num_trials = num_trials;
final_data.avg_window = avg_window;
    

% Clear temp variables
clear avg_window cls i ith num_events num_trials sum_window W right left s;

% If you want to see the intermediate outputs then comment the next line
% NOTE: It will only show the last iteration values
clear csp_left csp_right left_hand right_hand;