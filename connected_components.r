library(RODBC)
myconn <-odbcConnect("TF24")
#input is edge list
el <- sqlFetch(myconn, "S_D_MATRIX")

igraph <- graph.data.frame(el)
V(igraph)$type <- V(igraph)$name %in% el[,1]
igraph
cluster_info <-clusters(igraph, mode=c("weak", "strong"))
plot(igraph)
no_clus <-cluster_info$no
vertex_pro <-vertex.attributes(igraph)
rm(igraph)
nodeVsmember <-cbind(vertex_pro$name, vertex_pro$type, cluster_info$membership)
colnames(nodeVsmember) <- c("Node","Nodetype", "ClusterID")
nodeVsmember <- as.character(nodeVsmember)
head(nodeVsmember)
str(nodeVsmember)
nodeVsmember <- as.data.frame(nodeVsmember)
#TO SAVE THE DATA FRAME INTO RDMS
el <- fread("IMEI_ID_MSISDN_ID_20150607.csv",header=T)
str(el)

sqlSave(myconn, el, tablename = "RTBL_IMEI_MSISDN_T", append = FALSE,
        rownames = FALSE, 
        fast = TRUE)

sqlQuery(myconn,"BULK INSERT CTY_AMS_OPS.TOUFIQ.RTBL_IMEI_MSISDN FROM 'MSISDN_IMEI_FULL_APRIL.csv'");


sqlSave(myconn, t1, tablename = "RTBL_IMEI_MSISDN", append = FALSE)

sqlSave(myconn, dat, tablename = "RTBL_IMEI_MSISDN11", append = FALSE,
        rownames = FALSE, colnames = TRUE, 
        fast = TRUE)

#TO QUERY 
Q1 <- sqlQuery(myconn, "select * from RTBL_TEST")


write.csv(nodeVsmember, file = "footest.csv", row.names = FALSE)

