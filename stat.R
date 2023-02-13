rm(list=ls())
library(igraph)
library(R.matlab) 
library(ggraph)
source('F:\\network_parameters.R')
Data <- readMat('F:\\Data.mat')
{
  Result <- data.frame()
  for (j in c(1:10)){
    result <- data.frame()
    for (i in c(1:185)){
      Adj <- as.matrix(Data$DataMatrix[[i]][[1]][[1]][[j]][[1]])
      isSymmetric(Adj)
      g <- graph_from_adjacency_matrix(Adj,mode="undirected",weighted=NULL,diag=FALSE)
      temp <- network_parameters(g)
      result <- rbind(result,temp)
    } 
    result$"时长" <- j
    Result <- rbind(Result,result)
  }
}
write.csv(Result, file='F:\\Result.csv', row.names=FALSE)