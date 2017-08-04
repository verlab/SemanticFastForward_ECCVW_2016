%% Generates Ss and Sns values (Z is the min value and S is the effective speedup achieved if Ss and Sns were chosen)
function [SS, SNS, Z, S] = SpeedupOptimization(Tns, Ts, Sb, maxTempDist, lmb1, lmb2, show)

    if nargin < 7
        show = 0;
    end

    [Sns, Ss] = meshgrid(1:1:maxTempDist);
    
    ERR = abs((Tns + Ts)/Sb - Ts./Ss - Tns./Sns);
    OF = ERR + lmb1 * (Sns - Ss) + lmb2 * abs(Ss);   

    semantic_percentage = Ts/(Ts+Tns);% Semantic percentage
    ss_floor = semantic_percentage*Sb;% Semantic floor
    
    OF (Ss > Sns | Sns < Sb | Ss <= ss_floor) = nan;% Space Restrictions!
    
    [m, n] = min(OF);
    [Z, SNS] = min(m);
    SS = n(SNS);
    
    S = (Tns + Ts) / (Ts/SS + Tns/SNS);

    if show
        figure;
        title('Search Space','FontSize', 20); 
        xlabel('Non Semantic SpeedUp','FontSize', 15); 
        ylabel('Semantic SpeedUp','FontSize', 15);
        zlabel('Objective Function','FontSize', 15);
        hold on;
        surf(Sns,Ss,OF);
        grid minor;
        plot3([SNS,SNS],[0, maxTempDist],[0, 0],'Color','r','LineWidth',2);
        plot3([0,maxTempDist],[SS, SS],[0, 0],'Color','g','LineWidth',2);
        plot3([SNS,SNS],[SS, SS],[0, Z],'Color','m','LineWidth',2);
        colormap jet;
        colorbar;
        hold off;
    end    
end
