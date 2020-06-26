function [N, Kind, Param, From, To, Step, Comp, Am]= get_setup(N, Kind, Param, From, To, Step, Comp, Am)
    screenSize = get(0,'ScreenSize');
    pointsPerPixel = 1;
    width = 500*pointsPerPixel;    height = 300*pointsPerPixel;
    pos1 = [screenSize(3)/2-width/2 screenSize(4)/2-height/2 width height];
    setup = figure('MenuBar', 'None',...
        'BusyAction', 'queue',...
        'WindowStyle','normal',...
        'Interruptible', 'off', ...
        'DockControls', 'off', ...
        'Name', 'Setup',...
        'NumberTitle', 'Off', ...
        'Visible','on',...
        'Position',pos1);
    

    str1= eval('N');
    str2= eval('From');
    str3= eval('To');
    str4= eval('Step');
    
    handles.n = N;
    handles.kind = Kind;
    handles.param = Param;
    handles.from = From;
    handles.to = To;
    handles.step = Step;
    handles.comp = Comp;
    handles.am = Am;
    list1 = {str1, str2, str3, str4};
    
    uicontrol('Style', 'text',   'String', 'усреднение', 'Position', [10, 50, 70, 20]);
    uicontrol('Style', 'text',   'String', 'вид сигнала', 'Position', [10, 80, 70, 20]);
    uicontrol('Style', 'text',   'String', 'параметр', 'Position', [10, 110, 70, 20]);
    
    uicontrol('Style', 'text',   'String', 'от', 'Position', [10, 140, 70, 20]);
    uicontrol('Style', 'text',   'String', 'до', 'Position', [10, 170, 70, 20]);
    uicontrol('Style', 'text',   'String', 'шаг', 'Position', [10, 200, 70, 20]);
    
    f1 = uicontrol('Style', 'edit',   'String', list1(2), 'Tag', 'from','Position', [90, 140, 130, 20]);
    t1 = uicontrol('Style', 'edit',   'String', list1(3), 'Tag', 'to','Position', [90, 170, 130, 20]);
    s1 = uicontrol('Style', 'edit',   'String', list1(4), 'Tag', 'step','Position', [90, 200, 130, 20]);
    n1 = uicontrol('Style', 'edit',   'String', list1(1), 'Tag', 'mean','Position', [90, 50, 130, 20]);
    k1 = uicontrol('Style', 'popup',   'String', 'noise|signal', 'Tag', 'kind','Position', [90, 80, 130, 20]);
    p1 = uicontrol('Style', 'popup',   'String', 'SNR|a2|tay2|S|L', 'Tag', 'param','Position', [90, 110, 130, 20]);
    c1 = uicontrol('Style', 'radiobutton',   'String', 'complex', 'Value',  Comp, 'Tag', 'comp','Position', [230, 110, 70, 20]);
    am1 = uicontrol('Style', 'radiobutton',   'String', 'AM', 'Value',  Am, 'Tag', 'am','Position', [230, 80, 70, 20]);
    uicontrol('Style', 'pushbutton',   'String', 'Ok', 'Tag', 'Ok','Position', [width/2-50, 10, 100, 20],'CallBack', @ok);
    
    
    uiwait;
    close(setup);
    Kind = handles.kind;
    Param = handles.param;
    Comp = handles.comp;
    Am = handles.am;
	
    function ok(src,evt)
        N = str2num(cell2mat(get(n1, 'String')));
        From = str2num(cell2mat(get(f1, 'String')));
        To = str2num(cell2mat(get(t1, 'String')));
        Step = str2num(cell2mat(get(s1, 'String')));
        Comp = get(c1, 'value');
        Am = get(am1, 'value');
        Kind_str = get(k1, 'String');
        Kind_value = get(k1, 'Value');
        
        Param_str = get(p1, 'String');
        Param_value = get(p1, 'Value');
        
        handles = guidata(src);
        handles.n = N;
        handles.comp = Comp;
        handles.am = Am;
        handles.from = From;
        handles.to = To;
        handles.step = Step;
        len_temp = length(Kind_str);
        str_temp ='';
        for i_temp = 1:len_temp
            if Kind_str(Kind_value,i_temp) ~= ' '
                str_temp(i_temp) = Kind_str(Kind_value,i_temp);
            end
        end
        handles.kind = char(str_temp);

        len_temp = size(Param_str);
        str_temp = '';
        for i_temp = 1:len_temp(2)
            if Param_str(Param_value,i_temp) ~= ' '
               str_temp(i_temp) = Param_str(Param_value,i_temp);
            end
        end
        handles.param = char(str_temp);
        uiresume;
    end
end