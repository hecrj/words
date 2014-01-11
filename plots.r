setwd("/home/hector/Projects/words")

# Global variables
figures_dir = "report/figures"
data_dir = "data"

getPath <- function(dir, dataset, memory, name, extension)
{
  return(paste(dir, "/", dataset, "/", name, "_", memory, ".", extension, sep=""))
}

getDataPath <- function(dataset, memory, name) getPath(data_dir, dataset, memory, name, "txt")

getData <- function(dataset, memory)
{
  data = new.env()
  
  data[["sample"]]  = read.table(getDataPath(dataset, memory, "sample"), header=T)
  data[["summary"]] = read.table(getDataPath(dataset, memory, "summary"), header=T)
  data[["count"]]   = read.table(getDataPath(dataset, memory, "count"), header=T)
  
  return(data)
}

plotEstimation <- function(dataset, memory)
{
  data = getData(dataset, memory)

  dir.create(paste(figures_dir, "/", dataset, sep=""))
  pdf(getPath("report/figures", dataset, memory, "plot_estimation", "pdf"))

  plot(data$sample$est, col="red", pch=20, xlab="Ejecución", ylab="Estimación")
  title(main=paste("Estimaciones de ", dataset, ".dat con ", memory, " bytes", sep=""))
  legend("bottomleft", c("Valor real", "Estimación media"), col=c("green", "blue"), lty = c(1, 1))
  abline(h = data$summary$real, col="green")
  abline(h = data$summary$avgEstimation, col="blue")

  dev.off()
}

datasets = list.dirs(data_dir)
memories = c(1024)

for(i in 2:length(datasets))
{
  for(j in 1:length(memories))
  {
    plotEstimation(gsub(paste(data_dir, "/", sep=""), "", datasets[i]), memories[j])
  }
}
