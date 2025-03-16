nrep = 1;
sim_state_tcs_only = 0;
T = T{1};

[X,T,Gamma] = simhmmmar(T,hmm,Gamma,nrep,sim_state_tcs_only);