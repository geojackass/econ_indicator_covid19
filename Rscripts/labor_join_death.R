#####################################################################
###結合後データを年単位で集計する(volume, ratioは年次平均を求める)###
#####################################################################
dat <- read_csv("data/csv/labor_survey_unemployed3.csv")

###option=simplifyで返却値は行列型を指定する
time <- str_split(dat$time_code,pattern = "-", simplify = TRUE)[,1]
#time
df <- mutate(dat, time_code = time)
###このgenderの条件を1=総数,2=男,3=女としてファイルネームを作成した．
df2 <- filter(df, age=="15歳以上" & gender=="女")
df2

df3 <- group_by(df2, time_code)
df3

df4 <- mutate(df3, volume = round(mean(volume)))
df4

df5 <- mutate(df4, ratio = round(mean(ratio), digits=3))
df5

join <- unique(df5)

write.csv(join, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)

dat1 <- read_csv("[dir/to/path]")
dat2 <- read_csv("[dir/to/path]")
dat3 <- read_csv("[dir/to/path]")

joined <- bind_rows(dat1, dat2, dat3)
write.csv(joined, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
