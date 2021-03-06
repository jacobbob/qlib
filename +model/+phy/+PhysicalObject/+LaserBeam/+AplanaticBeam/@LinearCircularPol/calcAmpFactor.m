function calcAmpFactor( obj, Ppower)
%calcAmpFactor function get the amplitude coefficient for an incident beam
%with focal plane power Ppower
%
%   Detailed explanation goes here
k=obj.k;
px=obj.incBeam.px; py=obj.incBeam.py;
Z=obj.lens.work_medium.Z;
n1=obj.lens.inc_medium.n;
n2=obj.lens.work_medium.n;
f=obj.lens.focal_distance;

nPiece=10;
[aList, wList]=obj.alpha_sampling(nPiece);
sinA=sin(aList); cosA=cos(aList);
pp=px+1.j*py; pm=px-1.j*py;
p=obj.incBeam.p;l=obj.incBeam.l;

y=sqrt(2.0)*n2*sinA/obj.f0/obj.lens.NA;
if (px==2 || py==2)%radially and azimuthal polarized
    Q1a=1/Z*n1/n2*exp(-y.*y).*sinA.^3.*cosA;
    P1=pi/k^2*y.^2./sinA.^2.*Q1a; 
    Pfocal=wList*P1.';
else %LG linearly and circularly polarization
    Pa=y.^abs(l) .* laguerreL(p, abs(l), y.*y);
    %     Z=377.0/n2;% The wave impedance of working medium.
    Q1a=1/Z*n1/n2*Pa.^2.*exp(-y.*y).*(1+cosA).^2.*sinA;
    Q2a=1/Z*n1/n2*Pa.^2.*exp(-y.*y).*(1-cosA).^2.*sinA;
    P1=pi/4/k^2*(abs(px)^2+abs(py)^2).*Q1a;
    P2=-pi/8/k^2*(abs(pp)^2+abs(pm)^2).*Q2a;
    Pfocal=wList*P1.'+wList*P2.';
end
amp=sqrt(Ppower/Pfocal)*1e6; % the 1e6 is because we use um as unit.
yitaf=1i*k*f*exp(-1i*k*f);%objective lens at right
% yitaf=-1i*k*f*exp(1i*k*f);%objective lens at left
phase=angle(yitaf);
amp=amp*exp(1i*phase);
obj.AmplitudeFactor=amp;
obj.focBeam.setAmplitudeFactor(amp);
end