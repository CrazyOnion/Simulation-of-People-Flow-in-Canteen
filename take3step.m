function [savedmap,peoplelisti]=take3step(map,peoplelisti,originalmap)
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
        if map(i,j)~=0&&map(i,j)~=9%&&map(i,j)~=13&&map(i,j)~=15
            map(i,j)=2;%除去空地、灰色区域，其余为障碍
        end
    end
end
map(peoplelisti(2),peoplelisti(3)) = 5; % 起始点
map(peoplelisti(5),peoplelisti(6)) = 6; % 目标点
%% 建立地图
nrows = size(map,1); 
ncols = size(map,2); 
start_node = sub2ind(size(map), peoplelisti(2),peoplelisti(3)); 
dest_node = sub2ind(size(map), peoplelisti(5),peoplelisti(6)); 
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
                   (neighbor(:,2)<1) + (neighbor(:,2)>ncols ); %判断下一次搜索的区域是否超出限制。
    locate = find(outRangetest>0); %返回超限点的行数。
    neighbor(locate,:)=[]; %在下一次搜索区域里去掉超限点。
    neighborIndex = sub2ind(size(map),neighbor(:,1),neighbor(:,2)); %返回下次搜索区域的索引号。
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
    % 动态显示出路线
    
    map(route(2))=7;
    [xx,yy]=find(map==7);
    if (savedmap(xx,yy)==13)||(savedmap(xx,yy)==15)%遇到前一个正在打饭的人或正在排队的人或正在找座的人
        savedmap(route(1))=15;%什么也不做
    else%前方没有人的
        if xx==peoplelisti(5)&&yy==peoplelisti(6)%已到达出口
            peoplelisti(1)=-1;
            savedmap(route(1))=0;
        else
            savedmap(route(1))=originalmap(route(1));
            savedmap(route(2))=15;
            peoplelisti(2)=xx;
            peoplelisti(3)=yy;
        end
    end
end
end