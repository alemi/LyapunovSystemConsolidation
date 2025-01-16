function figsz(boxsize,varargin)
    %-----------------------------------------------------------------------------
    % Copyright (c) 2025 Alireza Alemi 
    % Licensed under the Non-Commercial License (for non-commercial use only).
    % For commercial use, a separate commercial license must be obtained.
    % For more information, contact alireza.alemi@gmail.com
    %-----------------------------------------------------------------------------    
    
    p = inputParser;
    addOptional(p, 'LineWidth',0, @isnumeric);
    addOptional(p, 'FontSize', 0, @isnumeric);
    addOptional(p, 'AxisOff',  false,  @islogical);
    addOptional(p, 'FontName', '', @isstr);
    addOptional(p, 'TickLength', 0, @isnumeric);
    
    set(gcf,'Units','Inches');
    pos = get(gcf,'Position');
    pos(3) = boxsize(1);
    pos(4) = boxsize(2);

    set(gcf,'Position', pos);
    if pos(3)==pos(4)
        axis square
    end
    box off
      
    parse(p, varargin{:});
    
    if p.Results.LineWidth
        set(gca,'LineWidth', p.Results.LineWidth);
    end
    
    if p.Results.TickLength
        set(gca,'TickLength', p.Results.TickLength);
    end
    
    if p.Results.FontSize
        set(gca,'FontSize', p.Results.FontSize);
    end
     
    if ~isempty(p.Results.FontName)
        set(gca,'FontName', p.Results.FontName);
    end 
    
    if p.Results.AxisOff
        axis off 
    end
    
end

