function [pic,map,peoplelist]=move(pic,map,peoplelist,t,originalmap)
for i=1:size(peoplelist,2)%将peoplelist遍历
    if peoplelist(1,i)==0&&peoplelist(8,i)==t
        peoplelist(1,i)=11;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if peoplelist(1,i)==11%人在找餐口&排队（动）
        [map,peoplelist]=take1step(map,peoplelist,i,originalmap);
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if peoplelist(1,i)==12%人在打餐（此时不动）
        peoplelist(7,i)=peoplelist(7,i)+1;
        if peoplelist(7,i)>=20%打饭时间为15s
            peoplelist(1,i)=13;
        end
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if peoplelist(1,i)==13%人在找座位（动）
        peoplelist(4,i)=8;
        d=999999999999;
        for m=1:size(map,1)%寻找最近可用座位
            for n=1:size(map,2)
                if map(m,n)==8&&sqrt((m-peoplelist(2,i))^2+(n-peoplelist(3,i))^2)<d
                    aimx=m;
                    aimy=n;
                    d=sqrt((m-peoplelist(2,i))^2 + (n-peoplelist(3,i))^2);
                end
            end
        end
        if d==999999999999%暂时没找到座位
            peoplelist(1,i)=15;
            map(peoplelist(2,i),peoplelist(3,i))=15;
            peoplelist(5,i)=46;%向出口走
            peoplelist(6,i)=59+round(2*rand());%向出口走
            [map,peoplelist(:,i)]=take3step(map,peoplelist(:,i),originalmap);
            if peoplelist(1,i)==15%人没有离开食堂
                peoplelist(1,i)=13;%再将状态切换回来
                map(peoplelist(2,i),peoplelist(3,i))=13;
            end
        else%找到座位了
            peoplelist(5,i)=aimx;
            peoplelist(6,i)=aimy;
            [map,peoplelist(:,i)]=take2step(map,peoplelist(:,i),originalmap);
        end
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if peoplelist(1,i)==14%人在吃饭（不动）
        peoplelist(7,i)=peoplelist(7,i)+1;
        if peoplelist(7,i)>=720+300*rand()%吃饭时间
            peoplelist(1,i)=15;
            peoplelist(4,i)=10;
            peoplelist(7,i)=0;
            peoplelist(5,i)=46;
            peoplelist(6,i)=59+round(2*rand());
        end
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if peoplelist(1,i)==15%人离开餐厅
        [map,peoplelist(:,i)]=take3step(map,peoplelist(:,i),originalmap);
        continue;
    end
end

%将人画入图像中
for i=1:size(peoplelist,2)
    if peoplelist(1,i)>=11&&peoplelist(1,i)<=16
       pic(peoplelist(2,i),peoplelist(3,i),1)=255;
       pic(peoplelist(2,i),peoplelist(3,i),2)=255*(mod(255*i/size(peoplelist,2),3)/3);
       pic(peoplelist(2,i),peoplelist(3,i),3)=0;
    end
end

% %绘制热度图
% for i=1:size(map,1)
%     for j=1:size(map,2)
%         if map(i,j)==11||map(i,j)==13||map(i,j)==15
%             data(i,j)=data(i,j)+1;
%         end
%     end
% end
    

end