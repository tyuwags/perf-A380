function m_moteur = f_moment(plane, alpha, fn, phi_t)
%F_MOMENT Summary of this function goes here
%   Detailed explanation goes here

m_moteur = 0;
if plane.numEngines == 4
    fn = fn / 4;
    m_moteur = plane.enginePositions(2, 2) * fn * cosd(alpha + phi_t) + plane.enginePositions(2, 1) * fn * sind(alpha + phi_t);
else 
    fn = fn / 2;
end

m_moteur = m_moteur + plane.enginePositions(1, 2) * fn * cosd(alpha + phi_t) + plane.enginePositions(1, 1) * fn * sind(alpha + phi_t);

end