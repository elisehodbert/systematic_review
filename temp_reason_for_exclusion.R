excluded <- read.csv("excluded.csv")
reason = excluded$Notes
reason_clean <- sub(";.*", "", sub(".*Exclusion reason: ", "", reason))
writeClipboard(paste(reason_clean, collapse = "\n"))


irrelevant <- read.csv("irrelevant.csv")
