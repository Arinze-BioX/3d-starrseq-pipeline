#!/datacommons/ydiaolab/arinze/apps/miniconda_20220118/envs/hicrep/bin/Rscript
args = commandArgs(trailingOnly=TRUE)

#devtools::install_github("TaoYang-dev/hicrep")
library(hicrep)

#read in .cool file paths
path1=paste0(args[1],args[2],".10000.cool")
test=args[2]
print(paste0("Test sample is ", test))
path2=list.files(path = args[1], full.names = TRUE)
path3=args[3]
print(path2)
compare_with=list.files(path = args[1], full.names = FALSE)
for(pair in 1:length(path2)){
    all.scc <- list()
    for (i in paste0("chr", c(as.character(1:22), "X", "Y"))){
        mat1.chr = cool2matrix(path1, chr = i)
        mat2.chr = cool2matrix(path2[pair], chr = i)
        all.scc[[i]] = get.scc(mat1.chr, mat2.chr, 100000, 5, lbr = 0, ubr = 5000000)
    }
    saveRDS(all.scc, paste0(path3,"hicrep_",args[2],"_vs_",compare_with[pair],".rds"))
}