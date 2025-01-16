function initVars(varNames,val,sffx)
    %-----------------------------------------------------------------------------
    % Copyright (c) 2025 Alireza Alemi 
    % Licensed under the Non-Commercial License (for non-commercial use only).
    % For commercial use, a separate commercial license must be obtained.
    % For more information, contact alireza.alemi@gmail.com
    %-----------------------------------------------------------------------------

    N = length(varNames);
    for i = 1 : N
        thisvar = [varNames{i},sffx];
       assignin('caller',thisvar, val);
    end
end