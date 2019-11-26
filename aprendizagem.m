function N = aprendizagem (escolha,tmax,t,No,Nt)
%calcula a aprendizagem dependendo da escolha do usuario
%N = (escolha,tmax,t,No,Nt)
%utilizacao -> escolha: 1 2 3 4: (tmax = treinamento*Nepocas)
%1: N = constante, 2: N = No*(1-(t/tmax))
%3: N = No/(1+t), 4: N = No*((Nt/No)^(t/tmax))
if escolha == 1,
    N = No;
elseif escolha == 2,
    N = No*(1-(t/tmax));
elseif escolha == 3,
    N = No/(1+t);
elseif escolha == 4,
    N = No*((Nt/No)^(t/tmax));
end