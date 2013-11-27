function [F, c] = mom_obj(B)
    m_00 = sum(sum(B));
    m_10 = 0;
    for i=1:size(B, 1)
        for j=1:size(B,2)
            m_10 = m_10 + i*1*B(i,j);
        end
    end
    m_01 = 0;
    for i=1:size(B, 1)
        for j=1:size(B,2)
            m_01 = m_01 + 1*j*B(i,j);
        end
    end
    x_c = m_10/m_00;
    y_c = m_01/m_00;
    c = [x_c y_c]';
    u_11 = 0;
    for i=1:size(B, 1)
        for j=1:size(B,2)
            u_11 = u_11 + (i-x_c)*(j-y_c)*B(i,j);
        end
    end
    u_20 = 0;
    for i=1:size(B, 1)
        for j=1:size(B,2)
            u_20 = u_20 + (i-x_c)^2*1*B(i,j);
        end
    end
    u_02 = 0;
    for i=1:size(B, 1)
        for j=1:size(B,2)
            u_02 = u_02 + 1*(j-y_c)^2*B(i,j);
        end
    end
    F = [m_00 u_11 u_20 u_02]';
end

