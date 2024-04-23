# WAMSI Theme 5.2 Waves
## raw data
Raw data is in the form of csvs seperated into WWM and WWM_REG folders

## issues 
The CSV structure for all files is:
-Date,X,Y,HS,DM,TPP

However for the site JPPL:
-Date,X,Y,WVHT,WVDIR,WVPER

So I just changed the file myself to match (easier than coding in an exception, at the expense of modifying what the agency has provided)

## Conversions
![Conversion table](./Wamsi%20Waves%20Conversions.png)