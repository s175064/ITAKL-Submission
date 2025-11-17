function [ elevation ] = get_elevation_fuct(angle1_deg, angle2_deg, rows, cols, center1, center2, radius)
% takes min and max elevation angles and generates a 3d segment across
% sagittal images
center = [center1, center2];  % Center coordinates of the circle

% Create a meshgrid
[x, y] = meshgrid(1:cols, 1:rows);

% Calculate polar coordinates relative to the center
theta = atan2(y - center(2), x - center(1));
theta = mod(theta, 2*pi);  % Ensure theta is within [0, 2*pi)
theta(theta < 0) = theta(theta < 0) + 2*pi;  % Adjust negative angles

% Convert theta to degrees for angle comparison
theta_deg = theta * (pi/180);

    % Convert angles to radians for comparison
angle1_rad = angle1_deg * (pi/180);
angle2_rad = angle2_deg * (pi/180);

% Create a matrix to store the filled area
filled_matrix_elevation = zeros(rows, cols);

% Iterate through each pixel and fill the area based on the angles
for i = 1:rows
    for j = 1:cols
        % Check if the pixel is within the radius and between the angles
        if sqrt((x(i,j) - center(1))^2 + (y(i,j) - center(2))^2) <= radius && ...
        theta(i,j) >= angle1_rad && theta(i,j) <= angle2_rad
        filled_matrix_elevation(i,j) = 1; % Set to 1 to indicate filled area
        end
    end
end

elevation = zeros(182, 218, 182); 
for i=1:182
    elevation(i, :, :) = filled_matrix_elevation;
end;
hdr = spm_vol('/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/MD/warpedDartel.nii');
hdr.fname = '/project/radiology/ANSIR_lab/shared/s175064_workspace/HS_multicontrast_final/elevation.nii';
wfu_writeimage(hdr, elevation);
end

