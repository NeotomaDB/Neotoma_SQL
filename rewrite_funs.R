library(stringr)
library(dplyr)

setwd('~/Documents/GitHub/Neotoma_SQL')

ti_done <- data.frame(names = list.files('function/ti', recursive = TRUE)) %>%
  mutate(names = substr(names, 1, str_length(names) - 4))

ti_fun <- readr::read_file('./legacy/export-ti-procedures.sql')

# Get the capture group:
no_param_function_name <- data.frame(names = stringr::str_match_all(ti_fun, "PROCEDURE \\[(.*)?\\]\\r\\n")[[1]][,2])

incompl_fun <- no_param_function_name %>%
  mutate(names = tolower(names)) %>%
  dplyr::filter(!names %in% ti_done$names)

funregex <- "(?s)CREATE PROCEDURE (\\[([a-zA-Z]*?)\\]\\r\\n)(.*?)GO"

aa <- stringr::str_match_all(ti_fun, funregex)[[1]][,3:4] %>% as.data.frame

colnames(aa) <- c('fun', 'call')

aa <- aa %>%
  mutate(fun = tolower(fun)) %>%
  dplyr::filter(fun %in% incompl_fun$names) %>%
  mutate(call = stringr::str_replace_all(call, '[(\r\n)]+', '\n')) %>%
  mutate(lc_call = sub("(?s)AS(:?.*)?SELECT(.*)?FROM\\s+(.*)(\n)", replacement = "AS $function$\nSELECT \\L\\2\\E FROM \\L\\3\\E", call, perl =TRUE)) %>%
  mutate(new_call = paste0("CREATE OR REPLACE FUNCTION ti.",
                            fun, "()\nRETURNS xxxxx\nLANGUAGE SQL\n", lc_call, ";\n$function$"))

for (i in 1:nrow(aa)) { readr::write_file(aa$new_call[i], path = paste0('./function/from_R/', aa$fun[i], '.sql')) }
