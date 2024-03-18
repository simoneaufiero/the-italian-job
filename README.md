# the-italian-job

In what follows, we are going to compare the Mean-Variance, Black-Littermann, Pure Bayesian and Global Minimum Variance asset allocation methods applied to a pool of Italian stocks to determine their perfomances, pros and cons.

First of all, we should decide whether to use linear or continuously compounded returns. We chose the latter for two reasons: compounded returns are stripped of the information about the time interval between observation, and therefore they are much more consistent when forecasting and projecting data as it is our case. 

Furthermore, this choice allows us to be consistent with the Black-Scholes-Merton model, which is a very effective (although not perfect) representation of the stock market, where prices behave as a geometric Brownian Motion, and their rate of change is therefore distributed as a gaussian random variable. 

Real returns unfortunately are not distributed like gaussian random variables, and we can test this using the Jarque-Bera test for normality.

We are now ready to look at our pool's statistics.
