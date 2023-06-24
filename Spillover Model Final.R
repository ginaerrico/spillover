library(deSolve)
library(ReacTran)

#No spillover ------------------------------------------------------------

model0<- function (Time, State, Pars) {
  with(as.list(c(State, Pars)), {
    dx1 = x1*(alpha1 - a11*x1 - a12*x2 - (beta11*y1)/(1+e11*x1))-((beta12*y2)/(1+e12*x1))
    dx2 = x2*(alpha2 - a22*x2 - a21*x1 - (beta21*y1)/(1+e21*x2))-((beta22*y2)/(1+e22*x2))
    dy1 = y1*((delta1*beta11*x1)/(1+e11*x1)+(delta2*beta21*x2)/(1+e21*x2))-m
    return(list(c(dx1,dx2, dy1)))
  })
}

#testing outcomes at different intersp. comp. levels
A21=seq(0.01,0.49, by=0.01) #intersp. competition 
A12=seq(0.01,0.49, by=0.01) 
outcome0<- c() #empty outcome vector
a_21<-c()
a_12<-c()

for(i in 1:length(A21))
{
  for(j in 1:length(A12))
  {
    Time <- seq(0, 100, by = 1)
    State <- c(x1=5, x2=5, y1=5) 
    Pars <- c(
      alpha1= 3,
      alpha2= 3,
      a11= 0.5,
      a22= 0.5,
      a21= A21[i],
      a12= A12[j],
      beta11= 0.3,
      beta12= 0.5,
      beta21= 0.3,
      beta22=0,
      e11= 0.1,
      e21= 0.1,
      e12= 0.1,
      e22=0.1,
      delta1= 0.1,
      delta2= 0.1,
      m=0.5,
      y2=0
    )
    out0 <- ode(y = State, func = model0,
               times = Time, parms = Pars)
    outcome0 <- rbind(outcome0, out0[nrow(out0),-1])
    a_12<-c(a_12,A12[j])
    a_21<-c(a_21,A21[i])
    
  }
}

outcome_P1<-(outcome0[,1])
outcome_P2<-(outcome0[,2])
outcome_Y1<-(outcome0[,3])

#printing the outcome
cc<-c() #vector of color
for(i in 1:length(outcome_P2)) {
  
  if((outcome_P2[i]>1 & outcome_P1[i]<1) & outcome_Y1[i]>0)
  {
    cc<-c(cc,"palegreen2") # x2 is winning
  }
  if((outcome_P2[i]<1 & outcome_P1[i]>1) & outcome_Y1[i]>0)
  {
    cc<-c(cc,"darkgreen") # x1 winning
  }
  if((outcome_P2[i]>1 & outcome_P1[i]>1) & outcome_Y1[i]>0)
  {
    cc<-c(cc,"orange1") # coexistence
  }
  if((outcome_P2[i]<1 & outcome_P1[i]<1)| (outcome_Y1[i]<0))
  {cc<-c(cc,"lightgrey")} #crash
  
  plot(a_21,a_12,pch=20,col=cc,xlab="Plant 2", ylab="Plant 1")
}

# Diffusion -----------------------------------------------------------------
##To create the turbulence vector
#turb<-runif(n=51, min=0.1, max=2)

model1 <- function (Time, State, Pars) {
  with(as.list(c(State, Pars)), {
    
    x1 <- State[1:N]
    x2 <- State[(N+1):(2*N)]
    y1<-State[((2*N)+1):(3*N)]
    y2<-State[((3*N)+1):(4*N)]
    
    dx1 = x1*(alpha1 - a11*x1 - a12*x2 - ((beta11*y1)/(1+e11*x1))-((beta12*y2)/(1+e12*x1)))
    dx2 = x2*(alpha2 - a22*x2 - a21*x1 - ((beta21*y1)/(1+e21*x2))-((beta22*y2)/(1+e22*x2)))
    dy1 = y1*((delta1*beta11*x1)/(1+e11*x1)+(delta2*beta21*x2)/(1+e21*x2))-m
    dy2 = tran.1D (C = y2, C.up = 5, C.down = 0,D = 10, dx = Grid, v=0)$dC 
    
    return(list(c(dx1,dx2, dy1,dy2)))
  })
}

N<-50
Grid <- setup.grid.1D(x.up = 0, x.down = 100, N = N)

x1ini <- rep(x = 5, times = N)
x2ini <- rep(x = 5, times = N)
y1ini <- rep(x = 5, times = N)
y2ini<-c(2,rep(x = 0, times = (N-1)))

State <- c(x1ini, x2ini,y1ini,y2ini)
Time <- seq(0, 100, by = 1)

A21=seq(0.01,0.49, by=0.01) #varying comp of x1 on x2
A12=seq(0.01,0.49, by=0.01) #
outcome01<- c() #empty outcome vector
a_21<-c()
a_12<-c()

for(i in 1:length(A21))
{
  for(j in 1:length(A12))
  {
    Pars <- c(
      alpha1= 3,
      alpha2= 3,
      a11= 0.5,
      a22= 0.5,
      a21= A21[i],
      a12= A12[j],
      beta11= 0.5,
      beta21= 0.5,
      beta12= 0.3, #effect of spillover on P1
      beta22=0.3, #effect of spillover on P2
      e11= 0.1,
      e21= 0.1,
      e12= 0.3,  
      e22=0.3,
      delta1= 0.1,
      delta2= 0.1,
      m=0.5
    )
    out01 <- ode.1D(y = State, func = model1,
                  times = Time, parms = Pars, nspec = 4,
                  names = c("x1","x2","y1","y2"), dimens = N)
    outcome01 <- rbind(outcome01, out01[nrow(out01),-1])
    a_12<-c(a_12,A12[j])
    a_21<-c(a_21,A21[i])
    
  }
}

outcome_P1<-(outcome01[,1:50])
outcome_P2<-(outcome01[,51:100])
outcome_Y1<-(outcome01[,101:150])


for (k in 1:50) { #looping through the space
  cc<-c() #vector of color
  for(i in 1:nrow(outcome_P2))
    
  {
    if(outcome_P2[i,k]<1 & outcome_P1[i,k]>1 & outcome_Y1[i,k]>0)
      
    {
      cc<-c(cc,"palegreen2") # x1 is winning
    }
    if(outcome_P2[i,k]>1 & outcome_P1[i,k]<1 & outcome_Y1[i,k]>0)
    {
      cc<-c(cc,"darkgreen") # x2 winning
    }
    if(outcome_P2[i,k]>1 & outcome_P1[i,k]>1 & outcome_Y1[i,k]>0)
    {
      cc<-c(cc,"orange1") # coexistence
    }
    if((outcome_P2[i,k]<1 & outcome_P1[i,k]<1) | (outcome_Y1[i,k]<0))
    {cc<-c(cc,"lightgrey")} #crash
  }
  plot(a_12,a_21,pch=20,col=cc,xlab="Plant 2",ylab="Plant 1") # competition
  dev.copy(png,paste("A",k,".png",sep="")) #saving on computer
  dev.off()
}


# Specific Competition Example --------------------------------------------
# with spillover at 40m in the forest, Plant 2 wins
Pars <- c(alpha1 = 3,
          alpha2 = 3,
          a11=0.5,
          a22=0.5,
          a12=0.05,
          a21=0.2,
          beta11=0.5,
          beta21=0.5,
          beta12=0.3,
          beta22=0,
          delta1 = 0.1,
          delta2 = 0.1,
          e21=0.1,
          e11=0.1,
          e12=0.5,
          e22=0,
          m=0.5) #I set up the specific parameters (where I put a star on the coexistence outcome figure)
out <- ode.1D(y = State, func = model1,
              times = Time, parms = Pars, nspec = 4,
              names = c("x1","x2","y1","y2"), dimens = N) #I solve the diffusion model as usual with the same starting value as usual but with these specific parameters
out<-out[-1,-1] #I always remove the first row and first column because they use give time and space.
out<-out[,c(20,70,120,170)] #This is specifically to focus on the dynamics of x1,x2,y2,and y1 at 40 meters
plot(1:100,out[,1],col="darkolivegreen2",type="l",lwd=4,ylim=c(0,5))
points(1:100,out[,2],col="darkgreen",type="l",lwd=4)
points(1:100,out[,3], col="royalblue3",type="l",lty=2,lwd=4)
points(1:100,out[,4],col="violetred", type="l",lty=3,lwd=4)

legend("topright", c("Plant 1", "Plant 2", "Pathogen 1","Spillover"), lty = c(1,2,3,3), box.lwd = 0, lwd=4, col=c("darkolivegreen2","darkgreen","royalblue3","violetred"))
