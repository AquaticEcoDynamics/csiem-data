# Wamsi Theme 3 SEDPSD
## Raw Data
This data about composition of the sediment as a percentage. This is stored in the swamp then processed into a flatfile in the data lake and then into the warehouse. The script that does this is called ImportSEDPSDMain.m



## Notes
The variable names as can be seen in the folder labeled Variable Naming have been
chosen to mimic WIR conventions. The file paths have been hard coded to appropriate relative locations
in the GIS_DATA local drive which can then be ran through hydro user on davy.

From a data transperacy perspective, I havent touched the data. Except in the case of Kwinana data,
its easier to just stitch the Lat and Long in after the fact than rename the data that came in so the names match perfectly.

I found the coordinates in the remastered sharepoint copy of the sediment data, this was done in terms of eastings and northings,
this was converted to lat and long using [https://www.zonums.com/online/coords/cotrans.php?module=14](https://www.zonums.com/online/coords/cotrans.php?module=14) and creating a seperate csv as to not edit the data that comes in from the agency.

![WIR naming conversions compared to variable names](./Variable%20Naming/Variablenames.png)

## Conversions
[Conversion table](./SEDPSD%20Conversions.png)