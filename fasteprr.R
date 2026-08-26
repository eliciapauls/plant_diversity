library(FastEPRR)
FastEPRR_VCF_step1(vcfFilePath="./phased.vcf.gz", winLength=100000, srcOutputFilePath="./rec_test/step1/chr1")
FastEPRR_VCF_step2(srcFolderPath = "./rec_test/step1", getCI = FALSE, replicateNum = 100, DXOutputFolderPath ="./rec_test/step2")
FastEPRR_VCF_step3(srcFolderPath = "./rec_test/step1", DXFolderPath = "./rec_test/step2", finalOutputFolderPath = "./rec_test/step3")
