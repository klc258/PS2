*______________________________________________________________________
*Data Management in Stata
*Kate Cruz, Fall 2017
*Problem Set 2 due: October 3rd 
*Stata Version 15/IC

//For the purpose of this excerise I have chosen to merge NJ County Health Rankings Data and data from the New Jersey Behavioral Risk Factor Survey in 2016. 
//New Jersey Behavioral Risk Factor Survey, Center for Health Statistics, New Jersey Department of Health Suggested citation: New Jersey Behavioral Risk Factor Survey (NJBRFS). New Jersey Department of Health, Center for Health Statistics, New Jersey State Health Assessment Data (NJSHAD) 
//Accessed at http://nj.gov/health/shad on [9/24/17] at [6pm].

//Using these data sets I hope to gain a clearer understading of the impact of the environment on public health. 
//I am interested to see if there is a correlation between access to food and green space and mental health and behavior. 
//Eventually I hope to merge data about tree count and pollution to see if the number of trees and the amount of air pollution impacts behavior and mental health.
/*Research questions may look like: 
Do trees negate negative impacts of pollution in highly polluted areas in New Jersey? 
Does inaccces to healthy food impact behavior and mental health?
Does increased green space impact poverty and mental health?
More specifically, does tree cover impact air quality and public health related to air quality ie: asthma rates */ 




*--------------------------------------------------------------------
*--------------------------------------------------------------------

local worDir "C:\Users\kathr\Desktop\CLASS2"

capture mkdir ps2 
cd ps2

//PART 1: Manipulating Data using original data set. I chose to manipulate this dataset because it has more variables 
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiZFZKbzhlOFN4Sm8&export=download", clear 

//First Round 
/*Renamed all of the variables in my dataset to provide clarity*/ 
rename A County 
rename B deaths 
rename C yearslost 
rename F zyearslost
rename G perfairpoorhealth
rename J zfairpoor
rename K puhdays
rename N zpuhdays
rename O muhdays
rename R zmuhdays
rename T lowbirth
rename U livebirth
rename V perlowbirth
rename Z persmoke
rename AC zsmoke 
rename AD perobese 
rename AG zobese 
rename AH foodindex
rename AI zfood
rename AJ perinactive
rename AM zinactive
rename AN perwaccess
rename AO zwaccess
rename AP perdrink
rename AS zdrink
rename AT aldrivedeath
rename AV peraldrivedeath
rename BC teenbirth
rename BD teenpop
rename BE teenbirthrate
rename BI uninsured
rename BJ peruninsured 
rename BM zuninsured 
rename BN PCP
rename BO PCPrate
rename BP zPCP
rename BQ dentist
rename BR dentistrate
rename BS zdentist 
rename BT MHproviders
rename BU MHPrate
rename BY medicaidenrolled
rename BZ prevhosprate
rename CC zprevhosprate
rename CD diabetics
rename CI zmedicareenrolled
rename CN cohortsize
rename CO gradrate
rename CP zgradrate
rename CQ somecollege
rename CR population 
rename CS persomecollege
rename CV zsomecollege
rename CW unemployed
rename CX laborforce 
rename CY perunemployed 
rename DA childpov
rename DB perchildpov
rename DE zchildpov
rename DF eightyincome
rename DG twentyincome
rename DH incomeratio
rename DI zincome 
rename DJ singleparent
rename DK households
rename DL persingleparent
rename DO zhouseholds
rename DP associations
rename DQ associationrate
rename DR zassociations 
rename DT violentcrimerate
rename DU zviolentcrime
rename DS violentcrime 
rename DV injurydeath
rename DW injurydeathrate
rename DZ zinjurydeath
rename EC violation
rename ED zviolation
rename EE severeproblems
rename EF persevereproblems
rename EI zsevereproblems 

//Dropped all irrelevant or confusing variables in the dataset to simplify 
drop D H L P W AA AE BF BK CA CF CK CT DC DM DC EG EM ER E I M Q S X AB AK AL AF AX AQ AW BF BG BK BL CA CB CF CG CK CM CT CU DC DD DM DN DX DY EG EH EM EN ER ES //removed the confidence intervals 
drop Y //unsure of what the zscore is related to therefore it is not necessary 
drop AU //number of driving deaths is not relevant 
drop AY BH CZ EO //unclear what these zscores are refering to 
drop AZ-BB //sexually transmitted diseases are not of interest to this study 
drop BV BW BX //as per note in the data, variable BT is the most up to date count of MHPs 
drop CE-CH //not relevant info 
drop CJ //mamography data not relevant to this study 
drop EA EB //not clear what this measures/relation to this study 
drop EJ-EL //number of drivers is irrelevant 
drop EP EQ ET //number of drivers who drive alone is irrelevant 

//code for cleaning
drop in 1/2 //these lines were confusing the data- they included variable names and statewide totals 
drop in 22/23 //these rows were extra/blank obersvations that were added when creating the new variable Region 

//Recode- 
//code for creating new region variables 
generate region=0
//region==0 means north 
//region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
//region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 
// = if you are assigning or generating, == for matching-find
move region deaths //this command moved the new variable to the front the the dataset

recode region (0/1=0 Non-Central) (1.1/2=1 Central), gen(region_2) //this allowed me to create a new level of comaprison looking at Central NJ in particular 
move region_2 region 


//destringing- most of my variables were not destrung and it was making it hard to calucate 
destring region deaths yearslost zyearslost perfairpoorhealth zfairpoor puhdays zpuhdays muhdays zmuhdays lowbirth livebirth perlowbirth persmoke zsmoke perobese zobese foodindex zfood perinactive zinactive perwaccess zwaccess perdrink zdrink aldrivedeath peraldrivedeath teenbirth teenpop teenbirthrate uninsured peruninsured zuninsured PCP PCPrate zPCP dentist dentistrate zdentist MHproviders MHPrate medicaidenrolled prevhosprate zprevhosprate diabetics zmedicareenrolled CL, replace

destring cohortsize gradrate zgradrate somecollege population persomecollege zsomecollege unemployed laborforce perunemployed childpov perchildpov zchildpov eightyincome twentyincome incomeratio zincome singleparent households persingleparent zhouseholds associations associationrate zassociations violentcrime violentcrimerate zviolentcrime injurydeath injurydeathrate zinjurydeath violation zviolation severeproblems persevereproblems zsevereproblems, replace

//violations for regressions- because violations would not destring because the obersvations were "yes" and "no" I created a new variable and assigned numeric values 
generate violations_r=0
replace violations_r=1 if violation=="Yes"
move violations_r violation
 
save kate_ps2

//Collapse- created a dummy variable for region and separated the counties into 3 regions: North, Central, South and used collapse to group 0=North 2=Central 1=South using county boundaries as defined by the State of New Jersey http://www.state.nj.us/transportation/about/directory/images/regionmapc150.gif
collapse childpov, by(region) //North Jersey has the largest population of children in poverty(20,000) followed by Central (13,627)and South Jersey (9,824)
collapse perchildpov, by(region) //When accounting for population size South Jersey has the highest rate of child poverty (18.7%), North Jersey with 15.7 and Central with 11.8 

clear //the collapse command creates issues when recalling the dataset so I cleared the data and started from where I left off prior to collapse 
use kate_ps2 

//Bys:egen- 
egen unhealthy=rowmean(muhdays puhdays) //I combined mental and physical health to create a measurement of overall poor health or unhealthy based on the means pulled by this code I see that Atlantic, Hudson, Ocean and Salem have the poorest overall health (with Camden following right behind) 
move unhealthy deaths 

egen av_deaths=mean(deaths), by(region) // this code produced the mean number of deaths for each region and shows that Central NJ has the largest average of deaths 
move av_deaths deaths 

//Second Round 
clear 
cd ps2
import excel "https://docs.google.com/uc?id=0B1opnkI-LLCiWk1BYUc3R3FFWkE&export=download", clear //this is my second dataset the behavioral risk survey 
rename A County //renamed the column for more clarity 
rename B Countyid 
rename C responses
rename D samplesize
rename E perstressdays //percentage of mental stress days 

drop F G //confidence intervals are not relevant at this time 
drop in 1/11 //Drop or Keep- I dropped labels and introductory information  
drop in 22/66 //dropped footnotes 

//destringing- my variables were not destrung and it was making it hard to calucate 
destring Countyid, gen(Countyid_n) 
destring responses, gen(responses_n)
destring samplesize, gen(samplesize_n)
destring perstressdays, gen(perstressdays_n) 

//Recode- 
//code for creating new region variables 
generate region=0
//region==0 means north 
//region==1 means south 
replace region=1 if County=="Burlington" | County=="Camden" | County=="Gloucester" | County=="Salem" | County=="Cumberland" | County=="Atlantic" | County=="Cape May" 
//region==2 means central
replace region=2 if County=="Hunterdon" | County=="Somerset" | County=="Middlesex" | County=="Monmouth" | County=="Ocean" | County=="Mercer" 

save kate_ps22 //didn't save as kate_ps2 because it is a different dataset

bys region: egen avgStress=mean(perstressdays_n) //shows the average percentage of stressful days per county. South Jersey has the highest average (15%), Central Jersey (10%) and North (9%) 

 
//PART 2: Merging Datasets 
clear 
cd ps2
use kate_ps2
merge 1:1 County using kate_ps22
save kate_ps2final




















 





























