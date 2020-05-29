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

#############################################################
###statsDataID=0002060002:就業状態，年齢階級別15歳以上人口###
#############################################################

ResultData <- estat_getStatsList(appId = AppID, searchWord = "労働力")
#confirm
head(ResultData)

MetaInfo <- estat_getMetaInfo(appId = AppID, statsDataId = "0002060002")
#confirm
MetaInfo
GetStatData <- estat_getStatsData(appId = AppID,
                                  statsDataId = "0002060002",
                                  cat01 = "000",
                                  limit = 9999999)
head(GetStatData)

#####年齢は5歳階級のみを抽出#####
d <- filter(GetStatData, cat04_code %in% c("00", "27", "02", "05","07","08","10","11","13","14","16","17","19","28","30","31","32"))
#####完全失業者のみを抽出#####
d2 <- filter(d, cat03_code=="08")
#####データ整形，リネームを行う#####
df <- d2 %>% select("産業","性別", "就業状態", "年齢階級", "time_code","value", "unit") %>% rename(industry="産業",gender="性別", condition="就業状態", age="年齢階級")
head(df)
year <- str_sub(df$time_code, start=1, end=4)
#head(year)
month <- str_sub(df$time_code, start=9, end=10)
#head(month)
ym <- paste(year, month, sep="-")
#ym
df <- mutate(df, time_code = ym)
head(df)
write.csv(df, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)


###########################################################################
###statsDataID=0002060004:年齢階級別労働力人口比率，就業率及び完全失業率###
###########################################################################
ResultData2 <- estat_getStatsList(appId = AppID, searchWord = "失業率")
#confirm
head(ResultData2)

MetaInfo <- estat_getMetaInfo(appId = AppID, statsDataId = "0002060004")
#confirm
MetaInfo

GetStatData2 <- estat_getStatsData(appId = AppID,
                                   statsDataId = "0002060004",
                                   cat01 = "000",
                                   limit = 9999999)
head(GetStatData2)

#####データ整形#####
#####年齢は5歳階級のみを抽出#####
d3 <- filter(GetStatData2, cat04_code %in% c("00", "27", "02", "05","07","08","10","11","13","14","16","17","19","28","30","31","32"))
#####完全失業者のみを抽出#####
d4 <- filter(d3, cat03_code=="08")
#####データ整形，リネームを行う#####
df2 <- d4 %>% select("産業","性別", "就業状態", "年齢階級", "time_code","value", "unit") %>% rename(industry="産業",gender="性別", condition="就業状態", age="年齢階級")
year <- str_sub(df2$time_code, start=1, end=4)
#head(year)
month <- str_sub(df2$time_code, start=9, end=10)
#head(month)
ym <- paste(year, month, sep="-")
#ym
df2 <- mutate(df2, time_code = ym)
head(df2)
write.csv(df2, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)

#####データの結合を行う#####
dat <- inner_join(df , df2 ,by=c("gender", "age", "time_code")) %>% select("industry.x","gender", "condition.x", "age", "time_code", "value.x","value.y") %>% rename(industry="industry.x", condition="condition.x", volume="value.x", ratio="value.y")
head(dat)
dat2 <- mutate(dat, volume = volume*10000)
#head(dat2)
#####指数表記にさせない#####
options(scipen=10)
write.csv(dat2, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
