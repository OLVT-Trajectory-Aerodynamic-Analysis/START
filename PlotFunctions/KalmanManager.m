function output = KalmanFilter(data)

aX = data.acceleration.Xacceleration;
aY = data.acceleration.Yacceleration;
aZ = data.acceleration.Zacceleration;
aList = [aX' aY' aZ'];

yaw = data.gyro.yaw;
pitch = data.gyro.pitch;
roll = data.gyro.roll;
gyroList = [yaw' pitch' roll'];

% The following was copied from HW:
Nsamples = length(aX); % # of data points (using aX assuming equal lengths)
EulerSaved = zeros(Nsamples, 3);

dt = 0.1; % seconds per time-step
psi = 0 ; % initial yaw   [rad]
theta=0 ; % initial pitch [rad]
phi = 0 ; % initial roll  [rad]

%This code iterates every time step and corrects it
for k=1:Nsamples
  w1 = gyroList(k,1); w2 = gyroList(k,2); w3 = gyroList(k,3);
  A = eye(4) + dt*1/2*[ 0   -w1  -w2  -w3 ;
                        w1   0    w3  -w2 ;
                        w2  -w3   0    w1 ;
                        w3   w2  -w1   0  ];
  % %The following is based on the assumption that the sensor is at CoM and
  % %the body is not accelerating. Needs changing.
  % [f1 f2] = GetAccel(); % load accelerometer data                 
  % [phi theta] = EulerAccel(f1, f2); % radians
  
  z = Euler3212EP([ psi theta phi ]');
  [psi theta phi] = EulerKalman(A, z); % radians
  
  EulerSaved(k, :) = [ psi theta phi ];
end 

PsiSaved   = EulerSaved(:, 1) * 180/pi;
ThetaSaved = EulerSaved(:, 2) * 180/pi;
PhiSaved   = EulerSaved(:, 3) * 180/pi;

t = 0:dt:Nsamples*dt-dt;

