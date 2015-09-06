#------------------------------------------------------------------------#
# TITLE:        example1-data-setup.R
#
# AUTHOR:       Erich Seamon
#
# INSTITUITON:  College of Natural Resources
#               University of Idaho
#
# DATE:         August 12, 2015
#
# STAGE:        
#
# COMMENTS:     This is the first script (Data Setup) as part of the 
#               data science/analysis Example 1 code, from the 
#               University of Idaho Data Science Laboratory.
#
#--Setting the working directory an d clearing the workspace-----------#

library("ncdf")
library("raster")
library("sp")
library("rgeos")
library("rgdal")
library("proj4")
library("RNetCDF")
library("ncdf4")


#--Data Loading.  Here we are loading data into variables
#--within R.  We use the ncdf4 library to access the nc_open
#--function - which lets us load our data using a url that 
#--is opendap compliant.  Many weather, climate modeling,
#--oceanographic, and other raster based data modesl use
#--opendap web services to expose their data.  This url
#--is where you would enter in your opendap url with any
#--additional filtering of the data.  Here we are loading
#--max temperature information for 2014.

maxtemp <- nc_open('http://reacchpna.org/thredds/dodsC/agg_met_tmmx_1979_2015_WUSA.nc?lon[0:1:1385],lat[0:1:584],daily_maximum_temperature[0:1:0][0:1:0][0:1:0],day[0:1:10]')

#--Here we use the ncvar_get call to access the data from the
#--previously loaded max temperature file.

maxtemp_var <- ncvar_get(maxtemp, 'daily_maximum_temperature', start=c(1,1,1), count=c(-1,-1,1)) 

# turn the file into a raster

maxtempraster <- (raster(maxtemp_var)) 


# set the exent of the raster

xtent <- extent(25.1562, 52.8438, -124.5938, -67.0312) 
extent(maxtempraster) <- xtent

# set the projection of the raster

crs(maxtempraster) <- "+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0" 
maxtempraster <- setExtent(maxtempraster, xtent, keepres=TRUE)

# transpose the raster 

maxtempraster_transposed <- t(maxtempraster) 

#--plot the data

plot(maxtempraster_transposed) 
hist(maxtempraster_transposed)