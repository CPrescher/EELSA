function varargout = eels_gui(varargin)
% MYGUI Brief description of GUI.
%       Comments displayed at the command line in response 
%       to the help command. 

% (Leave a blank line following the help.)

%  Initialization tasks
width=800;
height=600;
fh=figure('Visible','off','Name', 'EELS Analysis',...
    'resize','on','position',[200 200 width height],'MenuBar', 'none',...
    'ToolBar','none','WindowButtonMotionFcn',@fh_WindowButtonMotionFcn,... 
    'NumberTitle', 'off','WindowButtonDownFcn', @fh_WindowButtonDownFcn,...
    'ResizeFcn', @fh_ResizeFcn);


%  Construct the components
handles=guidata(fh);


%defining panels
%variables defining right panels:
panel_width=240;
panel_height1=360;


%content of left panel:
lpanh = uipanel('Parent',fh,'units','pixel','Position',[0 0 width-panel_width height]); %leftpanelhandles
data_in1= axes('Parent', lpanh,'units','pixel', 'outerposition', [0 height/2 width-panel_width  height/2]);
data_out1= axes('Parent', lpanh,'units','pixel', 'outerposition', ...
    [0 0 width-panel_width height/2]);
data_in2= axes('Parent', lpanh,'units','pixel', 'outerposition', ...
    [0 height/2 width-panel_width  height/2],'visible', 'off');
data_out2= axes('Parent', lpanh,'units','pixel', 'outerposition', ...
    [0 0 width-panel_width height/2],'visible', 'off');
data_in3= axes('Parent', lpanh,'units','pixel', 'outerposition',...
    [0 height/2 width-panel_width  height/2],'visible', 'off');
data_out3= axes('Parent', lpanh,'units','pixel', 'outerposition',  ...
    [0 0 width-panel_width height/2],'visible', 'off');
data_in4= axes('Parent', lpanh,'units','pixel', 'outerposition',...
    [0 height/4 width-panel_width  height/4*3],'visible', 'off');
data_out4= axes('Parent', lpanh,'units','pixel', 'outerposition',  ...
    [0 0 width-panel_width height/4],'visible', 'off');




%content of right panels
rpanh1 = uipanel('Parent',fh,'units', 'pixel','Position',[width-panel_width height-panel_height1  panel_width panel_height1]);%rightpanelhandle top
rpanh2 = uipanel('Parent',fh,'units', 'pixel','Position',[width-panel_width 0 panel_width height-panel_height1]);

hTabGroup = uitabgroup('parent',rpanh1,'SelectionChangedFcn', @tabGroupCB);


%**********************************************************************
%************************content of tab 1******************************
%**********************************************************************

tab1 = uitab(hTabGroup, 'title','ZLAna');

%*************Label group*************************************
edgelpos_lbl=uicontrol(tab1, 'Style', 'text','HorizontalAlignment','right',...
    'String', 'Left Pos:','Position', [10 255 60 15]);
edgerpos_lbl=uicontrol(tab1, 'style', 'text', 'HorizontalAlignment','right',...
    'String', 'Right Pos:','Position', [10 235 60 15]);

fwhm_lbl=uicontrol(tab1, 'style', 'text', 'horizontalalignment', 'right',...
    'String', 'FWHM', 'Position', [10 205 60 15]);

I0I_lbl=uicontrol(tab1, 'style', 'text', 'horizontalalignment', 'right',...
    'String', 'I0/I', 'Position', [10 185 60 15]);
I0LL_lbl=uicontrol(tab1, 'style', 'text', 'horizontalalignment','right',...
    'String', 'I0/LL', 'Position', [10 165 60 15]);

%*************************Text group*********************************

edgelpos_txt=uicontrol(tab1,'Style', 'edit','Horizontalalignment','right',...
    'backgroundcolor', [1 1 1], 'Position', [75 255 60 17],...
    'enable', 'inactive');
edgerpos_txt=uicontrol(tab1,'Style', 'edit','Horizontalalignment','right',...
    'backgroundcolor', [1 1 1], 'Position', [75 235 60 17],...
    'enable', 'inactive');

fwhm_txt=uicontrol(tab1,'style','edit','HorizontalAlignment','right',...
    'backgroundcolor', [1 1 1], 'Position', [75 205 60 17],...
    'Callback', @edit_cb);

I0I_txt=uicontrol(tab1, 'style','edit','Horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1], 'Position', [75 185 60 17],...
    'Callback', @edit_cb);
I0LL_txt=uicontrol(tab1,'style','edit','Horizontalalignment','right',...
    'backgroundcolor', [1 1 1], 'Position', [75 165 60 17],...
    'Callback', @edit_cb);

%************************defining buttons********************************

loadll_btn=uicontrol(tab1, 'Style', 'pushbutton','String','Load LL',...
    'Position', [10 280 125 30],'callback', @loadll_btn_click);
definezl_btn=uicontrol(tab1,'style','pushbutton','String','Define Zero-Loss',...
    'Position', [10 130 125 30],'callback', @definezl_btn_click);


%**********************************************************************
%************************content of tab 2******************************
%**********************************************************************

tab2 = uitab(hTabGroup, 'title','DatAna');

%**************************defining buttons:***************************

loaddat_btn=uicontrol(tab2, 'Style', 'pushbutton','String','Load data',...
    'Position', [10 280 125 30],'callback', @loaddat_btn_click);
defineedge_btn=uicontrol(tab2, 'Style', 'pushbutton', 'String','Define Edge',...
    'Position', [40 230 95 22], 'callback', @defineedge_btn_click);
fitbkg_btn=uicontrol(tab2,'Style', 'pushbutton', 'String', 'Fit Bkg',...
    'Position', [40 155 95 22], 'callback', @fitbkg_btn_click);
decon_btn=uicontrol(tab2, 'Style', 'pushbutton', 'String', 'Deconvolute',...
    'Position', [40 55 95 22], 'callback', @decon_btn_click);

%*************************defininge labls***************************
peakpos_lbl=uicontrol(tab2, 'Style', 'text', 'String', 'Edgepos:',...
    'Position', [10 255 60 15], 'horizontalalignment','right');
fitbkg_A_lbl=uicontrol(tab2, 'Style', 'text', 'String', 'A:',...
    'Position', [10 200 60 15], 'horizontalalignment', 'right');
fitbkg_r_lbl=uicontrol(tab2, 'Style', 'text', 'String', 'r:',...
    'Position', [10 180 60 15], 'horizontalalignment','right');
bkgfunc_lbl=uicontrol(tab2, 'Style', 'text', 'String','Bkg=A*E^-r', ...
    'Position', [140 190 60 15], 'horizontalalignment', 'right');
fwhm_decon_lbl=uicontrol(tab2, 'Style','text','String','FWHM:',...
    'Position', [10 102 60 15], 'horizontalalignment','right');
zl_factor_lbl=uicontrol(tab2, 'Style', 'text', 'String', 'ZL-Factor',...
    'Position', [10 82 60 15], 'horizontalalignment','right');


%*************************defining texts****************************
peakpos_txt=uicontrol(tab2, 'Style', 'edit', 'String', '707.8',...
    'Position', [75 255 60 17], 'horizontalalignment','right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);
fitbkg_A_txt=uicontrol(tab2,'Style','edit', 'String','',...
    'Position', [75 200 60 17], 'horizontalalignment','right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);
fitbkg_r_txt=uicontrol(tab2,'Style','edit','String','',...
    'Position', [75 180 60 17], 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);
fwhm_decon_txt=uicontrol(tab2, 'style', 'edit', 'string','',...
    'Position', [75 102 60 17], 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);
zl_factor_txt=uicontrol(tab2, 'Style', 'edit', 'String', '1',...
    'Position', [75 82 60 17], 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);

%***********************pop-up menu******************************
decon_pop=uicontrol(tab2, 'style', 'popupmenu',...
    'string',{'FR - Gaussian', 'FR - Lorentzian'},...
    'Value', 1, 'horizontalalignment','right','Position', [10 125 125 20],...
    'backgroundcolor',[1 1 1]);


%**********************************************************************
%************************content of tab 3******************************
%**********************************************************************

tab3=uitab(hTabGroup, 'title','Fe edge');

%**************************defining labels*****************************
edgepos_lbl=uicontrol(tab3,'style','text', 'string', 'Edgepos:',...
    'Position', [10 295 60 15], 'horizontalalignment', 'right');
h1_lbl=uicontrol(tab3, 'style', 'text', 'String', 'h1:',...
    'Position', [10 250 60 15], 'horizontalalignment', 'right');
h2_lbl=uicontrol(tab3, 'style', 'text', 'String', 'h2:',...
    'Position', [10 230 60 15], 'horizontalalignment', 'right');
feratio_lbl=uicontrol(tab3, 'style', 'text', 'String', 'Ferric iron ratio:',...
    'Position', [10 180 110 15], 'horizontalalignment', 'left');
int_lbl=uicontrol(tab3, 'style', 'text','String','Int method:',...
    'Position', [10 160 60 15], 'horizontalalignment','right');
fit_lbl=uicontrol(tab3, 'style', 'text','string','Fit method:',...
    'Position', [10 140 60 15], 'horizontalalignment','right');

%***************************defining texts*****************************
edgepos2_txt=uicontrol(tab3,'style','edit', 'string', '707.8',...
    'Position', [75 295 60 17], 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1], 'Callback', @edit_cb);
h1_txt=uicontrol(tab3, 'Style', 'edit', 'String', '',...
    'Position', [75 250 60 17],'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);
h2_txt=uicontrol(tab3, 'Style', 'edit','String', '',...
    'Position', [75 230 60 17],'horizontalalignment','right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);
int_txt=uicontrol(tab3, 'style', 'edit', 'String','',...
    'Position', [75 160 60 17], 'horizontalalignment','right',...
    'backgroundcolor' , [1 1 1],'Callback', @edit_cb);
fit_txt=uicontrol(tab3,'style', 'edit', 'String','',...
    'Position', [75 140 60 17], 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1],'Callback', @edit_cb);

%**************************defining buttons****************************
defineedge2_btn=uicontrol(tab3, 'style', 'Pushbutton', 'String', 'Define edge',...
    'Position', [40 270 95 22], 'callback', @defineedge_btn_click);
fittan_btn=uicontrol(tab3, 'style', 'Pushbutton', 'String', 'FitTan',...
    'Position', [40 205 95 22], 'callback', @fittan_btn_click);


%**********************************************************************
%************************content of tab 4******************************
%**********************************************************************

tab4=uitab(hTabGroup, 'title','General');

%**************************defining labels*****************************

%labels for the range output
uicontrol(tab4, 'style', 'text', 'String','Range:',...
    'Position', [10 310 60 15], 'horizontalalignment','right');
uicontrol(tab4,'style', 'text', 'String', '-',...
    'Position', [115 310 10 15],'horizontalalignment', 'center');
uicontrol(tab4,'style', 'text', 'String', 'eV',...
    'Position',[170 310 30 14],'horizontalalignment', 'left');

range1_txt=uicontrol(tab4,'style', 'edit', 'String', '440',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [75 310 40 17], 'callback', @range_txt_callback);
range2_txt=uicontrol(tab4,'style', 'edit', 'String', '500',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [125 310 40 17], 'callback', @range_txt_callback);

%************************define edge***********************************
uicontrol(tab4, 'style', 'text', 'String', 'EdgePos:',...
    'Position', [10 290 60 15], 'horizontalalignment', 'right');

edgepos3_txt=uicontrol(tab4,'style', 'edit','string', '450',...
    'backgroundcolor', [1 1 1],'horizontalalignment', 'right',...
    'Position', [75 290 40 17],'callback',@edit_cb);

defineedge3_btn=uicontrol(tab4, 'style', 'Pushbutton', 'String', 'Def edge',...
    'Position', [170 288 50 20], 'callback', @defineedge_btn_click);


%************************fit arcus tangens******************************
fittan2_btn=uicontrol(tab4,'style', 'pushbutton', 'string', 'FitTan',...
    'Position', [170 268 50 20], 'callback', @fittan_btn_click);

uicontrol(tab4, 'style','text','String','Inflections:',....
    'Position', [10 270 60 15],'horizontalalignment', 'right');

inf1_txt=uicontrol(tab4, 'style', 'edit', 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1 ],'Position', [75 270 40 17], 'String', '457.5',...
    'callback', @edit_cb);
inf2_txt=uicontrol(tab4, 'style', 'edit', 'horizontalalignment', 'right',...
    'backgroundcolor', [1 1 1 ],'Position', [125 270 40 17], 'String', '463.0',...
    'callback', @edit_cb);

ti_atan_cb=uicontrol(tab4,'style', 'checkbox', 'String','Ti arctan',...
    'Value', 1, 'Position',[75 250 80 15]);


%*********************control fitting*************************************

site_num_txt=uicontrol(tab4, 'Style', 'edit','Horizontalalignment','right',...
    'backgroundcolor', [1 1 1], 'string','1', 'Position', [10 227 20 17],...
    'callback', @graphnr_txt_edit,'enable','inactive');
site_num_cnt=uicontrol(tab4, 'style','slider', 'Max', 10, 'Min',1,...
    'value', 1,'SliderStep',[0.05 0.2],'position',[33 227 13 17],...
    'callback', @graphnr_cnt_click, 'enable', 'inactive');
site_type_pop=uicontrol(tab4, 'style', 'popupmenu',...
    'String', {'Gaussian', 'Lorentzian', 'PseudoVoigt'},...
    'Position', [55 228 90 17], 'backgroundcolor', [1 1 1]);

add_btn=uicontrol(tab4, 'style', 'Pushbutton', 'String', '+',...
    'Position', [150 225 20 20], 'callback', @add_btn_click);
delete_btn=uicontrol(tab4,'style', 'pushbutton', 'string', '-',...
    'Position', [175 225 20 20], 'callback', @delete_btn_click);


%********************definine site_param panel**************************
site_pan=uipanel('Parent',tab4,'units', 'pixel','Position',...
    [10 120 215 100],'Title', 'Site params');

uicontrol(site_pan, 'Style', 'text', 'String', 'Center:',...
    'Position', [05 65 55 15],'horizontalalignment', 'right');
uicontrol(site_pan, 'Style', 'text', 'String', '+-',...
    'Position', [115 65 20 15],'horizontalalignment', 'center');
center_txt=uicontrol(site_pan,'style','edit', 'string','',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [65 65 50 17], 'callback', @center_txt_callback);
center_bd_txt=uicontrol(site_pan,'style','edit', 'string','2',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [135 65 40 17], 'callback', @center_bd_txt_callback);
center_cb=uicontrol(site_pan,'style', 'checkbox', 'String','',...
    'Value', 1, 'Position',[180 67 15 15],...
    'callback', @center_cb_click);

uicontrol(site_pan, 'Style', 'text', 'String', 'FWHM:',...
    'Position', [05 45 55 15],'horizontalalignment', 'right');
uicontrol(site_pan, 'Style', 'text', 'String', '+-',...
    'Position', [115 45 20 15],'horizontalalignment', 'center');
fwhm_site_txt=uicontrol(site_pan,'style','edit', 'string','',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [65 45 50 17], 'callback', @fwhm_site_txt_callback);
fwhm_site_bd_txt=uicontrol(site_pan,'style','edit', 'string','2',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [135 45 40 17], 'callback', @fwhm_site_bd_txt_callback);
fwhm_cb=uicontrol(site_pan,'style', 'checkbox', 'String','',...
    'Value', 1, 'Position',[180 47 15 15],...
    'callback', @fwhm_cb_click);

uicontrol(site_pan, 'Style', 'text', 'String', 'Intensity:',...
    'Position', [05 25 55 15],'horizontalalignment', 'right');
uicontrol(site_pan, 'Style', 'text', 'String', '+-',...
    'Position', [115 25 20 15],'horizontalalignment', 'center');
intensity_txt=uicontrol(site_pan,'style','edit', 'string','',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [65 25 50 17], 'callback', @intensity_txt_callback);
intensity_bd_txt=uicontrol(site_pan,'style','edit', 'string','0',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [135 25 40 17], 'callback', @intensity_bd_txt_callback);
intensity_cb=uicontrol(site_pan,'style', 'checkbox', 'String','',...
    'Value', 1, 'Position',[180 27 15 15],...
    'callback', @intensity_cb_click);

uicontrol(site_pan, 'Style', 'text', 'String', 'Ratio:',...
    'Position', [05 05 55 15],'horizontalalignment', 'right');
pv_n_txt=uicontrol(site_pan,'style','edit', 'string','',...
    'backgroundcolor', [1 1 1], 'horizontalalignment', 'right',...
    'Position', [65 05 50 17], 'callback', @pv_n_txt_callback,...
    'enable','off');

fit_site_btn=uicontrol(site_pan, 'style', 'pushbutton',...
    'string', 'Fit', 'Position', [135 03 50 20],...
    'callback', @fit_site_btn_click);

%***************************save buttons*********************************
save_sites_btn=uicontrol(tab4, 'style', 'pushbutton', 'String', 'Save Sites',...
    'Position', [10 83 90 30],'callback', @save_sites_btn_click);
save_graph_btn=uicontrol(tab4, 'style', 'pushbutton', 'String', 'Save Graph',...
    'Position', [10 47 90 30],'callback', @save_graph_btn_click);
load_general_data_btn=uicontrol(tab4,'style', 'pushbutton', 'string','Load Data',...
    'Position', [10 11 90 30],'callback', @load_general_data_btn_click);

%***************************define output panel************************
output_pan=uipanel('Parent',tab4,'units', 'pixel','Position',...
    [110 10 115 110],'Title', 'Status');

output_txt=uicontrol(output_pan, 'style', 'text', 'string','',...
    'Position', [05 05 100 90], 'backgroundcolor', [1 1 1]',...
    'horizontalalignment', 'left', 'enable', 'inactive');
setappdata(0, 'output_txt', output_txt);




%**********************************************************************
%******************content for lower right panel***********************
%**********************************************************************

%rightpanelhandle bottom
x_lbl=uicontrol(rpanh2, 'Style', 'text', 'String', 'X:',...
    'horizontalalignment','right','Position', [10 200 30 15]);
x_out_lbl=uicontrol(rpanh2,'Style', 'text', 'String', '',...
    'horizontalalignment','right', 'Position', [45 200 65 15]);
y_lbl=uicontrol(rpanh2, 'Style','text', 'String', 'Y:',...
    'horizontalalignment','right','Position', [10 180 30 15]); 
y_out_lbl=uicontrol(rpanh2,'style', 'text', 'string','',...
    'horizontalalignment','right', 'Position', [45 180 65 15]);
copyright_lbl=uicontrol(rpanh2,'style','text','string','written by C. Prescher',...
    'horizontalalignment', 'right','Position', [80 1 150 15]);

msg_lbl=uicontrol(rpanh2,'style', 'text', 'horizontalalignment', 'center',...
    'String','','Position', [10 110 125 60]);

saveu_btn=uicontrol(rpanh2,'style','pushbutton','string', 'Save Upper',...
    'Position', [10 60 125 22], 'callback', @saveu_btn_click);
savel_btn=uicontrol(rpanh2,'style','pushbutton', 'string', 'Save Lower',...
    'Position', [10 35 125 22], 'callback', @savel_btn_click);
save_graphs=uicontrol(rpanh2, 'style', 'pushbutton', 'string', 'Save Graphs',...
    'Position', [145 35 83 48], 'callback', @save_graphs_btn_click);




       
     
guidata(fh,handles);
%  Initialization tasks

setappdata(0, 'zl_data',[]);
setappdata(0, 'edge_data',[]);
setappdata(0, 'current_tab',1);
setappdata(0, 'fit_state',1);
%only for purpose of which data should be loaded....
%1  -   general data
%2  -   general data-atan data... so fit_data...


%for the fitting process in the end

setappdata(0,'site_num', 0); % total amount of sites
setappdata(0,'site_cur', 0); % current active site

site(1)=csite(1,2,3);
setappdata(0,'site_data',site);
setappdata(0,'XLim',[680 750]);
setappdata(0,'YLim',[0 300]);

setappdata(0, 'state', 'normal');
set(hTabGroup, 'SelectedTab', tab1);
visibility(data_in1,data_out1,'on');
visibility(data_in2,data_out2,'off');
visibility(data_in3,data_out3,'off'); 
visibility(data_in4,data_out4,'off');



set(fh,'visible', 'on');
movegui(fh,'onscreen');

%*********************  Callbacks for MYGUI****************************
%**********************************************************************
    function visibility(graph1, graph2, state)
       set(graph1,'visible', state);
       set(get(graph1,'children'),'visible',state)
       set(graph2,'visible', state);
       set(get(graph2,'children'),'visible',state)
    end
    function tabGroupCB(hObject, eventdata)
        selected_tab=get(hObject,'SelectedTab');
        switch selected_tab
            case tab1
               visibility(data_in1,data_out1,'on');
               visibility(data_in2,data_out2,'off');
               visibility(data_in3,data_out3,'off');
               visibility(data_in4,data_out4,'off');
            case tab2
               visibility(data_in1,data_out1,'off');
               visibility(data_in2,data_out2,'on');
               visibility(data_in3,data_out3,'off'); 
               visibility(data_in4,data_out4,'off');
            case tab3             
               visibility(data_in1,data_out1,'off');
               visibility(data_in2,data_out2,'off');
               visibility(data_in3,data_out3,'on'); 
               visibility(data_in4,data_out4,'off');
            case tab4
               visibility(data_in1,data_out1,'off');
               visibility(data_in2,data_out2,'off');
               visibility(data_in3,data_out3,'off'); 
               visibility(data_in4,data_out4,'on');
        end
        resize_graphs;
    end

    function fh_ResizeFcn(hObject, eventdata)
        panel_width=240;
        panel_height1=360;
        fig_pos=get(fh,'Position');
        width=fig_pos(3);
        height=fig_pos(4);
        if height<=600
            height=600;
            fig_pos(4)=600;
            set(fh,'position', fig_pos);
        end
        
        resize_graphs;
        set(lpanh,'Position', [0 0 width-panel_width height]);
        set(rpanh1, 'Position', [width-panel_width height-panel_height1  panel_width panel_height1]);
        set(rpanh2, 'Position', [width-panel_width 0 panel_width height-panel_height1]); 
        
    end

    function resize_graph(graph1, graph2, panel_width, f_width, f_height)
        set(graph1,'OuterPosition',[0 f_height/2 f_width-panel_width  f_height/2]);
        set(graph1, 'Position', get(graph1, 'OuterPosition') - ...
            get(graph1, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]+[10 10 -20 -20]);
         set(graph2,'OuterPosition',[0 0 f_width-panel_width f_height/2]);
         set(graph2, 'Position', get(graph2, 'OuterPosition') - ...
            get(graph2, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]+[10 10 -20 -20]);
    end
    function resize_graph4(graph1, graph2, panel_width, f_width, f_height)
        set(graph1,'OuterPosition',[0 f_height/4 f_width-panel_width  f_height/4*3]);
        set(graph1, 'Position', get(graph1, 'OuterPosition') - ...
            get(graph1, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]+[10 10 -20 -20]);
         set(graph2,'OuterPosition',[0 0 f_width-panel_width f_height/4]);
         set(graph2, 'Position', get(graph2, 'OuterPosition') - ...
            get(graph2, 'TightInset') * [-1 0 1 0; 0 -1 0 1; 0 0 1 0; 0 0 0 1]+[10 10 -20 -20]);
    end
        
    function resize_graphs()
        panel_width=240;
        fig_pos=get(fh,'position');
        f_width=fig_pos(3);
        f_height=fig_pos(4);
        selected_tab=get(hTabGroup,'SelectedTab');
        switch selected_tab
            case tab1
                resize_graph(data_in1,data_out1, panel_width, f_width, f_height);
            case tab2
                resize_graph(data_in2,data_out2, panel_width, f_width, f_height);
            case tab3
                resize_graph(data_in3,data_out3, panel_width, f_width, f_height);
            case tab4
                resize_graph4(data_in4,data_out4, panel_width, f_width, f_height);
        end
    end

    function edit_cb(hObject,eventdata)
       str=get(hObject,'string');
       str=strrep(str,',','.');
       var=str2double(str);
       if isnan(var)
           beep;
           set(hObject,'String', '');
       else
           set(hObject,'String',var);
       end        
    end

    function fh_WindowButtonMotionFcn(hObject, eventdata)
        selected_tab=get(hTabGroup,'SelectedTab');
        switch selected_tab
            case tab1
                data_in=data_in1;
                data_out=data_out1;
            case tab2
                data_in=data_in2;
                data_out=data_out2;
            case tab3
                data_in=data_in3;
                data_out=data_out3;       
            case tab4
                data_in=data_in4;
                data_out=data_out4; 
        end                  
                
        pos1=get(data_in,'currentpoint');
        pos2=get(data_out,'currentpoint');
        XLim1=get(data_in,'XLim');
        YLim1=get(data_in,'YLim');
        XLim2=get(data_out,'XLim');
        YLim2=get(data_out,'YLim');
        if pos1(1,1)>=XLim1(1) && pos1(1,1)<=XLim1(2) && ...
                pos1(1,2)>=YLim1(1) && pos1(1,2)<=YLim1(2)
            set(x_out_lbl,'string', num2str(pos1(1,1),5));
            set(y_out_lbl,'string', num2str(pos1(1,2),5));
            state=getappdata(0,'state');
            if strcmp(state, 'define_zl1') || strcmp(state,'define_zl2') ||...
                    strcmp(state,'define_edge') || strcmp(state,'refine_edge') ||...
                    strcmp(state,'fit_bkg1') || strcmp(state,'fit_bkg2') || ...
                    strcmp(state,'define_edge2') || strcmp(state,'define_edge3')
                if strcmp(state,'define_zl1') || strcmp(state,'define_zl2')
                    data=getappdata(0, 'zl_data');
                elseif strcmp(state,'define_edge') || strcmp(state,'refine_edge')
                  switch index
                    case 2
                      data_str='edge_data';  
                    case 3
                      data_str='fe_data';
                    case 4
                      data_str='general_data';
                  end              
                  data=getappdata(0,data_str);
                else                   
                    data=getappdata(0, 'edge_data');
                end
                x(1)=pos1(1,1);
                x(2)=x(1);
                y=YLim;               
                cla(data_in);
                axes(data_in);
                
                plot(data_in, data.x,data.y,'b-');
                hold on;
                plot(data_in, x,y,'r--');
                if index==4
                   xrange=getappdata(0,'XLim');
                   yrange=getappdata(0,'YLim');
                   set(data_in, 'XLim', xrange);
                   set(data_in, 'YLim', yrange);                   
                end
                if strcmp(state,'refine_edge')
                   edge_pos=str2num(get(peakpos_txt, 'string'));
                   XLim=[edge_pos-10, edge_pos+10];  
                   set(data_in, 'XLim', XLim);
                end      
                if strcmp(state, 'define_zl2') 
                   x(1)=str2double(get(edgelpos_txt,'string'));
                   x(2)=x(1);
                   y=YLim;
                   plot(data_in,x,y,'r-');                     
                end
                
                
            %%define the arcus_tan function
            elseif strcmp(state,'define_atan1') || strcmp(state,'define_atan2') ||...
                    strcmp(state,'define_atan3')
                 switch index
                    case 3  
                        data=getappdata(0, 'fe_data');
                    case 4
                        data=getappdata(0, 'general_data');
                  end  
               
                x(1)=pos1(1,1);
                x(2)=x(1);
                y=YLim;               
                cla(data_in);
                axes(data_in);
                plot(data_in, data.x,data.y,'b.');                
                hold on;
                plot(data_in, x,y,'r--');
                if strcmp(state, 'define_atan2') || strcmp(state,'define_atan3');
                   atan_data=getappdata(0,'atan_data');
                   x(1)=atan_data.zero;
                   x(2)=x(1);
                   y=Ylim;
                   plot(data_in,x,y,'r-');
                   if strcmp(state, 'define_atan3')
                       atan_data=getappdata(0,'atan_data');
                       x(1)=atan_data.h1;
                       x(2)=x(1);
                       y=Ylim;
                       plot(data_in,x,y,'r-');
                   end
                end 
                hold off;
            end
            
            if strcmp(state,'fit_bkg2')
               fit_data=getappdata(0,'fitbkg_data');
               x(1)=fit_data.bd1;
               x(2)=x(1);
               y=YLim;
               plot(data_in,x,y,'r-'); 
            end
            
            
            %***********************************************
            %************tab4 fitting  listeners************
            %***********************************************
            if strcmp(state, 'site_define1')
                %first define the line:
                x(1)=pos1(1,1);
                x(2)=x(1);
                y(1)=0;
                y(2)=pos1(1,2);
                
                
                site=getappdata(0,'site_data');
                site_num=getappdata(0,'site_num');
                
                site(site_num).center=x(1);
                if strcmp(site(site_num).type, 'Lorentzian')
                    site(site_num).intensity=y(2)*(pi*site(site_num).hwhm);
                elseif strcmp(site(site_num).type, 'Gaussian');
                    site(site_num).intensity=y(2)*(sqrt(pi)*site(site_num).hwhm/0.8326);
                elseif strcmp(site(site_num).type, 'PseudoVoigt')
                    site(site_num).intensity=y(2)*...
                        site(site_num).n*(pi*site(site_num).hwhm)+...
                        (1-site(site_num).n)*y(2)*(sqrt(pi)*site(site_num).hwhm/0.8326);           
                end
                site(site_num).height=y(2);
                
                setappdata(0,'site_data', site);
                
                %update text boxes:
                update_txt();

                %plotting all data
                %to define the main output plot
                plot(data_in, x,y,'r-');
                hold on;
                plot_all();
            elseif strcmp(state,'site_define2')
               site=getappdata(0,'site_data');
               site_cur=getappdata(0,'site_cur');
               site_num=getappdata(0,'site_num');

               %define the positions of the line
               x(1)=pos1(1,1);
               hwhm=(x(1)-site(site_cur).center);

               site(site_num).fwhm=abs(hwhm)*2;
               if strcmp(site(site_num).type, 'Lorentzian')
                 site(site_num).intensity=abs(hwhm)*pi*site(site_num).height;
               elseif strcmp(site(site_num).type, 'Gaussian')
                   site(site_num).intensity=site(site_num).height*(sqrt(pi)*site(site_num).hwhm/0.8326);
               elseif strcmp(site(site_num).type, 'PseudoVoigt')
                   site(site_num).intensity=site(site_num).height*...
                      site(site_num).n*(pi*site(site_num).hwhm)+...
                     (1-site(site_num).n)*site(site_num).height*(sqrt(pi)*site(site_num).hwhm/0.8326);   
               end
               x(2)=x(1)-2*hwhm;
               y(1)=0.5*site(site_cur).height;
               y(2)=y(1);

               %save site parameter:
               setappdata(0,'site_data', site);


               %plot data, vline, new hline
               plot(data_in, [site(site_cur).center site(site_cur).center],[0, site(site_cur).height],'r-'); 
               hold on;
               plot(data_in, x,y,'r-');
               plot_all();     
               hold off;
               %updating the fwhm_txt toolbox
               update_txt();
            end
            hold off;
        elseif pos2(1,1)>=XLim2(1) && pos2(1,1)<=XLim2(2) && ...
                pos2(1,2)>=YLim2(1) && pos2(1,2)<=YLim2(2)
            set(x_out_lbl,'string', num2str(pos2(1,1),5));
            set(y_out_lbl,'string', num2str(pos2(1,2),5));
            %what to do when definine a fit:               
        else
           set(x_out_lbl,'string', '');
           set(y_out_lbl,'string', '');
        end
    end

    function fh_WindowButtonDownFcn(hObject, eventdata)
        selected_tab=get(hTabGroup,'SelectedTab');
        switch selected_tab
            case tab1
                data_in=data_in1;
                data_out=data_out1;
            case tab2
                data_in=data_in2;
                data_out=data_out2;
            case tab3
                data_in=data_in3; 
                data_out=data_out3;
            case tab4
                data_in=data_in4; 
                data_out=data_out4;
                
                
                
        end                  
        pos=get(data_in,'currentpoint');
        pos2=get(data_out,'currentpoint');
        XLim=get(data_in,'XLim');
        YLim=get(data_in,'YLim');
        XLim2=get(data_out,'XLim');
        YLim2=get(data_out,'YLim');
        if pos(1,1)>=XLim(1) && pos(1,1)<=XLim(2) && ...
                pos(1,2)>=YLim(1) && pos(1,2)<=YLim(2)            
           state=getappdata(0,'state');
           if strcmp(state,'define_zl1')
               set(edgelpos_txt,'string', str2double(get(x_out_lbl,'string')));
               set(msg_lbl,'string', 'Please define the right boundary of the zero-loss peak');
               setappdata(0,'state', 'define_zl2');
            elseif strcmp(state,'define_zl2')
               set(edgerpos_txt,'string', str2double(get(x_out_lbl,'string')));
               set(msg_lbl,'string','');
               fitzlpeak;
               data=getappdata(0,'zl_data');
               cla(data_in);
               plot(data_in, data.x,data.y);
               setappdata(0,'state','normal');
           elseif strcmp(state,'define_edge') 
               define_edge(pos); 
               setappdata(0,'state','refine_edge');                    
           elseif strcmp(state,'refine_edge')
               setappdata(0,'state','normal');
               define_edge(pos);      
           elseif strcmp(state,'fit_bkg1')
               fitbkg_data.bd1=pos(1,1);
               setappdata(0,'fitbkg_data',fitbkg_data);
               setappdata(0,'state', 'fit_bkg2');
           elseif strcmp(state,'fit_bkg2')
               fitbkg_data=getappdata(0,'fitbkg_data');
               fitbkg_data.bd2=pos(1,1);
               setappdata(0,'fitbkg_data',fitbkg_data);
               fit_bkg;
               setappdata(0,'state', 'normal');
           elseif strcmp(state,'define_edge2')
               define_edge2(pos);
               setappdata(0,'state','normal');
           elseif strcmp(state,'define_edge3')
               define_edge3(pos);
               setappdata(0,'state','normal');
           elseif strcmp(state, 'define_atan1')
               atan_data.zero=pos(1,1);
               setappdata(0,'atan_data',atan_data);
               setappdata(0,'state', 'define_atan2');
               set(msg_lbl,'String', 'Please define the height of the first step.');
           elseif strcmp(state, 'define_atan2')
               atan_data=getappdata(0,'atan_data');
               atan_data.h1=pos(1,1);
               if index==3
                 set(h1_txt,'String',num2str(atan_data.h1));
               end
               setappdata(0, 'atan_data', atan_data);               
               if index==4 && get(ti_atan_cb,'value')
                  setappdata(0,'state','normal');
                  ev_tan();
               else
                 setappdata(0, 'state', 'define_atan3');
                 set(msg_lbl,'String', 'Please define the height of the second step.');
               end
           elseif strcmp(state, 'define_atan3')
               atan_data=getappdata(0,'atan_data');
               setappdata(0,'state', 'normal');
               atan_data.h2=pos(1,1);
               setappdata(0, 'atan_data', atan_data);
               switch index
                 case 3  
                   calc_fe();
                   set(h2_txt,'String',num2str(atan_data.h2));
                 case 4
                   ev_tan();
               end  
               set(msg_lbl,'String', ''); 
           elseif strcmp(state,'site_define1')
               setappdata(0,'state', 'site_define2');
           elseif strcmp(state, 'site_define2')
               setappdata(0,'state', 'normal');
               plot_all;
           end
        elseif pos2(1,1)>=XLim2(1) && pos2(1,1)<=XLim2(2) && ...
                pos2(1,2)>=YLim2(1) && pos2(1,2)<=YLim2(2)            
            set(x_out_lbl,'string', num2str(pos2(1,1),5));
            set(y_out_lbl,'string', num2str(pos2(1,2),5));
           
        end   
    end
    function saveu_btn_click(hObject, eventdata)
        selected_tab=get(hTabGroup,'SelectedTab');
        switch selected_tab
            case tab1
                data_in=data_in1;
            case tab2
                data_in=data_in2;
            case tab3
                data_in=data_in3;    
            case tab4
                data_in=data_in4;  
        end       
        lh=findall(data_in,'type','line'); 
        data.x=get(lh,'xdata');
        data.y=get(lh,'ydata');
        if ~iscell(data.x)
           mat(:,1)=data.x;
           mat(:,2)=data.y;
        else
          l=zeros(length(data.x),1);
          for n=1:length(data.x)
            l(n)=length(data.x{n});
          end
          mat=ones(max(l),2);
          for n=1:length(data.x)
            mat(1:l(n),2*n-1)=data.x{n};
            mat(1:l(n),2*n)=data.y{n};
          end
          [r,c]=find(mat==1);
          mat(r,c)=NaN;
        end
        save_path=getappdata(0, 'save_path');
        file_name=getappdata(0, 'file_name');
        [file, path]=uiputfile('*.*','Save plot data from upper graph',[save_path,file_name,'.txt']) ;
        if path
            setappdata(0,'save_path', path);
            dlmwrite([path, file], mat,'delimiter', '\t');
            fclose('all');
        end;
    end

    function savel_btn_click(hObject, eventdata)
       selected_index=get(hTabGroup,'SelectedTab');
        switch selected_index
            case tab1
                data_out=data_out1;
            case tab2
                data_out=data_out2;
            case tab3
                data_out=data_out3;    
        end       
        lh=findall(data_out,'type','line'); 
        data.x=get(lh,'xdata');
        data.y=get(lh,'ydata');
        if ~iscell(data.x)
           mat(:,1)=data.x;
           mat(:,2)=data.y;
        else
          l=ones(length(data.x),1);
          for n=1:length(data.x)
            l(n)=length(data.x{n});
          end
          mat=ones(max(l),2);
          for n=1:length(data.x)
            mat(1:l(n),2*n-1)=data.x{n};
            mat(1:l(n),2*n)=data.y{n};
          end
          [r,c]=find(mat==1);
          mat(r,c)=NaN;
        end
        save_path=getappdata(0, 'save_path');
        file_name=getappdata(0, 'file_name');
        [file, path]=uiputfile('*.*','Save plot data from lower graph',[save_path,file_name]) ;
        if path
            setappdata(0,'save_path', path);
            dlmwrite([path, file], mat,'delimiter', '\t');
            fclose('all');
        end;
    end

%************************************************************************
%*********saving the graphs as fig file
%************************************************************************
    function save_graphs_btn_click(~,~)
        selected_tab=get(hTabGroup,'SelectedTab');%determine where we are in the program
        outf=figure; %make a new figure
        %get the handles of the graphs, for the index selected:
        %the graph gets a resizefunction, because with subplots, i think
        %the distances are too far....
        
        switch selected_tab
            case tab1
                graph1=data_in1;
                graph2=data_out1;
                set(outf,'resizeFcn',@fh_out_resizeFcn);
            case tab2
                graph1=data_in2;
                graph2=data_out2;
                set(outf,'resizeFcn',@fh_out_resizeFcn);
            case tab3
                graph1=data_in3;
                graph2=data_out3;
                set(outf,'resizeFcn',@fh_out_resizeFcn);
            case tab4
                graph1=data_in4;
                graph2=data_out4;
                set(outf,'resizeFcn',@fh_out2_resizeFcn);
        end
        out1=axes('Parent', outf,'units','pixel', 'outerposition', [0 height/2 width-panel_width  height/2]);
        out2= axes('Parent', outf,'units','pixel', 'outerposition', ...
             [0 0 width-panel_width height/2]);
        copyobj(get(graph1,'children'),out1);
        set(out1,'XLim',get(graph1,'XLim'));
        set(out1,'YLim',get(graph1,'YLim'));
        
        copyobj(get(graph2,'children'),out2);  
        set(out2,'XLim',get(graph2,'XLim'));
        set(out2,'YLim',get(graph2,'YLim'));
    end

%next are the two different resize functions
    function fh_out_resizeFcn(hObject,eventdata)
        fig_pos=get(hObject,'Position');   
        f_width=fig_pos(3); 
        f_height=fig_pos(4);      
        
        out=get(hObject,'Children');
        resize_graph(out(2),out(1),0,f_width,f_height);    
        
    end

    function fh_out2_resizeFcn(hObject, eventdata)
        fig_pos=get(hObject,'Position');   
        f_width=fig_pos(3); 
        f_height=fig_pos(4);     
        out=get(hObject,'Children');
        resize_graph4(out(2),out(1),0,f_width,f_height);   
    end

%*************************************************************************


    function define_edge(pos)
       selected_index=get(hTabGroup,'SelectedTab');
       data_str='';
       switch selected_index
         case tab2
           data_str='edge_data';
           data_in=data_in2;
           edge_pos=str2double(get(peakpos_txt,'String'));
         case tab3            
           data_str='fe_data';
           data_in=data_in3;
           edge_pos=str2double(get(edgepos2_txt,'String'));
         case tab4        
           data_str='general_data';
           data_in=data_in4;
           edge_pos=str2double(get(edgepos3_txt,'String'));
       end  
       data=getappdata(0,data_str);
       step=mean(diff(data.x));

       indice1=find(data.x<pos(1,1));
       indice2=find(data.x>pos(1,1));

       index1=indice1(length(indice1));
       index2=indice2(1);
       difference=data.x(index2)-data.x(index1);
       if difference>=step/2
           ind=index2;
       else
           ind=index1;
       end
       data.x=edge_pos-(ind-1).*step+(1:length(data.x))*step;
       cla(data_in);       
       plot(data_in, data.x, data.y);         
       
       setappdata(0,data_str,data);
       
       if selected_index==4     
           setappdata(0, 'fit_data', data);
%            plot_all();
       end
       set(msg_lbl,'string', '');
    end



%************************************************************************
%%**********************Callbacks for Tab1*****************************
%*********************************************************************



    function loadll_btn_click(hObject, eventdata)
        work_path=getappdata(0, 'work_path');
        [file, path]=uigetfile([work_path,'*.*'],'Select Zero-Loss File(s)','Multiselect','On');
        if path
            setappdata(0,'work_path', path);

            cla(data_in1);
            axes(data_in1);
            hold on;
            if ~ischar(file)
                for n=1:length(file)  
                    string=[path, file{n}];
                    misc=load(string);
                    zl_data.x(:,n)=misc(:,1);
                    zl_data.y(:,n)=misc(:,2);
                    plot(data_in1, zl_data.x(:,n), zl_data.y(:,n));              
                end
                merge_btn=uicontrol(tab1,'Style', 'pushbutton','String','Merge Spectra',...
                    'Position', [135 280 90 30],'callback', @merge_btn_click);

                setappdata(0,'file_name',file{1});

            else
               misc=load([path,file]);
               zl_data.x=misc(:,1);
               zl_data.y=misc(:,2);
               x_step=mean(diff(zl_data.x));
               [max_val, max_ind]=max(zl_data.y);
               zl_data.x(:)=-max_ind*x_step+(1:size(zl_data.x,1))*x_step; 
               
               plot(data_in1,zl_data.x,zl_data.y);
               setappdata(0,'file_name',file);
               setappdata(0, 'zl_ind', max_ind);
            end
            hold off;
            setappdata(0,'zl_data',zl_data);
            set(edgelpos_txt,'String','');
            set(edgerpos_txt,'String','');
            set(fwhm_txt,'String','');
            set(I0I_txt,'String','');
            set(I0LL_txt,'String','');
            resize_graphs; 
        end;
    end


    function definezl_btn_click(hObject, eventdata)
        set(msg_lbl,'String', 'Please define the left boundary of the zero-loss peak');
        setappdata(0, 'state', 'define_zl1');
    end

   
    function merge_btn_click(hObject, eventdata)
        zl_data=getappdata(0,'zl_data');
        
        x_step=mean(diff(zl_data.x(:,1)));
        
        %get indices for the maximum
        for n=1:size(zl_data.x,2)
            [max_val(n),max_ind(n)]=max(zl_data.y(:,n));
             zl_data.x(:,n)=-max_ind(n)*x_step+(1:size(zl_data.x,1))*x_step;               
        end
        %find the maximum and minimum of indices to add zl_data:
        min_inf2=min(max_ind);
        max_inf2=max(max_ind);
        num1=(max_ind(1)-(min_inf2-1));
        num2=(max_ind(1)+size(zl_data.x,1)-max_inf2);
        misc.y=zl_data.y(num1:num2,1);
        for n=2:size(zl_data.x,2)
           num1=(max_ind(n)-(min_inf2-1));
           num2=(max_ind(n)+size(zl_data.x,1)-max_inf2);
           misc.y=misc.y+zl_data.y(num1:num2,n);
        end
        misc.x=zl_data.x((max_ind(1)-(min_inf2-1)):(max_ind(1)+size(zl_data.x,1)-max_inf2),1);
        zl_data=misc;
        plot(data_in1, zl_data.x,zl_data.y);              
        
        [blub,zl_ind]=max(zl_data.y);
        setappdata(0, 'zl_ind', zl_ind);
        setappdata(0,'zl_data',zl_data);
        resize_graphs;
        delete(hObject);
    end

   


%%************************************************************************
%**********************Callbacks for Tab2********************************
%************************************************************************
    function loaddat_btn_click(hObject, eventdata)
        work_path=getappdata(0, 'work_path');
        [file, path]=uigetfile([work_path,'*.*'],'Select Edge-File(s)','Multiselect','On');
        if path
            setappdata(0,'work_path', path);

            axes(data_in2);
            cla(data_in2);
            hold on;
            if ~ischar(file)
                for n=1:length(file)  
                    string=[path, file{n}];
                    misc=load(string);
                    edge_data.x(:,n)=misc(:,1);
                    edge_data.y(:,n)=misc(:,2);
                    plot(data_in2, edge_data.x(:,n), edge_data.y(:,n));              
                end
                merge_edge_btn=uicontrol(tab2,'Style', 'pushbutton','String','Merge Spectra',...
                    'Position', [135 280 90 30],'callback', @merge_edge_btn_click);

                set(fh,'Name',['EELS Analysis  -  ', file{1}]); 
                setappdata(0,'file_name',file{1});
            else
               misc=load([path,file]);
               edge_data.x=misc(:,1);
               edge_data.y=misc(:,2);
               plot(edge_data.x,edge_data.y);
               set(fh,'Name',['EELS Analysis  -  ', file]); 
               setappdata(0,'file_name',file);
            end
            hold off;      
            setappdata(0,'edge_data',edge_data);
            resize_graphs;
        end
    end

    function merge_edge_btn_click(hObject, eventdata)
        edge_data=getappdata(0,'edge_data');
        for n=1:size(edge_data.x,2)
            %smooth the initial spectra
            smooth_edge_data.y(:,n)=smooth(edge_data.y(:,n),60,'loess');
            %find derivative
            for l=2:(size(edge_data.x,1)-1)
                der_edge_data.y(l-1,n) = (smooth_edge_data.y(l+1,n)-smooth_edge_data.y(l-1,n))/((edge_data.x(l+1,n)-edge_data.x(l-1,n)));
            end
            for l=2:(size(der_edge_data.y,1)-1)
                der2_edge_data.y(l-1,n) = (der_edge_data.y(l+1,n)-der_edge_data.y(l-1,n))/((edge_data.x(l+1,n)-edge_data.x(l-1,n)));
            end
            %find maximum index of derivative:
            [max_val, max_ind(n)]=min(der2_edge_data.y(:,n));
            max_ind(n)=max_ind(n)+2; % since derivative starts at second channel
        end
        
        min_inf2=min(max_ind);
        max_inf2=max(max_ind);
        num1=(max_ind(1)-(min_inf2-1));
        num2=(max_ind(1)+size(edge_data.x,1)-max_inf2);
        
        misc.y(:,1)=edge_data.y(num1:num2,1);
        misc.x(:,1)=edge_data.x((max_ind(1)-(min_inf2-1)):(max_ind(1)+size(edge_data.x,1)-max_inf2),1);
        axes(data_out2);
        plot(data_out2, misc.x(:,1), misc.y(:,1));
        hold on;
        for n=2:size(edge_data.x,2)
           num1=(max_ind(n)-(min_inf2-1));
           num2=(max_ind(n)+size(edge_data.x,1)-max_inf2);
           misc.y(:,n)=edge_data.y(num1:num2,n);
           misc.x(:,n)=edge_data.x((max_ind(1)-(min_inf2-1)):(max_ind(1)+size(edge_data.x,1)-max_inf2),1);
           plot(data_out2, misc.x(:,n), misc.y(:,n));
        end
        hold off;             
        
        new_edge_data.y=misc.y(:,1);
        for n=2:size(edge_data.x,2)
            new_edge_data.y=new_edge_data.y+misc.y(:,n);
            new_edge_data.x=misc.x(:,n);
        end
        plot(data_in2, new_edge_data.x, new_edge_data.y);
        setappdata(0,'edge_data', new_edge_data);
        axes(data_in2);
        resize_graphs;
        delete(hObject);       
    end

    function defineedge_btn_click(hObject, eventdata)
        setappdata(0,'state', 'define_edge');
    end
    function fitbkg_btn_click(hObject, eventdata)
        setappdata(0, 'state', 'fit_bkg1');
    end
    function decon_btn_click(hObject,eventdata)
        data_bs=getappdata(0,'edge_data_bs');
        data_zl=getappdata(0,'zl_data');
        step=mean(diff(data_bs.x));
        
        %scale the zeroloss peak if the deconvolution is too strong and if
        %the zeroloss peak was taken from another point than the spectrum
        
        zl_factor=str2double(get(zl_factor_txt,'String'));
        lb=str2double(get(edgelpos_txt,'String'));
        rb=str2double(get(edgerpos_txt,'String'));
        scale_ind=find(data_zl.x>lb & data_zl.x<rb);
        data_zl.y(scale_ind)=data_zl.y(scale_ind)*zl_factor;
        
        
        plot(data_in2, data_bs.x,data_bs.y);
%         plot(data_in2, data_zl.x,data_zl.y);
        fwhm_decon=str2double(get(fwhm_decon_txt,'string'))/2;
        fwhm_zl=str2double(get(fwhm_txt,'string'));
        
        method=get(decon_pop,'value');
        switch method
            case 1
                att=gauss_curve(400,fwhm_decon./step*2,max(data_zl.y)*sqrt(pi)*fwhm_zl/1.6652,(1:size(data_zl.x,1)));         
            case 2
                att=lorentz_curve(400,fwhm_decon./step*2,max(data_zl.y).*pi.*fwhm_zl./2,(1:size(data_zl.x,1))); 
        end      
        num_chan=min([size(data_bs.x,2), size(data_zl.x,1), length(att)]);
        data_decon.y=ifft(fft(att(1:num_chan))'.*fft(data_bs.y(1:num_chan))./fft(data_zl.y(1:num_chan)));
        data_decon.x=data_bs.x(1:num_chan);
        plot(data_out2, data_decon.x,data_decon.y);    
        
        %now shifting the data two original position:
        
        zl_ind=getappdata(0, 'zl_ind');
        l=length(data_decon.x);
        shift=400+zl_ind;
        num1=l-shift+1;
        num2=l;
        misc.x=zeros(l,1);
        misc.y=zeros(l,1);
        misc.x=data_decon.x;
        misc.y(1:shift)=data_decon.y(num1:num2);
        
        misc.y((shift+1):l)=data_decon.y(1: l-shift);
        misc.y=misc.y';
        cla(data_out2);
        plot(data_out2, misc.x,misc.y);
        setappdata(0,'data_decon', misc);
        setappdata(0,'general_data',misc);     
        setappdata(0,'fit_data',misc);  
        setappdata(0,'YLim', [min(misc.y)*0.95 max(misc.y)*1.05]);
       
        axes(data_in4);
        plot(misc.x, misc.y);
        xlim([str2double(get(range1_txt,'string')) str2double(get(range2_txt,'string'))]);
        set(data_in4, 'visible','off');
        set(get(data_in4, 'children'), 'visible','off');
        
        fe_indices=find(misc.x>700 & misc.x<740);
        fe_data.x=misc.x(fe_indices);
        fe_data.y=misc.y(fe_indices);
        fe_data.y=fe_data.y - min(fe_data.y);
        plot(data_in3, fe_data.x,fe_data.y);
        set(data_in3, 'visible','off');
        set(get(data_in3, 'children'), 'visible','off');
        setappdata(0,'fe_data',fe_data);      
        setappdata(0,'tab3_in_data', fe_data);
    end

%*********************************************************************
%**********************Callbacks for Tab3*****************************
%*********************************************************************
    function fittan_btn_click(hObject, eventdata)
         set(msg_lbl,'String', 'Please define the zero-value');
         setappdata(0, 'state', 'define_atan1');
    end


%%*********************************************************************
%**********************Callbacks for Tab4*****************************
%*********************************************************************
    function range_txt_callback(hObject, eventdata)
       str=get(hObject,'string');
       str=strrep(str,',','.');
       
       var=str2double(str);
       if isnan(var)
           beep;
           XLim=getappdata(0,'XLim');
           set(range1_txt,'String', XLim(1));
           set(range2_txt, 'String', XLim(2));
       else
           %concerning the x values
           x1=str2double(get(range1_txt,'String'));
           x2=str2double(get(range2_txt,'String'));
           setappdata(0,'XLim', [x1 x2]);
           
           %concerning the y range:
           
           data=getappdata(0,'fit_data');
           %find indices in the limit:
           ind= data.x>x1 & data.x<x2;
           adjust=0.1*range(data.y(ind));
           
           setappdata(0,'YLim', [min(data.y(ind))-adjust max(data.y(ind))+adjust]);    
           
           plot_all;
       end
    end
    
    function load_general_data_btn_click(hObject,eventdata)
        work_path=getappdata(0, 'work_path');
        [file, path]=uigetfile([work_path,'*.*'],'Select Edge-File(s)');
        if path
            setappdata(0,'work_path', path);

            axes(data_in4);
            cla(data_in4);
            hold on;
           
            misc=load([path,file]);
            general_data.x=misc(:,1)';
            general_data.y=misc(:,2)';
            
                       
            set(fh,'Name',['EELS Analysis  -  ', file]); 
            setappdata(0,'file_name',file);
            
            hold off;      
            setappdata(0,'general_data',general_data);
            setappdata(0,'fit_data',general_data);
            setappdata(0,'YLim', [min(general_data.y)*0.95 max(general_data.y)*1.05]);
            resize_graphs;
            plot_all;
        end        
    end

    function add_btn_click(hObject,eventdata)
        state=getappdata(0,'state');
        data=getappdata(0,'fit_data');
        if strcmp(state,'normal');
            plot_all();
            
            setappdata(0,'state','site_define1');

            site_num=getappdata(0,'site_num')+1;
            setappdata(0,'site_num',site_num);
            setappdata(0,'site_cur',site_num);

            %define initial values
            site=getappdata(0,'site_data');
            site(site_num)=csite(0,2,min(data.y));
            
            bd=[str2double(get(center_bd_txt,'string'));
                str2double(get(fwhm_site_bd_txt,'string'));
                str2double(get(intensity_bd_txt,'string'))];
            
            site(site_num).bounds=bd;

            type=get(site_type_pop,'String');
            site(site_num).type=type(get(site_type_pop,'Value'));

            if strcmp(site(site_num).type, 'PseudoVoigt')
                site(site_num).n=0.5;
            end
            
            setappdata(0,'site_data', site);

            %define the slider things
            set(site_num_txt, 'String', site_num);
            if site_num>=2
                set(site_num_cnt, 'Enable','on');
                set(site_num_cnt, 'Max', site_num);
                set(site_num_cnt, 'Min', 1);
                set(site_num_cnt, 'Value' , site_num);
                set(site_num_cnt, 'SliderStep', [1/(site_num-1) 5]);
            end
        end        
    end

    function delete_btn_click(hObject, eventdata)
         % hObject    handle to del_btn (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
        site_cur=getappdata(0,'site_cur');
        site_old=getappdata(0,'site_data');
        site_num=getappdata(0,'site_num');
        counter=0;
        if site_num>1
            for k=1:site_num
                if k~=site_cur
                    counter=counter+1;
                    site_new(counter)=site_old(k);
                end
            end
            setappdata(0,'site_data', site_new);
            site=site_new;
            site_num=site_num-1;
        else
            site_num=0;
        end

        setappdata(0,'site_num', site_num);

        %slider mist:

        if site_cur>1
            site_cur=site_cur-1;
            %reset the textboxes
            %update_txt();;
        else
            site_cur=1;
            %reset the textboxes
            if site_num>=1

            else
                set(center_txt,'String','');
                set(fwhm_site_txt,'String',0.19);
                set(intensity_txt,'String','');
            end
        end

        set(site_num_txt, 'String', site_cur);
        set(site_num_cnt, 'Value', site_cur);
        setappdata(0,'site_cur', site_cur);

        if site_num>=1
            set(site_num_cnt, 'Enable','on');
            if site_num>=2
              set(site_num_cnt, 'SliderStep', [1/(site_num-1) 5]);          
            end
            set(site_num_cnt, 'Max', site_num);
        else
            set(site_num_cnt, 'Enable', 'off');
            set(site_num_txt, 'String', 1);
        end
        update_txt();
        plot_all();
        %replot all data
    end

    function graphnr_cnt_click(hObject, eventdata)
        set(site_num_txt,'String', get(hObject, 'Value'));
        setappdata(0,'site_cur', get(hObject, 'Value'));
        plot_all();
        update_txt();        
    end
    
    %******************************************************
    %***************changing site param********************
    function center_txt_callback(hObject,eventdata)    
       site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');
       str=strrep(str,',','.');
       
       var=str2double(str);
       if isnan(var)
           beep;
           set(hObject,'String', site(site_cur).center);
       else
           set(hObject,'String',var);               
           site(site_cur).center=var;
           setappdata(0, 'site_data', site);
           plot_all();
       end      
    end
    function fwhm_site_txt_callback(hObject,eventdata)
       site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');       
       str=strrep(str,',','.');       
       
       var=str2double(str);
       if isnan(var) || var<0
           beep;
           set(hObject,'String', site(site_cur).fwhm);
       else
           set(hObject,'String',var);       
           site(site_cur).fwhm=var;
           setappdata(0, 'site_data', site);
           plot_all();
       end
    end
    function intensity_txt_callback(hObject, eventdata)
       site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');       
       str=strrep(str,',','.');       
       
       var=str2double(str);
       if isnan(var) || var<0
           beep;
           set(hObject,'String', site(site_cur).intensity);
       else
           set(hObject,'String',var);       
           site(site_cur).intensity=var;
           setappdata(0, 'site_data', site);
           plot_all();
       end
    end

    function pv_n_txt_callback(hObject, eventdata)
       site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');       
       str=strrep(str,',','.');       
       
       var=str2double(str);
       if isnan(var) || var<0 ||var>1
           beep;
           set(hObject,'String', site(site_cur).n);
       else
           set(hObject,'String',var);       
           site(site_cur).n=var;
           setappdata(0, 'site_data', site);
           plot_all();
       end
    end
    %*****************************************************
    %***************changing boundaries********************
    function center_bd_txt_callback(hObject,eventdata)    
       site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');       
       str=strrep(str,',','.');       
       
       var=str2double(str);
       if isnan(var) || var<0
           beep;
           set(hObject,'String', site(site_cur).center-site(site_cur).center_min);
       else
           set(hObject,'String',var);       
           site(site_cur).center_min=site(site_cur).center-var;
           site(site_cur).center_max=site(site_cur).center+var;
           setappdata(0, 'site_data', site);
           plot_all();
       end       
    end

    function fwhm_site_bd_txt_callback(hObject,eventdata)
        site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');       
       str=strrep(str,',','.');       
       
       var=str2double(str);
       if isnan(var) || var<0
           beep;
           set(hObject,'String', (site(site_cur).hwhm-site(site_cur).hwhm_min)*2);
       else
           set(hObject,'String',var);       
           site(site_cur).hwhm_min=site(site_cur).hwhm-var/2;
           site(site_cur).hwhm_max=site(site_cur).hwhm+var/2;
           setappdata(0, 'site_data', site);
           plot_all();
       end
    end


    function intensity_bd_txt_callback(hObject, eventdata)
       site=getappdata(0,'site_data');       
       site_cur=getappdata(0,'site_cur');
       
       str=get(hObject,'string');       
       str=strrep(str,',','.');       
       
       var=str2double(str);
       if isnan(var) || var<0
           beep;
           set(hObject,'String', site(site_cur).intensity-site(site_cur).intensity_min);
       else
           set(hObject,'String',var);       
           site(site_cur).intensity_min=site(site_cur).intensity-var;
           site(site_cur).intensity_max=site(site_cur).intensity+var;
           setappdata(0, 'site_data', site);
           plot_all();
       end
    end


    %*********************************** changing fit
    %checkboxes*****************
    function center_cb_click(hObject, eventdata)
        site=getappdata(0,'site_data');
        site_cur=getappdata(0,'site_cur');
        site(site_cur).fit(1)=get(hObject,'Value');
        if ~site(site_cur).fit(1)
            site(site_cur).center_error=NaN;
        end         
        setappdata(0,'site_data',site);        
    end

    function fwhm_cb_click(hObject, eventdata)
        site=getappdata(0,'site_data');
        site_cur=getappdata(0,'site_cur');
        site(site_cur).fit(2)=get(hObject,'Value');
        if ~site(site_cur).fit(2)
            site(site_cur).fwhm_error=NaN;
        end         
        setappdata(0,'site_data',site);     
        setappdata(0,'site_data',site);        
    end

    function intensity_cb_click(hObject, eventdata)
        site=getappdata(0,'site_data');
        site_cur=getappdata(0,'site_cur');
        site(site_cur).fit(3)=get(hObject,'Value');
        if ~site(site_cur).fit(3)
            site(site_cur).intensity_error=NaN;
        end     
        setappdata(0,'site_data',site);        
    end


    function fit_site_btn_click(hObject, eventdata)
        site=getappdata(0,'site_data');
    

        %fitting procedure
        fitting=cfit(site, output_txt);
        
        [site, ~,residual]=fitting.process();
        setappdata(0,'site_data',site);
        setappdata(0,'residual',residual);
%         set(handles.datatable, 'Data', table);
        update_txt();
        
        %**************************************************************
        %plotting all data
        %**************************************************************
        plot_all();
        data=getappdata(0,'fit_data');
        xrange=getappdata(0, 'XLim');
        indices= xrange(1)<=data.x & data.x<=xrange(2);
        data.x=data.x(indices);
        axes(data_out4);
        plot(data_out4, data.x,residual,'r.'); 
        hold on;
        plot(data_out4, xrange, [0 0], 'k-');
        hold off;
        set(data_out4,'XLim', xrange);
    end

    function save_sites_btn_click(hObject, eventdata)
        work_path=getappdata(0,'work_path');
        [file,path,FilterIndex] = uiputfile([work_path,'*.*'],...
            'Save fitted Site parameter');
        if path
            output(1,:)= {'site', 'center','error','FWHM', 'error', 'intensity','error',...
                'n','error'};
            site=getappdata(0,'site_data');
            site_num=getappdata(0,'site_num');

            for k=1:site_num
               output(k+1,:)={k, site(k).center, site(k).center_error,...
                   site(k).fwhm, 2*site(k).fwhm_error,...
                   site(k).intensity, site(k).intensity_error,...
                   site(k).n,site(k).n_error};
            end   
            dlmcell([path,file],output,';');
        end  
        
        
    end

    function save_graph_btn_click(hObject, eventdata)
        % hObject    handle to save_btn (see GCBO)
        % eventdata  reserved - to be defined in a future version of MATLAB
        % handles    structure with handles and user data (see GUIDATA)

        set(gcf,'Renderer','OpenGL')
        figure;
        site=getappdata(0,'site_data');
        site_num=getappdata(0,'site_num');
        residual=getappdata(0, 'residual');
        
        data=getappdata(0, 'fit_data');
        xrange=getappdata(0, 'XLim');
        indices= xrange(1)<=data.x & data.x<=xrange(2);
        
        data.x=data.x(indices);
        data.y=data.y(indices);
        hold on;

        all=0;
        %make the fitted shapes more smooth then the data:
        site_x=min(data.x):0.01:max(data.x);
        
        %plot all the sites:
        %but with a better resolution
        y_site=[];
        for k=1:site_num
            y_site(k,:)=site(k).calc(site_x);
            all=all+y_site(k,:);
            y_site(k,:)=y_site(k,:);
            maxima(k)=max(y_site(k,:));
        end

        %organizing colors:
        red=0; gr=0.4; blue=0;
        for k=1:site_num
           red=red+0.05;gr=gr+0.15;blue=blue+0.4;
           if red>1
               red=red-1;
           end
           if gr>1
               gr=gr-1;
           end
           if blue>1
               blue=blue-1;
           end
           colors(k,:)=[red gr blue]; 
        end

        %order the sites due to their max intensity and plot
        [maxima,order]=sort(maxima);
        for k=site_num:-1:1
            area(site_x, y_site(order(k),:), 0,'FaceColor',colors(k,:),'EraseMode','xor');    
        end

        %plotting the data + residual
        plot(data.x,data.y,'k.');

        %adjust residual height
        
        adjust=-max(residual)-(max(data.y)-min(data.y))*0.05;
        if min(data.y)>0
        else
            adjust=adjust+min(data.y);
        end
        residual=residual+adjust;
        plot(data.x,residual,'r.');
        %plot a line:
        x=[min(data.x) max(data.x)];
        y=[adjust adjust];
        plot(x,y,'k-');

        %plot sum of the fited data
        if site_num>0
            plot(site_x, all, 'g-','linewidth', 1);
        end    

        %now some cosmetic features:
        xlabel('Energy (eV)');
        ylabel('Absorption (a.u.)');
        xLim([min(data.x) max(data.x)])
    end
        

    
%*******************************************************************
%                   Utility functions for MYGUI
%*******************************************************************

%**********************functions for tab1*****************************
%*********************************************************************
    function fitzlpeak
        %getting zl_data
        zl_data=getappdata(0,'zl_data');
        lpos=str2double(get(edgelpos_txt,'string'));
        rpos=str2double(get(edgerpos_txt,'string'));
        %cutting the zl_data:
        ind=find(zl_data.x>lpos & zl_data.x<rpos);
        fdata.x=zl_data.x(ind);
        fdata.y=zl_data.y(ind);
        
        %ftting zl_data to Lorentzian model:
        model=@(x,xdata)(lorentz_curve(x(1),x(2),x(3),xdata));
        ival=[lpos+(rpos-lpos/2) ...
            (rpos-lpos)/4 ...
            max(fdata.y)];
        lb=[lpos, 0,0];
        ub=[rpos, rpos-lpos, max(fdata.y)*(rpos-lpos)];
        [param,resnorm,residual,exitflag,out,lambda,jacobian] = ...
               lsqcurvefit(model, ival, fdata.x,fdata.y, ...
               lb, ub);
           
           
        plot(data_out1,fdata.x, fdata.y, fdata.x, model(param,fdata.x));
       
        %display of results
        I0I=trapz(fdata.x,fdata.y)/(trapz(zl_data.x,zl_data.y));
        I0LL=trapz(fdata.x,fdata.y)/(trapz(zl_data.x,zl_data.y)-trapz(fdata.x,fdata.y));
        
        set(I0I_txt,'string', I0I);
        set(fwhm_txt,'String', param(2));
        set(fwhm_decon_txt,'String',param(2));
        set(I0LL_txt,'string', I0LL);
        
        %savingzl_data
        setappdata(0,'zloss_param',param);
        resize_graphs;
            
        
    end


%**********************functions for tab2*****************************
%********************************************************************

     function fit_bkg()
        fitbkg_data=getappdata(0,'fitbkg_data');
        data=getappdata(0,'edge_data');
        ind=find(data.x>=fitbkg_data.bd1 & data.x<fitbkg_data.bd2);
        fdata.x=data.x(ind);
        fdata.y=data.y(ind);
        model=@(x,xdata)(x(1).*(xdata.^-x(2))+x(3));
        lb=[0 0 0];
        ub=[inf inf inf];
        ival=[fdata.y(1)./(fdata.x(1).^-4) 4 0];
        %ival=[1 4 0];
        options=optimset('MaxFunEvals', 30000);
        param = lsqcurvefit(model, ival, fdata.x,fdata.y', ...
               lb, ub,options);       
        cla(data_in2);
        cla(data_out2);
        axes(data_in2);
        hold on;
        plot(data.x,data.y);
        plot(data.x, model(param,data.x), 'r--');
        hold off;
        data_bs.x=data.x;
        data_bs.y=data.y-model(param,data.x)';
        plot(data_out2,data.x, data_bs.y, 'b-'); 
        
        setappdata(0, 'edge_data_bs',data_bs);
        
        set(fitbkg_A_txt,'string',num2str(param(1),'%10.3e\n'));
        set(fitbkg_r_txt,'string',num2str(param(2),'%6.3f'));       
        
        output(:,1)=data_bs.x;
        output(:,2)=data_bs.y;
        save test.mat output;
    end

%**********************functions for tab3*****************************
%********************************************************************

    function calc_fe()
       atan_data=getappdata(0,'atan_data');
       data=getappdata(0,'fe_data');
       
       %finding the values for the energy
       step=mean(diff(data.x));
       zero_ind=find(data.x<atan_data.zero,1,'last');
       if (atan_data.zero-data.x(zero_ind)) < step/2
           zero_ind=zero_ind+1;
       end
       data.y=data.y-data.y(zero_ind);
       
       h1_ind=find(data.x<atan_data.h1,1,'last');
       if (atan_data.h1-data.x(h1_ind)) < step/2
           h1_ind=h1_ind+1;
       end
       h2_ind=find(data.x<atan_data.h2,1,'last');
       if (atan_data.h2-data.x(h2_ind)) < step/2
           h2_ind=h2_ind+1;
       end
       
       %calulating arctan function
       h1=data.y(h1_ind)-data.y(zero_ind);
       h2=data.y(h2_ind)-h1-data.y(zero_ind);
       bkg=h1/pi*(atan(pi*(data.x-708.65))+pi/2)+h2/pi*(...
           atan(pi*(data.x-721.65))+pi/2);
           
       %plot
       
       
       
       data_sub=data.y-bkg;
       final_data.x=data.x;
       final_data.y=data_sub;
       setappdata(0,'final_data', final_data);
       
       %whit-line intensity method:
       range1=find(data.x>=708.5 & data.x<=710.5);
       range2=find(data.x>=719.7 & data.x<=721.7);
       l3_int=trapz(data.x(range1), final_data.y(range1));
       l2_int=trapz(data.x(range2), final_data.y(range2));
        
       %l\F6sen der quadratischen Gleichung
       ratio=l3_int/l2_int;
       a=0.193; b= -0.465; c=0.366;
       l=(ratio+1)*a; m=(ratio+1)*b; n=(ratio+1).*c-1;
       p=m/l; q=n/l;
       result=-p./2-sqrt((p/2).^2-q);
       set(int_txt, 'string', num2str(result,'%4.3f'));
       
       %integrationsfenster zeichnen:
       axes(data_in3);
       for n=1:length(range1)
           x(1)=data.x(range1(n));
           x(2)=x(1);
           y(1)=bkg(range1(n));
           y(2)=data.y(range1(n));
          plot(data_in3, x,y,'g-','Linewidth',3)  
          hold on;           
       end  
       for n=1:length(range2)
           x(1)=data.x(range2(n));
           x(2)=x(1);
           y(1)=bkg(range2(n));
           y(2)=data.y(range2(n));
          plot(data_in3, x,y,'g-','Linewidth',3)  
          hold on;           
       end  
       
       plot(data_in3, data.x, bkg,'r--');
       plot(data_in3, data.x, data.y);
       
       hold off;
       
       %graphfitting:
       fit_range=find(data.x>=data.x(zero_ind) & data.x<=data.x(h1_ind));
       fdata.x=final_data.x(fit_range);
       fdata.y=final_data.y(fit_range);
       model=@(x,xdata)(gauss_curve(x(1),x(2),x(3),xdata)+...
           gauss_curve(x(4),x(5),x(6),xdata)+...
           gauss_curve(x(7),x(8),x(9),xdata)+...
           gauss_curve(x(10),x(11),x(12),xdata));
       ival=[707.8,1,10,...
           709.5,1,10,...
           711,1,3,...
           713,3,10];
       lb=[707.5,0.5,0,...
           708.9,0.5,0,...
           710.5,0.5,0,...
           712,0.5,0];
       ub=[708.2,10,inf,...
           711,1.5,inf,...
           712,2,inf,...
           715,4,inf];
       options = optimset('MaxFunEvals',100000);
       [param,resnorm,residual,exitflag,out,lambda,jacobian] = ...
               lsqcurvefit(model, ival, fdata.x,fdata.y, ...
               lb, ub,options);
              
            
       %and now the data of the fitting:
       data1=gauss_curve(param(1),param(2),param(3),fdata.x);
       data2=gauss_curve(param(4),param(5),param(6),fdata.x);
       data3=gauss_curve(param(7),param(8),param(9),fdata.x);
       data4=gauss_curve(param(10),param(11),param(12),fdata.x);
       
       y=trapz(data1)/(trapz(data1)+trapz(data2)+trapz(data3)+trapz(data4))*100;
       %y=param(3)/(param(3)+param(6)+param(9)+param(12))*100;
       a=-68.4; b=83.1;
       ratio=(y-b)/a;
       set(fit_txt,'string', num2str(ratio));
       
       axes(data_out3);  
       plot(data_out3, fdata.x, data1','g-','linewidth',3);
       hold on;
       plot(data_out3, fdata.x, data2','r--');
       plot(data_out3, fdata.x, data3','r--');
       plot(data_out3, fdata.x, data4','r--');
       
       plot(data_out3, final_data.x, final_data.y);  
         
       setappdata(0, 'fe_data', data);
    end

%**********************functions for tab4*****************************
%********************************************************************
    function ev_tan()
       atan_data=getappdata(0,'atan_data');
       data=getappdata(0,'general_data');
       
       %finding the values for the energy
       step=mean(diff(data.x));
       
       zero_ind=find(data.x<atan_data.zero,1,'last');
       if (atan_data.zero-data.x(zero_ind)) < step/2
           zero_ind=zero_ind+1;
       end
       data.y=data.y-data.y(zero_ind);
       
       h1_ind=find(data.x<atan_data.h1,1,'last');
       if (atan_data.h1-data.x(h1_ind)) < step/2
           h1_ind=h1_ind+1;
       end
       
       if get(ti_atan_cb,'value')
           h2=(data.y(h1_ind)-data.y(zero_ind))/2; 
           h1=h2;
       else
           h2_ind=find(data.x<atan_data.h2,1,'last');
           if (atan_data.h2-data.x(h2_ind)) < step/2
              h2_ind=h2_ind+1;
           end       
           %calulating arctan function
           h1=data.y(h1_ind)-data.y(zero_ind);
           h2=data.y(h2_ind)-h1-data.y(zero_ind);
       end
       inf1=str2double(get(inf1_txt,'string'));
       inf2=str2double(get(inf2_txt,'string'));
       bkg(1:length(data.x))=h1/pi*(atan(pi*(data.x-inf1))+pi/2)+h2/pi*(...
           atan(pi*(data.x-inf2))+pi/2);
       
       data.x(1,1:length(data.x))=data.x;
           
       fit_data.x=data.x;
       fit_data.y=data.y-bkg;
       
       setappdata(0,'YLim', [min(fit_data.y)*0.95 max(fit_data.y)*1.05]);
       setappdata(0,'fit_data',fit_data);
       
       plot_all();
    end

    function plot_all()
        site=getappdata(0,'site_data');
        site_cur=getappdata(0,'site_cur');
        site_num=getappdata(0,'site_num');
        data=getappdata(0,'fit_data');
        axes(data_in4);
        plot(data.x,data.y,'b.');
        hold on;
        all=0;
        for k=1:site_num
            y_site=site(k).calc(data.x);
            all=all+y_site;
            if k~=site_cur
                plot(data.x, y_site, 'b-');
            else
                plot(data.x, y_site, 'r--');
            end
        end
        if site_num>0
            plot(data.x, all, 'g-');
        end
        xrange=getappdata(0,'XLim');
        yrange=getappdata(0,'YLim');
        xlim(xrange);
        ylim(yrange);
        hold off;
    end
    function update_txt()  
        site=getappdata(0,'site_data');
        site_cur=getappdata(0,'site_cur');
        set(fwhm_site_txt, 'String', site(site_cur).fwhm);
        set(center_txt, 'String', site(site_cur).center);
        set(intensity_txt, 'String', site(site_cur).intensity);
        set(center_cb,'Value', site(site_cur).fit(1));
        set(fwhm_cb,'Value', site(site_cur).fit(2));
        set(intensity_cb,'Value', site(site_cur).fit(3));
        if strcmp(site(site_cur).type,'PseudoVoigt')
            set(pv_n_txt,'String', site(site_cur).n);
            set(pv_n_txt,'enable', 'on');
        else
            set(pv_n_txt,'enable', 'off');
        end
        %type slider
        for k=1:3
          str=get(site_type_pop, 'String');

          if strcmp(site(site_cur).type, str(k))
              set(site_type_pop,'Value',k);
          end
        end
    end
end
