function fn = f_thrust_model(altitude_m, mach_nb, isa_dev, n1)
%F_FN_MODEL Summary of this function goes here
%   Detailed explanation goes here
F_nmax = 352.9 * 10^3; % N

delta = m_atmos.f_delta(altitude_m);

theta = m_atmos.f_theta(altitude_m, isa_dev);

F_nmax_c = F_nmax / delta;

% Modèle de poussée:
p00 = +0.0072538779; p01 = -0.0152486559; p02 = -0.2872341189;
p03 = +0.1855958598; p10 = -0.0018632306; p11 = -0.0015972827;
p12 = +0.0047803814; p13 = -0.0067222190; p20 = +0.0002148330;
p21 = -0.0000421767; p22 = +0.0001528177; p23 = +0.0000359784; 
p30 = -0.0000052656; p31 = -0.0000014625; p32 = -0.0000011862;
p40 = +0.0000000713; p41 = +0.0000000128; p50 = -0.0000000003;

f_fn = @(x, y) p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + ...
    p30*x^3 + p21*x^2*y + p12*x*y^2 + p03*y^3 + p40*x^4 + ...
    p31*x^3*y + p22*x^2*y^2 + p13*x*y^3 + p50*x^5 + p41*x^4*y + ...
    p32*x^3*y^2 + p23*x^2*y^3;

fn = f_fn(n1 / sqrt(theta), mach_nb) * F_nmax_c;

%fn = fn * delta;

end