included <- read.csv("included_excluded_articles/included.csv") %>% select(Title, Authors, Published.Year)
excluded <- read.csv("included_excluded_articles/excluded.csv") %>% select(Title, Authors, Published.Year, Notes)
reason = excluded$Notes
reason_clean <- sub(";.*", "", sub(".*Exclusion reason: ", "", reason))

excluded_reason_clean <- excluded %>%
  mutate(
    reason_clean = sub(";.*", "", sub(".*Exclusion reason: ", "", Notes))
  ) %>%
  select(Title, Authors, Published.Year, reason_clean)

# write.xlsx(
#   excluded_reason_clean,
#   "included_excluded_articles/excluded_reason_clean.xlsx"
# )

# true_included = df_articles %>%
#   select(title, authors, year_publi)
#true_included$reason_clean=as.character("Included")

all_screening_full_text = bind_rows(included, excluded)

# all articles
records = read.xlsx("included_excluded_articles/records.xlsx")

# 
library(dplyr)
library(stringr)
library(stringi)

clean_txt <- function(x) {
  x %>%
    stri_trans_general("Latin-ASCII") %>%
    str_to_lower() %>%
    str_replace_all("[[:punct:]]+", " ") %>%
    str_squish()
}

records2 <- records %>%
  mutate(
    Title_clean = clean_txt(Title),
    Authors_clean = clean_txt(Authors),
    key = paste(Title_clean, Authors_clean, sep = " | ")
  )

fulltext2 <- all_screening_full_text %>%
  mutate(
    Title_clean = clean_txt(Title),
    Authors_clean = clean_txt(Authors),
    key = paste(Title_clean, Authors_clean, sep = " | ")
  )

records_identified <- records2 %>%
  mutate(in_full_text = key %in% fulltext2$key)

records_in_full_text <- records_identified %>%
  filter(in_full_text)

excluded_reason2 <- excluded_reason_clean %>%
  mutate(
    Title_clean = clean_txt(Title),
    Authors_clean = clean_txt(Authors),
    key = paste(Title_clean, Authors_clean, sep = " | ")
  ) %>%
  select(key, reason_clean)

records_in_full_text <- records_in_full_text %>%
  left_join(excluded_reason2, by = "key")

write.xlsx(
  records_in_full_text,
  "included_excluded_articles/records_in_full_text_with_exclusion_reason_raw.xlsx"
)
