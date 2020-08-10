function [Linear_Separability, Theta_perceptron] = ...
                                  Sigma_check_linear_separability(varargin)
%%-------------------------------------------------------------------------
% [data_are_separable, theta_perceptron] = ...
%                                 Sigma_check_linear_separability(varargin)
% [data_are_separable, theta_perceptron] = ...
%                       Sigma_check_linear_separability(feature_result)
% [data_are_separable, theta_perceptron] = ...
%                       Sigma_check_linear_separability(feature,label)
% This MATLAB code tests if given set of points are linearly separable
% using Linear Perceptron. Linear Perceptron is guaranteed to find a
% solution if one exists. This approach is not efficient for large
% dimensions. Computationally the most effective way to decide whether
% two sets of pointsare linearly separable is by applying
% linear programming.
%
% Other solutions:
%
% Find the convex hull for both the X points and the O points separately
% and check whether any segments of the hulls intersected or whether
% either hull was enclosed by the other. If the two hulls were found
% to be totally disjoint the two data-sets would be geometrically separable.
% Using Linear Programming Explained very well in
% http://www.joyofdata.de/blog/testing-linear-
%                             separability-linear-programming-r-glpk/
%
% The example uses libsvm format. If you need to use it for some other
% format, replace the variables Xtrain and Ytrain. Ytrain must be a (m x 1)
% matrix consisting of -1 and +1. Xtrain must be an (m x n) matrix. libsvm
% format is explained in http://www.csie.ntu.edu.tw/~cjlin/libsvm/
% Bias term is added automatically.
% The code calls data inseparable if 'maxiter' (default 10000) iterations
% have been reached. Change it in the code if required.
% http://rishirdua.github.io/linear-separability-matlab/
% https://github.com/rishirdua/linear-separability-matlab


if nargin==1
    if isstruct(varargin{1})
        Ytrain=varargin{1}.label';
        Xtrain=varargin{1}.o_feature_matrix';
    else
        warning('The input argument are not correct')
        return
    end
end

if nargin==2
    Xtrain=varargin{1}; % feature
    Ytrain=varargin{2}; % labels
end

% reorder the data
m=max(size(Ytrain));
%line_label=size(Ytrain,1);
column_label=size(Ytrain,2);
if m==column_label
   Ytrain=Ytrain';
end

%line_feature=size(Xtrain,1);
column_feature=size(Xtrain,2);

if m==column_feature
   Xtrain=Xtrain';
end


%set max iteration
maxiter = 10000;

%load data
%[Ytrain, Xtrain] = libsvmread('sample.txt'); %libsvm format

%Ytrain=labels';
%Xtrain=feature_value';
mtrain = size(Xtrain,1);
n = size(Xtrain,2);


% learn perceptron
Xtrain_perceptron = [ones(mtrain,1) Xtrain];
alpha = 0.1;
%initialize
theta_perceptron = zeros(n+1,1);
trainerror_mag = 1000000;
iteration = 0;

%loop
while (trainerror_mag>0)
    iteration = iteration+1;
    if (iteration == maxiter)
        break;
    end;
    for i = 1 : mtrain
        Ypredict_temp = sign(theta_perceptron'*Xtrain_perceptron(i,:)');
        theta_perceptron = theta_perceptron + alpha*(Ytrain(i)-Ypredict_temp)*Xtrain_perceptron(i,:)';
    end
    Ytrainpredict_perceptron = sign(theta_perceptron'*Xtrain_perceptron')';
    trainerror_mag = (Ytrainpredict_perceptron - Ytrain)'*(Ytrainpredict_perceptron - Ytrain);
end

if (trainerror_mag==0)
    fprintf('Data is Linearly seperable\n');
    fprintf('Parameters are:\n');
    disp(theta_perceptron)
    Theta_perceptron=theta_perceptron;
    Linear_Separability=1;
else
    fprintf('Data is not linearly seperable');
    Linear_Separability=0;
    Theta_perceptron=[];
end;
end