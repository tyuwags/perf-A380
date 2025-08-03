function [cls, cds, cms] = f_aero_coeffs(plane, alpha_deg, mach_nb, dstab)

% Total wing-body-tail contributions
[clwb, cdwb, cmwb] = m_aero.f_wing_coeffs(plane, alpha_deg, mach_nb);

downwash = m_aero.f_downwash(alpha_deg);

alpha_ht = alpha_deg - downwash + dstab;

[clht, cdht, cmht] = m_aero.f_stab_coeffs(plane, alpha_ht, mach_nb, downwash);


cls = clwb + plane.stabArea/plane.wingArea*(clht*cosd(downwash) - cdht*sind(downwash));

cds = cdwb + plane.stabArea/plane.wingArea*(cdht*cosd(downwash) + clht*sind(downwash));

cms = cmwb - plane.stabArea*plane.stabX/(plane.wingArea*plane.wingChord)*(clht*cosd(downwash) - cdht*sind(downwash)) + plane.stabArea*plane.stabZ/(plane.wingArea*plane.wingChord)*(cdht*cosd(downwash) + clht*sind(downwash));

%%% End of the function
end

