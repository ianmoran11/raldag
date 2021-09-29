
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
library(conflicted)
library(boot)

t <- v("t", .f = d(~ as.numeric(rbernoulli(n = 10, p = rbernoulli(n = 10, p = inv.logit(rsum(...)))))))
x <- v("x", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))
y <- v("y", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))

g <-
 (t * b(1) + x * b(1)) * y +
 (x * b(1)) * t

g %>% simulate()
g %>% plot()

t1 <- v("t1", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))
t2 <- v("t2", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))
t3 <- v("t3", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))
t4 <- v("t4", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))
t5 <- v("t5", .f = d(~ rnorm(n = 10, mean = rsum(.x), sd =  1)))

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
    simulate() %>% 
    gather(var, value, -sim_id) %>%
    separate( var, sep = "_",into = c("var","period")) %>%
    mutate(period = period %>% str_remove("t") %>% as.numeric()) %>%
    ggplot(aes(x = period, y= value, group = sim_id)) + geom_line(alpha = .05) + facet_wrap(~var)



