args <- commandArgs(trailingOnly=TRUE)

tracts <- read.table(args[2], col.names = c("start","end","indiv","ancestry"))
tracts$length <- tracts$end - tracts$start
numtracts <- mean(table(tracts$indiv))
length_minor_tracts <- median(aggregate(length ~ indiv, subset(tracts, ancestry == 2), FUN = median)$length)
#length_minor_tracts <- median(aggregate(length ~ indiv, subset(tracts, ancestry == 0), FUN = median)$length)
tracts$weightlen <- (tracts$length * tracts$ancestry/31064592)/2
avganc <- mean(aggregate(weightlen ~ indiv, data = tracts, FUN = sum)$weightlen)
varanc <- var(aggregate(weightlen ~ indiv, data = tracts, FUN = sum)$weightlen)

cat(paste(args[1], numtracts, length_minor_tracts,1-avganc,varanc,"\n"))
