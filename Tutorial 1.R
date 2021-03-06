library(tidyverse)
library(ggplot2)
#data input
response <- read.table("response.txt", skip = 6, header = TRUE)
# sumarising
response %>% 
  group_by(genotype) %>% 
  summarise(m = mean(sens),
            sd = sd(sens),
            n = length(sens),
            se = sd/sqrt(n),
            median = median(sens))

# filter our rows
responseA2 <- response %>% 
  filter(genotype == "A2")

# select columns
response %>% 
  select(sens, genotype)
str(response)
ggplot(data = response,
       aes(x = GSH, y = sens, col = genotype)) +
  geom_point() +
  xlim(0, 7) +
  ylim(0, 40) +
  geom_smooth(method = "lm", se =FALSE, fullrange = TRUE)


mod <- lm(data = response, sens ~ GSH * genotype)
summary(mod)

anova(mod)

mod_2  <- update(mod, .~. -GSH:genotype)
#removing sensitivity as isnt significant

summary(mod_2)
res <- anova(mod_2)
res
res$Df[1]
res$Df[3]
#want the F-value, P-value and DoF
#mean sqr is just variance f=Ms/residual (background variance) ie 57/2.875
# p is prob of getting more than F with this degrees of freedom
#there is a significant effect of GSH on the treatment (F=19.8285, p=0.0001324)
# there is a significant effect of genotype on the treatment (F=7.1468,p=0.0032285)