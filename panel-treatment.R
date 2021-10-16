
library(devtools)
install("../ralget")

rm(list = ls())
library(tidyverse)
library(ggdag)
library(tidygraph)
library(dagitty)
library(ggraph)
library(patchwork)
library(magrittr)
library(ralget)
library(topics)
library(ggforce)
library(raldag)
library(boot)

logit <- function(...)
t <- v("t", .f = d(~ as.numeric(rbernoulli(n = 100, p = inv.logit(rsum(...))))))
x <- v("x", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  1)))
y <- v("y", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  1)))

g <-
 (t * b(1) + x * b(1)) * y +
 (x * b(1000)) * t

g %>% simulate()
g %>% plot()

t1 <- v("t1", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  0)))
t2 <- v("t2", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  0)))
t3 <- v("t3", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  0)))
t4 <- v("t4", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  0)))
t5 <- v("t5", .f = d(~ rnorm(n = 10^2, mean = rsum(.x), sd =  0)))


t1 * b(1) * t2 * b(2) * t3

t <- 
(t1 * b(1) * t2) +
(t2 * b(1) * t3) +
(t3 * b(1) * t4) +
(t4 * b(1) * t5) 

t %>% plot()

xt <- cartesian_product(g,t,node_combine =  ~ c(.x), edge_combine =  ~ c(.x,.y))

xt %>% plot()

xt %>% simulate()


xt %>% 
    manipulate(t_t1 = 0 ) %>%
    manipulate(t_t2 = 1 ) %>%
    simulate() %>% 
    gather(var, value, -sim_id) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    ggplot(aes(x = period, y= value, group = sim_id)) + 
    geom_line(alpha = .55) + 
    facet_wrap(~var, scale = "free")



  treated <- xt %>%  manipulate(t_t1 = 0 ) %>% manipulate(t_t2 = 1 ) %>% simulate("treated",1)
untreated <- xt %>%  manipulate(t_t1 = 0 ) %>% manipulate(t_t2 = 0 ) %>% simulate("untreated",1)

bind_rows(treated,untreated) %>%
    gather(var, value, -sim_id, -label) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    mutate(value = as.numeric(value)) %>%
    ggplot(aes(x = period, y= value, group = label, color = label)) + 
    # geom_point(alpha = .55) + 
    facet_wrap(~var, scale = "free") + 
    geom_smooth(alpha = .01) +
    theme_bw()



t1 <- 
(t1 * b(1) * t2) +
(t2 * b(1) * t3) +
(t3 * b(1) * t4) +
(t4 * b(1) * t5)


t0 <- 
(t1 * b(1) * t2) +
(t2 * b(1) * t3) +
(t3 * b(1) * t4) +
(t4 * b(1) * t5) +
(t5 * b(1) * t1) 


plot(t1)
