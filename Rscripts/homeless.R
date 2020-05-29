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
pacman::p_load(tidyverse, magrittr, stringr, dplyr, readxl)

##############################################################
###homeless人数のデータ，クロス集計表を縦持ちのデータに変換###
##############################################################
###estatのファイルデータしかないので，APIはコールしなくてもよい###
df = read_xlsx("[dir/to/path]", sheet="homeless_volume")
#データを縦持ちに変換
df
df1 <- gather(df, key="gender", value="volume",男,女,不明,合計)
df1
###平成HH年度調査の文字列をYYYYに変更###
df2 <- mutate(df1, year=str_replace_all(year, pattern=c("24年調査"="2012","25年調査"="2013","26年調査"="2014","27年調査"="2015","28年調査"="2016","29年調査"="2017","30年調査"="2018")))
write.csv(df2, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)

##################################
###場所別ホームレス数(起居場所)###
##################################
dat = read_xlsx("[dir/to/path]", sheet="homeless_place")

###データを縦持ちに変換###
dat1 <- gather(dat, key="year", value="volume", `30年調査`,`29年調査`,`28年調査`, `27年調査`, `26年調査`, `25年調査`, `24年調査`)
###平成HH年度調査の文字列をYYYYに変更###
dat2 <- mutate(dat1, year=str_replace_all(year, pattern=c("24年調査"="2012","25年調査"="2013","26年調査"="2014","27年調査"="2015","28年調査"="2016","29年調査"="2017","30年調査"="2018")))
write.csv(dat2, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
dat2

##############################################
###都道府県別ホームレス数(28年，29年，30年)###
##############################################
d = read_xlsx("[dir/to/path]", sheet="area_year")
d
###平成HH年度調査の文字列をYYYYに変更###
d2 <- mutate(d, year=str_replace_all(year, pattern=c("28年調査"="2016","29年調査"="2017","30年調査"="2018")))
#d2$area
###都道府県名の文字列間の空白を削除###
d3 <- (gsub("[[:blank:]]","",d2$area))
d4 <- mutate(d2, area=d3)
d4
#
d5 <- gather(d4, key="gender", value="volume", man,women,unknown,subtotal)
d5
write.csv(d5, "[dir/to/path]", fileEncoding="UTF-8", row.names=FALSE)
