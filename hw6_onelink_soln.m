function hw6_onelink_soln

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN CHANGE
%

% - This line says your name.
params.teamname = 'My Team (My Name and My Other Name)';
% - This line says the file to record your actions.
params.action_filename = 'action.mat';
% - This line says the file to record your movie.
params.movie_filename = 'movie.avi';
% - This line says the file to record your snapshot.
params.snapshot_filename = 'snapshot.pdf';
% - This line says whether or not you want to record a movie --- change it
%   from "false" to "true" and you will record a movie. Note that you must
%   have already recorded actions, before making a movie!
params.makemovie = false;
% - This line says whether or not you want to take a snapshot --- change it
%   from "false" to "true" and you will create a PDF of the figure after
%   the simulation is over.
params.makesnapshot = false;

% - NOTE: The keyboard interface is as follows:
%
%   'q'         causes the simulation to quit (gracefully, saving the
%               actions, the movie, and/or the snapshot)
% 
%   '1'         increases the torque applied to link 1 at the first joint
%   '!'         decreases the torque applied to link 1 at the first joint
%
%   '2'         increases the torque applied to link 2 at the second joint
%   '@'         decreases the torque applied to link 2 at the second joint
%
%   '3'         increases the torque applied to link 3 at the third joint
%   '#'         decreases the torque applied to link 3 at the third joint
%

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN'T CHANGE
%

% Define the geometry and mass properties of the robot.
robot = GetGeometryOfRobot;

% Run the simulation.
RunSimulation(robot,params);

function robot = GetGeometryOfRobot
% - Vertices for base
robot.base.dx=sqrt(2);
robot.base.dy=sqrt(2);
robot.base.dz=0.5;
robot.base.p_in0 = [0.5*robot.base.dx*[-1 1 1 -1 -1 1 1 -1];
                    0.5*robot.base.dy*[-1 -1 -1 -1 1 1 1 1];
                    0.5*robot.base.dz*[-1 -1 1 1 -1 -1 1 1]];
% - Vertices of link #1
robot.link1.dx=2;
robot.link1.dy=2;
robot.link1.dz=1.5;
robot.link1.p_in1 = [0.5*robot.link1.dx*[-1 1 1 -1 -1 1 1 -1];
                     0.5*robot.link1.dy*[-1 -1 -1 -1 1 1 1 1];
                     0.5*robot.link1.dz*[-1 -1 1 1 -1 -1 1 1]];
% - Vertices of link #2
robot.link2.dx=1;
robot.link2.dy=3;
robot.link2.dz=1;
robot.link2.p_in2 = [0.5*robot.link2.dx*[-1 1 1 -1 -1 1 1 -1];
                     0.5*robot.link2.dy*[-1 -1 -1 -1 1 1 1 1];
                     0.5*robot.link2.dz*[-1 -1 1 1 -1 -1 1 1]];
% - Vertices of link #3
robot.link3.dx=1;
robot.link3.dy=4;
robot.link3.dz=1;
robot.link3.p_in3 = [0.5*robot.link3.dx*[-1 1 1 -1 -1 1 1 -1];
                     0.5*robot.link3.dy*[-1 -1 -1 -1 1 1 1 1];
                     0.5*robot.link3.dz*[-1 -1 1 1 -1 -1 1 1]];
% - Create for later use
robot.link1.p_in0 = nan(size(robot.link1.p_in1));
robot.link2.p_in0 = nan(size(robot.link2.p_in2));
robot.link3.p_in0 = nan(size(robot.link3.p_in3));
% - Faces for base and for each link (all are boxes with vertices in the
%   same order)
robot.faces =  [1 2 3;
                3 4 1;
                2 6 7;
                7 3 2;
                6 5 8;
                8 7 6;
                5 1 4;
                4 8 5;
                4 3 7;
                7 8 4;
                5 6 2;
                2 1 5];

% - The density (assumed uniform) of each link
robot.link1.rho = 1;
robot.link2.rho = 1;
robot.link3.rho = 1;

% - Parameters that you may ignore
alpha = 0.5;
beta = 0.35;
delta = 0.05;

% - Parameters that govern the relative position of each frame
%
%       o_10 = robot.a1 + R_1in0*robot.b1
%
%           ... (same for the others)
%
robot.a1 = [0; 0; (alpha+delta)*(robot.link1.dz+robot.base.dz)];
robot.b1 = [0; 0; 0];
robot.a2 = [(alpha+delta)*(robot.link2.dx+robot.link1.dx); 0; 0];
robot.b2 = [0; beta*robot.link2.dy; 0];
robot.a3 = [(alpha+delta)*(robot.link3.dx+robot.link2.dx); beta*robot.link2.dy; 0];
robot.b3 = [0; beta*robot.link3.dy; 0];

% - The points of attachment between links
%
%       p_ABinC means the point of attachment between link A and link B,
%               written in the coordinates of frame C (where "link 0" and
%               "base" are the same thing)
%
robot.p_01in0 = [0;0;(alpha+delta)*robot.base.dz];
robot.p_12in1 = [(alpha+delta)*robot.link1.dx;0;0];
robot.p_23in2 = [(alpha+delta)*robot.link2.dx;beta*robot.link2.dy;0];

% - The coefficient of friction at each joint
robot.kfriction = 1;

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MUST CHANGE
%

% - Mass and moment of inertia of link #1
robot.link1.m = robot.link1.rho*robot.link1.dx*robot.link1.dy*robot.link1.dz;
robot.link1.J_in1 = (robot.link1.m/12)*diag([robot.link1.dy^2+robot.link1.dz^2,robot.link1.dx^2+robot.link1.dz^2,robot.link1.dx^2+robot.link1.dy^2]);

% - Mass and moment of inertia of link #2
robot.link2.m = 1;
robot.link2.J_in2 = eye(3);

% - Mass and moment of inertia of link #3
robot.link3.m = 1;
robot.link3.J_in3 = eye(3);

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN'T CHANGE
%

function RunSimulation(robot,params)

% Create figure.
world = CreateFigure(robot,params);
% Define time at which to start the simulation.
t = 0;
% Define time step.
dt = 2e-2;

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN CHANGE
%

% Define time limit.
tmax = 100;
% Define initial conditions
% - joint angles (configuration)
theta = [0;0;0];
% - joint velocities
thetadot = [0;0;0];
% Define intial motor torques
u1 = 0;
u2 = 0;
u3 = 0;

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN'T CHANGE
%

% Either start making a movie or start storing actions.
global action done
action = [u1;u2;u3];
if (params.makemovie)
    load(params.action_filename);
    myV = VideoWriter(params.movie_filename);
    myV.Quality = 100;
    open(myV);
else
    actionRecord = [];
end

% Loop until 'done' is true.
done = false;
while (~done)
    
    % Either store or retrieve the action.
    if (params.makemovie)
        [actionRecord,curaction,done] = RetrieveAction(actionRecord);
        action = curaction;
    else
        curaction = action;
        actionRecord = StoreAction(actionRecord,curaction);
    end
    
    % Compute input torques applied by SC to each RW.
    u1 = curaction(1);
    u2 = curaction(2);
    u3 = curaction(3);
	
    % Solve ODEs.
    [t,theta,thetadot] = ...
        Simulate(t,dt,...           % <- time and time step
                 theta,thetadot,... % <- state
                 u1,u2,u3,...       % <- applied torques
                 robot);            % <- parameters that describe the robot
	
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MUST CHANGE
%
    
    % Compute: orientation and position of link #1
    %   (R_1in0 and o_1in0)
    R_1in0 = RZ(theta(1));
    o_1in0 = robot.a1+R_1in0*robot.b1;
    
    % Compute: orientation and position of link #2
    %   (R_2in0 and o_2in0 ... hint: first compute R_2in1 and o_2in1)
    R_2in0 = eye(3);
    o_2in0 = zeros(3,1);
    
    % Compute: orientation and position of link #3
    %   (R_3in0 and o_3in0 ... hint: first compute R_3in2 and o_3in2)
    R_3in0 = eye(3);
    o_3in0 = zeros(3,1);
    
    % Compute: robot.link1.p_in0, robot.link2.p_in0, robot.link3.p_in0
    for i=1:size(robot.link1.p_in1,2)
        robot.link1.p_in0(:,i) = o_1in0+R_1in0*robot.link1.p_in1(:,i);
    end
    robot.link2.p_in0 = nan(size(robot.link2.p_in2));
    robot.link3.p_in0 = nan(size(robot.link3.p_in3));
    
%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN'T CHANGE
%
    
    % Update the figure.
    world = UpdateFigure(world,robot,o_1in0,R_1in0,o_2in0,R_2in0,o_3in0,R_3in0,u1,u2,u3,t,tmax);
    
    % If making a movie, store the current figure as a frame.
    if (params.makemovie)
        frame = getframe(gcf);
        writeVideo(myV,frame);
    end
    
    % Stop if time has reached its maximum.
    if (t>tmax)
        done = true;
    end
    
end
% Either close the movie or save the record of actions.
if (params.makemovie)
    for i=1:30
        frame = getframe(gcf);
        writeVideo(myV,frame);
    end
    close(myV);
else
    save(params.action_filename,'actionRecord');
end

if (params.makesnapshot)
    set(gcf,'paperorientation','landscape');
    set(gcf,'paperunits','normalized');
    set(gcf,'paperposition',[0 0 1 1]);
    print(gcf,'-dpdf',params.snapshot_filename);
end

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MUST CHANGE
%

function [thetadot,thetadotdot] = GetRates(theta,thetadot,u1,u2,u3,robot)
%
% inputs:
%
%   theta       3x1 matrix of joint angles
%   thetadot    3x1 matrix of joint velocities
%   u1          torque applied by motor to link 1 through joint 1
%   u2          torque applied by motor to link 2 through joint 2
%   u3          torque applied by motor to link 3 through joint 3
%   robot       a whole bunch of parameters (see GetGeometryOfRobot)
%
% outputs:
%
%   thetadot    3x1 matrix of joint velocities
%   thetadotdot 3x1 matrix of joint accelerations

% velocities ...
thetadot = thetadot;

% accelerations ...

% parameters I copied for convenience
m1 = robot.link1.m;
a1 = robot.a1;
b1 = robot.b1;
J_1in1 = robot.link1.J_in1;
p_01in0 = robot.p_01in0;
k = robot.kfriction;

% parameters I defined
z_0in0 = [0;
          0;
          1];
z_1in1 = [0;
          0;
          1];
t01 = [0;
       0;
       1];
S01 = [1 0;
       0 1;
       0 0];
g = 9.81;

% things I computed
R_1in0 = RZ(theta(1));
o_1in0 = a1+R_1in0*b1;
p_01in1 = R_1in0'*(p_01in0-o_1in0);
w_01in1 = z_1in1*thetadot(1);


F = [m1*R_1in0*wedge(b1)*z_1in1 -eye(3) zeros(3,2);
     J_1in1*z_1in1 -wedge(p_01in1)*R_1in0' -R_1in0'*S01];

h = [-m1*R_1in0*wedge(w_01in1)^2*b1-m1*g*z_0in0;
     -wedge(w_01in1)*J_1in1*w_01in1+R_1in0'*t01*(u1-k*thetadot(1))];

soln = inv(F)*h;

thetadotdot(1,1) = soln(1,1);
thetadotdot(2,1) = 0;
thetadotdot(3,1) = 0;


%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CAN'T CHANGE
%

function actionRecord = StoreAction(actionRecord,action)
actionRecord(:,end+1) = action;

function [actionRecord,action,done] = RetrieveAction(actionRecord)
action = actionRecord(:,1);
actionRecord = actionRecord(:,2:end);
done = isempty(actionRecord);

function [t,theta,thetadot] = ...
                Simulate(t,dt,...           % <- time and time step
                         theta,thetadot,... % <- state
                         u1,u2,u3,...       % <- applied torques
                         robot)             % <- parameters
[t,x] = ode45(@(t,x) GetXDot(t,x,u1,u2,u3,robot),[t t+dt],[theta;thetadot]);
x = x';
t = t(end);
[theta,thetadot] = XToState(x);

function xdot = GetXDot(t,x,u1,u2,u3,robot)
% Unpack the state.
[theta,thetadot] = XToState(x);
% Get time derivatives.
[thetadot,thetadotdot] = GetRates(theta,thetadot,u1,u2,u3,robot);
% Pack time derivatives.
xdot = [thetadot;thetadotdot];

function [theta,thetadot] = XToState(x)
theta = x(1:3,end);
thetadot = x(4:6,end);

function robotfig = DrawRobot(robotfig,robot,o_1in0,R_1in0,o_2in0,R_2in0,alpha)
ered=[1,0.6,0];
egrey=[0.4745,0.6471,0.9098];
if isempty(robotfig)
    % - joints
    p = robot.p_01in0;
    robotfig.joint1 = line(p(1),p(2),p(3),'color','k','marker','.','markersize',30);
    p = o_1in0+R_1in0*robot.p_12in1;
    robotfig.joint2 = line(p(1),p(2),p(3),'color','k','marker','.','markersize',30);
    p = o_2in0+R_2in0*robot.p_23in2;
    robotfig.joint3 = line(p(1),p(2),p(3),'color','k','marker','.','markersize',30);
    % - links
    robotfig.base = patch('Vertices',robot.base.p_in0','Faces',robot.faces,'FaceColor',egrey,...
                          'FaceAlpha',alpha,'EdgeAlpha',alpha,...
                          'backfacelighting','reverselit','AmbientStrength',0.6);
    robotfig.link1 = patch('Vertices',robot.link1.p_in0','Faces',robot.faces,'FaceColor',ered,...
                             'FaceAlpha',alpha,'EdgeAlpha',alpha,...
                             'backfacelighting','reverselit','AmbientStrength',0.6);
	robotfig.link2 = patch('Vertices',robot.link2.p_in0','Faces',robot.faces,'FaceColor',ered,...
                             'FaceAlpha',alpha,'EdgeAlpha',alpha,...
                             'backfacelighting','reverselit','AmbientStrength',0.6);
	robotfig.link3 = patch('Vertices',robot.link3.p_in0','Faces',robot.faces,'FaceColor',ered,...
                             'FaceAlpha',alpha,'EdgeAlpha',alpha,...
                             'backfacelighting','reverselit','AmbientStrength',0.6);
else
    set(robotfig.link1,'vertices',robot.link1.p_in0');
    set(robotfig.link2,'vertices',robot.link2.p_in0');
    set(robotfig.link3,'vertices',robot.link3.p_in0');
    p = o_1in0+R_1in0*robot.p_12in1;
    set(robotfig.joint2,'xdata',p(1),'ydata',p(2),'zdata',p(3));
    p = o_2in0+R_2in0*robot.p_23in2;
    set(robotfig.joint3,'xdata',p(1),'ydata',p(2),'zdata',p(3));
end

function frame = DrawFrame(frame,o,R)
p = [o repmat(o,1,3)+R];
if isempty(frame)
    frame.x = plot3(p(1,[1 2]),p(2,[1 2]),p(3,[1 2]),'r-','linewidth',4);
    frame.y = plot3(p(1,[1 3]),p(2,[1 3]),p(3,[1 3]),'g-','linewidth',4);
    frame.z = plot3(p(1,[1 4]),p(2,[1 4]),p(3,[1 4]),'b-','linewidth',4);
else
    set(frame.x,'xdata',p(1,[1 2]),'ydata',p(2,[1 2]),'zdata',p(3,[1 2]));
    set(frame.y,'xdata',p(1,[1 3]),'ydata',p(2,[1 3]),'zdata',p(3,[1 3]));
    set(frame.z,'xdata',p(1,[1 4]),'ydata',p(2,[1 4]),'zdata',p(3,[1 4]));
end

function world = CreateFigure(robot,params)
% - clear the current figure
clf;
% - text (it's important this is in the back, so you can rotate the view
%         and other stuff!)
axes('position',[0 0 1 1]);
axis([0 1 0 1]);
hold on;
axis off;
fs = 10;
world.text.label=text(0.15,0.95,'view: frame 0','fontweight','bold','fontsize',fs);
world.text.time=text(0.05,0.1,sprintf('t = %6.2f / %6.2f\n',0,0),'fontsize',fs,'verticalalignment','top','fontname','monaco');
world.text.teamname=text(0.05,0.04,params.teamname,'fontsize',fs,'verticalalignment','top','fontweight','bold');
world.text.torques=text(0.8,0.02,sprintf('u_1 = %6.1f\nu_2 = %6.1f\nu_3 = %6.1f',0,0,0),'fontsize',fs,'fontname','monaco','verticalalignment','bottom');
% - view from frame 0
axes('position',[0.05 0.05 .9 1]);
set(gcf,'renderer','opengl');
axis equal;
axis([-6.5 6.5 -6.5 6.5 -5 7]);
axis manual;
hold on;
view([90-37.5,20]);
box on;
set(gca,'projection','perspective');
set(gca,'clipping','on','clippingstyle','3dbox');
world.view0.robot = DrawRobot([],robot,zeros(3,1),eye(3),zeros(3,1),eye(3),0.6);
world.view0.frame0 = DrawFrame([],zeros(3,1),eye(3));
world.view0.frame1 = DrawFrame([],zeros(3,1),eye(3));
world.view0.frame2 = DrawFrame([],zeros(3,1),eye(3));
world.view0.frame3 = DrawFrame([],zeros(3,1),eye(3));
lighting gouraud
world.view0.light = light('position',zeros(3,1)','style','local');
% - make the figure respond to key commands
set(gcf,'KeyPressFcn',@onkeypress_nokeypad);

function world = UpdateFigure(world,robot,o_1in0,R_1in0,o_2in0,R_2in0,o_3in0,R_3in0,u1,u2,u3,t,tmax)
world.view0.robot = DrawRobot(world.view0.robot,robot,o_1in0,R_1in0,o_2in0,R_2in0);
world.view0.frame1 = DrawFrame(world.view0.frame1,o_1in0,R_1in0);
world.view0.frame2 = DrawFrame(world.view0.frame2,o_2in0,R_2in0);
world.view0.frame3 = DrawFrame(world.view0.frame3,o_3in0,R_3in0);
set(world.view0.light,'position',(o_3in0+R_3in0*[0;0.51*robot.link3.dy;0])');
set(world.text.time,'string',sprintf('t = %6.2f / %6.2f\n',t,tmax));
set(world.text.torques,'string',sprintf('u_1 = %6.1f\nu_2 = %6.1f\nu_3 = %6.1f',u1,u2,u3));
drawnow

function onkeypress_nokeypad(src,event)
global action done
du = 1;
if event.Character == '1'
    action(1,1) = action(1,1)+du;
elseif event.Character == '!'
    action(1,1) = action(1,1)-du;
elseif event.Character == '2'
    action(2,1) = action(2,1)+du;
elseif event.Character == '@'
    action(2,1) = action(2,1)-du;
elseif event.Character == '3'
    action(3,1) = action(3,1)+du;
elseif event.Character == '#'
    action(3,1) = action(3,1)-du;
elseif event.Character == 'q'
    done = true;
end

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   FUNCTIONS I ADDED
%

function R = RZ(h)
R = [cos(h) -sin(h) 0;
     sin(h) cos(h) 0;
     0 0 1];

function ahat = wedge(a)
ahat = [0 -a(3) a(2);
        a(3) 0 -a(1);
        -a(2) a(1) 0];

%
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
