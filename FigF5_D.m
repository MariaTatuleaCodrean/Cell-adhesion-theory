clear; close all; clc;
%--------------------------------------------------------------------------
% Universal constants
%--------------------------------------------------------------------------
kT = 4.11; % pN*nm

%--------------------------------------------------------------------------
% Model parameters
%--------------------------------------------------------------------------
P.f1 = 2;  % force to activate adhesome proteins [pN]
P.f0 = 50; % force to break bond [pN]
P.chi0 = 15; % interaction strength, units of kT
P.Pi = 15; % activation energy, units of kT
P.r = 25;  % ratio of spring constants, r=kb/k0
P.fb = 20; % elastic force on stretched bond  [pN]
P.Eel = 200; % elastic energy, units of kT
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Input variables
%--------------------------------------------------------------------------
allchi0 = [0 7 15];              % attraction strength
allf = linspace(0,5,1000);       % vertical force 
allmub = linspace(-10,15,1000);  % effective chemical potential 

%--------------------------------------------------------------------------
% Output variables
%--------------------------------------------------------------------------
mub_critical = zeros(length(allchi0),length(allf)); % clustering threshold

%--------------------------------------------------------------------------
% Main routine
%--------------------------------------------------------------------------
tic
numberofchiplots = 0;
mywaitbar = waitbar(0,'Entering for loop');
% For each specified value of chi0
for ii = 1:length(allchi0)
    P.chi0 = allchi0(ii);

    % For range of forces
    for jj = 1:length(allf)
        f = allf(jj);

        % For each force, find turning points of g(x) (= chemical potential)
        [phibintervals, mubintervals] = findturningpoints(P,f);

        % Interpret lower value of (finite) mubintervals to be critical
        % threshold for clustering
        mubintervals = mubintervals(isfinite(mubintervals));
        mub_critical(ii,jj) = min(mubintervals);

    end
end
toc
close(mywaitbar)

%%
myLineWidth = 1.5;
myFontSize = 10;

% Color scheme
pink = [232 51 210]/255;
green = [121 251 77]/255;
cyan = [107 231 233]/255;
blue = [86 105 211]/255;
red = [216 13 60]/255;
ochre = [219 198 116]/255;
darkgreen = [51 153 102]/255;
grey = [1 1 1]*116/255;

numcols = length(allchi0);
col1 = green;
col2 = darkgreen;
c = zeros(numcols,3);
for kk = 1:numcols
    c(:,kk) = linspace(col1(kk),col2(kk),numcols);
end
% c = cat(1,darkgreen,darkgreen,darkgreen);
lnstyle = {'-','--','-.'};

% Enlarge figure by factor
X = 1.5;

% Generate figure to correct size
figure('Units','centimeters','Position',[5 5 X*7 X*6])
hold on

% For each value of chi0
for ii = 1:length(allchi0)
        plot(allf,mub_critical(ii,:),lnstyle{ii},'Color',c(ii,:),'LineWidth',X*myLineWidth);
end
axis([min(allf) max(allf) -10 20])

% Determine legend
mylegend = cell(1,length(allchi0));
for ii = 1:length(allchi0)
    mylegend{ii} = ['$\chi_0= ' num2str(allchi0(ii)) '~\mathrm{k_{B}T}$'];
end

legend(mylegend,'Location','northwest','Interpreter','latex')
xlabel('$f~(pN)$','Interpreter','latex')
ylabel('$\mu_b~(k_BT)$','Interpreter','latex')
box on
set(gca,'FontSize',X*myFontSize)