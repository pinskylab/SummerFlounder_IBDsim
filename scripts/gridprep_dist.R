# Grid the summer flounder samples on the center line of a long, skinny lattice for use in IBDSim
# Use the distance from Cape Hatteras as the y-location in the lattice

library(here)
library(data.table)

meta <- fread(here("data", "pade_metadata.txt"))

xy <- meta[, .(PinskyID, lon, lat, dist)] # dist = great circle distance from a southern point (km)
max(xy$dist)

# Aim for grid with 1 million points, 10% buffer on all edges
# We'll use 200 x 4000: width is 5% of length
# to match 100 km wide x 1900 km continental shelf on east coast of us
# So buffer of 400 on either end of the y-direction
xy$grid_y <- round((xy$dist - min(xy$dist))/diff(range(xy$dist))*3200+400)
xy$grid_x <- 100 # all samples in the middle

# y grid range for samples should be 400 to 3600
range(xy$grid_y)

# Location of Cape Hatteras in grid coords
round((900 - min(xy$dist))/diff(range(xy$dist))*3200+400) # 1837

# write out
write.csv(xy[order(grid_y), .(PinskyID, grid_x, grid_y)], file = here('output', 'pade_gridlocations.csv'), row.names = FALSE)
