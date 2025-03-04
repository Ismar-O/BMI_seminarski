    % Citanje slike
    img = imread('img/kolege_6.jpg');
    
    % Prebacivanje u HSV prostor
    hsvImg = rgb2hsv(img);
    % Odredjivanje granicnih vrijednosti

    lowerRed1 = [0, 0.3, 0.3]; % Donja granica za crvenu
    upperRed1 = [7/360, 1, 1];  % Gornja granica za crvenu
    lowerRed2 = [353/360, 0.3, 0.3]; % Donja granica za crvenu
    upperRed2 = [1, 1, 1];      % Gornja granica za crvenu
    
    lowerGreen = [70/360, 0.3, 0.3]; % Donja granica za zelenu
    upperGreen = [180/360, 1, 1];  % Gornja granica za zelenu

    % Kreiranje maske
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
    

  
    
  
  % Morfoloske operacije nad maskom
  

     redMask = imerode(redMask, strel('disk', 3));
     redMask = imerode(redMask, strel('disk', 3));
     redMask = imopen(redMask, strel('disk', 10));
     redMask = imdilate(redMask, strel('disk', 10));
     
     greenMask = imerode(greenMask, strel('disk', 3));
     greenMask = imerode(greenMask, strel('disk', 3));
     greenMask = imopen(greenMask, strel('disk', 10));
     greenMask = imdilate(greenMask, strel('disk', 10));
     
 

    
    % Trazenje kontura
    
    
    Br = bwboundaries(redMask, 'noholes');
    Bg = bwboundaries(greenMask, 'noholes');
     
   


    subplot(1,1,1)
    imshow(img,  'InitialMagnification', 40);

 
    % Funkcija
    f = @(x) 0.03*x+600 + 20;
    RsquareCount = Funkcija_brojanje(Br,'red',f);
    GsquareCount = Funkcija_brojanje(Bg,'green',f);
    
    fprintf('\nNumber of red squares: %d\n', RsquareCount);
    fprintf('\nNumber of red squares: %d\n', GsquareCount);
    xlabel(sprintf('Broj crvenih: %d  Broj zelenih: %d', RsquareCount, GsquareCount), 'FontSize', 40);
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
