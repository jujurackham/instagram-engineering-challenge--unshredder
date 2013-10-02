function U = unshred(Im)
    % Instagram Engineering Challenge :
    %       The Unshredder
    %   Julien Lerouge, 29/12/2012
    
    disp('-------------------------------');
    disp('- Julien Lerouge''s Unshredder -');
    disp('-------------------------------');
    disp('');
    
    img = imread(Im);
    [n, d, c] = size(img);
    
    % Converts to Hue-Saturation-Brightness
    imgbis = rgb2hsv(img);

    % Gives more importance to brightness
    imgbis(:,:,3) = 2*imgbis(:,:,3);
    
    % Finds the slices
    slices = sum(sum(abs([imgbis zeros(n,1,c)] - [zeros(n,1,c) imgbis]),1),3);
    slices = find([0 slices 0] > ([0 0 slices] + [slices 0 0]))-2;
    
    % Computes the slices width and number
    slW = [slices 0] - [0 slices];
    slW = mode(slW(2:end-1));
    disp(['Found the width of slices : ' num2str(slW) 'px.']);
    slN = round(d/slW);
    disp(['Number of slices : ' num2str(slN) '.']);

    % Computes the slices distance
    disp('Unshredding ...');
    D = zeros(slN, slN)+inf;
    for i=1:slN
        for j=setdiff(1:slN, i)
            sli = get_slice(imgbis, slW, i);
            slj = get_slice(imgbis, slW, j);
            D(i,j) = sum(sum(abs(sli(:,end,:) - slj(:,1,:)),1),3);
        end
    end

    vec = [];
    [i, j] = find(D == min(min(D)));
    D(i,:) = inf;
    D(:,j) = inf;
    vec = [i, j];

    while (length(vec) < slN)
        i = vec(1);
        j = vec(end);
        mini = min(D(:,i));
        minj = min(D(j,:));
        if(mini < minj)
            [i, j] = find(D == mini);
            vec = [i vec];
        else
            [i, j] = find(D == minj);
            vec = [vec j];
        end
        D(i,:) = inf;
        D(:,j) = inf;
    end
    disp('Done.');

    img_unshd = [];
    for k=1:slN
        img_unshd = [img_unshd get_slice(img, slW, vec(k))];
    end
    [d, output, ext] = fileparts(Im);
    output = [output '_unshredded' ext];
    imwrite(img_unshd, output);
    disp(['Image saved to' output '.']);
    %disp('Press any key to exit...');
    %pause;
    exit;
end
