#Figure 4: CC6 - CC10

figure4 <- list(shp6CC, shp7CC, shp8CC, shp9CC, shp10CC)


par (mfrow = c(5, 6))
par (mar = c(1, 1, 1, 1))
par (oma = c(4, 2, 2, 1))
par(mgp = c(.6, .01, 0))

for (f in figure2){
  
  Graph(f, f$TA01, f$TA06, f$TA11)
  Graph(f, f$PD01, f$PD06, f$PD11)
  Graph(f, f$ED01, f$ED06, f$ED11)
  Graph(f, f$MPS01, f$MPS06, f$MPS11)
  Graph(f, f$COV01, f$COV06, f$COV11)
  Graph(f, f$FRAC01, f$FRAC06, f$FRAC11)
  
}

#Names of concentric Circles

mtext("CC6", outer = TRUE, 2, at = .9)

mtext("CC7", outer = TRUE, 2, at = .7)

mtext("CC8", outer = TRUE, 2, at = .5)

mtext("CC9", outer = TRUE, 2, at = .3)

mtext("CC10", outer = TRUE, 2, at = .1)


#Name of Metrics

mtext("UA", outer = TRUE, 3, at = .083, line = -.5)

mtext("PD", outer = TRUE, 3, at = .25, line = -.5)

mtext("ED", outer = TRUE, 3, at = .42, line = -.5)

mtext("MPS", outer = TRUE, 3, at = .58, line = -.5)

mtext("COV", outer = TRUE, 3, at = .75, line = -.5)

mtext("FRAC", outer = TRUE, 3, at = .91, line = -.5)

mtext("Concentric Circle", outer = TRUE, 1, at = .5, line = 1)

plot_colors <- c("green3", "red", "blue")
symbols <- c(21, 22, 24)
linestypes <- c(1, 2, 3)
bg <- c("green3", "red", "blue")
text <- c("2001", "2006", "2011")
par(new = TRUE)

legend(x = -15, y = .98, inset = -.25, xpd = NA, legend = text, text.width = max(sapply(text, strwidth)),
       col=plot_colors, lty = linestypes, lwd = 1.9, cex = 1, horiz = TRUE)
