function [rotated, rotated_enlarged] = rotation(img, angle)
    theta = deg2rad(angle);
    [height,width]=size(img);
    new_width=round(width*abs(cos(theta))+height*abs(sin(theta)));
    new_height=round(width*abs(sin(theta))+height*abs(cos(theta)));
    u0=width*sin(theta);
    T=[cos(theta),sin(theta);-sin(theta),cos(theta)]; 
    rotated = zeros(new_height,new_width);

    for j=1:new_height
        for i=1:new_width  
            new_coordinate = T*([j;i]-[u0;0]); 
            x=new_coordinate(1);
            y=new_coordinate(2); 
            x_low=floor(x);
            x_up=ceil(x); 
            y_low=floor(y);
            y_up=ceil(y);
                
            if (x>=1 && x<=height)&&(y>=1&&y<=width) 
                if (x-x_low)<=(x_up-x) 
                    x=x_low; 
                else
                    x=x_up; 
                end
                if (y-y_low)<=(y_up-y)            
                    y=y_low;         
                else
                    y=y_up;            
                end
                rotated(j,i)=img(x,y); 
            end

        end
    end
    rotated_enlarged = imresize(rotated, 3);
end