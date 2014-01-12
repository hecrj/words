setwd("/home/hector/Projects/words")

# Global variables
figures_dir = "figs"
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
  pdf(getPath(figures_dir, dataset, memory, "plot_estimation", "pdf"))
  layout(rbind(1, 2), heights=c(15,1))
  
  plot(data$sample$est, col="red", pch=20, xlab="Ejecución", ylab="Estimación")
  title(main=paste("Estimaciones de ", dataset, ".dat con ", memory, " bytes", sep=""))
  abline(h = data$summary$real, col="green")
  abline(h = data$summary$avgEstimation, col="blue")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", c("Valor real", "Estimación media"), col=c("green", "blue"), lty = c(1, 1), bty="n", ncol=2)
  
  dev.off()
}

plotErrors <- function(dataset, memory)
{
  data = getData(dataset, memory)
  
  pdf(getPath(figures_dir, dataset, memory, "plot_errors", "pdf"))
  layout(rbind(1,2), heights=c(15,1))
  
  plot(data$sample$relError, col="red", pch=20, xlab="Ejecución", ylab="Error relativo")
  title(main=paste("Errores relativos de ", dataset, ".dat con ", memory, " bytes", sep=""))
  abline(h = data$summary$stdError, col="blue")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", "groups", c("Error estándar"), col=c("blue"), lty = c(1), bty="n")
  
  dev.off()
}

plotCount <- function(dataset, memory)
{
  data = getData(dataset, memory)
  
  pdf(getPath(figures_dir, dataset, memory, "plot_count", "pdf"))
  layout(rbind(1,1))
  
  barplot(as.matrix(data$count[1:6]), names=c("[0, 1)", "[1, 5)", "[5, 10)", "[10, 15)", "[15, 20)", "[20, 100]"),
    ylim=c(0, 200), ylab="Cantidad de ejecuciones", xlab="Intervalos de error relativo (%)", border=NA,
      col="cornflowerblue")
  title(main=paste("Clasificación ejecuciones de ", dataset, ".dat con ", memory, " bytes", sep=""))
  
  dev.off()
}

plotTime <- function(dataset, memory)
{
  data = getData(dataset, memory)
  
  pdf(getPath(figures_dir, dataset, memory, "plot_time", "pdf"))
  layout(rbind(1,2), heights=c(15,1))
  
  plot(data$sample$timeMs, col="red", pch=20, xlab="Ejecución", ylab="Tiempo (ms)")
  title(main=paste("Tiempos de ejecución en ", dataset, ".dat con ", memory, " bytes", sep=""))
  abline(h = data$summary$avgTimeMs, col="blue")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", "groups", c("Tiempo medio (ms)"), col=c("blue"), lty = c(1), bty="n")
  
  dev.off()
}

datasets = list.dirs(data_dir)
memories = c(1024)

for(i in 2:length(datasets))
{
  for(j in 1:length(memories))
  {
    dataset = gsub(paste(data_dir, "/", sep=""), "", datasets[i])
    
    plotEstimation(dataset, memories[j])
    plotErrors(dataset, memories[j])
    plotCount(dataset, memories[j])
    plotTime(dataset, memories[j])
  }
}
