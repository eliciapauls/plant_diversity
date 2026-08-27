##king-cutoff relatedness heatmap
options (stringsAsFactors = F)
in1 <- read.table ("/data/home/elicia/Athaliana/WG_king_structure/plink_king_table.kin0")

#inds <- unique (in1[,1])

inds <- unique (c(in1[,3],in1[,1]))



dd <- array(NA,c(length(inds),length(inds)))
colnamesdd <- array (NA, length (inds))
for (i in 1:length (inds)){
        for (j in 1:length (inds)){

                ind1 <- which (in1[,1] == inds[i] & in1[,3] == inds[j])

                if (length (ind1) > 0){
                dd[i,j] <- in1[ind1,8]
                }
        }
        colnamesdd[i] <- inds[i]

}



library(gplots)

#Adjusting image size to fit 615 entries
jpeg("heatmap_kin0_formatted.jpeg", width = 3000, height = 3000)  #increase width/height to accommodate more entries

heatmap.2(dd,
          trace = "none",
          Colv = F,
          Rowv = F,
          dendrogram = "none",
          cexRow = 0.8, # Adjusting font size of row labels
          cexCol = 0.8, # Adjusting font size of column labels
          margins = c(10, 10), # Adjust margins to fit larger labels
          keysize = 1.5, # Increase the size of the color key
          key.title = "Color Key and Histogram", # Title for the color key
          key.xlab = "Relatedness", # X-axis label for the color key
           key.par=list(cex=3.0)
 )

dev.off()
