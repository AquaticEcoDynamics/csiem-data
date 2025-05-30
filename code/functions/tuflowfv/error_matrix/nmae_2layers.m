% Error calculation:
% 1) Normalized ABSOLUTE ERROR (NMAE)
% The MAE measures the average magnitude of the errors in a set of 
% forecasts, without considering their direction. It measures accuracy 
% for continuous variables. The equation is given in the library references. 
% Expressed in words, the MAE is the average over the verification 
% sample of the absolute values of the differences between forecast
% and the corresponding observation. The MAE is a linear score which
% means that all the individual differences are weighted equally in 
% the average.

%        sum | Xsim - Xobs |
%  MAE = ------------------
%                N

% Syntax:
%     [error_MAE] = mae(obsDATA, simDATA)
%
% where:
%     obsData = N x 2
%     simData = N x 2
%
%     obsData(:,1) = time observed
%     obsData(:,2) = Observed Data
%     simData(:,1) = time simulated
%     simData(:,2) = Simulated data
%
function [error_NMAE] = nmae_2layers(obsData, simData)

 MatchedData = [simData*0 obsData simData];
ss = find(~isnan(MatchedData(:,2)) == 1);

X = MatchedData(ss,2) - MatchedData(ss,3);
N = length(MatchedData(ss,2));

error_NMAE= sum(abs(X)) / N/mean(MatchedData(ss,2));