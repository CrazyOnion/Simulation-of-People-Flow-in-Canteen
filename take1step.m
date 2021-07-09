function [savedmap,peoplelist]=take1step(map,peoplelist,m,originalmap)
savedmap=map;
%% % set up color map for display 
% 1 - white - 空地
% 2 - black - 障碍 
% 3 - red - 已搜索过的地方
% 4 - blue - 下次搜索备选中心 
% 5 - green - 起始点
% 6 - yellow -  到目标点的路径
% 设置障障碍

for i=1:size(map,1)
    for j=1:size(map,2)
        if map(i,j)~=0&&map(i,j)~=11&&map(i,j)~=12&&map(i,j)~=13&&map(i,j)~=15
            map(i,j)=2;%除去行人、空地，其余为障碍
        end
        if (map(i,j)==13||map(i,j)==15)&&originalmap(i,j)==9
            map(i,j)=2;%为障碍
        end
    end
end
map(peoplelist(2,m),peoplelist(3,m)) = 5; %起始点
map(peoplelist(5,m),peoplelist(6,m)) = 6; %起始点

% if savedmap(peoplelist(5,m)+1,peoplelist(6,m))==12
%     map(peoplelist(5,m)+1,peoplelist(6,m))=1;%使得算法可以穿透等饭的人到达目标
% end
% for i=1:m
%     if peoplelist(1,i)==11&&i<m&&peoplelist(4,i)==peoplelist(4,m)%说明前方有相同餐口的人还未打餐
%         map(peoplelist(2,i),peoplelist(3,i))=6; %将前方人设为目标点
%         break;
%     end
%     if i==m
%         map(peoplelist(5,m),peoplelist(6,m)) = 6; %目标点
%     end
% end
% [destx,desty]=find(map==6);
%% 建立地图
nrows = size(map,1); 
ncols = size(map,2); 
start_node = sub2ind(size(map), peoplelist(2,m),peoplelist(3,m)); 
dest_node = sub2ind(size(map), peoplelist(5,m),peoplelist(6,m)); 
% 距离数组初始化
distanceFromStart = Inf(nrows,ncols); 
distanceFromStart(start_node) = 0; 
% 对于每个网格单元，这个数组保存其父节点的索引。 
parent = zeros(nrows,ncols); 

% 主循环!!!!!!!!!!!!!!
while true 
    % 找到距离起始点最近的节点
    [min_dist, current] = min(distanceFromStart(:)); %返回当前距离数组的最小值和索引。
    if ((current == dest_node) || isinf(min_dist)) %搜索到目标点或者全部搜索完，结束循环。
        break; 
    end; 

    map(current) = 3; %将当前颜色标为红色。
    distanceFromStart(current) = Inf;  %当前区域在距离数组中设置为无穷，表示已搜索。
    [i, j] = ind2sub(size(distanceFromStart), current); %返回当前位置的坐标
    neighbor = [i-1,j;... 
            i+1,j;... 
            i,j+1;... 
            i,j-1]; %确定当前位置的上下左右区域。
    outRangetest = (neighbor(:,1)<1) + (neighbor(:,1)>nrows) +...
                   (neighbor(:,2)<1) + (neighbor(:,2)>ncols );%判断下一次搜索的区域是否超出限制。
    locate = find(outRangetest>0); %返回超限点的行数。
    neighbor(locate,:)=[];%在下一次搜索区域里去掉超限点。
    neighborIndex = sub2ind(size(map),neighbor(:,1),neighbor(:,2));%返回下次搜索区域的索引号。
    for i=1:length(neighborIndex) 
        if (map(neighborIndex(i))~=2) && (map(neighborIndex(i))~=3 && map(neighborIndex(i))~= 5) 
            map(neighborIndex(i)) = 4; %如果下次搜索的点不是障碍，不是起点，没有搜索过就标为蓝色。
            if distanceFromStart(neighborIndex(i))> min_dist + 1      
                distanceFromStart(neighborIndex(i)) = min_dist+1; 
                parent(neighborIndex(i)) = current; %如果在距离数组里，。
            end 
        end 
    end 
end
%%
if (isinf(distanceFromStart(dest_node)))
    route = [];
else
    %提取路线坐标
    route = [dest_node];
    while (parent(route(1))~=0)
        route=[parent(route(1)), route];
    end
    % 移动
    
    map(route(2))=7;
    [xx,yy]=find(map==7);
    
    if (savedmap(xx,yy)==12&&savedmap(xx-1,yy)==peoplelist(4,m))||(savedmap(xx,yy)==11)||(savedmap(xx,yy)==13)||(savedmap(xx,yy)==15)%遇到前一个正在打饭的人或正在排队的人或正在找座的人
        savedmap(route(1))=11;%什么也不做
    else%前方没有打饭的
        if xx-1==peoplelist(5,m)&&yy==peoplelist(6,m)%前方没有打饭的，到达目标前一格
            peoplelist(2,m)=xx;
            peoplelist(3,m)=yy;
            peoplelist(1,m)=12;
            peoplelist(7,m)=0;
            savedmap(xx,yy)=12;
            savedmap(route(1))=0;
        else%什么也没有
            peoplelist(2,m)=xx;
            peoplelist(3,m)=yy;
            savedmap(route(1))=0;
            savedmap(route(2))=11;
        end
    end
end