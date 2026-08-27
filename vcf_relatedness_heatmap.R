##relatedness heatmap from VCF file of random SNPs
library(gplots)
in1 <- read.table ("/data/home/elicia/Ahalleri/WG_king_structure/pruned_subset_10k.vcf")

dd <- in1[in1[,5] != ".",]
data <- dd[,10:ncol(dd)]

gtypes <- array (NA, c(nrow(data),ncol(data)))

data2 <- as.matrix(data)

for (i in 1:nrow (data)){

        sub1 <- strsplit (data2[i,],split = ":")
        gtypes[i,] <- sapply (sub1,"[[",1)

}


gtypes2 <- gtypes
gtypes2 <- gsub("0/0","0",gtypes2,fixed = T)
gtypes2 <- gsub("0/1","0.5",gtypes2,fixed = T)
gtypes2 <- gsub("1/1","1",gtypes2,fixed = T)
gtypes2 <- gsub("./.",NA,gtypes2,fixed = T)

write.table (gtypes2,"temp454.txt")
gtypes2 <- read.table ("temp454.txt")

gtypes2 <- as.data.frame(gtypes2)
gtypes2[] <- lapply(gtypes2, function(x) as.numeric(as.character(x)))

gvar <- apply (gtypes2,1,var)
gsum <- apply (gtypes2,1,sum)

gsum2 <- gsum[which (gvar == 0)]

gtypes3 <- gtypes2[which(gvar != 0),]

numdiff <- array (NA,c(ncol(gtypes3),ncol(gtypes3)))
numdiff_unfilt <- array (NA,c(ncol(gtypes3),ncol(gtypes3)))

for (i in 1:ncol(gtypes3)){
        for (j in 1:ncol(gtypes3)){

        numdiff[i,j] <- sum (abs(gtypes3[,i] - gtypes3[,j]))
        numdiff_unfilt[i,j] <- sum (abs(gtypes2[,i] - gtypes2[,j]),na.rm = T)

}
}

write.table (numdiff, "numdiff.txt")
write.table (numdiff_unfilt, "numdiff_unfilt.txt")
numdiff <- read.table ("numdiff.txt")
numdiff_unfilt <- read.table ("numdiff_unfilt.txt")

numdiff <- as.matrix(numdiff)
numdiff_unfilt <- as.matrix(numdiff_unfilt)
numdiff[cbind(1:ncol(numdiff),1:ncol(numdiff))] <- NA
numdiff_unfilt[cbind(1:ncol(numdiff),1:ncol(numdiff))] <- NA

jpeg("heatmap_numdiff.jpeg", width = 3000, height = 3000)
heatmap.2 (numdiff,trace = "none", Colv = F, Rowv = F, dendrogram = "none")
dev.off()
jpeg("heatmap_numdiff_unfilt.jpeg", width = 3000, height = 3000)
heatmap.2 (numdiff_unfilt,trace = "none", Colv = F, Rowv = F, dendrogram = "none")
dev.off()
