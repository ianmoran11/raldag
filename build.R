library(devtools)
install("../ralget")
covr::report()
document()
build()

#build()
install()

usethis::use_test("plots")

test()
check()

rm(list = ls())
library(tidyverse)
library(ggdag)
library(tidygraph)
library(dagitty)
library(ggraph)
library(patchwork)
library(magrittr)
library(ralget)
library(ggforce)
library(raldag)
options(dplyr.print_max = 3,dplyr.print_min = 3)

c <- v("c", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 10, sd =  4)))
a <- v("a", .f = d(~ rnorm(n = 10^4, mean = rsum(.x)     , sd =  1)))
x <- v("x", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 30, sd =  4)))
y <- v("y", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) +  7, sd =  2)))
m <- v("m", .f = d(~ rnorm(n = 10^4, mean = rsum(.x) + 40, sd =  2)))

g <-
 (a * b(9) + m * b(1)) * x +
 (c * b(2) + m * b(5)) * y +
 (a * b(3) + c * b(5)) * m

g %>% simulate()
g %>% plot()

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

t %>% plot()

xt <- cartesian_product(g,t,node_combine =  ~ c(.x), edge_combine =  ~ c(.x,.y))

xt %>% plot()

xt %>% simulate()