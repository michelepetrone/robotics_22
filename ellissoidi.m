%clc;

sim("CLIK_secondo_ordine");

syms v1 v2 real
index = [1 3000 5000 14000 16000 27000 30000 31000 33000 34000];
P_e = permute(p_e.signals.values,[1 3 2]);

for i = 1:length(index)
    figure();
    plot(P_e(1,:),P_e(2,:),"LineStyle","--");
    grid on; hold on;
    J_p = J.signals.values(1:2,1:2,index(i));
    p = P_e(1:2,index(i));
    fimplicit(@(v1,v2) ([v1 v2]'-p)' * ((J_p*J_p')\([v1 v2]'-p)) - 1,"LineWidth",1);
    hold on;
    fimplicit(@(v1,v2) ([v1 v2]'-p)' * ((J_p*J_p')*([v1 v2]'-p)) - 1,"LineWidth",1);
    scatter(p(1),p(2),"Marker","x","LineWidth",2,'MarkerEdgeColor',[0 0 0]);
    text(p(1),p(2),strcat(32,32,num2str(p(1)),10,32,32,num2str(p(2))));
    title('Ellissoidi','Interpreter','latex','FontSize',12);
    legend('$p_{e}$','velocita','forza','Interpreter','latex');
end