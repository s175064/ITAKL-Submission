
############################################################
########## Linear regression for RWE-Lin and MD ############
############################################################

# import csv file
> df <- read.csv('hs_final.csv')
# get only the data for football players
> fb_df <- df[df$Biomech_Group != "Control",]
# generate the linear regression model for mean diffusivity
> md_model <- lm(fb_df$MD_Avg ~ fb_df$Lin + fb_df$Age + fb_df$BMI + fb_df$Pos_Bin + fb_df$Level_Bin + fb_df$TBS_Days + fb_df$Concussion_bin + fb_df$Scanner_Bin)
> summary(md_model)

Call:
lm(formula = fb_df$MD_Avg ~ fb_df$Lin + fb_df$Age + fb_df$BMI + 
    fb_df$Pos_Bin + fb_df$Level_Bin + fb_df$TBS_Days + fb_df$Concussion_bin + 
    fb_df$Scanner_Bin)

Residuals:
    Min      1Q  Median      3Q     Max 
-4.2626 -1.3959 -0.1489  1.4238  5.3679 

Coefficients:
                      Estimate Std. Error t value Pr(>|t|)    
(Intercept)           8.024349   5.850638   1.372    0.174    
fb_df$Lin             8.610411   1.834071   4.695 1.12e-05 ***
fb_df$Age            -0.308530   0.365325  -0.845    0.401    
fb_df$BMI            -0.090624   0.078427  -1.156    0.251    
fb_df$Pos_Bin         0.219795   0.724230   0.303    0.762    
fb_df$Level_Bin       0.629776   0.874675   0.720    0.474    
fb_df$TBS_Days       -0.001052   0.010361  -0.101    0.919    
fb_df$Concussion_bin  0.035404   0.610352   0.058    0.954    
fb_df$Scanner_Bin    -2.831398   0.688835  -4.110 9.68e-05 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 2.303 on 78 degrees of freedom
  (16 observations deleted due to missingness)
Multiple R-squared:  0.408,	Adjusted R-squared:  0.3473 
F-statistic:  6.72 on 8 and 78 DF,  p-value: 1.149e-06

####################################################################
### determine if linear regression is appropriate for this model ###
####################################################################
> shapiro.test(residuals(md_model))

	Shapiro-Wilk normality test

data:  residuals(md_model)
W = 0.98735, p-value = 0.5631

############################################################
####### compare MD for high, low, and control groups #######
############################################################

> biomech <- df[df$Biomech_Group != "Mid",]
> md_model <- lm(biomech$MD_Avg ~ biomech$Biomech_Group + biomech$BMI + biomech$Age + biomech$TBS_Days + biomech$Scanner_Bin)
> emmeans(MDmodel, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control        0.317 0.772 54    -1.23     1.86
 High           3.185 0.650 54     1.88     4.49
 Low            0.360 0.414 54    -0.47     1.19

Results are averaged over the levels of: Scanner_Bin 
Confidence level used: 0.95 

$contrasts
 contrast       estimate    SE df t.ratio p.value
 Control - High  -2.8671 1.010 54  -2.838  0.0173
 Control - Low   -0.0429 0.762 54  -0.056  0.9983
 High - Low       2.8242 0.752 54   3.757  0.0012

Results are averaged over the levels of: Scanner_Bin 
P value adjustment: tukey method for comparing a family of 3 estimates 

#############################################################
###### Rerun MD ANCOVA without duplicates ###################
#############################################################

> df <- read.csv('hs_final_deidentified_no_duplicates.csv')
> biomech <- df[df$Biomech_Group != "Mid",]
> MD_model <- lm(biomech$MD_Avg ~ biomech$Biomech_Group + biomech$BMI + biomech$Age + biomech$TBS_Days + biomech$Scanner)
> emmeans(MD_model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL
 Control        0.230 0.782 47   -1.343
 High           3.278 0.646 47    1.979
 Low            0.542 0.434 47   -0.331
 upper.CL
     1.80
     4.58
     1.41

Results are averaged over the levels of: Scanner 
Confidence level used: 0.95 

$contrasts
 contrast       estimate    SE df t.ratio
 Control - High   -3.048 1.030 47  -2.961
 Control - Low    -0.311 0.795 47  -0.392
 High - Low        2.736 0.764 47   3.581
 p.value
  0.0131
  0.9191
  0.0023

Results are averaged over the levels of: Scanner 
P value adjustment: tukey method for comparing a family of 3 estimates 

# SAME RESULTS AS ABOVE!!!

############################################################
########## compare tSNR with and without ArtRepair #########
############################################################

> df <- read.csv('tsnr.csv')
> t.test(df$art_tsnr, df$orig_tsnr, paired=TRUE, alternative='greater')

	Paired t-test

data:  df$art_tsnr and df$orig_tsnr
t = 8.3996, df = 195, p-value = 4.58e-15
alternative hypothesis: true mean difference is greater than 0
95 percent confidence interval:
 11.39494      Inf
sample estimates:
mean difference 
       14.18623 

############################################################
########## Linear regression for RWE-Lin and PSD ###########
############################################################

> PSD_model <- lm(fb_df$PSD_Avg ~ fb_df$Lin + fb_df$Age + fb_df$BMI + fb_df$Pos_Bin + fb_df$Level_Bin + fb_df$TBS_Days + fb_df$Concussion_bin)
> summary(PSD_model)

Call:
lm(formula = fb_df$PSD_Avg ~ fb_df$Lin + fb_df$Age + fb_df$BMI + 
    fb_df$Pos_Bin + fb_df$Level_Bin + fb_df$TBS_Days + fb_df$Concussion_bin)

Residuals:
    Min      1Q  Median      3Q     Max 
-10.089  -3.419  -0.087   2.796  11.984 

Coefficients:
                       Estimate Std. Error t value Pr(>|t|)
(Intercept)           -1.802107  11.289693  -0.160 0.873585
fb_df$Lin            -13.063469   3.718567  -3.513 0.000736
fb_df$Age             -0.007185   0.725427  -0.010 0.992123
fb_df$BMI              0.097815   0.158966   0.615 0.540111
fb_df$Pos_Bin          0.787375   1.468372   0.536 0.593311
fb_df$Level_Bin       -2.108499   1.746506  -1.207 0.230932
fb_df$TBS_Days         0.010765   0.020993   0.513 0.609543
fb_df$Concussion_bin   1.315785   1.237445   1.063 0.290882
                        
(Intercept)             
fb_df$Lin            ***
fb_df$Age               
fb_df$BMI               
fb_df$Pos_Bin           
fb_df$Level_Bin         
fb_df$TBS_Days          
fb_df$Concussion_bin    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 4.669 on 79 degrees of freedom
  (16 observations deleted due to missingness)
Multiple R-squared:  0.2175,	Adjusted R-squared:  0.1481 
F-statistic: 3.137 on 7 and 79 DF,  p-value: 0.005637

####################################################################
### determine if linear regression is appropriate for this model ###
####################################################################

> shapiro.test(residuals(PSD_model))

	Shapiro-Wilk normality test

data:  residuals(PSD_model)
W = 0.98878, p-value = 0.6638

############################################################
####### compare PSD for high, low, and control groups ######
############################################################

> df <- read.csv('hs_final_deidentified.csv')
> biomech <- df[df$Biomech_Group != "Mid",]
> PSD_model <- lm(biomech$PSD_Avg ~ biomech$Biomech_Group + biomech$BMI + biomech$Age + biomech$TBS_Days)
> emmeans(PSD_model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL upper.CL
 Control        2.338 1.510 55   -0.684    5.359
 High          -3.682 1.450 55   -6.596   -0.768
 Low            0.913 0.781 55   -0.653    2.479

Confidence level used: 0.95 

$contrasts
 contrast       estimate   SE df t.ratio p.value
 Control - High     6.02 2.22 55   2.712  0.0238
 Control - Low      1.42 1.70 55   0.840  0.6801
 High - Low        -4.59 1.70 55  -2.707  0.0241
 
P value adjustment: tukey method for comparing a family of 3 estimates 

#############################################################
###### Rerun PSD ANCOVA without duplicates ##################
#############################################################

> df <- read.csv('hs_final_deidentified_no_duplicates.csv')
> biomech <- df[df$Biomech_Group != "Mid",]
> PSD_model <- lm(biomech$PSD_Avg ~ biomech$Biomech_Group + biomech$BMI + biomech$Age + biomech$TBS_Days)
> emmeans(PSD_model, pairwise ~ Biomech_Group, adjust="tukey")
$emmeans
 Biomech_Group emmean    SE df lower.CL
 Control        2.263 1.580 48   -0.913
 High          -3.848 1.490 48   -6.852
 Low            0.932 0.895 48   -0.868
 upper.CL
    5.438
   -0.844
    2.732

Confidence level used: 0.95 

$contrasts
 contrast       estimate   SE df t.ratio
 Control - High     6.11 2.32 48   2.629
 Control - Low      1.33 1.81 48   0.734
 High - Low        -4.78 1.78 48  -2.682
 p.value
  0.0303
  0.7448
  0.0266

P value adjustment: tukey method for comparing a family of 3 estimates 

# SAME RESULTS!!!

############################################################
####### Agreement between MD and PSD values - football #####
############################################################
> cor.test(fb_df$MD_Avg,fb_df$PSD_Avg)

	Pearsons product-moment correlation

data:  fb_df$MD_Avg and fb_df$PSD_Avg
t = -9.8509, df = 85, p-value = 1.027e-15
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.8153627 -0.6138802
sample estimates:
       cor 
-0.7301152

############################################################
####### Agreement between MD and PSD values - controls #####
############################################################

> control <- df[df$Biomech_Group == "Control",]
> cor.test(control$MD_Avg,control$PSD_Avg)

	Pearsons product-moment correlation

data:  control$MD_Avg and control$PSD_Avg
t = -2.3204, df = 9, p-value = 0.04546
alternative hypothesis: true correlation is not equal to 0
95 percent confidence interval:
 -0.88637542 -0.01885026
sample estimates:
       cor 
-0.6118071 


