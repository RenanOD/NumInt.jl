function print_table(f, a, b, exact)
  
  Nf = [2^4, 2^5, 2^6, 2^7, 2^8, 2^9, 2^10];
  u = size(Nf, 1); k = 1;
  functions = [trapezoidal_rule, simpsons_rule, mid_point, gaussian_quadrature, sinh_tanh];
  t = size(functions, 1);
  
  tabela = cell(u + 1, t + 1)
  tabela[1,1] = "Nf"
  tabela[1,2] = "TR"; tabela[1,3] = "SR"; tabela[1,4] = "MP"; tabela[1,5] = "QG"; tabela[1,6] = "ST"

  for i = 1:u 
    tabela[i + 1,1] = Nf[i];
  end
  
  for k = 1:t
    for i = 2:1:u + 1
      g = functions[k]
      tabela[i, k + 1] = abs(exact - g(f, a, b, Nf = Nf[i - 1]))
    end
  end
  tabela
end