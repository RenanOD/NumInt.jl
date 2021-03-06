export adaptive_simpson
export adaptive_simpson2

function adaptive_simpson(f::Function, a, b; tol::Float64 = 1.0e-10, N::Int = 128)
  Va = fill(1.0, N); Vb = fill(1.0, N)
  Vfa = ones(Vb); Vfb = ones(Vb)
  Vfc = ones(Vb); Vfm1 = ones(Vb); Vfm2 = ones(Vb)
  i = 1; approx = 0; Va[1] = a; Vb[1] = b; m = 0
  Vfa[i] = f(a);   Vfb[i] = f(b);   Vfc[i] = f((a + b)/2)
  Vfm1[1] = f(a + (b - a)/4); Vfm2[1] = f(b - (b - a)/4)

  while i > 0
    atemp = Va[i]; btemp = Vb[i]; htemp = (btemp - atemp)/2
    fatemp = Vfa[i]; fbtemp = Vfb[i]
    fctemp = Vfc[i]; fm1temp = Vfm1[i]; fm2temp = Vfm2[i]
    S2 = (fatemp + 4(fm1temp + fm2temp) + 2fctemp + fbtemp)*htemp/6
    toltemp = 15tol/((b - a)/(btemp - atemp))
    i -= 1

    if abs((fatemp + 4fctemp + fbtemp)*htemp/3 - S2) < toltemp
      approx += S2
    else
      if ((b - a)/(btemp - atemp) > N)
        approx += S2
      else
        i += 1
        Va[i] = btemp - htemp; Vb[i] = btemp; Vfa[i] = fctemp; Vfb[i] = fbtemp
        Vfc[i] = fm2temp; Vfm1[i] = f(Va[i] + (Vb[i] - Va[i])/4)
        Vfm2[i] = f(Vb[i] - (Vb[i] - Va[i])/4)
        i += 1
        Va[i] = atemp; Vb[i] = btemp - htemp; Vfa[i] = fatemp; Vfb[i] = fctemp
        Vfc[i] = fm1temp; Vfm1[i] = f(Va[i] + (Vb[i] - Va[i])/4)
        Vfm2[i] = f(Vb[i] - (Vb[i] - Va[i])/4)
      end
    end
  end
  return approx
end

function adaptive_simpson2(f::Function, a, b; tol::Float64 = 1.0e-6, hlim::Float64 = 1/1024)
  h = b - a; fa = f(a); fm1 = f(a + h/4); fm = f(a + h/2); fm2 = f(a + 3h/4); fb = f(b)
  S4 = h*(fa + 4(fm1 + fm2) + 2fm + fb)/12
  if abs(S4 - h*(fa + 4fm + fb)/6) < 15tol || h/4 < hlim
    return S4
  else
    m = a + h/2
    return adaptive_simpson2(f, a, m, tol/2, hlim, fa, fm1, fm) + adaptive_simpson2(f, m, b, tol/2, hlim, fm, fm2, fb)
  end
end

function adaptive_simpson2(f::Function, a, b, tol::Float64, hlim::Float64, fa, fm, fb)
  h = b - a; fm1 = f(a + h/4); fm2 = f(a + 3h/4)
  S4 = h*(fa + 4(fm1 + fm2) + 2fm + fb)/12
  if abs(S4 - h*(fa + 4fm + fb)/6) < 15tol || h/4 < hlim
    return S4
  else
    m = a + h/2
    return adaptive_simpson2(f, a, m, tol/2, hlim, fa, fm1, fm) + adaptive_simpson2(f, m, b, tol/2, hlim, fm, fm2, fb)
  end
end