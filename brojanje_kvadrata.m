
    % Read the image
    img = imread('img/test1.jpg');
    
    % Convert the image to HSV color space
    hsvImg = rgb2hsv(img);
    
    % Define thresholds for red color in HSV
    % Adjust these values based on the specific shade of red
    lowerRed1 = [0, 0.7, 0.5]; % Lower threshold for red
    upperRed1 = [0.05, 1, 1];  % Upper threshold for red
    lowerRed2 = [0.95, 0.7, 0.5]; % Lower threshold for red
    upperRed2 = [1, 1, 1];      % Upper threshold for red

    % Create masks for red colors
    mask1 = (hsvImg(:,:,1) >= lowerRed1(1) & hsvImg(:,:,1) <= upperRed1(1) & ...
              hsvImg(:,:,2) >= lowerRed1(2) & hsvImg(:,:,2) <= upperRed1(2) & ...
              hsvImg(:,:,3) >= lowerRed1(3) & hsvImg(:,:,3) <= upperRed1(3));
          
    mask2 = (hsvImg(:,:,1) >= lowerRed2(1) & hsvImg(:,:,1) <= upperRed2(1) & ...
              hsvImg(:,:,2) >= lowerRed2(2) & hsvImg(:,:,2) <= upperRed2(2) & ...
              hsvImg(:,:,3) >= lowerRed2(3) & hsvImg(:,:,3) <= upperRed2(3));
          
    redMask = mask1 | mask2;
   
  % Perform morphological operations to clean up the mask
  
  
     redMask = imerode(redMask, strel('disk', 3));
     redMask = imerode(redMask, strel('disk', 10));
     redMask = imopen(redMask, strel('disk', 10));
     redMask = imdilate(redMask, strel('disk', 10));
     %redMask = imclose(redMask, strel('square', 3));
     %redMask = imerode(redMask, strel('square', 5));
     %redMask = imdilate(redMask, strel('square', 7));
     %redMask = imopen(redMask, strel('disk', 10));
 
  
    % Find contours of the red areas
    
    
    [B, L] = bwboundaries(redMask, 'noholes');
   % subplot(2,2,1), imshow(mask1);   
     xlabel('MASK 1');
     %subplot(2,2,2), imshow(mask2);
     
     subplot(1,2,1), imshow(redMask);  


    % Count squares
    squareCount = 0;
    minAreaThreshold = 3000; % Define your minimum area threshold here (adjust as necessary)

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
    
    fprintf('\n@@@@@@@@\n width ');
    
    width = maxX - minX;
    height = maxY - minY;
      fprintf('%d', width);
      fprintf('\n height ');
        fprintf('%d', height);
    
    % Calculate aspect ratio
    if width > 0 && height > 0
        aspectRatio = height / width;  % or width / height depending on your preference
        if perimeter>0
        % Check for minimum area and aspect ratio
            if area >= minAreaThreshold && aspectRatio >= 0.5 && aspectRatio <= 2
              fprintf('\n min i aspect');
                roundness = (4 * pi * area) / (perimeter^2);
                if roundness < 1% Adjust this threshold as necessary
                    squareCount = squareCount + 1;
                    fprintf('\nOVAJ');
                     %You can use the centroid or any point within the boundary
                    centroidX = mean(boundary(:,2));
                    centroidY = mean(boundary(:,1));
                    
                    % Place the label near the boundary
                    label = sprintf('Square %d', squareCount);
                    text(centroidX, centroidY, label, 'Color', 'yellow', 'FontSize', 20, 'FontWeight', 'bold', 'HorizontalAlignment', 'center');
                end
                      fprintf('\n%f', roundness);
            end
        end
    end
end


    subplot(1,2,2)
    % Display the result
    fprintf('\nNumber of red squares: %d\n', squareCount);
    
    % Optionally, display the image with detected squares
    imshow(img);
    xlabel(sprintf('Broj crvenih: %d', squareCount), 'FontSize', 40);
    hold on;
   colors = lines(length(B)); % Create a matrix of colors using the 'lines' colormap

for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2), boundary(:,1), 'Color', colors(k, :), 'LineWidth', 2);
end
    hold off;
