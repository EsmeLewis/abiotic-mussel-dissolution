######## Trossulus dissolution analysis ########

### Load required packages
library(tidyverse)
library(sf)
library(purrr)
library(ggplot2)
library(car)
library(rcompanion)

### Load dataset
tross <- read.csv("/Users/rachelcarlson/Documents/Berkeley/Research/Postdoc-2022-present/Trossulus/FinalCode_June2025/analytical_dataset.csv")

### Plot all data
ggplot(tross, aes(OmegaAragonite, G, color = as.factor(treatment))) + geom_point() + 
  geom_smooth(data = subset(tross, treatment != "shell.californianus.painted" & treatment != "shell.trossulus.painted"), aes(OmegaAragonite, G, color = as.factor(treatment)), formula = y ~ log(x), se = FALSE) +
  scale_color_manual(values=c("#98BAD9","#59638F","#E8101f","#de9a1b")) +
  ylab("Calcification rate") +
  scale_x_continuous(breaks = seq(0, 8, len = 5)) +
  scale_y_continuous(breaks = seq(-0.375, 0, len = 6)) +
  theme_classic()
  
nrow(tross %>% filter(treatment == "shell.trossulus")) # 45 unpainted trossulus with standard deviation within 10
nrow(tross %>% filter(treatment == "shell.trossulus.painted")) # 28 painted trossulus with standard deviation within 10
nrow(tross %>% filter(treatment == "shell.californianus")) # 46 californianus (no standard deviation provided)
nrow(tross %>% filter(treatment == "shell.californianus.painted")) # 25 painted californianus with periostracum > 50%

### Bootstrapping: compare tross to californianus at omega < 1 
sub <- tross %>% filter((treatment == "shell.trossulus" & OmegaAragonite <1) & !is.na(G))
n = length(sub$G)
B = 10000
result = rep(NA, B)
for (i in 1:B) {
  boot.sample = sample(n, replace = TRUE)
  result[i] = mean(sub$G[boot.sample])
}
with(sub, mean(G) + c(-1, 1) * 2 * sd(result))
mean(sub$G)
nrow(sub)

### Bootstrapping: compare tross to californianus at all omega
sub <- tross %>% filter((treatment == "shell.californianus.painted") & !is.na(G))
n = length(sub$G)
B = 10000
result = rep(NA, B)
for (i in 1:B) {
  boot.sample = sample(n, replace = TRUE)
  result[i] = mean(sub$G[boot.sample])
}
with(sub, mean(G) + c(-1, 1) * 2 * sd(result))
mean(sub$G)
nrow(sub)

### Bootstrapping plots
boot <- read.csv("/Users/rachelcarlson/Documents/Berkeley/Research/Postdoc-2022-present/Trossulus/bootstrap_californianus_LOWOMEGA.csv")
boot$Group <- as.factor(boot$Group)
boot$X_axis[1:4] <- c("Californianus unsealed", "Trossulus unsealed", "Californianus sealed", "Trossulus sealed")
ggplot(boot[1:4,], aes(x = Group, y = Y_axis, fill = X_axis)) +
  geom_bar(position = position_dodge(), stat = "identity",
           colour = "black",
           size = 0.3) +
  geom_errorbar(aes(ymin = Y_axis-sd, ymax = Y_axis+sd), width =0.3, position = position_dodge(.9)) +
  ylim(0,0.35) +
  theme_classic() +
  scale_fill_manual(values=c("#59638F","#98BAD9","#de9a1b","#E8101f")) +
  labs(fill = "Treatment group", title = "Dissolution at omega < 1", y = "Dissolution rate")

boot <- read.csv("/Users/rachelcarlson/Documents/Berkeley/Research/Postdoc-2022-present/Trossulus/bootstrap_californianus.csv")
boot$Group <- as.factor(boot$Group)
boot$X_axis[1:4] <- c("Californianus unsealed", "Trossulus unsealed", "Californianus sealed", "Trossulus sealed")
ggplot(boot[1:4,], aes(x = Group, y = Y_axis, fill = X_axis)) +
  geom_bar(position = position_dodge(), stat = "identity",
           colour = "black",
           size = 0.3) +
  geom_errorbar(aes(ymin = Y_axis-sd, ymax = Y_axis+sd), width =0.3, position = position_dodge(.9)) +
  ylim(0,0.35) +
  theme_classic() +
  scale_fill_manual(values=c("#59638F","#98BAD9","#de9a1b","#E8101f")) +
  labs(fill = "Treatment group", title = "Dissolution across full omega range", y = "Dissolution rate")

tross$D <- -tross$G
tross$treatment2 <- ifelse(tross$treatment == "shell.californianus" | tross$treatment == "shell.trossulus", "unpainted", "painted")
tross$species <- ifelse(tross$treatment == "shell.californianus" | tross$treatment == "shell.californianus.painted", "californianus", "trossulus")

#linear regression on values where omega < 1, log transforming D given high skew
trossSub <- tross %>% filter(OmegaAragonite < 1) 
table(trossSub$species, trossSub$treatment2)

mod <- lm(log(D) ~ (species * treatment2) + OmegaAragonite, data = trossSub)
summary(mod)

influencePlot(mod) # identify high leverage points
trossSub2 <- trossSub[-c(27, 63, 71), ]
mod <- lm(log(D) ~ (species * treatment2) + OmegaAragonite, data = trossSub2)
summary(mod) #removing high-leverage points does not change significance and has low impact on coefficients

plot(mod) # All diagnostics for linear regression are met and removing influential points does not change model conclusions
hist(residuals(mod))

# Plot fitted v. actual values
fitted_vals <- fitted(mod) # Get fitted values
actual_vals <- model.response(model.frame(mod))  # log(D) values used in model

plot(fitted_vals, actual_vals, # Plot
     xlab = "Fitted Values",
     ylab = "Actual log(D)",
     main = "Fitted vs. Actual log(D)")
abline(a = 0, b = 1, col = "red", lty = 2)  # Line of perfect fit



##############################################

# Tabulate group means
aggregate(x= tross2$G,
          # Specify group indicator
          by = list(tross2$treatment),      
          # Specify function (i.e. mean)
          FUN = sd)
