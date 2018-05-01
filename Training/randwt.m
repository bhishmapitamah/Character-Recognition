function [theta] = randwt(r, c)
%% Randomly initialize theta with some weights so as to break symmetry problem

INIT_EPSILON = sqrt(6)/sqrt(r+c);
theta = rand(r,c) * (2*INIT_EPSILON) - INIT_EPSILON;

end

