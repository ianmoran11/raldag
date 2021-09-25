test_that("Butterfly dag", {

library(tidyverse)
library(tidygraph)
library(ggraph)
library(magrittr)
library(ralget)
library(raldag)
library("conflicted")
options(dplyr.print_max = 3,dplyr.print_min = 3)
conflict_prefer("do", "raldag")
conflict_prefer("filter", "dplyr")
conflict_prefer("simulate", "raldag")

c <- v("c", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 10, sd =  4)))
a <- v("a", .f = d(~ rnorm(n = 10^4, mean = rsum(.x)     , sd =  1)))
x <- v("x", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 30, sd =  4)))
y <- v("y", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) +  7, sd =  2)))
m <- v("m", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 40, sd =  2)))

g <-
 (a * b(9) + m * b(1)) * x +
 (c * b(2) + m * b(5)) * y +
 (a * b(3) + c * b(5)) * m

obs <- g %>% simulate(label = "Observational")
do0 <- g %>% raldag::do(a = 0) %>% simulate(label = "do(a = 0)",seed = 1)
do1 <- g %>% raldag::do(a = 1) %>% simulate(label = "do(a = 1)",seed = 1)

check_manipulation <- 
bind_rows(do0,do1) %>%
  gather(var,value, -sim_id,-label) %>%
  spread(label,value) %>%
  mutate(diff =  `do(a = 1)` - `do(a = 0)`) %>%
  filter(var == "a") %>%
  pull(diff) %>% `==`(1) %>% all()

check_effect <- 
bind_rows(do0,do1) %>%
  gather(var,value, -sim_id,-label) %>%
  spread(label,value) %>%
  mutate(diff =  `do(a = 1)` - `do(a = 0)`) %>%
  filter(var == "x") %>%
  pull(diff) %>% round() %>% `==`(9) %>% all()

expect_true(check_effect)
expect_true(check_manipulation)
})
