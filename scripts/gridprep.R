# Code from Malin Pinsky, July 2, 2021
# Maps summer flounder samples onto a 1000 x 750 grid with a buffer on all sides
# Potential grid prep for IBDsim

library(sp)
library(rgdal)
require(data.table)

dat <- fread('data/pade_metadata.txt', header = TRUE)
dat[, plot(lon, lat)]


xy <- dat[, .(PinskyID, lon, lat)]
coordinates(xy) <- c("lon", "lat")
proj4string(xy) <- CRS("+proj=longlat +datum=WGS84")  ## for example
xyUTM <- spTransform(xy, CRS("+proj=utm +zone=17 ellps=WGS84"))

xyUTM$grid_y <- (xyUTM$lat - min(xyUTM$lat))/diff(range(xyUTM$lat))*1250+125
xyUTM$grid_x <- (xyUTM$lon - min(xyUTM$lon))/diff(range(xyUTM$lon))*600+75

range(xyUTM$grid_y)
range(xyUTM$grid_x)

# for a grid that is 1000 grid points N-S and 750 grid points E-W. has a 10% buffer on all sides of the samples