# load packages
library(Rmisc)
library(tidyverse)


#################################
##### LOAD AND PROCESS DATA #####
#################################

# load data
index <- read.csv(file="~/Box/Schumer_lab_resources/Project_files/Xcortezi_Xbirchmanni_hybridization/Data/matched_hybrid_index_STAC_mothers_embryos_combined_August2020.txt",sep="\t",head=TRUE)
pop_index <- read.csv(file="~/Box/Schumer_lab_resources/Project_files/Xcortezi_Xbirchmanni_hybridization/Data/hybrid_index_STAC_cluster_specific_priors_June2020",sep="\t",head=TRUE)

# add individual maternal-offspring difference & labels for different ancestry groups
index <- index %>%
  mutate(diff = hybrid_index_mother - hybrid_index_embryo) %>%
  mutate(ancestry_group = ifelse(hybrid_index_mother > 0.5,"cortezi","birchmanni"))


##### DATASET TO RUN SIMULATIONS #####

# subset dataset to keep only one mother-offspring pair per individual
index_subset <- index %>%
  group_by(mother_id) %>%
  sample_n(size=1)


# observed maternal-offspring difference in ancestry_group overall
observed_maternal_offspring <- mean(abs(index_subset$hybrid_index_embryo-index_subset$hybrid_index_mother))
observed_maternal_offspring_CI <- CI(abs(index_subset$hybrid_index_embryo-index_subset$hybrid_index_mother),ci=0.95)





##########################################
##### ASSORTATIVE MATING SIMULATIONS #####
##########################################


##### PARAMETERS #####

###CLUSTER THRESHOLD = maximum difference in ancestry within a cluster

# using a random normal distribution to estimate this based on mean and sd of the observed data
threshold_birchmanni <- pop_index %>%
  filter(hybrid_index<0.5) %>%
  summarize(mean = mean(hybrid_index), sd = sd(hybrid_index))

threshold_cortezi <- pop_index %>%
  filter(hybrid_index>0.5) %>%
  summarize(mean = mean(hybrid_index), sd = sd(hybrid_index))

rnorm_cortezi <- rnorm(10000,mean=threshold_cortezi$mean,sd=threshold_cortezi$sd)
rnorm_birchmanni <- rnorm(10000,mean=threshold_birchmanni$mean,sd=threshold_birchmanni$sd)

diff_cortezi <- ifelse(max(rnorm_cortezi)>1,1,max(rnorm_cortezi)) - min(rnorm_cortezi)
diff_birchmanni <- max(rnorm_birchmanni) - ifelse(min(rnorm_birchmanni)<0,0,min(rnorm_birchmanni))

cluster_threshold <- round(max(diff_cortezi,diff_birchmanni),4)


###ANCESTRY SD = variance in ancestry between siblings

# calculating from (full) observed data
ancestry_sd <- index %>%
  group_by(mother_id) %>%
  summarize(offspring_ancestry_sd = sd(hybrid_index_embryo))

ancestry_sd <- round(mean(na.omit(ancestry_sd$offspring_ancestry_sd)),4)


###ADDITIONAL PARAMETERS
number_of_simulations <- 500
sample_size <- 46 #number of mother-offspring pairs to simulate



##### SIMULATIONS #####

# vary assortative mating value over the interval of 0 to 1
mating_prop = seq(0,1,by=0.01)

# make output matrix for storing results
output <- matrix(NA,nrow=length(mating_prop),ncol=5)


# simulation: loops over the mating proportion interval with 500 simulated matings for each value
for (P in 1:length(mating_prop)) {
  mean <- {}

  for (j in 1:number_of_simulations){
    mates<-c(pop_index$hybrid_index)
    offspring_index<-{}
    maternal_index<-{}
    for (x in 1:length(index_subset$hybrid_index_mother)){
      maternal<-index_subset$hybrid_index_mother[x]
      mate<-sample(mates,1)
      hold=0
      while(hold==0){
        if(abs(maternal-mate)<cluster_threshold){
          hold=1
        }
        if(abs(maternal-mate)>cluster_threshold){
          pref=rbinom(1,1,1-mating_prop[P])
          if(pref == 1){
            hold=1
          } else{
            mate<-sample(mates,1)
          }
        }

      }

      off<-rnorm(1,mean=(maternal+mate)/2,sd=ancestry_sd)
      if(off<0){off=0}#don't allow hybrid index <1
      if(off>1){off=1}#don't allow hybrid index >1
      offspring_index<-c(offspring_index,off)
      maternal_index<-c(maternal_index,maternal)

    }
    new<-cbind(offspring_index,maternal_index)
    new<-new[sample(nrow(new),sample_size),]
    mean<-c(mean,mean(abs(new[,1]-new[,2])))

  }

  mean_assort <- mean
  mean_assort_CI <- CI(mean_assort,ci=0.95)

  ### summarize output
  # mating prop value in simulation
  output[P,1] <- mating_prop[P]

  # confidence intervals for difference between mother and offspring value
  output[P,2] <- mean_assort_CI[1] #lower 95%
  output[P,3] <- mean_assort_CI[2] #mean
  output[P,4] <- mean_assort_CI[3] #upper 95%

  # proportion of simulations with stronger assortative mating than observed data
  output[P,5] <- length(subset(mean_assort,mean_assort<observed_maternal_offspring))/length(mean_assort)

}

output <- as.data.frame(output) %>%
  rename(
    assort_mating_value = V1,
    sim_lowerCI = V2,
    sim_mean = V3,
    sim_upperCI = V4,
    prop_stronger_sims = V5
  )




##### PLOT RESULTS #####

output <- output %>%
  mutate(sim_diff = sim_mean - observed_maternal_offspring_CI[2])

ggplot() +
  geom_hline(aes(yintercept=0),color="dark gray",size=1) +
  geom_smooth(data=output,aes(x=assort_mating_value,y=sim_diff)) +
  geom_point(data=output,aes(x=assort_mating_value,y=sim_diff),shape=21) +
  xlab("Simulated assortative mating value") +
  ylab("Simulated mean - Observed mean") +
  theme_bw() 
