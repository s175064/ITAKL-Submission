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

psd_model <- lm(fb$PSD_Avg ~ fb$Lin + fb$Age + fb$BMI + fb$Pos_Bin + fb$Level_Bin + fb$TBS_Days + fb$Concussion_bin)
res <- residuals(psd_model)
shapiro.test(res)

# Shapiro Result
Shapiro-Wilk normality test

data:  res
W = 0.98924, p-value = 0.6968

summary(psd_model)

Call:
lm(formula = fb$PSD_Avg ~ fb$Lin + fb$Age + fb$BMI + fb$Pos_Bin + 
    fb$Level_Bin + fb$TBS_Days + fb$Concussion_bin)

Residuals:
    Min      1Q  Median      3Q     Max 
-9.4525 -2.9739 -0.0341  2.7765 11.8909 

Coefficients:
                    Estimate Std. Error t value Pr(>|t|)    
(Intercept)        -0.103183  11.095029  -0.009 0.992603    
fb$Lin            -13.038851   3.654449  -3.568 0.000615 ***
fb$Age             -0.112461   0.712919  -0.158 0.875059    
fb$BMI              0.110300   0.156225   0.706 0.482243    
fb$Pos_Bin          0.662573   1.443054   0.459 0.647390    
fb$Level_Bin       -1.920236   1.716392  -1.119 0.266631    
fb$TBS_Days         0.009415   0.020631   0.456 0.649377    
fb$Concussion_bin   1.177480   1.216108   0.968 0.335881    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.589 on 79 degrees of freedom
  (3 observations deleted due to missingness)
Multiple R-squared:  0.2257,	Adjusted R-squared:  0.157 
F-statistic: 3.289 on 7 and 79 DF,  p-value: 0.004041

#######################################
#### Run Group Comparisons for MD #####
#######################################

> biomech_df <- df[df$Biomech_Group != "Mid",]
> model <- lm(biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days + biomech_df$Scanner)
> summary(model)

Call:
lm(formula = biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + 
    biomech_df$Age + biomech_df$TBS_Days + biomech_df$Scanner)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.0916 -1.0264  0.2002  1.2744  3.8233 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)   
(Intercept)                  -4.42014    4.37055  -1.011  0.31692   
biomech_df$Biomech_GroupHigh  3.04309    1.06213   2.865  0.00617 **
biomech_df$Biomech_GroupLow   0.02669    0.77244   0.035  0.97258   
biomech_df$BMI               -0.04631    0.06637  -0.698  0.48863   
biomech_df$Age                0.26589    0.25250   1.053  0.29759   
biomech_df$TBS_Days           0.01707    0.01045   1.634  0.10891   
biomech_df$ScannerTwo        -2.14931    0.88977  -2.416  0.01957 * 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.034 on 48 degrees of freedom
  (3 observations deleted due to missingness)
Multiple R-squared:  0.5542,	Adjusted R-squared:  0.4985 
F-statistic: 9.945 on 6 and 48 DF,  p-value: 4.041e-07

> emmeans(model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control        0.134 0.812 48   -1.498     1.77
 High           3.177 0.658 48    1.854     4.50
 Low            0.161 0.499 48   -0.843     1.16

Results are averaged over the levels of: Scanner 
Confidence level used: 0.95 

$contrasts
 contrast       estimate    SE df t.ratio p.value
 Control - High  -3.0431 1.060 48  -2.865  0.0167
 Control - Low   -0.0267 0.772 48  -0.035  0.9993
 High - Low       3.0164 0.818 48   3.686  0.0016

Results are averaged over the levels of: Scanner 
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
> model <- lm(biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + biomech_df$Age + biomech_df$TBS_Days + biomech_df$Scanner)
> summary(model)

Call:
lm(formula = biomech_df$MD_Avg ~ biomech_df$Biomech_Group + biomech_df$BMI + 
    biomech_df$Age + biomech_df$TBS_Days + biomech_df$Scanner)

Residuals:
    Min      1Q  Median      3Q     Max 
-6.4840 -0.9903  0.1413  1.3690  3.4784 

Coefficients:
                             Estimate Std. Error t value Pr(>|t|)   
(Intercept)                  -4.32305    4.61004  -0.938  0.35374   
biomech_df$Biomech_GroupHigh  3.48549    1.09941   3.170  0.00284 **
biomech_df$Biomech_GroupLow   0.45159    0.82316   0.549  0.58618   
biomech_df$BMI               -0.09817    0.07221  -1.360  0.18122   
biomech_df$Age                0.28407    0.27021   1.051  0.29914   
biomech_df$TBS_Days           0.02017    0.01116   1.808  0.07784 . 
biomech_df$ScannerTwo        -1.91812    0.91639  -2.093  0.04242 * 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.063 on 42 degrees of freedom
Multiple R-squared:  0.5698,	Adjusted R-squared:  0.5084 
F-statistic: 9.273 on 6 and 42 DF,  p-value: 1.78e-06

> emmeans(model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control       -0.188 0.840 42   -1.884     1.51
 High           3.297 0.665 42    1.956     4.64
 Low            0.263 0.526 42   -0.798     1.32

Results are averaged over the levels of: Scanner 
Confidence level used: 0.95 

$contrasts
 contrast       estimate    SE df t.ratio p.value
 Control - High   -3.485 1.100 42  -3.170  0.0078
 Control - Low    -0.452 0.823 42  -0.549  0.8477
 High - Low        3.034 0.844 42   3.595  0.0024

Results are averaged over the levels of: Scanner 
P value adjustment: tukey method for comparing a family of 3 estimates

# SAME RESULTS FOUND AS ABOVE!

#################################################
#### Group PSD Comparisons without Duplicates ###
#################################################
> df <- read.csv('/Users/james/Desktop/hs_final_no_duplicates.csv')
> biomech_df <- df[df$Biomech_Group != "Mid",]
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

