%{
TODOs
---------------------------------------------------------------------------
> There's 6 sessions in the {mi_event}, merge them into one.

> (Unsure) Separate each MI event into its own block with its respective class. 

> Filter using CSPs / FBCSPs. There's a function csp(A,B). Check it out.

> Club all left event into one and right events into another, then do a csp
transformation.
---------------------------------------------------------------------------
%}

num_trials = 0;
sum_window = 0;

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
for i = (1:6)
    cls = repelem(mi_event{1,i}.mi_events_class, avg_window);
    ith = mi_event{1,i}.mi_events;
    ith(:,23) = cls;
    left = ith(cls == 1, :);
    right = ith(cls == 2, :);
    
    left = left(:,1:22)';
    right = right(:,1:22)';
    
    [W,~] = csp(left, right);
    csp_left = (W' * left)';
    csp_right = (W' * right)';
    
    left_hand = [left_hand;csp_left];
    right_hand = [right_hand;csp_right];
    
    s.left = left';
    s.right = right';
    s.csp_left = csp_left;
    s.csp_right = csp_right;
    
    CSP_data{1,i} = s;
    
end

left_hand = left_hand(2:end,:);
right_hand = right_hand(2:end,:);

final_data = struct;
final_data.left_hand = left_hand;
final_data.right_hand = right_hand;
final_data.num_events = num_events;
final_data.num_trials = num_trials;
final_data.avg_window = avg_window;
    

clear avg_window cls i ith num_events num_trials sum_window W right left s;

clear csp_left csp_right left_hand right_hand;