library(tidyverse)

broods<-read.csv(file="~/Box/Schumer_lab_resources/Project_files/Xcortezi_Xbirchmanni_hybridization/Data/STAC_broods_add_HI_cleaned.csv",head=TRUE) %>%
  drop_na()

embryo_stats <- group_by(broods, female) %>%
  summarise(n = n(),
            stage_avg = mean(stage),
            stage_var = var(stage),
            cv = sqrt(stage_var)/stage_avg,
            num_stages = length(unique(stage)),
            num_abnormal = sum(abnormal),
            hi = hybrid_index_mother[1],
            cluster = ifelse(hi > 0.7, "cortezi", ifelse(hi < 0.1, "birchmanni", NA)))

fert_stats <- filter(broods, stage > 3) %>%
  group_by(female) %>%
  summarise(n = n(),
            stage_avg = mean(stage),
            stage_var = var(stage),
            cv = sqrt(stage_var)/stage_avg,
            num_stages = length(unique(stage)),
            num_abnormal = sum(abnormal),
            hi = hybrid_index_mother[1],
            cluster = ifelse(hi > 0.7, "cortezi", ifelse(hi < 0.1, "birchmanni", NA)))

mean(fert_stats$n)
sd(fert_stats$n)

t.test(filter(embryo_stats, cluster == "birchmanni")$n, filter(embryo_stats, cluster == "cortezi")$n)
t.test(filter(fert_stats, cluster == "birchmanni")$n, filter(embryo_stats, cluster == "cortezi")$n)

t.test(filter(embryo_stats, cluster == "birchmanni")$num_stages, filter(embryo_stats, cluster == "cortezi")$num_stages)
t.test(filter(fert_stats, cluster == "birchmanni")$num_stages, filter(embryo_stats, cluster == "cortezi")$num_stages)

t.test(filter(embryo_stats, cluster == "birchmanni")$stage_var, filter(embryo_stats, cluster == "cortezi")$stage_var)
t.test(filter(fert_stats, cluster == "birchmanni")$stage_var, filter(embryo_stats, cluster == "cortezi")$stage_var)

t.test(filter(embryo_stats, cluster == "birchmanni")$cv, filter(embryo_stats, cluster == "cortezi")$cv)
t.test(filter(fert_stats, cluster == "birchmanni")$cv, filter(embryo_stats, cluster == "cortezi")$cv)

t.test(filter(embryo_stats, cluster == "birchmanni")$num_abnormal, filter(embryo_stats, cluster == "cortezi")$num_abnormal)
t.test(filter(fert_stats, cluster == "birchmanni")$num_abnormal, filter(embryo_stats, cluster == "cortezi")$num_abnormal)
