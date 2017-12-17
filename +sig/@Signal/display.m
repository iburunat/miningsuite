% SIG.SIGNAL.DISPLAY
%
% Copyright (C) 2014, 2017 Olivier Lartillot
%
% All rights reserved.
% License: New BSD License. See full text of the license in LICENSE.txt in
% the main folder of the MiningSuite distribution.

function display(obj)
    if obj.polyfile
        for i = 1:length(obj.Ydata)
            file = obj.selectfile(i);
            display(file);
        end
        return
    end
    
    xdata = obj.xdata;
    sdata = obj.sdata;
    
    nchans = obj.Ydata.size('freqband');
    if iscell(nchans)
        nchans = nchans{1};
    end
    
    %%    
    if ~obj.Srate || isequal(obj.Ydata.size('sample',1), 1)
        if isempty(xdata) || length(xdata) == 1
            textual(obj.yname,obj.Ydata.content);
            return
        end
        abscissa = 'xdata';
        Xaxis = obj.Xaxis;
        ydata = obj.Ydata;
        iscurve = (length(obj.Sstart) == 1);  
        
    elseif length(xdata) < 2
        switch length(xdata)
            case 0
                % Variable number of data points per sample
                iscurve = -1;
            case 1
                iscurve = 1;
        end
        abscissa = 'sdata';
        Xaxis = obj.saxis;
        ydata = obj.Ydata;
        
    else
        iscurve = 0;
%         f = sdata;
%         t = [f 2*f(end)-f(end-1)];
%         x = xdata(:);
%         x = [ 1.5*x(1) - 0.5*x(2); ...
%               (x(1:end-1) + x(2:end)) / 2; ...
%               1.5*x(end) - 0.5*x(end-1) ];
        Xaxis = obj.saxis;
        ydata = obj.Ydata.format({'element','sample'});
    end

    %%
    figure
    hold on
    
    if iscurve && nchans > 20
        ydata.apply(@drawmat,{sdata,(1:nchans)'},{'sample','freqband'},2);
        set(gca,'YDir','normal');   
        title(obj.yname);
    else
        for i = 1:nchans
            if nchans > 1
                subplot(nchans,1,nchans-i+1,'align');
                hold on
                ydatai = ydata.extract('freqband',i);
            else
                ydatai = ydata;
            end
            
            if iscurve
                if iscurve == -1 && iscell(ydatai.content)
                    varpeaks = 0;
                    for j = 1:length(ydatai.content)
                        if length(ydatai.content{j}) > 1
                            varpeaks = 1;
                            break
                        end
                    end
                    if ~varpeaks
                        iscurve = 1;
                        d = zeros(1,length(ydatai.content));
                        for j = 1:length(ydatai.content)
                            if isempty(ydatai.content{j})
                                d(j) = NaN;
                            else
                                d(j) = ydatai.content{j};
                            end
                        end
                        ydatai.content = d;
                    end
                end
                if iscell(ydatai.content)
                    if strcmp(abscissa,'sdata')
                        if iscell(sdata)
                            for j = 1:length(ydata.content)
                                plot(sdata{j},squeeze(ydatai.content{j}));
                            end
                        else
                            for j = 1:length(ydata.content)
                                if ~isempty(ydatai.content{j})
                                    plot(sdata(j),squeeze(ydatai.content{j}),'+');
                                end
                            end
                        end
                    else
                        
                    end
                else
                    if strcmp(abscissa,'xdata')
                        dim = 'element';
                    elseif strcmp(abscissa,'sdata')
                        dim = 'sample';
                    end
                    ydatai.apply(@draw,{obj.(abscissa),obj.Frate,'index'},{dim,'channel'},2);
                end
            elseif iscell(ydatai.content)
                for j = 1:length(ydatai.content)
                    x = obj.Sstart(j) + [0, obj.Ssize(j)];
                    y = xdata{j}';
                    y(end+1) = 2 * y(end) - y(end-1);
                    surfplot(x,y,ydatai.content{j});
                end
            else
                ydatai.apply(@drawmat,{sdata,xdata(:)},{'sample','element'},2);
                set(gca,'YDir','normal');
            end
            
            if ~isempty(obj.peak)
                if nchans == 1
                    p = obj.peak;
                else
                    p = obj.peak.extract('freqband',i);
                end
                
                if iscurve
                    pi = p.content{1};
                    px = Xaxis.data(pi);
                    py = ydatai.content(pi);
                    plot(px,squeeze(py),'or');
                elseif iscell(ydatai.content)
                    for k = 1:length(ydatai.content)
                        pk = p;
                        pk.content = p.content{k};
                        if pk.size('sample') == 1
                            pk = pk.content{1};
                            if ~isempty(pk)
                                py = obj.Xaxis.data(pk+.5);
                                px = obj.Sstart(k) + obj.Ssize(k) / 2;
                                plot(px,py,'+k');
                            end
                        else
                            for j = 1:pk.size('sample')
                                pj = pk.view('sample',j);
                                if ~isempty(pj{1})
                                    px = obj.saxis.data(j+.5);
                                    py = obj.Xaxis.data(pj{1});
                                    plot(px,py,'+k');
                                end
                            end
                        end
                    end
                else
                    for j = 1:obj.peak.size('sample')
                        pj = p.view('sample',j);
                        if ~isempty(pj{1})
                            px = obj.saxis.data(j+.5);
                            py = obj.Xaxis.data(pj{1});
                            plot(px,py,'+k');
                        end
                    end
                end
            end
            
            if i == 1
                xlabel(Xaxis.name);
            end
        end
        axis tight
        title(obj.yname);
    end
    fig = gcf;
    if isa(fig,'matlab.ui.Figure')
        fig = fig.Number;
    end
    disp(['The ' obj.yname ' is displayed in Figure ',num2str(fig),'.']);
end


function textual(name,data)
    disp(['The ' name ' is:']);
    display(data);
end


function draw(y,x,frate,index)
    if frate
        x = x + (index-1) / frate;
        plot(x,y,'k');
        y(isnan(y)) = [];
        y(isinf(y)) = [];
        if ~isempty(y)
            rectangle('Position',[x(1),...
                min(min(y)),...
                x(end)-x(1),...
                max(max(y))-...
                min(min(y))]+1e-16,...
                'EdgeColor','k',...
                'Curvature',.1,'LineWidth',1)
        end
    else
        plot(x,y);
    end
end


function drawmat(z,x,y)
    x(end+1) = 2*x(end) - x(end-1);
    y(end+1) = 2*y(end) - y(end-1);
    surfplot(x,y,z')
end


function surfplot(x,y,c)
    cax = newplot([]);
    surface(x,y,zeros(size(y,1),size(x,2)),c,'parent',cax,'EdgeColor','none');  % Here are the modification
    lims = [min(min(x)) max(max(x)) min(min(y)) max(max(y))];
    set(cax,'View',[0 90]);
    set(cax,'Box','on');
    axis(cax,lims);
end