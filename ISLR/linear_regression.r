library(MASS) # collection of data sets
library(ISLR) # data sets used in ISLR
library(tidyverse)
library(tidymodels)



# Simple linear regression ------------------------------------------------

boston <- as_tibble(Boston)

# linear regression

linear<- lm(medv ~ lstat, data = boston)

# elements in the model

names(linear)

# coefficient 

coef(linear)

# confidence interval 

confint(linear)

# prediction interval 

linear %>% 
  predict(data.frame(lstat = c(5,10, 15)), interval = "confidence")



# least square regression line  

boston %>% 
  ggplot(aes(lstat, medv))+ 
  geom_point(colour = "red", size = 1) +
  geom_smooth(size =2, 
              colour = "red",
              method = "lm", 
              se = FALSE) 

# R base ------------------------------------------------------------------

# equivalent in R base 

plot(data = boston, lstat, medv, col = "red", pch = 20)
abline(linear, col = "red", lwd = 5)

# Diagnosing a Linear Regression in R

par(mfrow = c(2,2))
plot(linear)
dev.off()



# Multiple Linear Regression -----------------------------------------------------

multiple_linear <- lm(medv ~ ., data = boston)

summary(multiple_linear)$coefficients
