getwd()
lib_pth <- getwd()
print(lib_pth)
pacman::p_load(tidyverse, magrittr, stringr, dplyr)

df <- read_csv("[dir/to/path]")
df

dat <- filter(df, age=="15歳以上")
dat
time <- str_split(dat$time_code,pattern = "-", simplify = TRUE)[,1]
time
d4 <- mutate(dat, time_code=time)
d4

dat2 <- group_by(d4, time_code)
dat2

dat3 <- mutate(dat2, volume = cumsum(volume), ratio = mean(ratio))
dat4 <- filter(dat3, time_code >= 2012 && time_code <=2018) %>% slice(12, 24, 36, 48, 60)# %>% mutate(df1, year=str_replace_all(year,
#dat5 <- str_replace_all(dat4$gender, pattern="総数", replacement="合計")
write.csv(dat4, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
