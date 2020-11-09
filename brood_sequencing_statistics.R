hybrid_index <- read.table('~/Box/Schumer_lab_resources/Project_files/Xcortezi_Xbirchmanni_hybridization/Data/hybrid_index_STAC_mother_embryo_August2020_corrected') %>%
  rownames_to_column(var = "indiv") %>%
  mutate(indiv = str_replace_all(lapply(indiv, function(x) str_split(x, '_')[[1]][1]),"-","."),
         mother = is.na(str_match(indiv, 'E')))

broods<-read.csv(file="~/Box/Schumer_lab_resources/Project_files/Xcortezi_Xbirchmanni_hybridization/Data/STAC_broods_simplified.csv",head=TRUE) %>%
  mutate(collecion.date = str_replace_all(collecion.date,'_','.'),
         indiv = ifelse(female > 10, paste("STAC.",collecion.date,".",female,"F.E",embryo, sep = ""),
                        paste("STAC.",collecion.date,".0",female,"F.E",embryo, sep = "")))

stage_v_index <- left_join(hybrid_index, broods) %>%
  filter(hybrid_index > 0.25)

left_join(hybrid_index, broods) %>%
  group_by(female) %>%
  summarise(n = n()) %>%
  summarise(mean = mean(n),
            sd = sd(n))
