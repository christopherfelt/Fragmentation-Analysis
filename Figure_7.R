#Figure 7: T6 - T10

figure7 <- list(shp6Tran, shp7Tran, shp8Tran, shp9Tran, shp10Tran)


par (mfrow = c(5, 6))
par (mar = c(1, 1, 1, 1))
par (oma = c(4, 2, 2, 1))
par(mgp = c(.6, .01, 0))

tranIndex = 6 

for (f in figure7){
  
  GraphTran(f, f$TA01, f$TA06, f$TA11, tranIndex)
  GraphTran(f, f$NP01, f$NP06, f$NP11, tranIndex)
  GraphTran(f, f$ED01, f$ED06, f$ED11, tranIndex)
  GraphTran(f, f$MPS01, f$MPS06, f$MPS11, tranIndex)
  GraphTran(f, f$COV01, f$COV06, f$COV11, tranIndex)
  GraphTran(f, f$FRAC01, f$FRAC06, f$FRAC11, tranIndex)
  
  tranIndex = tranIndex + 1
  
}



#Names of Transects

mtext("T6", outer = TRUE, 2, at = .9)

mtext("T7", outer = TRUE, 2, at = .7)

mtext("T8", outer = TRUE, 2, at = .5)

mtext("T9", outer = TRUE, 2, at = .3)

mtext("T10", outer = TRUE, 2, at = .1)


#Name of Metrics

mtext("UA", outer = TRUE, 3, at = .083, line = -.5)

mtext("NP", outer = TRUE, 3, at = .25, line = -.5)

mtext("ED", outer = TRUE, 3, at = .42, line = -.5)

mtext("MPS", outer = TRUE, 3, at = .58, line = -.5)

mtext("COV", outer = TRUE, 3, at = .75, line = -.5)

mtext("FRAC", outer = TRUE, 3, at = .91, line = -.5)


#Partition Type

mtext("Block", outer = TRUE, 1, at = .5, line = 1)

plot_colors <- c("green3", "red", "blue")
symbols <- c(21, 22, 24)
linestypes <- c(1, 2, 3)
bg <- c("green3", "red", "blue")
text <- c("2001", "2006", "2011")
par(new = TRUE)

legend(x = -15, y = .98, inset = -.25, xpd = NA, legend = text, text.width = max(sapply(text, strwidth)),
       col=plot_colors, lty = linestypes, lwd = 1.9, cex = 1, horiz = TRUE)