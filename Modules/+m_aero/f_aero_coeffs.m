function [cls, cds, cms] = f_aero_coeffs(plane, alpha_deg, mach_nb, dstab)

% Total wing-body-tail contributions
[clwb, cdwb, cmwb] = m_aero.f_wing_coeffs(plane.aeroCoeffs, alpha_deg, mach_nb);

downwash = m_aero.f_downwash(alpha_deg);

alpha_ht = alpha_deg - downwash + dstab;

[clht, cdht, cmht] = m_aero.f_stab_coeffs(plane.aeroCoeffs, alpha_ht, mach_nb, downwash);


cls = clwb + clht;
cds = cdwb + cdht;
cms = cmwb + plane.stabArea*plane.stabX/(plane.wingArea*plane.wingChord)*cmht;

%%% End of the function
end