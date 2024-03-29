#Table edits and merges for concentric circles


#If new tables are created these file paths will need to be changed

tableImport("raster1", "cc01")
tableImport("raster2", "cc06")
tableImport("raster3", "cc11")


totalFileListCC <- list(fileList_cc01, fileList_cc06, fileList_cc11)

#Edits each table within the following list

k = 1
kList = c('01','06','11')

#Edits each table within the following list
for (shpLists in totalFileListCC){



  for(file in shpLists){
    
    yearInput = kList[k]
    tableEditCC(file, yearInput)

  }
  k = k +1
}

#List of strings which the tableMerge function uses to match fragstat tables
shpLists <- c("shp1", "shp2", "shp3", "shp4", "shp5", "shp6", "shp7",
              "shp8", "shp9", "shp10", "shp11", "shp12", "shp13", "shp14")


#This for loop goes through each list within the totalFileListCC and merges the matching shapefile tables

for (shp in shpLists){

  tableMerge(shp, 'totalFileListCC')

}


#Removes all of the singular fragstat tables

rm(shp1cc01, shp2cc01, shp3cc01, shp4cc01, shp5cc01, shp6cc01, shp7cc01, 
   shp8cc01, shp9cc01, shp10cc01, shp11cc01, shp12cc01, shp13cc01, shp14cc01)
rm(shp1cc06, shp2cc06, shp3cc06, shp4cc06, shp5cc06, shp6cc06, shp7cc06, 
   shp8cc06, shp9cc06, shp10cc06, shp11cc06, shp12cc06, shp13cc06, shp14cc06)
rm(shp1cc11, shp2cc11, shp3cc11, shp4cc11, shp5cc11, shp6cc11, shp7cc11, 
   shp8cc11, shp9cc11, shp10cc11, shp11cc11, shp12cc11, shp13cc11, shp14cc11)






