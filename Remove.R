rm(shp1CC, shp2CC, shp3CC, shp4CC, shp5CC, shp6CC, shp7CC, shp8CC, shp9CC, shp10CC)
rm(list=ls(all=TRUE))


rm(shp1Tran, shp2Tran, shp3Tran, shp4Tran, shp5Tran, shp6Tran, shp7Tran, shp8Tran, shp9Tran, shp10Tran)
rm(list=ls(all=TRUE))


sum(shp8CC$TA11) + sum(shp9CC$TA11) + sum(shp10CC$TA11)

sum(shp1CC$TA11) + sum(shp2CC$TA11) + sum(shp3CC$TA11)

mean(shp1Tran)
mean(shp)

ug <- shp1Tran$TA11 - shp1Tran$TA01
ug <- data.frame(shp1Tran$block, ug)
View(ug)

shp1Tran$TA11 - shp1Tran$TA01

sum(shp2Tran$TA11 - shp2Tran$TA01)/sum(shp2Tran$TA01)

sum(shp4Tran$TA11 - shp4Tran$TA01)/sum(shp4Tran$TA01)


