##############initial setup################
getwd()
lib_pth <- getwd()
print(lib_pth)
#install.packages("tidyverse", lib=lib_pth)
#install.packages("pacman", lib=lib_pth)
#install.packages("stringr", lib=lib_pth)
#install.packages("magrittr", lib=lib_pth)
#install.packages("estatapi", lib=lib_pth)
############################################
pacman::p_load(tidyverse, magrittr, stringr, estatapi)

AppID <- "SET YOUR ID"

####################################################################################################
###statsDataID=0003411656死因（死因年次推移分類）別にみた性・年次別死亡数及び死亡率（人口10万対）###
####################################################################################################

ResultData <- estat_getStatsList(appId = AppID, searchWord = "死因")
#confirm
head(ResultData)

MetaInfo <- estat_getMetaInfo(appId = AppID, statsDataId = "0003411656")
#confirm
MetaInfo

MetaInfo$cat01
MetaInfo$cat02
#カテゴリマスターは予め抽出しておく
write.csv(MetaInfo$cat01, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)

#死因が自殺の物を抽出する
GetStatData <- estat_getStatsData(appId = AppID,
                                  statsDataId = "0003411656",
                                  limit = 9999999)
head(GetStatData)
GetStatData

#####死因が自殺のみ抽出#####
d <- filter(GetStatData, cat01_code=="Hi16")
#####データ整形，リネームを行う#####
d2 <- d %>% select("死因年次推移分類","性別", "time_code","value", "unit") %>% rename(cause="死因年次推移分類",gender="性別")
#####死因の"Hi16_"を削除#####
cause2 <- str_split(d2$cause,pattern = "_")[[1]][2]
df <- mutate(d2, cause = cause2)
#####time_codeをYYYYに変換する#####
year <- str_sub(df$time_code, start=1, end=4)
#head(year)
df <- mutate(df, time_code = year)
head(df)
write.csv(df, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)

############################################################################
###自殺者数と人口10万人対比の分割を行い，genderとtime_codeをKEYにJOINする###
############################################################################

num <- filter(df, unit=="人")
ratio <- filter(df, unit!="人")
dat <- inner_join(num , ratio ,by=c("gender", "time_code")) %>% select("cause.x","gender", "time_code", "value.x","value.y") %>% rename(cause="cause.x", volume="value.x", ratio="value.y")
#dat
write.csv(dat, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
