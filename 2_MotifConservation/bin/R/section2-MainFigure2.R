# Name:
#   section2-MainFigure2.R
# Author:
#   Hernandez Benitez Ericka Montserrat
# Version:
#   v1
# Description:
#   The script computes the dot plot identity vs. coverage of DNA binding motifs.
# Input parameters:
#   --inpath[directory]
#   --outpath[directory]
#   --ecoliFile[file name]
#   --rphaseoliFile[file name]
#   --color[color palette]
#   --outFile[directory]
#   --interceptT[boolean]

# Output
#     1) A png file with 2 grids

# Rscript --vanilla section2-MainFigure2.R
# /home/emhernan/2_MotifConservation/motifsInfo/
# /home/emhernan/2_MotifConservation/png/
# ECaaq_oTFs_DNAbinding_motifs_info.tsv
# RZaaq_oTFs_DNAbinding_motifs_info.tsv
# mako
# MainF2.png
# TRUE
# Rscript --vanilla section2-MainFigure2.R /home/emhernan/2_MotifConservation/motifsInfo/ /home/emhernan/2_MotifConservation/png/ ECaaq_oTFs_DNAbinding_motifs_info.tsv RZaaq_oTFs_DNAbinding_motifs_info.tsv mako MainF2.png TRUE

# inpath <- "/home/emhernan/2_MotifConservation/motifsInfo/"
# outpath <- "/home/emhernan/2_MotifConservation/png/"
# ecoliFile <- "ECaaq_oTFs_DNAbinding_motifs_info.tsv"
# rphaseoliFile <- "RZaaq_oTFs_DNAbinding_motifs_info.tsv"
# color <- "mako"
# outFile <- "MainF2.png"
# interceptT <- TRUE


############################## Functions ###############################

###########################################################################
############################ dot_plot #####################################
###########################################################################

dot_plot <- function(df, x_axe, y_axe, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab = TRUE, colab = "", titlelab, xsize, ysize, textsize, titlesize, scaleColor = "mako", intercept = FALSE){
  
  ggobject <- df %>% 
    ggplot(aes(x = x_axe, y = y_axe, color = x_axe)) +
    geom_point() +
    geom_jitter(width = 0.4, height = 0.4) 
    ggobject <- plot_settings(ggobject, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab, colab, titlelab, xsize, ysize, textsize, titlesize, scaleColor)
  
  if(intercept){
  ggobject <- ggobject + 
              geom_vline(xintercept = 30, colour = "#000000", linetype="dashed")
  }
  return(ggobject)
  
}

###########################################################################
######################### plot_settings ###################################
###########################################################################

plot_settings <- function(ggobj, xilim, xslim, yilim, yslim, ylab, xlab, flagcolab, colab, titlelab, xsize, ysize, textsize, titlesize, scaleColor){
  
  ggobj <- ggobj +
    coord_cartesian(ylim = c(yilim, yslim), xlim = c(xilim, xslim)) +
    theme_classic() +
    labs(y = ylab, 
         x = xlab,
         title = titlelab) +
    theme(plot.title = element_text(hjust = 0.5, size = titlesize, face = "italic"), 
          axis.title.x = element_text(size = xsize, hjust = 0.5, vjust = 0.5),
          axis.title.y = element_text(size = ysize, angle = 90, hjust = 0.5, vjust = 0.5),
          axis.text = element_text(size = textsize),
          panel.background = element_rect(fill='transparent'),
          plot.background = element_rect(fill='transparent', color=NA),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    scale_colour_viridis(option= scaleColor, direction = -1) 
  
  if(flagcolab){
    ggobj <- ggobj +
      labs(color = colab)
  }
  
  return(ggobj)
}

############################## Main program ###############################

############################ Loading libraries ############################
print("........................Loading libraries........................") 
library(dplyr)
library(ggplot2)
library(ggpubr)
library(RColorBrewer)
library(viridis)
library(png)

arg = commandArgs(trailingOnly = T)

if (length(arg)==0) {
  stop("Must supply input and output directories", call.=FALSE)
} else if (length(arg) == 1){
  stop("Enter output directory")
} else if (length(arg) == 2){
  stop("Enter ecoli file name")
} else if (length(arg) == 3){
  stop("Enter rphaseoli file name")
} else if (length(arg) == 4){
  stop("Enter colo palette name")
} else if (length(arg) == 5){
  stop("Enter output file name")
} else if (length(arg) == 6){
  stop("Enter TRUE/FALSE for intercept line")
} 

inpath        <- arg[1]
outpath       <- arg[2]
ecoliFile     <- arg[3]
rphaseoliFile <- arg[4]
color         <- arg[5]
outFile       <- arg[6]
interceptT    <- arg[7]


print("........................Reading data........................")

ecoli     <- read.table(file = paste(inpath, ecoliFile, sep = ""), header =  FALSE, sep = "\t")
rphaseoli <- read.table(file = paste(inpath, rphaseoliFile, sep = ""), header =  FALSE, sep = "\t")


print("........................Processing data ........................")


ecoli <- ecoli %>% rename("NCBI_name" =  V1, "EC_locusTag" = V2, "motifCoverage" = V3, "identPercent" = V4, "motifDesc" = V5)
rphaseoli <- rphaseoli %>% rename("NCBI_name" =  V1, "EC_locusTag" = V2, "motifCoverage" = V3, "identPercent" = V4, "motifDesc" = V5)
  

dotplotEcoli    <- dot_plot(df = ecoli, x_axe = ecoli$identPercent, y_axe = ecoli$motifCoverage, 
                         xilim = 0, xslim = 100, yilim = 0, yslim = 100, ylab = "Query coverage (%)", 
                         xlab = "Identity (%)", colab = 'Identity (%)', 
                         titlelab = "Escherichia coli\n", xsize = 10, ysize = 10, textsize = 8, titlesize = 12, scaleColor = color, intercept = interceptT)

dotplotRphaseoli <- dot_plot(df = rphaseoli, x_axe = rphaseoli$identPercent, y_axe = rphaseoli$motifCoverage, 
                         xilim = 0, xslim = 100, yilim = 0, yslim = 100, ylab = "Query coverage (%)", 
                         xlab = "Identity (%)", colab = 'Identity (%)', 
                         titlelab = "Rhizobium phaseoli\n", xsize = 10, ysize = 10, textsize = 8, titlesize = 12, scaleColor = color, intercept = interceptT)


MainF2 <- ggarrange(dotplotEcoli, dotplotRphaseoli, 
                    labels = c("A", "B"), 
                    ncol = 2, nrow = 1, 
                    common.legend = TRUE, legend="bottom") +
          theme(legend.background = element_rect(fill='transparent'),
          legend.box.background = element_rect(fill='transparent'))


print("........................Saving data ........................")

pngpath <- paste(outpath, outFile,sep="")
png(pngpath, width=5.59, height=6.2, res=300, units="in", bg = "transparent")
MainF2
dev.off()



pdfpath <- paste(outpath, "MainF2.pdf",sep="")
pdf(pdfpath, width=5.59, height=6.2, pointsize=300, bg = "transparent")
MainF2
dev.off()