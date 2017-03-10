library(scales)

allpp=read.csv("outputs/queryOutput.csv") #result of the command: ./runQuery.py -o outputs/queryOutput.csv -qf queries/all -d "," 


pdf("img/bipartite_network.pdf",width=12)
tab=plotNetwork(table(allpp[,c("fplmunName","pplace")]))
dev.off()

cab=as.data.frame(tab)
colnames(tab)=c("fp","pp", "w")
write.csv(tab,"outputs/list_edge_bipartite.csv")
write.csv(table(allpp[,c("fplmunName","pplace")]),"outputs/matrice_bipartite.csv")




plotNetwork<-function(mat,city=""){
    res=c()
    xmax=max(nrow(mat),ncol(mat))
    xmin=min(nrow(mat),ncol(mat))
    begin=(xmax-xmin)*2
    f=0
    a=0
    if(nrow(mat)>ncol(mat)){a = begin}else{f=begin}
    pp=1:nrow(mat)*4+f
    fp=1:ncol(mat)*10+(a-150)
    ppsum=apply(mat,1,sum)
    fpsum=apply(mat,2,sum)
    pporder=order(ppsum)
    fporder=order(fpsum,decreasing=T)
    ptsize=3
    cx0=c()
    cy0=c()
    cx1=c()
    cy1=c()
    plot(pp,rep(-1,nrow(mat)),cex=log(ppsum)[pporder],bty="n",ylim=c(-2.0,2.00),col=alpha("dark green",0.8),pch=20,xaxt="n",xlab="",yaxt="n", ylab="",xlim=c(-10,xmax*4),type="n")
    for( p in 1:(nrow(mat))){
	for(f in 1:(ncol(mat))){
	    xp=pp[pporder[p]]
	    yp=-1
	    xf=fp[fporder[f]]
	    yf=1
	    if(mat[pporder[p],fporder[f]] > 0 ){
	    segments(x0=xf,y0=yf-.05,x1=xp,y1=yp+.05,col=alpha("black",.6),lwd=log(mat[pporder[p],fporder[f]])+.5)
	    res=rbind(res,c(rownames(mat)[pporder[p]],colnames(mat)[fporder[f]],mat[pporder[p],fporder[f]]))
	    }
	}
    }
    points(pp,rep(-1,nrow(mat)),cex=log(ppsum)[pporder]+.5,bty="n",ylim=c(-2.0,2.00),col=alpha("dark green",0.8),pch=20,xaxt="n",xlab="",yaxt="n", ylab="",xlim=c(-10,xmax*4))
    text(pp,rep(-1,nrow(mat))-log(ppsum)[pporder]/40,label=rownames(mat)[pporder],cex=.5,srt=60,c(1,1))
    points(fp,rep(1,ncol(mat)),cex=log(fpsum)[fporder]+.5,col=alpha("dark orange",0.8),pch=20)
    text(fp,rep(1,ncol(mat))+log(fpsum)[fporder]/40,label=colnames(mat)[fporder],cex=.5,srt=300,adj=c(1,1))
    text(-8+f,-1,"Finding")
    text(-5+a,1,"Prod.")
    return(res)
}

