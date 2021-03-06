function sinh_tanh(f, a, b; Nf = 2^5)
  a=BigFloat(a)
  b=BigFloat(b)

  big_one = one(BigFloat)
  h = parse(BigFloat, "10.6")/(Nf - 1)
  nt = 0

  q(k) = e^(-big_one*2*sinh(k))
  subs(k) = (b - a)*q(k)/(big_one + q(k))
  g(k) = 2(b - a)*q(k)*cosh(k)/(big_one + q(k))^2
  approx = f((a + b)/2)*g(zero(BigFloat))*h
  nt+=1

  for k = h:h:big_one*parse(BigFloat, "5.3")
    j = subs(k)
    dxdt = g(k)
    f1 = f(a + j)
    f2 = f(b - j)

    if abs(f1) == Inf || abs(f2) == Inf
      break
    end
    
    nt += 2

    if nt > Nf
      break
    end

  approx += (f1 + f2)*dxdt*h
  end
return approx
end

function sinh_tanh(f, a::BigFloat, b::BigFloat; Nf = 2^5)
 
  big_one = one(BigFloat)
  h = parse(BigFloat, "10")/(Nf - 1)
  nt = 0

  q(k) = e^(-big_one*2*sinh(k))
  subs(k) = (b - a)*q(k)/(big_one + q(k))
  g(k) = 2(b - a)*q(k)*cosh(k)/(big_one + q(k))^2
  approx = f((a + b)/2)*g(zero(BigFloat))*h
  nt+=1

  for k = h:h:big_one*parse(BigFloat, "5")
    j = subs(k)
    dxdt = g(k)
    f1 = f(a + j)
    f2 = f(b - j)

    if abs(f1) == Inf || abs(f2) == Inf
      break
    end
    
    nt += 2

    if nt > Nf
      break
    end

  approx += (f1 + f2)*dxdt*h
  end
return approx
end

function zero_to_inf(f; Nf = 2^5)

  h = 18.0/(Nf - 2)
  nt = 0

  x(k) = e^(pi*sinh(k))
  w(k) = x(k)*pi*cosh(k)
  approx = 0
  for k = -4.5:h:4.5
    f1 = f(x(k))*w(k)
    f2 = f(x(k + 1))*w(k + 1)
    nt += 2

    if nt > Nf
      break
    end

    approx += f1 + f2
  end
  approx = approx*h/2
  return approx
end

function simpsons_rule_inf(f, a, b; Nf = 2^5)
  h = 18/Nf
  x(t) = 1/t
  g(t) = f(x(t))/t^2
  approx = simpsons_rule(g, 1/b, 1/a, Nf = Nf)
  return approx
end

function mid_point(f, a, b; Nf = 2^5)

  h = (b - a)/Nf
  sum = f(a + h/2)
  for i = 1:Nf-1
    sum += f(a + h/2 + i*h)
  end
  approx = h*sum
  return approx
end

function double_inf(f; Nf = 2^5)

  approx = 0
  h = 18/(Nf-1)
  nt = 0
  x(k) = sinh(pi*sinh(k)/2)
  w(k) = cosh(pi*sinh(k)/2)*pi*cosh(k)/2

  for k = -4.5:h:4.5
    approx += (f(x(k))*w(k) + f(x(k + 1))*w(k + 1))*h/2
    nt += 2

    if nt > Nf
      break
    end

  end
  return approx
end

function simpsons_rule(f, a, b; Nf = 2^5)

  n = Nf - 2
  nt = 0

  if n%2 != 0
    n += 1
  end
  h = (b - a)/n
  approx = (f(a) + f(b) + 4f(a + h))
  nt += 3 
  for i = 2:2:n-1
    x = a + i*h
    approx += 2f(x) + 4f(x + h)
    nt += 2

    if nt > Nf
      break
    end 

  end
  return approx*(h/3)
end

function trapezoidal_rule(f, a, b; Nf = 2^5)

  n = Nf - 1
  nt = 0

  h = (b - a)/n
  approx = (f(a) + f(b))/2
  nt += 2
  for i = 1:n-1
    x = a + i*h
    approx += f(x)
    nt += 1

    if nt > Nf
      break
    end
  end
  return approx*h
end

function open_formula(f, a, b; Nf = 200)
  n = Nf + 2
  h = (b - a)/n
  approx = 3/2(f(a + h) + f(b - h))

  for i = 2:n - 2
    approx += f(a + i*h)
  end
  return h*approx
 end
 
function gaussian_quadrature(f, a, b; Nf = 16.0)
  h = 2(b-a)/Nf
  atemp = 0.0
  btemp = h
  approx = 0.0
  x1(atemp, btemp) = (atemp + btemp + sqrt(3)/3*h)/2
  x2(atemp, btemp) = (atemp + btemp - sqrt(3)/3*h)/2

  for k = 1:1:Nf/2
    approx += (f(x1(atemp, btemp)) + f(x2(atemp, btemp)))
    atemp+=h; btemp+=h;
  end

  return approx*h/2
end

function clenshaw_rule(f::Function, a, b; Nf::Int = 16)
  V = fill(1.0, Nf, Nf)
  F = Float64[]; W = fill(1.0, Nf)
  const h = b - a; const M = pi/(Nf - 1)

  for i = 1 : Nf
    if i != 1
      i % 2 != 0 ? W[i] = 2/(1 - (i - 1)^2) : W[i] = 0
      for j = 2 : Nf
        V[i, j] = cos((j - 1)*(i - 1)*M)
      end
    end
    V[i, Nf] *= 0.5
    V[i, 1] = 0.5
   push!(F, f((a + b + cos((i - 1)*M)*h)/2))
  end
  return (W'*(V*F))[1]*h/(Nf - 1)
end

function clenshaw_rule(f::Function, a::BigFloat, b::BigFloat; Nf::Int = 16)
  V = fill(one(BigFloat), Nf, Nf)
  F = BigFloat[]; W = fill(one(BigFloat), Nf)
  const h = b - a; const M = pi/(BigFloat(Nf) - one(BigFloat))

  for i = 1 : Nf
    if i != 1
      i % 2 != 0 ? W[i] = one(BigFloat)*2/(one(BigFloat) - (i - one(BigFloat))^2) : W[i] = zero(BigFloat)
      for j = 2 : Nf
        V[i, j] = cos((BigFloat(j) - one(BigFloat))*(BigFloat(i) - one(BigFloat))*M)
      end
    end
    V[i, Nf] *= 0.5
    V[i, 1] = 0.5
   push!(F, f((a + b + cos((i - one(BigFloat))*M)*h)/2))
  end
  return (W'*(V*F))[1]*h/(BigFloat(Nf) - one(BigFloat))
end

function gauss_legendre(f::Function, a, b; Nf::Int = 16)
  (F, W) = gausslegendre(Nf)
  const h = b - a
  for i = 1 : Nf
    F[i] = f((a + b + h*F[i])/2)
  end
  return (F'*W)[1]*h/2
end