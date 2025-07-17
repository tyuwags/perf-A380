function m_moteur = f_moment(plane, fn, phi_t)
%F_MOMENT Summary of this function goes here
%   Detailed explanation goes here

m_moteur = 0;
if plane.numEngines == 4
    fn = fn / 4;
    m_moteur = plane.enginePosOuter(2) * fn * cosd(phi_t) + plane.enginePosOuter(1) * fn * sind(phi_t);
else 
    fn = fn / 2;
end

m_moteur = m_moteur + plane.enginePosCenter(2) * fn * cosd(phi_t) + plane.enginePosCenter(1) * fn * sind(phi_t);

end