function y = replace_empty(x)
    if isempty(x)
        y = NaN;
    else
        y = x;
    end
end