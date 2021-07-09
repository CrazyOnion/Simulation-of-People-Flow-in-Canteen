clc;
%模拟食堂60min
clear; 
%读入图片
[pic,map,m,n]=LoadPic();
originalmap=map;
savedpic=pic;
%生成一个人
peoplelist=zeros(8,1900);
peoplelist=intpeople(peoplelist,map);
% imshow(pic,'InitialMagnification','fit');
% pause(0.01);
% clf;
% data=zeros(size(map,1),size(map,2));

for t=1:5500%1个步长为1秒
    clf;
    [pic,map,peoplelist]=move(pic,map,peoplelist,t,originalmap);
    %绘制实时图像
    imshow(pic,'InitialMagnification','fit');hold on;
    title('学二食堂');hold on;
    p=sprintf('%d',t);
    text(0,-1,p);hold on;
    pause(0.01);%保留图像100ms
%     imwrite(pic,strcat('pic-',num2str(t),'.png')); %关键是这句

    pic=savedpic;
end