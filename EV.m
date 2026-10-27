matlab
clc;
clear;
close all;

% EV Charging Load Management

% Vehicle details
EV = {'EV1','EV2','EV3','EV4'};

arrival = [9 9 10 10];
departure = [12 11 13 12];

energy = [6 4 6 4];       % Required energy in kWh
power = [3 4 3 4];        % Charging power in kW

capacity = 10;             % Maximum available power in kW

% Time slots from 9 AM to 1 PM
time = 9:12;
nEV = length(EV);
nSlots = length(time);

% Initialize schedule
schedule = zeros(nEV,nSlots);
remaining = energy;

% Prioritize vehicles with earlier departure
[~,order] = sort(departure);

% Allocate charging slots
for t = 1:nSlots

    currentTime = time(t);
    availablePower = capacity;

    for k = 1:nEV

        i = order(k);

        if currentTime >= arrival(i) && ...
           currentTime < departure(i) && ...
           remaining(i) > 0 && ...
           power(i) <= availablePower

            schedule(i,t) = power(i);

            remaining(i) = remaining(i) - power(i);

            availablePower = availablePower - power(i);

        end
    end
end

% Calculate total load for each time slot
totalLoad = sum(schedule,1);

% Display charging schedule
disp('EV CHARGING LOAD MANAGEMENT');
disp('Charging power in kW');

disp(array2table(schedule, ...
    'RowNames',EV, ...
    'VariableNames',{'9_10','10_11','11_12','12_13'}));

% Display total load
disp('Total Charging Load (kW):');
disp(totalLoad);

% Display remaining energy
disp('Remaining Energy Required (kWh):');

for i = 1:nEV
    fprintf('%s = %.1f kWh\n',EV{i},remaining(i));
end

% Plot total load
figure;

stairs(time,totalLoad,'-o','LineWidth',2);

hold on;

yline(capacity,'r--','Capacity Limit');

xlabel('Time (Hours)');
ylabel('Charging Load (kW)');

title('EV Charging Load Management');

legend('Total Load','Available Capacity');

grid on;

xticks(9:12);
xlim([9 12]);

% Plot charging schedule
figure;

imagesc(time,1:nEV,schedule > 0);

colormap([1 1 1; 0 0.7 0.2]);

xlabel('Time (Hours)');
ylabel('Electric Vehicles');

title('EV Charging Schedule');

yticks(1:nEV);
yticklabels(EV);

xticks(9:12);
colorbar;
