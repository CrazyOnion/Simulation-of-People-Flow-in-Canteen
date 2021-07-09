function [pic,map,m,n]=LoadPic()
%读取图片
pic=imread('学二食堂.png');%28行40列的RGB数组
%imshow(pic);
%以下过程将RGB数组转换成数值数组！！！
[m,n,~]=size(pic);%m为行数，n为列数，o是3
map=ones(m,n);

for i=1:m
    for j=1:n
        if (pic(i,j,1)==255)&&(pic(i,j,2)==255)&&(pic(i,j,3)==255)
            map(i,j)=0;continue;
        end
        if (pic(i,j,1)==255)&&(pic(i,j,2)==127)&&(pic(i,j,3)==39)
            map(i,j)=1;continue;
        end
        if (pic(i,j,1)==163)&&(pic(i,j,2)==73)&&(pic(i,j,3)==164)
            map(i,j)=2;continue;
        end
        
        if (pic(i,j,1)==255)&&(pic(i,j,2)==0)&&(pic(i,j,3)==255)
            map(i,j)=7;continue;
        end
        if (pic(i,j,1)==128)&&(pic(i,j,2)==128)&&(pic(i,j,3)==0)
            map(i,j)=8;continue;
        end
        if (pic(i,j,1)==195)&&(pic(i,j,2)==195)&&(pic(i,j,3)==195)
            map(i,j)=9;
            pic(i,j,:)=[255,255,255];
            continue;
        end
        if (pic(i,j,1)==0)&&(pic(i,j,2)==162)&&(pic(i,j,3)==232)
            map(i,j)=10;continue;
        end
        if (pic(i,j,1)==34)&&(pic(i,j,2)==177)&&(pic(i,j,3)==76)
            map(i,j)=17;continue;
        end
        if (pic(i,j,1)==255)&&(pic(i,j,2)==174)&&(pic(i,j,3)==201)
            map(i,j)=18;continue;
        end
        if (pic(i,j,1)==128)&&(pic(i,j,2)==255)&&(pic(i,j,3)==0)
            map(i,j)=19;continue;
        end
        if (pic(i,j,1)==128)&&(pic(i,j,2)==0)&&(pic(i,j,3)==255)
            map(i,j)=20;continue;
        end
        if (pic(i,j,1)==128)&&(pic(i,j,2)==255)&&(pic(i,j,3)==128)
            map(i,j)=21;continue;
        end
        if (pic(i,j,1)==255)&&(pic(i,j,2)==128)&&(pic(i,j,3)==128)
            map(i,j)=22;continue;
        end
        if (pic(i,j,1)==0)&&(pic(i,j,2)==255)&&(pic(i,j,3)==255)
            map(i,j)=23;continue;
        end
        if (pic(i,j,1)==0)&&(pic(i,j,2)==128)&&(pic(i,j,3)==128)
            map(i,j)=24;continue;
        end
        if (pic(i,j,1)==136)&&(pic(i,j,2)==0)&&(pic(i,j,3)==21)
            map(i,j)=25;continue;
        end
        if (pic(i,j,1)==63)&&(pic(i,j,2)==72)&&(pic(i,j,3)==204)
            map(i,j)=26;continue;
        end
    end
end
end

