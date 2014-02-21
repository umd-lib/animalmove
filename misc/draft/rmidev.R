install.packages("sqldf")
require(sqldf)
library(sqldf)
data(puechabonsp)

.populationType <- function(x1){
    type <- subset(x1, id == id, select = c("type"))[1,1]
    return(type)
}
individual.mcp
population.mcp

df <- ind1@data
df

individual.mcp

colnames(df)[colnames(df)=="Name"] <- "id"

head(df)

df1 <- as.data.frame(individual.mcp)

head(df1)

#apply(df1, 1, .populationType(df) )


s01 <- sqldf("select type, id from df")
head(s01)

s02 <- sqldf("select id from df")

head(s02)


#colnames(individual.mcp@data)[colnames(individual.mcp@data)=="area"] <- "indhomerange"
colnames(population.mcp@data)[colnames(population.mcp@data)=="area"] <- "pophomerange"