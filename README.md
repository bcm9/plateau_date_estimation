# plateau_date_estimation

### MATLAB function to fit logistic function and estimate xpoint. Applied to estimate the date when (speech recognition) scores measured over time "plateau". 

### Main code: plateau_date_estimation.m returns:

* plateau_score = upper horizontal asymptote 

* plateau_date = first date within score_diff% of the plateau score on the function.

* plateau_var = standard deviation of the scores measured over the plateau

### Arguments:
### plateau_date_estimation(dates,scores,score_diff)

* dates = N x 1 array of dates (arbitrary)
* scores = N x 1 array of scores (arbitrary)
* score_diff = % criteria within the plateau score

### Example
[plateau_date plateau_score plateau_var] = plateau_date_estimation([0.5 1 2 4 6 12 18 36 48 60]',[10 8 20 18 50 75 85 82 88 86]',5)
