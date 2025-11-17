# import data
df <- read.csv('/Users/james/Desktop/hs_final.csv')

# remove controls from the dataset
fb <- df[df$Biomech_Group != "Control",]

#######################################
#### Run Linear Regression for MD #####
#######################################

md_model <- lm(fb$MD_Avg ~ fb$Lin + fb$Age + fb$BMI + fb$Pos_Bin + fb$Level_Bin + fb$TBS_Days + fb$Scanner + fb$Concussion_bin)

# run shapirio-wilk test for normally distributed residuals
res <- residuals(md_model)
shapiro.test(res)

# Shapiro Result
Shapiro-Wilk normality test

data:  res
W = 0.98735, p-value = 0.5631
summary(md_model)

# Linear Regression Result
Call:
lm(formula = fb$MD_Avg ~ fb$Lin + fb$Age + fb$BMI + fb$Pos_Bin + 
    fb$Level_Bin + fb$TBS_Days + fb$Scanner + fb$Concussion_bin)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.2626 -1.3959 -0.1489  1.4238  5.3679 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)        8.024349   5.850638   1.372    0.174    
fb$Lin             8.610411   1.834071   4.695 1.12e-05 ***
fb$Age            -0.308530   0.365325  -0.845    0.401    
fb$BMI            -0.090624   0.078427  -1.156    0.251    
fb$Pos_Bin         0.219795   0.724230   0.303    0.762    
fb$Level_Bin       0.629776   0.874675   0.720    0.474    
fb$TBS_Days       -0.001052   0.010361  -0.101    0.919    
fb$ScannerTwo     -2.831398   0.688835  -4.110 9.68e-05 ***
fb$Concussion_bin  0.035404   0.610352   0.058    0.954    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.303 on 78 degrees of freedom
Multiple R-squared:  0.408,	Adjusted R-squared:  0.3473 
F-statistic:  6.72 on 8 and 78 DF,  p-value: 1.149e-06

#######################################
#### Run Linear Regression for PSD ####
#######################################

psd_model <- lm(fb$PSD_Avg ~ fb$Lin + fb$Age + fb$BMI + fb$Pos_Bin + fb$Level_Bin + fb$TBS_Days + fb$Scanner + fb$Concussion_bin)
res <- residuals(psd_model)
shapiro.test(res)

# Shapiro Result
Shapiro-Wilk normality test

data:  res
W = 0.99108, p-value = 0.8234
Call:
lm(formula = fb$PSD_Avg ~ fb$Lin + fb$Age + fb$BMI + fb$Pos_Bin + 
    fb$Level_Bin + fb$TBS_Days + fb$Scanner + fb$Concussion_bin)

Residuals:
    Min      1Q  Median      3Q     Max 
-9.5714 -2.8916  0.2169  2.1810  9.1643 

Coefficients:
                   Estimate Std. Error t value Pr(>|t|)    
(Intercept)       -15.08858   10.34771  -1.458 0.148812    
fb$Lin            -13.05136    3.24382  -4.023 0.000132 ***
fb$Age              0.50339    0.64613   0.779 0.438288    
fb$BMI              0.09497    0.13871   0.685 0.495589    
fb$Pos_Bin          0.66137    1.28091   0.516 0.607083    
fb$Level_Bin       -0.65379    1.54699  -0.423 0.673735    
fb$TBS_Days         0.01262    0.01833   0.688 0.493246    
fb$ScannerTwo       5.74890    1.21831   4.719 1.02e-05 ***
fb$Concussion_bin   1.21906    1.07950   1.129 0.262238    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.073 on 78 degrees of freedom
Multiple R-squared:  0.3976,	Adjusted R-squared:  0.3358 
F-statistic: 6.436 on 8 and 78 DF,  p-value: 2.106e-06

#######################################
#### Run Group Comparisons for MD #####
#######################################

> biomech_df <- df[df$Biomech_Group != "Mid",]
> model <- lm(biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days)
> summary(model)

Call:
lm(formula = biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + 
    biomech_df$Age + biomech_df$TBS_Days)

Residuals:
   Min     1Q Median     3Q    Max 
-7.212 -1.326  0.399  1.260  3.741 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)    
(Intercept)                  -9.33807    4.05371  -2.304 0.025529 *  
biomech_df$Biomech_GroupHigh  3.95313    1.04091   3.798 0.000403 ***
biomech_df$Biomech_GroupLow   0.36634    0.79612   0.460 0.647442    
biomech_df$BMI               -0.06049    0.06929  -0.873 0.386912    
biomech_df$Age                0.44328    0.25322   1.751 0.086277 .  
biomech_df$TBS_Days           0.01880    0.01093   1.720 0.091747 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.132 on 49 degrees of freedom
Multiple R-squared:    0.5,	Adjusted R-squared:  0.449 
F-statistic:   9.8 on 5 and 49 DF,  p-value: 1.552e-06

> emmeans(model, pairwise ~ Biomech_Group, adjust="tukey")

#emmeans Results
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control       -0.995 0.695 49    -2.39    0.402
 High           2.958 0.683 49     1.58    4.331
 Low           -0.629 0.395 49    -1.42    0.165

Confidence level used: 0.95 

$contrasts
 contrast       estimate    SE df t.ratio p.value
 Control - High   -3.953 1.040 49  -3.798  0.0012
 Control - Low    -0.366 0.796 49  -0.460  0.8901
 High - Low        3.587 0.821 49   4.368  0.0002

P value adjustment: tukey method for comparing a family of 3 estimates 

#######################################
#### Run Group Comparisons for PSD ####
#######################################

> model <- lm(biomech_df$PSD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days)
> summary(model)

Call:
lm(formula = biomech_df$PSD_Avg ~ biomech_df$Biomech_Group + 
    biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days)

Residuals:
     Min       1Q   Median       3Q      Max 
-10.1451  -2.0933  -0.0224   2.3516  14.5090 

Coefficients:
                              Estimate Std. Error t value Pr(>|t|)   
(Intercept)                  13.082078   8.487377   1.541  0.12966   
biomech_df$Biomech_GroupHigh -6.498511   2.179386  -2.982  0.00445 **
biomech_df$Biomech_GroupLow  -0.987273   1.666864  -0.592  0.55638   
biomech_df$BMI                0.159499   0.145075   1.099  0.27695   
biomech_df$Age               -0.821043   0.530173  -1.549  0.12791   
biomech_df$TBS_Days          -0.009573   0.022886  -0.418  0.67757   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.463 on 49 degrees of freedom
Multiple R-squared:  0.3263,	Adjusted R-squared:  0.2576 
F-statistic: 4.747 on 5 and 49 DF,  p-value: 0.001293

> emmeans(model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control         2.59 1.460 49  -0.3356     5.52
 High           -3.91 1.430 49  -6.7836    -1.03
 Low             1.60 0.828 49  -0.0606     3.27

Confidence level used: 0.95 

$contrasts
 contrast       estimate   SE df t.ratio p.value
 Control - High    6.499 2.18 49   2.982  0.0122
 Control - Low     0.987 1.67 49   0.592  0.8249
 High - Low       -5.511 1.72 49  -3.205  0.0066

P value adjustment: tukey method for comparing a family of 3 estimates 

#################################################
#### Group MD Comparisons without Duplicates ####
#################################################
> df <- read.csv('/Users/james/Desktop/hs_final_no_duplicates.csv')
> biomech_df <- df[df$Biomech_Group != "Mid",]
> model <- lm(biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days)
> summary(model)

Call:
lm(formula = biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + 
    biomech_df$Age + biomech_df$TBS_Days)

Residuals:
    Min      1Q  Median      3Q     Max 
-7.5198 -1.3267  0.3995  1.2625  3.2920 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)    
(Intercept)                  -8.81796    4.23666  -2.081 0.043391 *  
biomech_df$Biomech_GroupHigh  4.32508    1.06311   4.068 0.000199 ***
biomech_df$Biomech_GroupLow   0.82716    0.83435   0.991 0.327046    
biomech_df$BMI               -0.11648    0.07444  -1.565 0.125001    
biomech_df$Age                0.45063    0.26819   1.680 0.100160    
biomech_df$TBS_Days           0.02234    0.01154   1.935 0.059534 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.143 on 43 degrees of freedom
Multiple R-squared:  0.525,	Adjusted R-squared:  0.4697 
F-statistic: 9.504 on 5 and 43 DF,  p-value: 3.692e-06

> emmeans(model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control       -1.209 0.711 43    -2.64    0.224
 High           3.116 0.684 43     1.74    4.496
 Low           -0.382 0.443 43    -1.27    0.510

Confidence level used: 0.95 

$contrasts
 contrast       estimate    SE df t.ratio p.value
 Control - High   -4.325 1.060 43  -4.068  0.0006
 Control - Low    -0.827 0.834 43  -0.991  0.5862
 High - Low        3.498 0.846 43   4.136  0.0005

P value adjustment: tukey method for comparing a family of 3 estimates 

# SAME RESULTS FOUND AS ABOVE!

#################################################
#### Group PSD Comparisons without Duplicates ###
#################################################

> model <- lm(biomech_df$PSD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days)
> summary(model)

Call:
lm(formula = biomech_df$PSD_Avg ~ biomech_df$Biomech_Group + 
    biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days)

Residuals:
    Min      1Q  Median      3Q     Max 
-9.2539 -1.9629 -0.2442  2.0059 14.7458 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)   
(Intercept)                  13.55258    8.94498   1.515  0.13706   
biomech_df$Biomech_GroupHigh -6.64397    2.24457  -2.960  0.00499 **
biomech_df$Biomech_GroupLow  -1.75782    1.76159  -0.998  0.32393   
biomech_df$BMI                0.19010    0.15717   1.210  0.23307   
biomech_df$Age               -0.81723    0.56624  -1.443  0.15619   
biomech_df$TBS_Days          -0.01740    0.02437  -0.714  0.47896   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.524 on 43 degrees of freedom
Multiple R-squared:  0.3281,	Adjusted R-squared:  0.2499 
F-statistic: 4.199 on 5 and 43 DF,  p-value: 0.003397

> emmeans(model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control        2.683 1.500 43   -0.343     5.71
 High          -3.961 1.450 43   -6.875    -1.05
 Low            0.925 0.934 43   -0.959     2.81

Confidence level used: 0.95 

$contrasts
 contrast       estimate   SE df t.ratio p.value
 Control - High     6.64 2.24 43   2.960  0.0136
 Control - Low      1.76 1.76 43   0.998  0.5822
 High - Low        -4.89 1.79 43  -2.737  0.0239

P value adjustment: tukey method for comparing a family of 3 estimates 

# SAME RESULTS FOUND AS ABOVE!

#################################################################
#### Correlation Coeffiecients between MD and PSD - Football ####
#################################################################

> df <- read.csv('/Users/james/Desktop/hs_final.csv')
> fb = df[df$Biomech_Group != "Control",]
> control = df[df$Biomech_Group == "Control",]
> cor.test(fb$MD_Avg, fb$PSD_Avg)

	Pearsons product-moment correlation

data:  fb$MD_Avg and fb$PSD_Avg
t = -9.9664, df = 85, p-value = 6.007e-16
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.8182034 -0.6191704
sample estimates:
       cor 
-0.7340753 

#################################################################
#### Correlation Coeffiecients between MD and PSD - Control ####
#################################################################

> cor.test(control$MD_Avg, control$PSD_Avg)

	Pearsons product-moment correlation

data:  control$MD_Avg and control$PSD_Avg
t = -2.6509, df = 9, p-value = 0.02644
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.9032518 -0.1033297
sample estimates:
       cor 
-0.6621607 

