setwd("/home/hector/Projects/words")

# Global variables
figures_dir = "figs"
data_dir = "data"

#Esta funcion devuelve una direccion completa al directorio que especificamos
#con los parametros de la funcion
getPath <- function(dir, dataset, memory, name, extension)
{
  return(paste(dir, "/", dataset, "/", name, "_", memory, ".", extension, sep=""))
}

#Esta funcion devuelve una direccion completa al directorio que especificamos
#con los parametros de la funcion
getDataPath <- function(dataset, memory, name) getPath(data_dir, dataset, memory, name, "txt")

#Esta funcion devuelve los datos del dataset indicado para poder trabajar con ellos
getData <- function(dataset, memory)
{
  data = new.env()
  
  data[["sample"]]  = read.table(getDataPath(dataset, memory, "sample"), header=T)
  data[["summary"]] = read.table(getDataPath(dataset, memory, "summary"), header=T)
  data[["count"]]   = read.table(getDataPath(dataset, memory, "count"), header=T)
  
  return(data)
}

#Esta funcion devuelve el error relativo del dataset indicado
getRel <- function(dataset, memories, column)
{
  rel = c()
  
  for(i in 1:length(memories))
  {
    rel[i] <- getData(dataset, 2^memories[i])[["summary"]][[column]]
  }
  
  return(rel)
}

#Esta funcion saca la grafica con las estimaciones del dataset indicado
plotEstimation <- function(dataset, memory)
{
  data = getData(dataset, memory)

  dir.create(paste(figures_dir, "/", dataset, sep=""))
  pdf(getPath(figures_dir, dataset, memory, "plot_estimation", "pdf"))
  layout(rbind(1, 2), heights=c(15,1))
  
  plot(data$sample$est, col="red", pch=20, xlab="Ejecución", ylab="Estimación", ylim=c(0, max(data$sample$est, data$summary$real, data$summary$avgEstimation)))
  title(main=paste("Estimaciones de ", dataset, ".dat con ", memory, " bytes", sep=""))
  abline(h = data$summary$real, col="green")
  abline(h = data$summary$avgEstimation, col="blue")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", c("Valor real", "Estimación media"), col=c("green", "blue"), lty = c(1, 1), bty="n", ncol=2)
  
  dev.off()
}

#Esta funcion saca la grafica con los errores relativos del dataset indicado
plotErrors <- function(dataset, memory)
{
  data = getData(dataset, memory)
  
  pdf(getPath(figures_dir, dataset, memory, "plot_errors", "pdf"))
  layout(rbind(1,2), heights=c(15,1))
  
  plot(data$sample$relError, col="red", pch=20, xlab="Ejecución", ylab="Error relativo", ylim=c(0, max(data$sample$relError, data$summary$stdError)))
  title(main=paste("Errores relativos de ", dataset, ".dat con ", memory, " bytes", sep=""))
  abline(h = data$summary$stdError, col="blue")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", c("Error estándar"), col=c("blue"), lty = c(1), bty="n")
  
  dev.off()
}

#Esta funcion saca la grafica con los elementos que contiene el dataset indicado
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

#Esta funcion saca la grafica con los tiempos de ejecucion del dataset indicado
plotTime <- function(dataset, memory)
{
  data = getData(dataset, memory)
  
  pdf(getPath(figures_dir, dataset, memory, "plot_time", "pdf"))
  layout(rbind(1,2), heights=c(15,1))
  
  plot(data$sample$timeMs, col="red", pch=20, xlab="Ejecución", ylab="Tiempo (ms)", ylim=c(0, max(data$sample$timeMs, data$summary$avgTimeMs)))
  title(main=paste("Tiempos de ejecución en ", dataset, ".dat con ", memory, " bytes", sep=""))
  abline(h = data$summary$avgTimeMs, col="blue")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", c("Tiempo medio (ms)"), col=c("blue"), lty = c(1), bty="n")
  
  dev.off()
}

#Esta funcion saca la grafica con los la estimacion media del dataset indicado en funcion de la memoria
memEstimation <- function(dataset, memories)
{
  real = getData(dataset, 2^memories[1])$summary$real
  estimations = getRel(dataset, memories, "avgEstimation")
  
  pdf(getPath(figures_dir, dataset, "rel", "mem_estimation", "pdf"))
  layout(rbind(1, 2), heights=c(15,1))
  
  plot(memories, estimations, col="red", pch=20, xlab="log2(Memoria)", ylab="Estimación media", xaxt="n", ylim=c(0, max(estimations)))
  axis(side=1, at=memories, cex.axis=1)
  title(main="Influencia de la memoria sobre la estimación media")
  abline(h = real, col="green")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", c("Valor real"), col=c("green"), lty=c(1), bty="n")
  
  dev.off()
}

#Esta funcion saca la grafica con el error medio del dataset indicado en funcion de la memoria
memErrors <- function(dataset, memories)
{
  errors = getRel(dataset, memories, "stdError")
  
  pdf(getPath(figures_dir, dataset, "rel", "mem_errors", "pdf"))
  layout(rbind(1, 2), heights=c(15,1))
  
  plot(memories, errors, col="red", pch=20, xlab="log2(Memoria)", ylab="Error estándar", xaxt="n", ylim=c(0, max(errors)))
  curve(1.04 / sqrt(2^x), from=memories[1], to=memories[length(memories)], add=T, lty=2, col="blue")
  axis(side=1, at=memories, cex.axis=1)
  title(main="Influencia de la memoria sobre el error estándar")
  
  par(mar=c(0, 0, 0, 0))
  plot.new()
  legend("center", c("1.04 / sqrt(2^x)"), col=c("blue"), lty=c(2), bty="n")
  
  dev.off()
}

#Esta funcion saca la grafica con el tiempo medio de ejecucion del dataset indicado en funcion de la memoria
memTime <- function(dataset, memories)
{
  times = getRel(dataset, memories, "avgTimeMs")
  
  pdf(getPath(figures_dir, dataset, "rel", "mem_time", "pdf"))
  layout(rbind(1, 1))
  
  plot(memories, times, col="red", pch=20, xlab="log2(Memoria)", ylab="Tiempo medio (ms)", xaxt="n", ylim=c(0, max(times)))
  axis(side=1, at=memories, cex.axis=1)
  title(main="Influencia de la memoria sobre el tiempo medio")
  
  dev.off()
}

datasets = list.dirs(data_dir)
memory = 1024

for(i in 2:length(datasets))
{
    dataset = gsub(paste(data_dir, "/", sep=""), "", datasets[i])
    
    plotEstimation(dataset, memory)
    plotErrors(dataset, memory)
    plotCount(dataset, memory)
    plotTime(dataset, memory)
}

memories = c(5:14)

memEstimation("D1", memories)
memErrors("D1", memories)
memTime("D1", memories)

