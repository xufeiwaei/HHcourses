function [connected] = area_obj(lab_bact,num)
	connected = zeros(num,1);
	for i = 1:num
        connected(i) = sum(sum(lab_bact == i));
    end
end


