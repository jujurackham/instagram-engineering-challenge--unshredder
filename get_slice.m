function sl = get_slice(img, width, n)
    % sl = get_slice(img, width, n)
    % Returns the nth slice of an image.
    %
    %   img : an image
    %   width : the width (in px) of the slice
    %   n : the number of the slice
    sl = img(:, 1+(n-1)*width:n*width, :);
end
