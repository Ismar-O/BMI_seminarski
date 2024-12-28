    % Read the image
    img = imread('img/studenti.jpg');
    
    % Convert the image to HSV color space
    hsvImg = rgb2hsv(img);
    % Define thresholds for red color in HSV
    % Adjust these values based on the specific shade of red
    lowerRed1 = [0, 0.2, 0.2]; % Lower threshold for red
    upperRed1 = [7/360, 1, 1];  % Upper threshold for red
    lowerRed2 = [353/360, 0.2, 0.2]; % Lower threshold for red
    upperRed2 = [1, 1, 1];      % Upper threshold for red
    
    lowerGreen = [70/360, 0.3, 0.3]; % Lower threshold for red
    upperGreen = [180/360, 1, 1];  % Upper threshold for red

    % Create masks for red and green colors
    mask1 = (hsvImg(:,:,1) >= lowerRed1(1) & hsvImg(:,:,1) <= upperRed1(1) & ...
              hsvImg(:,:,2) >= lowerRed1(2) & hsvImg(:,:,2) <= upperRed1(2) & ...
              hsvImg(:,:,3) >= lowerRed1(3) & hsvImg(:,:,3) <= upperRed1(3));
          
    mask2 = (hsvImg(:,:,1) >= lowerRed2(1) & hsvImg(:,:,1) <= upperRed2(1) & ...
              hsvImg(:,:,2) >= lowerRed2(2) & hsvImg(:,:,2) <= upperRed2(2) & ...
              hsvImg(:,:,3) >= lowerRed2(3) & hsvImg(:,:,3) <= upperRed2(3));
          
    mask3 = (hsvImg(:,:,1) >= lowerGreen(1) & hsvImg(:,:,1) <= upperGreen(1) & ...
              hsvImg(:,:,2) >= lowerGreen(2) & hsvImg(:,:,2) <= upperGreen(2) & ...
              hsvImg(:,:,3) >= lowerGreen(3) & hsvImg(:,:,3) <= upperGreen(3));
          
    redMask = mask1 | mask2;
    greenMask = mask3;
    

  
    
  
  % Perform morphological operations to clean up the mask
  

     redMask = imerode(redMask, strel('disk', 3));
     redMask = imerode(redMask, strel('disk', 3));
     redMask = imopen(redMask, strel('disk', 10));
     redMask = imdilate(redMask, strel('disk', 10));
     
     greenMask = imerode(greenMask, strel('disk', 3));
     greenMask = imerode(greenMask, strel('disk', 3));
     greenMask = imopen(greenMask, strel('disk', 10));
     greenMask = imdilate(greenMask, strel('disk', 10));
     
 

    
    % Find contours of the red areas
    
    
    [Br, Lr] = bwboundaries(redMask, 'noholes');
    [Bg, Lg] = bwboundaries(greenMask, 'noholes');
     
   

    xlabel('MASK 1');
    minAreaThreshold = 3000; % Define your minimum area threshold here (adjust as necessary)
    
    hold on
    
    lineHeight = size(img, 1) * 3 / 5;
    line([1, size(img, 2)], [lineHeight, lineHeight], 'Color', 'r', 'LineWidth', 2);
    
    hold off
    
    subplot(1,1,1)
    imshow(redMask | greenMask,  'InitialMagnification', 40);

    RsquareCount = Funkcija_brojanje(Br,minAreaThreshold,'red',lineHeight);
    GsquareCount = Funkcija_brojanje(Bg,minAreaThreshold,'green',lineHeight);



    
    % Display the result
    fprintf('\nNumber of red squares: %d\n', RsquareCount);
    fprintf('\nNumber of red squares: %d\n', GsquareCount);
    
    % Optionally, display the image with detected squares
    
    xlabel(sprintf('Broj crvenih: %d\nBroj zelenih: %d', RsquareCount, GsquareCount), 'FontSize', 40);
    hold on;

    
for i = 1:length(Br)
    boundary = Br{i};
    plot(boundary(:,2), boundary(:,1), 'Color', 'blue', 'LineWidth', 2);
end

for i = 1:length(Bg)
    boundary = Bg{i};
    plot(boundary(:,2), boundary(:,1), 'Color', 'yellow', 'LineWidth', 2);
end


    hold off;
