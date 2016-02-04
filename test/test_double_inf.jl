function test_precision_double_inf(g, exact)
  approx=double_inf(g, n = 10)
  @test_approx_eq_eps(exact, approx, 1e-10)
end

function test_double_inf()

  g1(t) = 1/(1 + t^2)
  exact = pi*1.0
  test_precision_double_inf(g1, exact)

  g2(t) = 1/(25 + 4t^2)
  exact = pi/10.0
  test_precision_double_inf(g2, exact)

end

test_double_inf()