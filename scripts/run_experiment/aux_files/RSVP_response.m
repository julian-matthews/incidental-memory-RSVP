% 23/07/2015 - RSVP wheely_confident
% Draws/flips confidence wheel along with distractor & probe faces
% Requires 'trial' value, 'TR' data & 'Exp' data for configuration
% Also uses the probe & distractor textures created for this trial
% Adds probe/distractor labels to 'TR' ie: {'probe' 'distractor'}


function [Exp, TR] = RSVP_response(Exp, TR, trial, Probe_Tex, Distr_Tex, invert)

SetMouse(Exp.Cfg.xCentre,Exp.Cfg.yCentre);
ShowCursor;

% Control for inverting image
if invert == 1
    tex_angle = 180;
else
    tex_angle = 0;
end

%Draw the response boxes
Screen('FillRect',  Exp.Cfg.win, Exp.Cfg.Color.gray);

Screen('TextSize',Exp.Cfg.win,20);

Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.white, Exp.Cfg.bigrect_{1} );
Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray, Exp.Cfg.smallrect_{1} );
Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray, Exp.Cfg.cleavage_{1});

Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(1),Exp.Cfg.smallrect_{1}(4),Exp.Cfg.bigrect_{1}(1),Exp.Cfg.bigrect_{1}(4),2);
Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(1),Exp.Cfg.smallrect_{1}(2),Exp.Cfg.bigrect_{1}(1),Exp.Cfg.bigrect_{1}(2),2);
Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(1),Exp.Cfg.smallrect_{1}(2),Exp.Cfg.bigrect_{1}(1),Exp.Cfg.bigrect_{1}(2),2);
Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(3),Exp.Cfg.smallrect_{1}(2),Exp.Cfg.bigrect_{1}(3),Exp.Cfg.bigrect_{1}(2),2);
Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(3),Exp.Cfg.smallrect_{1}(4),Exp.Cfg.bigrect_{1}(3),Exp.Cfg.bigrect_{1}(4),2);

Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.xCentre,Exp.Cfg.smallrect_{1}(4),Exp.Cfg.xCentre,Exp.Cfg.bigrect_{1}(4),2);
Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.xCentre,Exp.Cfg.smallrect_{1}(2),Exp.Cfg.xCentre,Exp.Cfg.bigrect_{1}(2),2);

Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(1),Exp.Cfg.yCentre,Exp.Cfg.bigrect_{1}(1),Exp.Cfg.yCentre,1.3);
Screen('DrawLine', Exp.Cfg.win,Exp.Cfg.Color.black,Exp.Cfg.smallrect_{1}(3),Exp.Cfg.yCentre,Exp.Cfg.bigrect_{1}(3),Exp.Cfg.yCentre,1.3);

Exp.Cfg.edge_offset = 1; % Polygon edge offset (prevents overlap)
polyL(1,:,:)=[Exp.Cfg.smallrect_{1}(1)+Exp.Cfg.edge_offset Exp.Cfg.cleavage_{1}(1) Exp.Cfg.cleavage_{1}(1) Exp.Cfg.bigrect_{1}(1)+Exp.Cfg.edge_offset;Exp.Cfg.smallrect_{1}(4) Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4) Exp.Cfg.bigrect_{1}(4)]; %Left conf 1
polyL(2,:,:)=[Exp.Cfg.smallrect_{1}(1) Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1) Exp.Cfg.bigrect_{1}(1);Exp.Cfg.smallrect_{1}(4)-Exp.Cfg.edge_offset Exp.Cfg.yCentre+Exp.Cfg.edge_offset Exp.Cfg.yCentre+Exp.Cfg.edge_offset Exp.Cfg.bigrect_{1}(4)-Exp.Cfg.edge_offset]; %2
polyL(3,:,:)=[Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1) Exp.Cfg.bigrect_{1}(1) Exp.Cfg.smallrect_{1}(1);Exp.Cfg.yCentre-Exp.Cfg.edge_offset Exp.Cfg.yCentre-Exp.Cfg.edge_offset Exp.Cfg.bigrect_{1}(2)+Exp.Cfg.edge_offset Exp.Cfg.smallrect_{1}(2)+Exp.Cfg.edge_offset]; %3
polyL(4,:,:)=[Exp.Cfg.smallrect_{1}(1)+Exp.Cfg.edge_offset Exp.Cfg.bigrect_{1}(1)+Exp.Cfg.edge_offset Exp.Cfg.cleavage_{1}(1) Exp.Cfg.cleavage_{1}(1);Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2) Exp.Cfg.bigrect_{1}(2) Exp.Cfg.smallrect_{1}(2)]; %4

polyR(1,:,:)=[Exp.Cfg.cleavage_{1}(3) Exp.Cfg.smallrect_{1}(3)-Exp.Cfg.edge_offset Exp.Cfg.bigrect_{1}(3)-Exp.Cfg.edge_offset Exp.Cfg.cleavage_{1}(3);Exp.Cfg.smallrect_{1}(4) Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4) Exp.Cfg.bigrect_{1}(4)];
polyR(2,:,:)=[Exp.Cfg.smallrect_{1}(3) Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3) Exp.Cfg.bigrect_{1}(3);Exp.Cfg.smallrect_{1}(4)-Exp.Cfg.edge_offset Exp.Cfg.yCentre+Exp.Cfg.edge_offset Exp.Cfg.yCentre+Exp.Cfg.edge_offset Exp.Cfg.bigrect_{1}(4)-Exp.Cfg.edge_offset];
polyR(3,:,:)=[Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3) Exp.Cfg.bigrect_{1}(3) Exp.Cfg.smallrect_{1}(3);Exp.Cfg.yCentre-Exp.Cfg.edge_offset Exp.Cfg.yCentre-Exp.Cfg.edge_offset Exp.Cfg.bigrect_{1}(2)+Exp.Cfg.edge_offset Exp.Cfg.smallrect_{1}(2)+Exp.Cfg.edge_offset];
polyR(4,:,:)=[Exp.Cfg.smallrect_{1}(3)-Exp.Cfg.edge_offset Exp.Cfg.cleavage_{1}(3) Exp.Cfg.cleavage_{1}(3) Exp.Cfg.bigrect_{1}(3)-Exp.Cfg.edge_offset;Exp.Cfg.smallrect_{1}(2) Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2) Exp.Cfg.bigrect_{1}(2)];

% Save the poly matrices for registering responses
Exp.polyL = polyL;
Exp.polyR = polyR;

% Draw 'sureness'
Screen('TextSize',Exp.Cfg.win,36);
DrawFormattedText(Exp.Cfg.win, 'sure', 'center', Exp.Cfg.bigrect_{1}(2) - 60 , [255 255 255]);
DrawFormattedText(Exp.Cfg.win, 'not sure', 'center',  Exp.Cfg.bigrect_{1}(4) + 20 , [255 255 255]);

% Boxes for text
text_box=[0 0 1 1];
offset=(Exp.Cfg.xCentre-mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)]))/2.;

global ptb_drawformattedtext_disableClipping; % needed for DrawFormattedText with winRect ... otherwise text is not drawn
ptb_drawformattedtext_disableClipping=1;

rect_1L=text_box+[mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)])+offset mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)]) mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)])+offset mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)])];
rect_2L=text_box+[mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)]) mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)])-offset mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)]) mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)])-offset];
rect_3L=text_box+[mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)]) mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)])+offset mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)]) mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)])+offset];
rect_4L=text_box+[mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)])+offset mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)]) mean([Exp.Cfg.smallrect_{1}(1) Exp.Cfg.bigrect_{1}(1)])+offset mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)])];

rect_1R=text_box+[mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)])-offset mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)]) mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)])-offset mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)])];
rect_2R=text_box+[mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)]) mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)])-offset mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)]) mean([Exp.Cfg.smallrect_{1}(4) Exp.Cfg.bigrect_{1}(4)])-offset];
rect_3R=text_box+[mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)]) mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)])+offset mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)]) mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)])+offset];
rect_4R=text_box+[mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)])-offset mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)]) mean([Exp.Cfg.smallrect_{1}(3) Exp.Cfg.bigrect_{1}(3)])-offset mean([Exp.Cfg.smallrect_{1}(2) Exp.Cfg.bigrect_{1}(2)])];

Screen('TextSize',Exp.Cfg.win,30);

DrawFormattedText(Exp.Cfg.win, '1', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_1L); 
DrawFormattedText(Exp.Cfg.win, '2', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_2L);
DrawFormattedText(Exp.Cfg.win, '3', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_3L);
DrawFormattedText(Exp.Cfg.win, '4', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_4L);

DrawFormattedText(Exp.Cfg.win, '1', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_1R);
DrawFormattedText(Exp.Cfg.win, '2', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_2R);
DrawFormattedText(Exp.Cfg.win, '3', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_3R);
DrawFormattedText(Exp.Cfg.win, '4', 'center', 'center',  [0 0 0],[],[],[],[],[],rect_4R);

Screen('TextSize',Exp.Cfg.win,20);

%% DISPLAY IMAGES

image_rect = [0 0 101 101]; % Size of object images

x_left = Exp.Cfg.xCentre - 70;
y_left = Exp.Cfg.yCentre;
x_right = Exp.Cfg.xCentre + 70;
y_right = Exp.Cfg.yCentre;


if TR(trial).response_side == -1
    % Probe on left
    dest_rect_probe = CenterRectOnPoint(image_rect, x_left, y_left);
    dest_rect_distr = CenterRectOnPoint(image_rect, x_right, y_right);
    TR(trial).label_pos = {'probe' 'distractor'};
    
elseif TR(trial).response_side == 1
    % Probe on right
    dest_rect_distr = CenterRectOnPoint(image_rect, x_left, y_left);
    dest_rect_probe = CenterRectOnPoint(image_rect, x_right, y_right);
    TR(trial).label_pos = {'distractor' 'probe'};
    
end

% Draw correct images to screen
Screen('DrawTextures', Exp.Cfg.win, Probe_Tex, [], dest_rect_probe, tex_angle);
Screen('DrawTextures', Exp.Cfg.win, Distr_Tex, [], dest_rect_distr, tex_angle);

% Present everything
Screen('Flip',Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);

end
