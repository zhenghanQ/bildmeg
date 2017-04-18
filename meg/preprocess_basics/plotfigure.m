
figure;hold on;
plot(ASD_small.Time,ASD_small.Value(1,:));
plot(ASD_small.Time,ASD_big.Value(1,:),'r');

figure;hold on;
plot(ASD_small.Time,ASD_small.Value(2,:));
plot(ASD_small.Time,ASD_big.Value(2,:),'r');

figure;hold on;
plot(NT_small.Time,NT_small.Value(1,:));
plot(NT_small.Time,NT_big.Value(1,:),'r');

figure;hold on;
plot(NT_small.Time,NT_small.Value(2,:));
plot(NT_small.Time,NT_big.Value(2,:),'r');


ASD_small.Value(1,:)