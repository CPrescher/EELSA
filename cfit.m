classdef cfit
    %cfit capsulates all the fitting of MossA, for a better readability
    %etc. and maintenance
    %   Detailed explanation goes here
    
    properties
        %general poperties
        sites; %array of all the sites to fit
        sites_num; %number of sites
        status; %fitting status or error bar
        handles; %structure of the handles from the interface
        param; residual;
        
        %fitting properties
        func_str;
        model;
        ub=[]; lb=[]; ival=[]; %upper and lower boundaries, inital valus
        errors; % array with error values for every fitting parameter
        
        output_txt;
    end
    
    methods
        %constructor
        function obj=cfit(sites,output_txt)
           obj.sites=sites;
           obj.sites_num=length(sites);
           obj.output_txt=output_txt;
        end
        
        
        %%************************************************************
        %%build iniial values and upper and lower boundaries +model
        %%function
        %************************************************************
        
        function obj=start(obj)
            obj.func_str='0';
            obj.ub=[];
            obj.lb=[];
            obj.ival=[];
            l=1;            
            
            for k=1:obj.sites_num
                matrix=obj.sites(k).getMatrix();
                dim=size(matrix,1);
                if strcmp(obj.sites(k).type,'Lorentzian')
                    obj.func_str=[obj.func_str,'+lorentz_curve('];
                elseif strcmp(obj.sites(k).type,'Gaussian')
                    obj.func_str=[obj.func_str,'+gauss_curve('];
                elseif strcmp(obj.sites(k).type,'PseudoVoigt')
                    obj.func_str=[obj.func_str,'+pseudov_curve('];
                end
                
                
                %setting up cs, hwhm, int and qs/bhf
                for n=1:dim
                   if matrix(n,1)
                      obj.ival=[obj.ival; matrix(n,2)];
                      obj.lb=[obj.lb; matrix(n,3)];
                      obj.ub=[obj.ub; matrix(n,4)];
                      obj.func_str=[obj.func_str,'x(',int2str(l),'),'];
                      l=l+1; 
                   else
                      obj.func_str=[obj.func_str,num2str(matrix(n,2)),','];
                   end
                end
                
                %concerning about the pseudoVoigt factor
                if strcmp(obj.sites(k).type, 'PseudoVoigt')
                    obj.func_str=[obj.func_str,'x(',int2str(l),'),'];
                    obj.lb=[obj.lb; 0];
                    obj.ub=[obj.ub; 1];
                    obj.ival=[obj.ival; 0.5];
                    l=l+1;
                end
                
                %finishing the site
                obj.func_str=[obj.func_str,'xdata)'];
                      
            end
            sprintf(obj.func_str);
            obj.func_str=['@(x,xdata)(',obj.func_str,')'];
            obj.model=eval(obj.func_str);    
        end %build
        
        function stop = outfun(obj, x, optimValues,state)
            stop = false;
            switch state
                case 'init'
                case 'iter'
                    str=cellstr(get(obj.output_txt, 'String'));
                    str=[str; cellstr(sprintf(' %d \t %2.4d', optimValues.iteration, optimValues.resnorm))];
                    if length(str)>6
                        new_str=str(2:7);
                        str=new_str;
                    end
                    set(obj.output_txt, 'String',str);
                    drawnow;
                case 'done'
                   str=cellstr(get(obj.output_txt, 'String'));
                   str=[str; cellstr('       End fitting')];
                   if length(str)>6
                        new_str=str(2:7);
                        str=new_str;
                   end
                   set(obj.output_txt, 'String',str);
               otherwise
           end        
        end %outfun    
       
         
        
        function [sites, table, residual]=process(obj)
                      
            obj=obj.start();
            data=getappdata(0,'fit_data');
            options=optimset('OutputFcn', @obj.outfun);
            xrange=getappdata(0, 'XLim');
            indices=find(xrange(1)<=data.x & data.x<=xrange(2));
            data.x=data.x(indices);
            data.y=data.y(indices);
            [obj.param,resnorm,residual,exitflag,out,lambda,jacobian] = ...
               lsqcurvefit(obj.model, obj.ival, data.x, data.y, ...
               obj.lb, obj.ub,options);
           
            
            
            error_vals=nlparci(obj.param, residual,'jacobian', jacobian);
            obj.errors=zeros(length(error_vals),1);
            for k=1:length(error_vals)
              obj.errors(k)=(error_vals(k,2)-error_vals(k,1))/2; 
            end
            
            [sites, table]=output(obj, obj.param, obj.errors);

            
        end
                
        %%**************************************************************
        %%output of parameters into the site array and a table matrix
        %****************************************************************
        function [sites, table]=output(obj, param, errors)
            site=obj.sites;
            %create output table
            table=zeros(obj.sites_num, 8);
            l=1;% counter for parameter number + die param die vorn dran für Bkg function sind
            for k=1:obj.sites_num
              %setting up standard values
              if obj.sites(k).fit(1)
                  site(k).center=param(l);
                  site(k).center_error=errors(l);
                  l=l+1;
              else
                  site(k).center_error=NaN;
              end
              
              if obj.sites(k).fit(2)
                  site(k).fwhm=param(l);
                  site(k).fwhm_error=errors(l);
                  l=l+1;
              else
                  site(k).hwhm_error=NaN;
              end
              
              if obj.sites(k).fit(3)
                  site(k).intensity=param(l);
                  site(k).intensity_error=errors(l);
                  l=l+1;
              else
                  site(k).intensity_error=NaN;
              end
              
             
              
              %setting up the pseudovoigt ratio
              
              if strcmp(obj.sites(k).type,'PseudoVoigt')
                  site(k).n=param(l);
                  site(k).n_error=errors(l);
                  l=l+1;
              else
                  site(k).n=NaN;
                  site(k).n_error=NaN;
              end
              
             
               
              %setting now the table shit:
            
              table(k,:)=[site(k).center, site(k).center_error,...
                  site(k).fwhm, site(k).fwhm_error,...
                  site(k).intensity, site(k).intensity_error,...
                  site(k).n, site(k).n_error];      
            end
            obj.sites=site;
            obj.param=param;
            obj.errors=errors;
            sites=obj.sites;
        end %output function
        
    end %methods block    
end %class

