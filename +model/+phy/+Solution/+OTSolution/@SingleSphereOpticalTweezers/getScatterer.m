function scatterer = getScatterer( obj )
%GETSCATTERER Summary of this function goes here
%   Detailed explanation goes here
    import model.phy.PhysicalObject.Scatterer.SphereScatter
    
    postition = obj.parameters.SpherePosition;
    radius    = obj.parameters.SphereRadius;
    medium    = obj.parameters.SphereMedium;
    
    scatterer = SphereScatter(postition,radius,medium);
end

