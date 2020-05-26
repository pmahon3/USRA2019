library(nimble)
nimCode <- nimbleCode(
  
  {
    ##Population level likelihood
    for ( i in 1:nBirds ){
      
      ##Individual level likelihood
      for ( j in 1:nDays-1 ){
        
        ##Up until the penultimate day
        for ( k in 1:nObservations ){
          
          
          
          y[i,j,k] ~ dnorm( 
            mu[ i, 
                step( t[i,j,k] - delta[i,j,1] ) + step( t[i,j,k] - delta[i,j, 2] ) + 1
            ] , 
            
            tau[ i, 
                 step( t[i,j,k] - delta[i,j,1] ) + step( t[i,j,k] - delta[i,j, 2] ) + 1
            ]
          )
          
        }
      }
      
      
      ##The ultimate day
      for ( k in 1:nObservations ){
        
        
        
        y[i,nDays,k] ~ dnorm( 
          mu[ i,
              step( t[i,nDays,k] - delta[i,nDays,1] ) + step( t[i,nDays,k] - delta[i,nDays, 2] - delta_prime ) + 1
          ],
          tau[ i, 
               step( t[i,nDays,k] - delta[i,nDays,1] ) + step( t[i,nDays,k] - delta[i,nDays, 2] - delta_prime ) + 1
          ]
        )
        
      }
    }
    
    ##Population level priors
    for( i in 1:nBirds ){
      
      ##Individual level priors
      for( j in 1:3 ){
        mu[i, j ] ~ dnorm( mu_mu_y[j], 1 / ( sd_mu_y[j]^2 ) ) 
        tau[ i, j] ~ dgamma( 10, 1/2 )
      }
      
      for( j in 1:nDays ){
        delta[i,j, 1] ~ dnorm( mu_delta[i,1], tau_delta[i,1] ) 
        delta[i,j, 2] ~ dnorm( mu_delta[i,2], tau_delta[i,2] )
      }
    
      mu_delta[i,1] ~ dnorm(mu_mu_delta1, tau_mu_delta1)
      mu_delta[i,2] ~ dnorm(mu_mu_delta2, tau_mu_delta2)
      
      tau_delta[i,1] ~ dgamma(1, 1/2)
      tau_delta[i,2]~ dgamma(1, 1/2)
      
    }
  
    delta_prime ~ dnorm( mu_delta_prime, 1 )
    
    mu_mu_delta1 ~ dnorm(mu_mu_mu_delta1, tau_mu_mu_delta1)
    mu_mu_delta2 ~ dnorm(mu_mu_mu_delta2, tau_mu_mu_delta2)
    
    tau_mu_mu_delta1 ~ dgamma(1,1/2)
    tau_mu_mu_delta2 ~ dgamma(1,1/2)
    
    tau_mu_delta1 ~ dgamma(1,1/2)
    tau_mu_delta2 ~ dgamma(1,1/2)
  }
)


DELTA_PRIME = 1/4

CONSTANTS = list(
  
  nDays = 10,
  

  nBirds = 10,
  
  nObservations = 96,
  
  interval = 24, 


  ## TOP LEVEL HYPER PARAMETERS
  
  mu_mu_y = c(  one = -80, two = -50,  three = -80  ),
  
  sd_mu_y =  c(   one = 1,   two =  1,  three =  1  ),
  
  mu_mu_delta1 = 6, 
  
  mu_mu_delta2 = 18,
  
  
  # Change Point Shift
  
  mu_delta_prime = 1/4, 
  
  sigma_delta_prime = 1/120
)