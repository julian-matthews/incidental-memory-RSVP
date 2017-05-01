function [x,y,buttons] = getMouseResponse()

[x,y,buttons] = GetMouse;
while any(buttons) % if already down, wait for release
    [x,y,buttons] = GetMouse;
end
while ~any(buttons) % wait for press
    [x,y,buttons] = GetMouse;
end
end