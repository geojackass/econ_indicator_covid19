##############initial setup################
getwd()
lib_pth <- getwd()
print(lib_pth)
#install.packages("tidyverse", lib=lib_pth)
#install.packages("pacman", lib=lib_pth)
#install.packages("stringr", lib=lib_pth)
#install.packages("magrittr", lib=lib_pth)
#install.packages("dplyr", lib=lib_pth)
#install.packages("estatapi", lib=lib_pth)
############################################
pacman::p_load(tidyverse, magrittr, stringr, dplyr)

###############################################################
###statsDataID=0003100934:住宅・土地統計調査###表89-1##########
###############################################################
df <- read_csv("[dir/to/path]")
#df

####################################################################
###住宅・土地統計調査から，各市区町村の年収を抽出する###############
###住宅所有の関係・世帯収入は関係なく各市区町村の平均年収を算出する#
###平均値=SUM(階級値*度数)/SUM(度数)################################
####################################################################
#階級別にするため，年収階級の総数を除く
dat <- filter(df, cat03_code != "00000") %>% select("cat03_code","世帯の年間収入階級_2013","area_code","H25地域","value") 
dat
#度数分布表からの平均値を算出する
#階級値(年収)1500万円以上に関しては，2000万として算出する
sr <- read_csv("[dir/to/path]")
#sr
#階級値(salary_rank)*度数(value)をsalaray_volumeカラムとして追加する
dat2 <- left_join(dat, sr, by="cat03_code") %>% mutate(salary_volume= value * salary_rank)
dat2

#階級値(salary_rank)*度数(value)をsalaray_volumeのarea_code(市区町村)ごとの総和を算出する
#area_codeは重複するので，summarizeの際のキーはarea_codeとH25地域(市区町村名)を両方用いる
sum.saraly_volume <- group_by(dat2, area_code, H25地域) %>% summarize(sum_rank_value=sum(salary_volume,na.rm = TRUE))
sum.saraly_volume

#度数(value)のarea_code(市区町村)ごとの総和を算出する
#area_codeは重複するので，summarizeの際のキーはarea_codeとH25地域(市区町村名)を両方用いる
sum.value <- group_by(dat2, area_code, H25地域) %>% summarize(sum_value=sum(value,na.rm = TRUE))
sum.value

dat3 <- left_join(sum.saraly_volume, sum.value, by=c("area_code", "H25地域"))
dat3

###平均賃金の算出
d <- mutate(dat3, avg_salary= sum_rank_value / sum_value)
d

###area_code,H25地域名のマスターを作成する
area <- select(df, "area_code","H25地域")
area

###area_codeと平均賃金を結合する
salary <- inner_join(d, area, by=c("area_code", "H25地域")) %>% distinct(area_code,.keep_all=TRUE)
salary
write_csv(salary, "[dir/to/path]")
