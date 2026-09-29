function linear_transform_explorer(LT, steps, pause1, pause2)
%LINEAR_TRANSFORM_EXPLORER Explore a linear transformation
%  LINEAR_TRANSFORM_EXPLORER(LT, STEPS, PAUSE1, PAUSE2)
%
%  Explores a 2-dimensional linear transformation.
%  This function creates a graph on the left showing vectors
%  around the unit circle (using STEPS steps) in different colors.
%  On the right, the linear projection of these vectors using
%  the transformation LT is shown.  The data are plotted slowly
%  so the user can develop a feel for the transformation being
%  made by LT.
%
%  PAUSE1 is how long, in seconds, the system should pause after plotting
%  a vector on the unit circle. PAUSE2 is how long, in seconds, the system
%  should pause after plotting the corresponding vector on the transform
%  axes.


figure;

subplot(2,2,1);
subplot(2,2,2);

 
NUM_COLORS = 256;
colors = jet(NUM_COLORS);

angles = 0:(2*pi/steps):2*pi-2*pi/steps;  % make STEPS angles
projection_points = [ cos(angles)' sin(angles)' ];

 % first make the transformation without plotting to get the axes scale
projected_points = projection_points * LT;
mx = max(projected_points(:)); % get the overall maximum


for i=1:length(angles),
	c = 1+round((NUM_COLORS-1)*angles(i)/(2*pi));
	mycolor = colors(c,:);
	subplot(2,2,1);
	title(['The unit circle']);
	hold on;
	plot([0 projection_points(i,1)],[0 projection_points(i,2)],'color',mycolor);
	axis([-1 1 -1 1]);
    axis equal
	box off;
	pause(pause1);
	subplot(2,2,2);
	hold on;
	plot([0 projected_points(i,1)],[0 projected_points(i,2)],'color',mycolor);
	title(['The linear transformation']);
	axis([-1 1 -1 1]*mx);
    axis equal
	pause(pause2);    
end;

[V,D] = eig(LT);

for j=[-1 1],
	for i=1:size(V,2),
		subplot(2,2,3);
		my_angle = mod(atan2(j*V(1,i),j*V(2,i)), 2*pi);  % find the angle on the unit circle
		c = 1+round((NUM_COLORS-1)*my_angle/(2*pi));
		mycolor = colors(c,:);
		hold on;
		plot([0 j*V(1,i)],[0 j*V(2,i)],'color',mycolor);
		title(['Eigenvectors of the transform (+/-)']);
		axis([-1 1 -1 1]);
        axis equal
		pause(pause1);
	
		subplot(2,2,4);
		mypt = j*V(:,i)' * LT;
		hold on;
		plot([0 mypt(1)],[0 mypt(2)],'color',mycolor);
		title(['Transformed eigenvectors of the transform (+/-)']);
		axis([-1 1 -1 1]*mx); 
        axis equal
		pause(pause2);
	end;
end;
        
