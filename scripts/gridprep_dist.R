library(here)
library(data.table)

meta <- fread(here("data", "pade_metadata.txt"))

xy <- meta[, .(PinskyID, lon, lat, dist)] # dist = great circle distance from a southern point (km)
max(xy$dist)

# Aim for grid with 1 million points, 10% buffer on all edges
# Maybe 250 x 4000?
xy$grid_y <- (xy$dist - min(xy$dist))/diff(range(xy$dist))*3200+400

# x grid range for samples should be 25 to 225
# y grid range for samples should be 400 to 3600
range(xy$grid_y)

