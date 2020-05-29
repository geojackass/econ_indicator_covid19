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
#カテゴリマスターは予め抽出しておく
write.csv(MetaInfo$cat01, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
write.csv(MetaInfo$cat02, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
write.csv(MetaInfo$cat03, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
write.csv(MetaInfo$cat04, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)

GetStatData <- estat_getStatsData(appId = AppID,
                                  statsDataId = "0002060002",
                                  cat01 = "000",
                                  limit = 9999999)
GetStatData
head(GetStatData)

#####データ整形#####
df2 <- GetStatData %>% select("産業","性別", "就業状態", "年齢階級", "time_code","value", "unit") %>% rename(industry="産業",gender="性別", condition="就業状態", age="年齢階級")
year <- str_sub(df2$time_code, start=1, end=4)
#head(year)
month <- str_sub(df2$time_code, start=9, end=10)
#head(month)
ym <- paste(year, month, sep="-")
#ym
df2 <- mutate(df2, time_code = ym)
head(df2)
write.csv(df2, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)


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
GetStatData2
head(GetStatData2)

#####データ整形#####
df2 <- GetStatData2 %>% select("産業","性別", "就業状態", "年齢階級", "time_code","value", "unit") %>% rename(industry="産業",gender="性別", condition="就業状態", age="年齢階級")
year <- str_sub(df2$time_code, start=1, end=4)
#head(year)
month <- str_sub(df2$time_code, start=9, end=10)
#head(month)
ym <- paste(year, month, sep="-")
#ym
df2 <- mutate(df2, time_code = ym)
head(df2)
write.csv(df2, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)


##############################
#########講義・練習用#########
##############################
#データの簡素化のために，いらないカラムの削除を行う．(Areaは全国で都道府県区分なし)，その他はカテゴリマスタとDB上で結合演算
df <- GetStatData %>% select("cat01_code","cat02_code", "cat03_code", "cat04_code","time_code","value", "unit")
head(df)
year <- str_sub(df$time_code, start=1, end=4)
#head(year)
month <- str_sub(df$time_code, start=9, end=10)
#head(month)
ym <- paste(year, month, sep="-")
#ym
df <- mutate(df, time_code = ym)
#head(df)
write.csv(df, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)


getwd()
df <- read.csv("[dir/to/path]", fileEncoding="UTF-8")
dat <- df %>% select("order", "age")
write.csv(dat, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
