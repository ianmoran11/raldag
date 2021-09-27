library(devtools)
install("../ralget")
covr::report()
document()
#build()
install()

usethis::use_test("plots")

rm(list = ls())
library(tidyverse)
library(tidygraph)
library(ggraph)
library(patchwork)
library(magrittr)
library(ralget)
library(ggforce)
library(raldag)
library("conflicted")
options(dplyr.print_max = 3,dplyr.print_min = 3)
conflict_prefer("do", "raldag")
conflict_prefer("filter", "dplyr")
conflict_prefer("simulate", "raldag")
conflict_prefer("%x%", "ralget")

c <- v("c", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 10, sd =  4)))
a <- v("a", .f = d(~ rnorm(n = 10^4, mean = rsum(.x)     , sd =  1)))
x <- v("x", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 30, sd =  4)))
y <- v("y", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) +  7, sd =  2)))
m <- v("m", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 40, sd =  2)))


t1 <- v("t1", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t2 <- v("t2", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t3 <- v("t3", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t4 <- v("t4", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))
t5 <- v("t5", .f = d(~ rnorm(n = 10^4, mean = rsum(.x), sd =  1)))

t <- 
(t1 * b(1) * t2) +
(t2 * b(1) * t3) +
(t3 * b(1) * t4) +
(t4 * b(1) * t5) 

g <-
 (a * b(9) + m * b(1)) * x +
 (c * b(2) + m * b(5)) * y +
 (a * b(3) + c * b(5)) * m

xt <- g %x% t

xtc <- 
xt %>% 
    select(-.attrs.y) %>% 
    activate("edges") %>% 
    mutate(.attrs = map2(.attrs,.attrs.y, ~ c(.x,.y))) %>%
    select(-.attrs.y) %>%
    activate("nodes")  %>%
    get_edge_names() %>%
    activate("nodes")  %>%
    filter(!is.na(x_src))
plot(xtc)
xtc %>% evaluate_prepare() %>% pull(.attrs)
xtc %>% simulate()


xtc %>% as_tibble() %>% print(n = Inf)

plot(xt)
activate(xt, "nodes") %>% as_tibble() %>% print(n =Inf)
activate(xt, "edges") %>% as_tibble() %>% print(n =Inf)



g %>% evaluate_prepare() %>% evaluate_execute()


g %>% evaluate_prepare() %>% evaluate_execute()



h <-
 (m * b(2) + x * b(1)) * y 



h %>% evaluate_prepare() %>% evaluate_execute()




q <- (m * b(2) + x * b(1)) * y  +  ( y * b(2)*c)

q %>% evaluate_prepare() %>% filter(row_number() == 1) %>% evaluate_execute()
q %>% evaluate_prepare() %>% filter(row_number() <= 2) %>% evaluate_execute()
q %>% evaluate_prepare() %>% filter(row_number() <= 3) %>% evaluate_execute()






c <- (a * b(9) + m * b(1)) * x +
 (c * b(2) + m * b(5)) * y +
 (a * b(3) + c * b(5)) * m
