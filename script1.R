setwd("D:/Dropbox/Universitat/5é Quatrimestre/A/Pràctiques/Pràctica Final/data")

#mostra=sample$timeMs
ExecutionTime<-function(mostra)
{
	return (sum(mostra))
}

#mostra=sample$timeMs
MeanTimePerElement<-function(mostra,size)
{
	return (ExecutionTime(mostra)/size)
}

#mostra=sample$est
ErrorRelatiu<-function(valorReal,mostra)
{
	longitud<-length(mostra)
	return (abs(valorReal-mostra)/valorReal)
}

#mostra=sample$est
MeanValue<-function(setVal)
{
	return (sum(setVal)/length(setVal))
}

#mostra=sample$est
StandardError<-function(valorMitja,valorReal,mostra)
{
	K<-length(mostra)
	return (sqrt(sum(mostra^2)/K-valorMitja)/valorReal)
}

LessOnePerCent<-function(mostra)
{
	return (length(mostra[mostra<0.01]))
}

BetweenOneFive<-function(mostra)
{
	aux<-mostra[mostra>=0.01]
	return (length(aux[aux<0.05]))
}

BetweenFiveTen<-function(mostra)
{
	aux<-mostra[mostra>=0.05]
	return (length(aux[aux<0.1]))
}

MoreThanTen<-function(mostra)
{
	return (length(mostra[mostra>=0.1]))
}

Dirs<-list.dirs()
numDirs<-length(Dirs)

estimacions<-matrix(nrow=100,ncol=9)
cardinalitats<-vector()
errorsRelatius<-matrix(nrow=100,ncol=9)
estimacioMitja<-vector()
errorEstandar<-vector()
tempsExecucio<-matrix(nrow=100,ncol=9)
tempsMitja<-vector()
tempsMitjaPerElement<-vector()
nomsDataset<-vector()
lessThanOne<-vector()
lessThanFive<-vector()
lessThanTen<-vector()
moreThanTen<-vector()

for (i in 2:numDirs)
{
	x<-i-1
	nomsDataset[x]<-paste("D",x,sep="")

	arxiuSample<-paste(list.dirs()[i],"/sample_1024.txt",sep="")
	arxiuSummary<-paste(list.dirs()[i],"/summary_1024.txt",sep="")
	sample<-read.table(arxiuSample,header=TRUE)
	summary<-read.table(arxiuSummary,header=TRUE)
	RealValue<-summary$real	
	cardinalitats[x]<-summary$real

	estimacions[,x]<-sample$est
	errorsRelatius[,x]<-ErrorRelatiu(RealValue,sample$est)
	estimacioMitja[x]<-MeanValue(sample$est)
	errorEstandar[x]<-StandardError(estimacioMitja[x],RealValue,sample$est)
	tempsExecucio[,x]<-sample$timeMs
	tempsMitja[x]<-ExecutionTime(sample$timeMs)
	tempsMitjaPerElement[x]<-MeanTimePerElement(sample$timeMs,summary$total)
	lessThanOne[x]<-LessOnePerCent(errorsRelatius[,x])
	lessThanFive[x]<-BetweenOneFive(errorsRelatius[,x])
	lessThanTen[x]<-BetweenFiveTen(errorsRelatius[,x])
	moreThanTen[x]<-MoreThanTen(errorsRelatius[,x])
}

mostraInformacio<-function(dataset)
{
	nomDataset<-paste("./D",dataset,sep="")

	arxiuSample<-paste(nomDataset,"/sample_1024.txt",sep="")
	arxiuSummary<-paste(nomDataset,"/summary_1024.txt",sep="")
	sample<-read.table(arxiuSample,header=TRUE)
	summary<-read.table(arxiuSummary,header=TRUE)

	RealValue<-summary$real

	par(mfrow=c(1,4))

	estim<-sample$est
	errorsRel<-ErrorRelatiu(RealValue,sample$est)
	tmpExec<-sample$timeMs

	barplot(estim, main=paste("Estimacions ",nomDataset,sep=""),
		xlab="Execucions",names.arg=seq(100),col="red") 
	barplot(errorsRel, main=paste("Errors Relatius ",nomDataset,sep=""),
		xlab="Execucions",names=seq(100),col="blue")
	barplot(tmpExec, main=paste("Temps d'execucio ",nomDataset,sep=""),
		xlab="Execucions",names=seq(100),col="green")

	numErrors<-vector()
	numErrors[1]<-LessOnePerCent(errorsRel)
	numErrors[2]<-BetweenOneFive(errorsRel)
	numErrors[3]<-BetweenFiveTen(errorsRel)
	numErrors[4]<-MoreThanTen(errorsRel)


	barplot(numErrors, main=paste("Numero Errors ",nomDataset,sep=""),
		xlab="Execucions",names=c('<1%','<5%','<10%','>=10%'),col="yellow")	

	aux <- list()
	aux[[1]] <- MeanValue(sample$est)
	aux[[2]] <- summary$real
	aux[[3]] <- StandardError(aux[[1]],RealValue,sample$est)
	aux[[4]] <- ExecutionTime(sample$timeMs)
	aux[[5]] <- MeanTimePerElement(sample$timeMs,summary$total)

	result<-t(do.call(rbind,aux))
	colnames(result)<-c('Estimacio mitjana','Cardinalitat','Error estandar','Temps Mitja','Temps Mitja per Element')
	rownames(result)<-c(nomDataset)
	result<-as.table(result)
	return (result)
}

mostraErrorEstandar<-function()
{
	numDirs<-length(list.dirs())
	errorEstandar<-vector()
	for (i in 2:numDirs)
	{
	x<-i-1
	nomsDataset[x]<-paste("D",x,sep="")

	arxiuSample<-paste(list.dirs()[i],"/sample_1024.txt",sep="")
	arxiuSummary<-paste(list.dirs()[i],"/summary_1024.txt",sep="")
	sample<-read.table(arxiuSample,header=TRUE)
	summary<-read.table(arxiuSummary,header=TRUE)
	RealValue<-summary$real	

	estimacioMitja<-MeanValue(sample$est)
	errorEstandar[x]<-StandardError(estimacioMitja,RealValue,sample$est)
	}
	barplot(errorEstandar, main="Error Estandar",xlab="Dataset",
		names.arg=nomsDataset,col="red") 
}

mostraEstimacioMitja<-function()
{
	numDirs<-length(list.dirs())
	estimacioMitja<-vector()
	for (i in 2:numDirs)
	{
	x<-i-1
	nomsDataset[x]<-paste("D",x,sep="")

	arxiuSample<-paste(list.dirs()[i],"/sample_1024.txt",sep="")
	sample<-read.table(arxiuSample,header=TRUE)

	estimacioMitja[x]<-MeanValue(sample$est)
	}
	barplot(estimacioMitja, main="EstimacioMitja",xlab="Dataset",
		names.arg=nomsDataset,col="dark blue") 
}


mostraTempsPerElement<-function()
{
	numDirs<-length(list.dirs())
	tempsMitjaPerElement<-vector()
	for (i in 2:numDirs)
	{
	x<-i-1
	nomsDataset[x]<-paste("D",x,sep="")

	arxiuSample<-paste(list.dirs()[i],"/sample_1024.txt",sep="")
	sample<-read.table(arxiuSample,header=TRUE)
	arxiuSummary<-paste(list.dirs()[i],"/summary_1024.txt",sep="")
	summary<-read.table(arxiuSummary,header=TRUE)

	tempsMitjaPerElement[x]<-MeanTimePerElement(sample$timeMs,summary$total)
	}
	barplot(tempsMitjaPerElement, main="Temps Mitja per Element",xlab="Dataset",
		names.arg=nomsDataset,col="dark green") 
}

