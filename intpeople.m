function peoplelist=intpeople(peoplelist,map)
for i=1:size(peoplelist,2)
    peoplelist(1,i)=0;
    peoplelist(2,i)=48+round(2*rand());
    peoplelist(3,i)=6;
    peoplelist(8,i)=1+round(3600*rand());
end
peoplelist=peoplelist';
peoplelist=sortrows(peoplelist,8);%按进入时间升序排列
peoplelist=peoplelist';
temp=peoplelist(8,1);
for i=2:1:size(peoplelist,2)
    if temp>=peoplelist(8,i)
        peoplelist(8,i)=temp+1;
    end
    temp=peoplelist(8,i);
end
for i=1:1:size(peoplelist,2)
    peoplelist(4,i)=17+mod(i+9,10);
    [peoplelist(5,i),peoplelist(6,i)]=find(map==peoplelist(4,i));
end

end