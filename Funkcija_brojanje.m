function output = Funkcija_brojanje( B, color, funkcija)
squareCount = 0;
    for k = 1:length(B)
        boundary = B{k};
  
        % Racunanje povrsine i obima
        area = polyarea(boundary(:,2), boundary(:,1));
        perimeter = sum(sqrt(sum(diff(boundary).^2, 2)));
    
        % Racunanje velicine okvira
        minX = min(boundary(:,2));
        maxX = max(boundary(:,2));
        minY = min(boundary(:,1));
        maxY = max(boundary(:,1));
    
        width = maxX - minX;
        height = maxY - minY;
        %Racunanje odnosa viine i sirine
        aspectRatio = height / width;     
          
 
        if perimeter>0
       
            if aspectRatio >= 0.5 && aspectRatio <= 2
                
                if mean(boundary(:,1))<funkcija(area)
                    squareCount = squareCount + 1;
                    centroidX = mean(boundary(:,2));
                    centroidY = mean(boundary(:,1));
             
                    label = sprintf('%d', squareCount);
                    text(centroidX, centroidY, label, 'Color', color, 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                    continue;
                end
            end     
        end
    end

output = squareCount;

end

