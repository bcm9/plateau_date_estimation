function [plateau_date plateau_score plateau_var] = plateau_date_estimation(dates,scores,score_diff)
%plateau_date_estimation Estimate the date when scores measured over time plateau
%   Four-parameter logistic regression and interpolation to estimate the plateau date of scores measured over time
%   Returns:
%       plateau_score = the upper asymptote 
%       plateau_date = the first date within score_diff% of the plateau score (horizontal asym) on the function.
%       plateau_var = standard deviation of the scores measured over the plateau
%   Arguments are:
%       dates = N x 1 array of arbitrary dates
%       scores = N x 1 array of arbitrary scores
%       score_diff = % criteria within the plateau score (horizontal asym)
%   e.g. [plateau_date plateau_score plateau_var] = plateau_date_estimation([0.5 1 2 4 6 12 18 36 48 60]',[10 8 20 18 50 75 85 82 88 86]',5)
%   https://github.com/bcm9
%   Inspired by % Cardillo G. (2012) Four parameters logistic regression - There and back again https://it.mathworks.com/matlabcentral/fileexchange/38122

%% Build logistic regression model
% pre-processing: remove NaN scores
idx=find(~isnan(scores));
% remove rows where NaNs are present
scores=scores(idx);
dates=dates(idx);

% set starting points for regression
A=min(scores); % lower asymptote
k=(scores(end)-scores(1))/(dates(end)-dates(1)); % slope
[~,idx]=min(abs((scores-((max(scores)-min(scores))/2)))); % index inflection point
B=sign(k);
C=dates(idx); % inflection point
D=max(scores); % upper asymptote
% concatenate starting points into array
startpts=[A B C D];

% set lower/upper bounds of parameters
lB=zeros(1,4);
uB=Inf(1,4);

% set options for model
options = fitoptions('method','NonlinearLeastSquares','Lower',lB,'Upper',uB);
set(options,'Startpoint',startpts);

% set fit type for model
ft = fittype('D+(A-D)/(1+(x/C)^B)','dependent',{'y'},'independent',{'x'},'coefficients',{'A', 'B', 'C', 'D'});

%% Fit model to data, return the goodness of fit
[lfit,GoF] = fit(dates,scores,ft,options);

%% Use model to estimate plateau date
% create array of x values to fit function to
fdates=min(dates):0.01:max(dates);
% use model to estimate scores across array of postactdates
fscores=lfit.D+(lfit.A-lfit.D)./(1+(fdates./lfit.C).^lfit.B);

% index dates ranging from plateau score - score diff to end
find(max(fscores)-fscores<score_diff);
% plateau date is first date within score_diff% of plateau score (horizontal asym)
plateau_date=fdates(ans(1));
plateau_score=max(fscores);
% find the variation in scores over the plateau
plateau_var=std(scores(find(dates>=plateau_date)),1);

%% Plot the scores as a function of date, and the logistic fit, with estimate reference line
plot(dates,scores,'ko','LineWidth',1.5,'MarkerSize',10)
hold on
h=plot(lfit,'b-');
h1=line([plateau_date plateau_date], [0 100],'Color','r','LineStyle','--');
grid on
legend off
xlabel('\bfDATE \rm(Months)','FontSize',12)
ylabel('\bfSCORE \rm(%)','FontSize',12)
ylim([0 100])
axis square
legend('Scores','Fit','Plateau date','Location', 'Best')
end
