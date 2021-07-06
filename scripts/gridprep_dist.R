# Grid the summer flounder samples on the center line of a long, skinny lattice for use in IBDSim
# Use the distance from Cape Hatteras as the y-location in the lattice

library(here)
library(data.table)

meta <- fread(here("data", "pade_metadata.txt"))

xy <- meta[, .(PinskyID, lon, lat, dist)] # dist = great circle distance from a southern point (km)
max(xy$dist)

# Aim for grid with 1 million points, 40% buffer on all edges
# We'll use 200 x 4000: width is 5% of length
# to match 100 km wide x 1900 km continental shelf on east coast of us
# So buffer of 1600 on either end of the y-direction
xy$grid_y <- round((xy$dist - min(xy$dist))/diff(range(xy$dist))*800+1600)
xy$grid_x <- 100 # all samples in the middle

# y grid range for samples should be 1600 to 2400
range(xy$grid_y)

# Space the samples away from the center line if they share the same y-coord
ys <- sort(unique(xy$grid_y))
for(i in 1:length(ys)){
    n <- xy[grid_y == ys[i], .N] # find number of points that share this y-coord
    if(n > 1){
        xy[grid_y == ys[i], grid_x := sample(-floor(n/2):floor(n/2)+100, n, replace = FALSE)] # sample new x-coords around the center line
    }
}
          
# Plot
xy[, plot(grid_x, grid_y)]

# x grid range for samples should be 80 to 120
range(xy$grid_x)

# Location of Cape Hatteras in grid coords
round((864 - min(xy$dist))/diff(range(xy$dist))*800+1600) # 1944; 864 and below is south of Hatteras while any distance above 864 is north of Hatteras

# write out
write.csv(xy[order(grid_y), .(PinskyID, grid_x, grid_y)], file = here('output', 'pade_gridlocations_buffer40.csv'), row.names = FALSE)
