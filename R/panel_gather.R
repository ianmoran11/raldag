#' Set value for variable in DAG
#'
#' @param df simulated panel df.
#' @export

panel_gather <- function(df){
    df %>% 
mutate(sim_id = row_number()) %>%
gather(Variable,Value, -sim_id, -label)  %>%
separate(Variable, c("Variable", "Period"), sep = "_") %>%
mutate(Period  = Period %>% str_remove("t") %>% as.numeric()) 

}