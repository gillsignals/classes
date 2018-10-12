# Load the data
library(dslabs)
library(tidyverse)
data(polls_us_election_2016)

# Generate an object `polls` that contains data filtered for polls that ended on or after October 31, 2016 in the United States
polls <- polls_us_election_2016 %>% filter(enddate>="2016-10-31"& state=="U.S.")

# Create a new object called `pollster_results` that contains columns for pollster name, end date, X_hat, lower confidence interval, and upper confidence interval for each poll.
pollster_results <- polls %>%
  mutate(X_hat = rawpoll_clinton/100, se_hat = sqrt(X_hat*(1-X_hat)/samplesize), lower = X_hat - qnorm(.975)*se_hat, upper = X_hat + qnorm(.975)*se_hat) %>%
  select(pollster, enddate, X_hat, se_hat, lower, upper)

# Calculate the proportion of polls with correct Clinton X_hat in CI
avg_hit_clinton <- pollster_results %>% mutate(hit = lower <= .482 & upper >= .482) %>%
  summarize(mean=mean(hit))

# Determine the proportion of polls that correctly estimated the spread d_hat.
# Calculate the spread `d_hat` to `polls`. The new column should contain the difference in the proportion of voters for Clinton and Trump.
polls <- polls_us_election_2016 %>% filter(enddate >= "2016-10-31" & state == "U.S.") %>% mutate(d_hat = rawpoll_clinton/100 - rawpoll_trump/100)

# Calculate X_hat, se_hat, lower and upper CI bounds for d_hat for each poll.
# Create a new object called `pollster_results` that contains columns for pollster name, end date, d_hat, lower confidence interval, and upper confidence interval for each poll.
pollster_results <- polls %>%
  mutate(X_hat = (d_hat+1)/2, se_hat = 2*sqrt(X_hat*(1-X_hat)/samplesize), lower = d_hat - qnorm(.975)*se_hat, upper = d_hat + qnorm(.975)*se_hat) %>%
  select(pollster, enddate, d_hat, lower, upper)

#Calculate proportion of polls with correct spread d_hat in CI.
avg_hit_spread <- pollster_results %>% mutate(hit = lower<=.021 & upper>=.021) %>%
  summarize(mean=mean(hit))

#Calculate and plot the error of d_hat for each pollster with at least 5 polls.
polls %>% mutate(error = d_hat - .021) %>% 
  group_by(pollster) %>% 
  filter(n() >= 5) %>%
  ggplot(aes(x = pollster, y = error)) +
  geom_point() +
  theme(axis.text.x = element_text(angle=90,hjust=1))
