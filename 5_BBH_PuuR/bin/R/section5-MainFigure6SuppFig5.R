# Name:
#   section5-MainFigure6SuppFig5.R
# Author:
#   Hernandez Benitez Ericka Montserrat
# Version:
#   v1
# Description:
#   The script computes the dot plot identity vs. coverage of PuuR BBH and the E-value density.
# Input parameters:
#   --inpath[directory]
#   --outpath[directory]

# Output
#     1) Two png files 

# Rscript --vanilla section5-MainFigure6SuppFig5.R
# /home/emhernan/5_BBH_PuuR/output/
# /home/emhernan/5_BBH_PuuR/png/
# Rscript --vanilla section5-MainFigure6SuppFig5.R /home/emhernan/5_BBH_PuuR/output/ /home/emhernan/5_BBH_PuuR/png/

# inpath <- "/home/emhernan/5_BBH_PuuR/output/"
# outpath <- "/home/emhernan/5_BBH_PuuR/png/"

############################## Functions ###############################

###########################################################################
############################ dot_plot #####################################
###########################################################################

dot_plot <- function(df, x_axe, y_axe, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab = TRUE, colab = "", titlelab, xsize, ysize, textsize, titlesize){
  
  ggobject <- df %>% 
    ggplot(aes(x = x_axe, y = y_axe, color = x_axe)) +
    geom_point(position=position_jitter(h=0.7, w=0.7), size = 5) 
  ggobject <- plot_settings(ggobject, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab, colab, titlelab, xsize, ysize, textsize, titlesize)
  
  return(ggobject)
  
}


###########################################################################
########################## density_plot ###################################
###########################################################################

density_plot <- function(df, x_axe, col, filler, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab = FALSE, colab = "", titlelab, xsize, ysize, textsize, titlesize){
  
  ggobject <- df %>%
    ggplot(aes(x = x_axe)) +
    geom_density(colour = col, fill = filler)
  ggobject <- plot_settings(ggobject, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab, colab, titlelab, xsize, ysize, textsize, titlesize)
  
  return(ggobject)
}


###########################################################################
######################### plot_settings ###################################
###########################################################################

plot_settings <- function(ggobj, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab, colab, titlelab, xsize, ysize, textsize, titlesize){
  
  ggobj <- ggobj +
    coord_cartesian(ylim = c(yilim, yslim), xlim = c(xilim, xslim)) +
    theme_classic() +
    labs(y = ylab, 
         x = xlab,
         title = titlelab) +
    theme(plot.title = element_text(hjust = 0.5, size = titlesize, face = "italic"), 
          axis.title.x = element_text(size = xsize),
          axis.title.y = element_text(size = ysize),
          axis.text.y = element_text(size = textsize),
          axis.text.x = element_text(angle = 45, hjust = 1, size = textsize),
          panel.background = element_rect(fill='transparent'),
          plot.background = element_rect(fill='transparent', color=NA),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    scale_colour_viridis(option="inferno", direction = -1) 
  
  if(flagcolab){
    ggobj <- ggobj +
      labs(color = colab)
  }
  
  return(ggobj)
}


print("........................Here is your input data........................")



############################## Main program ###############################

############################ Loading libraries ############################

print("........................Loading libraries........................") 

library(dplyr)
library(ggplot2)
library(ggpubr)
library(RColorBrewer)
library(viridis)



arg = commandArgs(trailingOnly = T)

if (length(arg)==0) {
  stop("Must supply input and output directories", call.=FALSE)
} else if (length(arg) == 1){
  stop("Enter output directory")
} 

inpath        <- arg[1]
outpath       <- arg[2]

print("........................Reading data........................")

rhizobium  <- read.table(file = paste(inpath, "Rpaaq_Rhaadb_PuuROrthologous.tsv", sep = ""), header =  FALSE, sep = "\t")
rhizobia <- read.table(file = paste(inpath, "Rhaaq_Rpaadb_PuuROrthologous.tsv", sep = ""), header =  FALSE, sep = "\t")

colnames(rhizobium) <- c("qName", "sName", "peri", "alilen", "numMM", "nnGP", "qSS", "qSE", "sSS", "sSE", "Evalue", "bitScore")
colnames(rhizobia) <- c("qName", "sName", "peri", "alilen", "numMM", "nnGP", "qSS", "qSE", "sSS", "sSE", "Evalue", "bitScore")

rhizobium$qcovs = 100
rhizobia$qcovs = 100

print("........................Processing data ........................")
dotplotRhizobium <- dot_plot(df = rhizobium, x_axe = rhizobium$peri, y_axe = rhizobium$qcovs, 
         xilim = 75, xslim = 100, yilim = 75, yslim = 100, ylab = "Query coverage (%)", 
         xlab = "Identity (%)", colab = "Identity (%)", 
         titlelab = "Rhizobium phaseoli\n", xsize = 10, ysize = 10, textsize = 8, titlesize = 12)  

dotplotRhizobia <- dot_plot(df = rhizobia, x_axe = rhizobia$peri, y_axe = rhizobia$qcovs, 
                             xilim = 75, xslim = 100, yilim = 75, yslim = 100, ylab = "Query coverage (%)", 
                             xlab = "Identity (%)", colab = "Identity (%)", 
                             titlelab = "Hyphomicrobiales\n", xsize = 10, ysize = 10, textsize = 8, titlesize = 12)  


rhizobiumEvalue <- density_plot(df = rhizobium, x_axe = rhizobium$Evalue, col = "#e2127f", filler = "#fbd1e2", 
                            xilim = 0, xslim =  max(rhizobium$Evalue), yilim = 0, yslim = 1.8e+104, ylab = "Density", xlab = "E-value", 
                            titlelab = "Rhizobium phaseoli\n", xsize =8, ysize = 8, textsize = 7, titlesize = 9)

rhizobiaEvalue <- density_plot(df = rhizobia, x_axe = rhizobia$Evalue, col = "#e2127f", filler = "#fbd1e2", 
                                xilim = 0, xslim = max(rhizobia$Evalue), yilim = 0, yslim = 1.8e+104, ylab = "Density", xlab = "E-value", 
                                titlelab = "Hyphomicrobiales\n", xsize = 8, ysize = 8, textsize = 7, titlesize = 9)


print("........................Saving data ........................")
MainF4 <- ggarrange(dotplotRhizobium, dotplotRhizobia, 
                    labels = c("A", "B"), 
                    ncol = 2, nrow = 1, 
                    common.legend = TRUE, legend="bottom")  +
          theme(legend.background = element_rect(fill='transparent', colour= NA),
               legend.box.background = element_rect(fill='transparent', colour= NA))

SuppF4 <- ggarrange(rhizobiumEvalue, rhizobiaEvalue,
                    labels = c("A", "B"), 
                    ncol = 1, nrow = 2,
                    common.legend = FALSE)


pngpath <- paste(outpath, "MainF6.png",sep="")
png(pngpath, width=300*5.59, height=300*6.2, res=300, units="px", bg = "transparent")
MainF4
dev.off()

pngpath <- paste(outpath, "SuppF5.png",sep="")
png(pngpath, width=300*4.5, height=300*5.5, res=300, units="px", bg = "transparent")
SuppF4
dev.off()

pdfpath <- paste(outpath, "MainF6.pdf",sep="")
ggsave(pdfpath, MainF4, width = 5.59, height = 6.2, units = "in", dpi = 300)

pdfpath <- paste(outpath, "SuppF5.pdf",sep="")
ggsave(pdfpath, SuppF4, width = 4.5, height = 5.5, units = "in", dpi = 300)

