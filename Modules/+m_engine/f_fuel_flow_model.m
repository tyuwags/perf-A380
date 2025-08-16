function f_wf = f_fuel_flow_model(altitude_m, mach_nb, isa_dev, n1)
%F_WF_MODE Summary of this function goes here
%   Detailed explanation goes here
W_fmax = 9856.8; % kg/h

W_fmax = W_fmax / 3600; % kg/s

theta = m_atmos.f_theta(altitude_m, isa_dev);

delta = m_atmos.f_delta(altitude_m);

W_fmax_c = W_fmax / (delta * sqrt(theta));

% Modèle de débit carburant
p00 = -0.001557817987; p01 = +0.014020968264; p02 = +0.006629228294; 
p03 = -0.026175772666; p10 = +0.000372741439; p11 = -0.005864395066; 
p12 = +0.006022804654; p13 = +0.000021874793; p20 = +0.000011163272; 
p21 = +0.000158667185; p22 = -0.000165619582; p23 = +0.000000911818; 
p30 = +0.000000084786; p31 = -0.000001111082; p32 = +0.000001161472; 
p40 = -0.000000012528; p41 = -0.000000000126; p50 = +0.000000000130;

f_wf = @(x, y) (p00 + p10*x + p01*y + p20*x^2 + p11*x*y + p02*y^2 + ...
    p30*x^3 + p21*x^2*y + p12*x*y^2 + p03*y^3 + p40*x^4 + ...
    p31*x^3*y + p22*x^2*y^2 + p13*x*y^3 + p50*x^5 + p41*x^4*y + ...
    p32*x^3*y^2 + p23*x^2*y^3) ;

f_wf = f_wf(n1 / sqrt(theta), mach_nb) * W_fmax_c; % output wfc

%f_wf = f_wf / (delta * sqrt(theta));
end