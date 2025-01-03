function output = Funkcija_brojanje( B, minArea, color, Yheight )
squareCount = 0;
    for k = 1:length(B)
        boundary = B{k};
  
        % Calculate area and perimeter
        area = polyarea(boundary(:,2), boundary(:,1));
        perimeter = sum(sqrt(sum(diff(boundary).^2, 2)));
    
        % Calculate the bounding box
        minX = min(boundary(:,2));
        maxX = max(boundary(:,2));
        minY = min(boundary(:,1));
        maxY = max(boundary(:,1));
    
  
    
        width = maxX - minX;
        height = maxY - minY;
    
        % Calculate aspect ratio
        tempArea = minArea;
        if nargin == 4  % Check if the 'mode' argument is missing
          if mean(boundary(:,1))< Yheight
            tempArea  = minArea / 3;
          end;
        end
    
        aspectRatio = height / width;  % or width / height depending on your preference
        if perimeter>0
        % Check for minimum area and aspect ratio
            if area >= tempArea && aspectRatio >= 0.5 && aspectRatio <= 2
                   roundness = (4 * pi * area) / (perimeter^2);
                if roundness < 1% Adjust this threshold as necessary
                    squareCount = squareCount + 1;
                    centroidX = mean(boundary(:,2));
                    centroidY = mean(boundary(:,1));
                    
                    % Place the label near the boundary
                    label = sprintf('%d', squareCount);
                    text(centroidX, centroidY, label, 'Color', color, 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                    continue;
                end
            end     
        end
    end

output = squareCount;

end

