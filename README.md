This is a README text file for running “Spillover Model Final”

To access and run the model, you will need R

Packaged needed: deSolve, ReacTran

Model0: baseline model with two plant species interacting with a resident pathogen in the absence of spillover. #lines 6-13

Investigation of the effects of intraspecific competition on the coexistence outcome of model0. #lines 16-55

Extracting the specific population dynamics #lines 57-59

Summarizing and plotting the outcome of intraspecific competition on long-term coexistence: #lines 62-81
P1<1 P2>1 Y1>0, P2 wins.
P1>1 P2<1 Y1>0, P1 wins.
P1>1 P2>1 Y1>0, Coexistence
P1<1 P2<1  | Y1<0, System crash

Creating the randomized turbulence vector #line 85

Model1: Testing the effects of introduced pathogen. Two plant species interacting with both the resident and introduced pathogen #lines 87-102

##To change wind speed (velocity)
###Wind & no velocity: v=0 #line 98; r=2 #line 110
###Wind & velocity: v=0.25 #line 98; r=2 #line 110
###Wind & turbulence: v=0 #line 98; r=turb #line 110 (turb= turbulence vector #line 85)

Setting up the grid space #lines 104-105

Setting up initial parameters #lines 107-113

Investigation of the effects of intraspecific competition on the coexistence outcome of model1. #lines 115-152

##To set introduced pathogen specificity:
###For generalist: beta12,22= 0.3 #lines 134-135; e12,22= 0.5 #lines 138-139
###For specialist: beta12=0.3 #line 134; beta22=0 #line 135; e12=0.3 #line 138; e22=0 #line 139

Extracting the specific population dynamics #lines 154-156

Summarizing and plotting the outcome of intraspecific competition on long-term coexistence: #lines 159-183
P1<1 P2>1 Y1>0, P2 wins.
P1>1 P2<1 Y1>0, P1 wins.
P1>1 P2>1 Y1>0, Coexistence
P1<1 P2<1  | Y1<0, System crash


Modeling examples with specific competition coefficients 40m into the forest #lines 186-206

Investigation of the effects of intraspecific competition on the coexistence outcome of model1. #lines 188-200

###Competition coefficients for coexistence example: a21= 0.22, a12= 0.15 #line 191
###Competition coefficients for competitive exclusion: a21= 0.2, a12=0.05 #line 191

###To run with just resident pathogen: beta12,22= 0 #lines 196-197; e12,22= 0 #lines 202-203
##To set introduced pathogen specificity:
###For generalist: beta12,22= 0.3 #lines 196-197; e12,22= 0.5 #lines 202-203
###For specialist: beta12=0.3 #line 196; beta22=0 #line 197; e12=0.3 #line 202; e22=0 #line 203

Removing first row and column to omit from analysis #line 208

Making a new vector with the dynamics of x1, x2, y1, and y2 at 40 m #line 209

Plotting the outcome of specific competition over time at 40 m #lines 210-215
Plotting the outcome of x1 at 40m #line 210
Plotting the outcome of x2 at 40m #line 211
Plotting the outcome of y1 at 40m #line 212
Plotting the outcome of y2 at 40m #line 213

Creating figure legend #line 215
