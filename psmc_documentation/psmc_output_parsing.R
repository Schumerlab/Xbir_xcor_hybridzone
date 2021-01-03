library(tidyverse)
library(cowplot)
library(scales)

cor_out <- read_delim(file = "cor_5587-MS-0004_mapped_bir_combined.0.txt", 
                       col_names = c("YBP", "Ne_e4", "I", "Dont", "Know"), delim = "\t") %>%
  mutate(Species = "cortezi", Population = "Las Conchas", indiv = "cor_5587-MS-0004")

### BOOTSTRAP INPUT ###

boot_samps <- lapply(1:100, FUN=function(num) {
  out <- read_delim(file = paste("cor_5587-MS-0004_mapped_bir_combined.",num,".txt", sep = ""), 
                    col_names = c("YBP", "Ne_e4", "I", "Dont", "Know"), delim = "\t") %>%
    mutate(Species = "cortezi", Population = "Las Conchas", indiv = "cor_5587-MS-0004", rep = as.character(num))
  out
}) %>%
  bind_rows()
write_csv(boot_samps, "cor_5587-MS-0004_PSMC_bootstraps.csv")

#### SECOND ROUND (MULTIPLE REPLICATES) Data aggregation #####

HUIC_indivs <- c("HUICXI17JM06wt", "HUICXI17M01wt", "HUICXI17M03sc", "HUICXI17M04wt", "HUICXI17M05sc")
HUIC_samps <- lapply(HUIC_indivs, FUN = function(name) {
  out <- read_delim(file = paste(name,"_pseudoref_birchmanni.0.txt", sep = ""), 
                    col_names = c("YBP", "Ne_e4", "I", "Dont", "Know"), delim = "\t") %>%
    mutate(Species = "cortezi", Population = "Huichihuayán", indiv = name)
  out
}) %>%
  bind_rows()
bir_indivs <- c("Xbirchmanni_COAC1F", "Xbirchmanni_COAC10F", "Xbirchmanni_COAC11F", "Xbirchmanni_COAC12F", "Xbirchmanni_COAC15F",
                "Xbirchmanni_COAC16F", "Xbirchmanni_COAC17F", "Xbirchmanni_COAC19F", "Xbirchmanni_COAC2010M01",
                "Xbirchmanni_COAC2010M02", "Xbirchmanni_COAC7F", "Xbirchmanni_COAC_father", "Xbirchmanni_COAC_mother")
bir_samps <- lapply(bir_indivs, FUN = function(name) {
   out <- read_delim(file = paste(name,"_pseudoref_birchmanni.0.txt", sep = ""), 
                        col_names = c("YBP", "Ne_e4", "I", "Dont", "Know"), delim = "\t") %>%
    mutate(Species = "birchmanni", Population = "Coacuilco", indiv = name)
   out
}) %>%
  bind_rows()
psmc_samps <- rbind(HUIC_samps, cor_out, bir_samps)
write_csv(psmc_samps, "HUIC_COAC_PSMC_results.csv", col_names = T)


### Calculating long-term Ne
psmc_intervals <- read.csv(file = "HUIC_COAC_PSMC_results.csv",header = T) %>%
  group_by(indiv, Population) %>%
  mutate(length = lead(YBP) - YBP) %>%
  drop_na()

harmeanic <- psmc_intervals %>%
  summarise(harmonic_mean = (sum(length * (Ne_e4)^-1)/sum(length))^-1)

trunc_intervals <- filter(psmc_intervals, YBP > 2000, YBP < 100000)

trunc_harmeanic <- trunc_intervals %>%
  summarise(harmonic_mean = (sum(length * (Ne_e4)^-1)/sum(length))^-1)

summarise(group_by(trunc_harmeanic, Population), mean = mean(harmonic_mean))
### For the Figure_Scripts.txt:
library(tidyverse)
library(cowplot)
library(scales)
psmc_colors <- c("Coacuilco" = rgb(58/255,107/255,198/255),"Huichihuayán" = rgb(204/255,173/255,33/255),"Las Conchas" = rgb(53/255,157/255,111/255))
psmc_samps <- read.csv(file = "HUIC_COAC_PSMC_results.csv", header = T)
boot_samps <- read.csv(file = "cor_5587-MS-0004_PSMC_bootstraps.csv", header = T)
conservative_psmc <- filter(psmc_samps, YBP > 2000, YBP < 100000)
conservative_boot <- filter(boot_samps, YBP > 2000, YBP < 100000)
final_psmc <- ggplot(conservative_psmc, aes(x = YBP, y = Ne_e4, group = indiv, color = Population)) +
  theme_cowplot() +
  theme(panel.border = element_rect(colour = "black"),
        axis.line = element_blank(),
        legend.position = c(0.1, 0.75),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 14)) +
  xlab("Years Before Present") +
  ylab(expression(paste("Effective Population Size (×",10^4,")"))) +
  annotation_logticks(sides = "b") +
  scale_x_log10(labels=trans_format('log10',math_format(10^.x)), breaks = c(10000, 100000)) +
  scale_color_manual(values = psmc_colors) +
  scale_y_continuous(breaks = seq(1,25), 
                     labels = c(rep("",4),"5",rep("",4),"10",rep("",4),"15",rep("",4),"20",rep("",4),"25")) +
  geom_step(data = conservative_boot, aes(group = rep), alpha = 0.2) +
  geom_step(size = 1.25)
final_psmc
ggsave("cor_bir_psmc_truncated_RGQ.pdf", plot = final_psmc,
       device = "pdf", units = "in", width = 5.59, height = 4.33)

ggplot(psmc_samps, aes(x = YBP, y = Ne_e4, group = indiv, color = Population)) +
  theme_cowplot() +
  theme(panel.border = element_rect(colour = "black"),
        axis.line = element_blank(),
        legend.position = c(0.1, 0.75)) +
  xlab("Years Before Present") +
  ylab(expression(paste("Effective Population Size (×",10^4,")"))) +
  annotation_logticks(sides = "b") +
  scale_x_log10(labels=trans_format('log10',math_format(10^.x))) +
  scale_color_manual(values = psmc_colors) +
  scale_y_continuous(breaks = seq(1,20), 
                     labels = c(rep("",4),"5",rep("",4),"10",rep("",4),"15",rep("",4),"20")) +
  geom_step(data = boot_samps, aes(group = rep), alpha = 0.25, color = psmc_colors["Las Conchas"]) +
  geom_step(size = 1.25)
  
