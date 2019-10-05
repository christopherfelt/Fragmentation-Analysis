#Functions
#If edits are made to the function, the functions needs to run again in order for the edits to take effect.



#The tableImport function imports the table ouputs from fragstats.
#The function gives the each imported tables the names given to them by the spatialMetricTool
#The nameIndex document indicates which names are given to which shapefiles.
#Additional text can be added to name by adding it as the second argument (year).


tableImport <- function(filepath, year){
  
  #Variable used in the following blocks of code
  path = filepath
  
  #This makes a list of all the files for a given directory.  In this case, the file path assigned in the function
  filenames <-list.files(filepath)
  
  #This code block finds the names of the tables at given diretory and creates a list of strings based on those files
  #The strings in the list contain a file extenstion (.class) and it is replaced by the text extension declared in the function. In this case, the im year.
  result_names <- structure(
    .Data = gsub(
      pattern = ".class",
      replacement = year,
      x = filenames),
    .Names = filenames)
  
  #Empty list to be filled in the for loop
  tabImFileList <- list()
  #Variable to aid in adding things to the list above
  i = 1
  
  #This for loop generates the dataframes from the list of tables from the given directory
  for(.file in filenames) {
    
    #This list is filled with each altered file name from above
    tabImFileList[[i]] <- result_names[.file]
    
    i = i+1
    
    #This code block creates the dataframe
    assign(
      x = result_names[.file],
      value = read.table(
        file = file.path(path, .file),
        header = TRUE,
        sep = ','),
      envir = .GlobalEnv
    )
    
    
    
  }
  
  #The list containing the names of the created dataframe is assigned to a global variable
  assign(x = paste("fileList_",year,sep = ""), value = tabImFileList, envir = .GlobalEnv)
  
  
}


#The tableEditCC function cleans up the tables by renaming columns and adding a distance/partition number column.  
#The distance/partition number for concentric circles is cc and blocks for transects
#This function is limited in what metrics it cleans up.  Currently, it only fixes tables with "TA, NP, PD, MPS, COV, and FRAC".



tableEditCC <- function(df, year) {
  
  
  #The df is a string input.  The following line assigns makes it recognizable as a local variable
  dfEdit = eval(parse(text = df))
  #Variable used in the following code block
  dfName = df
  
  #Changes any column that may be factors to strings/characters
  j <- sapply(dfEdit, is.factor)
  dfEdit[j] <-lapply(dfEdit[j], as.character)
  
  #Removes the rows for the non urban patches by subsetting a given table and keeping only rows measuring urban patches
  dfEdit <- subset(dfEdit, TYPE == ' cls_2 ')
  
  #This block derives the distance/partition column from the LID(filepath) column in the fragstats table
  polyRE <- regexpr("poly(.*).tif", dfEdit$LID)
  polyRESub <- regmatches(dfEdit$LID, polyRE)
  ccRE <- regexpr('[0-9]+', polyRESub)
  ccRESub <- regmatches(polyRESub, ccRE)
  
  #Assigns the distance/partition column to a given dataframe
  dfEdit$cc <- ccRESub
  
  #Changes all the names of the columns in a given dataframe
  colnames(dfEdit)[colnames(dfEdit) == "NP"] <- paste("NP", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "CA"] <- paste("TA", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "ED"] <- paste("ED", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "PD"] <- paste("PD", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "AREA_AM"] <- paste("MPS", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "AREA_CV"] <- paste("COV", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "FRAC_AM"] <- paste("FRAC", year, sep = "")
  
  #Assigns the editted local dataframe variable back to the global variable
  assign( x = dfName, value = dfEdit, envir = .GlobalEnv)
}



#The tableEditTran function does the same process as the above function but for transects

tableEditTran <- function(df, year) {
  
  dfEdit = eval(parse(text = df))
  dfName = df
  
  j <- sapply(dfEdit, is.factor)
  dfEdit[j] <-lapply(dfEdit[j], as.character)
  dfEdit <- subset(dfEdit, TYPE == ' cls_2 ')
  
  polyRE <- regexpr("poly(.*).tif", dfEdit$LID)
  polyRESub <- regmatches(dfEdit$LID, polyRE)
  ccRE <- regexpr('[0-9]+', polyRESub)
  ccRESub <- regmatches(polyRESub, ccRE)
  
  dfEdit$block <- ccRESub
  
  colnames(dfEdit)[colnames(dfEdit) == "NP"] <- paste("NP", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "CA"] <- paste("TA", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "ED"] <- paste("ED", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "PD"] <- paste("PD", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "AREA_AM"] <- paste("MPS", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "AREA_CV"] <- paste("COV", year, sep = "")
  colnames(dfEdit)[colnames(dfEdit) == "FRAC_AM"] <- paste("FRAC", year, sep = "")
  
  
  assign( x = dfName, value = dfEdit, envir = .GlobalEnv)
}


#The tableMerge function merges for the tables from the three different years for a given shapefile in a single table
#This function returns a table with the data from the three years into a single table.

tableMerge <- function(shpNum, totalFileList) {
  
  #Takes the inputted strings
  TFL = eval(parse(text = totalFileList))
  
  print(TFL)
  
  mergeList <- list()
  i = 1
  
  for (shpLists in TFL){
    
    mergeIndex <-regexpr(paste(shpNum,"cc[0-9]+", sep = ''), shpLists)
    mergeUnit <- regmatches(unlist(shpLists), mergeIndex)
    mergeList[i]<- mergeUnit
    i = i+1
  }
  
  DF1 <- eval(parse(text = mergeList[1]))
  DF2 <- eval(parse(text = mergeList[2]))
  DF3 <- eval(parse(text = mergeList[3]))
  
  tempMergeDF <- merge(DF1, DF2, by = "cc", all = TRUE)
  
  totalMergeDF <- merge(tempMergeDF, DF3, by = "cc", all = TRUE)
  
  options(digits = 2)
  
  totalMergeDF$cc <- as.double(totalMergeDF$cc)
  
  totalMergeDF <- totalMergeDF[order(totalMergeDF$cc),]
  
  tempName = paste(shpNum, "CC", sep = '')
  
  assign(x = tempName, value = totalMergeDF, envir = .GlobalEnv)
  
}

#The tableMergeTran function does the same thing as the tableMerge function above except for transects

tableMergeTran <- function(shpNum, totalFileList) {
  
  
  TFL = eval(parse(text = totalFileList))
  
  
  mergeList <- list()
  i = 1
  
  for (shpLists in TFL){
    
    mergeIndex <-regexpr(paste(shpNum,"tran[0-9]+", sep = ''), shpLists)
    mergeUnit <- regmatches(unlist(shpLists), mergeIndex)
    mergeList[i]<- mergeUnit
    i = i+1
  }
  
  DF1 <- eval(parse(text = mergeList[1]))
  DF2 <- eval(parse(text = mergeList[2]))
  DF3 <- eval(parse(text = mergeList[3]))
  
  tempMergeDF <- merge(DF1, DF2, by = "block", all = TRUE)
  
  totalMergeDF <- merge(tempMergeDF, DF3, by = "block", all = TRUE)
  
  options(digits = 2)
  
  totalMergeDF$block <- as.double(totalMergeDF$block)
  
  totalMergeDF <- totalMergeDF[order(totalMergeDF$block),]
  
  tempName = paste(shpNum, "Tran", sep = '')
  
  assign(x = tempName, value = totalMergeDF, envir = .GlobalEnv)
  
}


#The graph function graphs the concentric circles data

Graph <- function(DF, metric01, metric06, metric11){
  

  #Background Plot to Establish Area for metric Lines
  plot(DF$cc, metric01, type = "l", col = "white", xlab="", ylab="", cex.lab = 1.3,
       xaxt ='n', yaxt ='n', pch = 21, bg = "white")
  
  #Creates axis tick marks and numbers that are close to the plot area
  axis(1, cex.axis = 1, tck = 0)
  axis(2, cex.axis = 1, tck = 0)
  
  #Metric Lines
  par(new=TRUE)
  lines(DF$cc, metric01, type = "l", lty = 2, lwd = 2,  col = "green3", 
        xlab="", ylab="", xaxt = 'n', yaxt = 'n', pch = 21, bg = "green3", cex = .5 )
  
  par(new=TRUE)
  lines(DF$cc, metric06, type = "l", lty = 3, lwd = 2, col = "red",
        xlab="", ylab="", xaxt = 'n', yaxt = 'n', pch = 22, bg = "red", cex = .5)
  
  par(new=TRUE)
  lines(DF$cc, metric11, type = "l", lty = 4, lwd = 2, col = "blue",
        xlab="",ylab="", xaxt = 'n', yaxt = 'n', pch = 24,bg = "blue", cex = .5)
  
}


#The GraphTran function graphs the transect data

GraphTran <- function(DF, metric01, metric06, metric11, transectIndex){
  
  lim <- par("usr")
  
  #Background Plot to Establish Area for City Limit Areas
  
  #Finds the largest number from each column
  maxTranNum <- c(max(metric01), max(metric06), max(metric11))
  #Finds the largest number from the above list
  maxTranNumNum <- max(maxTranNum)
  
  #Creates an x-axis column. The point of creating this is to keep the text from running off the plot
  xcoords <- c(rep_len(seq(1, maxTranNumNum, (maxTranNumNum/nrow(DF))), nrow(DF)))
  
  #Background plot
  plot(DF$block, xcoords,
       type = "l", col = "white", xlab="", ylab="", xaxt = 'n', yaxt = 'n')
  
  axis(1, cex.axis = 1, tck = 0)
  axis(2, cex.axis = 1, tck = 0)
  
  
  #City Limit Areas.  Creating the city limit aspects of the graphs requires information from the transect table included in this project.
  
  #First City Limit
  if(transect[[1]][transectIndex]: TRUE)
  {
    par(new=TRUE)
    par(bg= rect(transect[[3]][transectIndex],  lim[3]-50, transect[[4]][transectIndex], lim[4]+300, border="black", col = "gray85"))
  }
  
  
  #Second City Limit
  if(transect[[5]][transectIndex]: TRUE)
  {
    par(new=TRUE)
    par(bg= rect(transect[[7]][transectIndex],  lim[3]-50, transect[[8]][transectIndex], lim[4]+300, border="black", col = "gray85"))
    
  }
  
  #Third City Limit
  if(transect[[9]][transectIndex]: TRUE)
  {
    par(new=TRUE)
    par(bg= rect(transect[[11]][transectIndex],  lim[3]-50, transect[[12]][transectIndex], lim[4]+300, border="black", col = "gray85"))
  }
  
  
  #Background Plot to Establish Area for metric Lines
  par(new=TRUE)
  plot(DF$block, metric01, type = "l", col = "white", xlab="", ylab="", cex.lab = 1.3,
       xaxt ='n', yaxt ='n', lty = 1, bg = "white")
  
  #Metric Lines
  par(new=TRUE)
  lines(DF$block, metric01, type = "l", col = "green3", xlab="", ylab="", xaxt = 'n', yaxt = 'n', lty = 1, bg = "green3")
  
  par(new=TRUE)
  lines(DF$block, metric06, type = "l", col = "red", xlab="", ylab="", xaxt = 'n', yaxt = 'n', lty = 2, bg = "red")
  
  par(new=TRUE)
  lines(DF$block, metric11, type = "l", col = "blue", xlab="",ylab="", xaxt = 'n', yaxt = 'n', lty = 3, bg = "blue")
  
  maxTranNum <- c(max(metric01), max(metric06), max(metric11))
  
  
  #Text for City Limit Area. Locates and aligns the text with their respective shaded areas
  
  #First City Limit
  if(transect[[1]][transectIndex]: TRUE)
  {
    text(((transect[[3]][transectIndex]+transect[[4]][transectIndex])/2), median(xcoords), transect[[2]][transectIndex], font=2)
  }
  
  #Second City Limit
  if(transect[[5]][transectIndex]: TRUE)
  {
    text(((transect[[7]][transectIndex]+transect[[8]][transectIndex])/2), median(xcoords), transect[[6]][transectIndex], font=2)
  }
  
  #Third City Limit
  if(transect[[9]][transectIndex]: TRUE)
  {
    text(((transect[[11]][transectIndex]+transect[[12]][transectIndex])/2), median(xcoords), transect[[10]][transectIndex], font=2)
  }
  
}







