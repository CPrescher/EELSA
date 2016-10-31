classdef csite
    properties
       center;
       center_error;center_min;center_max;
       fwhm;  fwhm_error;   fwhm_min;   fwhm_max;
       intensity;   intensity_error;    intensity_max;    intensity_min=0;
       type=''; height; %determines the function type(Lorentzian, Gaussian, PseudoVoigt)
       n; n_error;  % PseudoVoigt parameter for the proportien: n L(x)+ (1-n)*G(x)
       bounds=[0 0 0];
       %area ratios for the different sites:
       fit=[true;true;true]; %vector which which variables are fitted
            %it is setted to be true intially for all variables
    end
    methods
        %constructor
        function obj=csite(center,fwhm,intensity)
            obj.center=center;
            obj.fwhm=fwhm;
            obj.intensity=intensity;
        end
        
        %set properties
        function obj = set.center(obj,value)
            obj.center=value;
            if obj.bounds(1)==0
                obj.center_min=-inf;
                obj.center_max=inf;
            else                
                obj.center_min=obj.center-obj.bounds(1);
                obj.center_max=obj.center+obj.bounds(1);
            end;
        end
        function obj = set.fwhm(obj,value)
            obj.fwhm=abs(value);
            if obj.bounds(2)==0
                obj.fwhm_min=0;
                obj.fwhm_max=inf;
            else                
                obj.fwhm_min=obj.fwhm-obj.bounds(2);
                obj.fwhm_max=obj.fwhm+obj.bounds(2);
            end
        end
        function obj = set.intensity(obj,value)
           obj.intensity=value; 
           if obj.bounds(3)==0
                obj.intensity_min=0;
                obj.intensity_max=inf;
            else
                obj.intensity_min=obj.intensity-obj.bounds(3);
                obj.intensity_max=obj.intensity+obj.bounds(3);
            end            
        end
      
        function y=hwhm(obj)
           y=obj.fwhm/2;           
        end
         
        
        % matrix output for plotting:
        
        function y=getMatrix(obj)
            y=[obj.fit(1), obj.center, obj.center_min, obj.center_max;
                obj.fit(2), obj.fwhm, obj.fwhm_min, obj.fwhm_max;
                obj.fit(3), obj.intensity, obj.intensity_min, obj.intensity_max]; 
        end
        
       %real functions for plotting
        
        function y=calc(obj,x)
            if strcmp(obj.type,'Lorentzian')
               y=lorentz_curve(obj.center,obj.fwhm,obj.intensity,x);                 
            elseif strcmp(obj.type,'Gaussian')
               y=gauss_curve(obj.center,obj.fwhm,obj.intensity,x); 
            elseif strcmp(obj.type,'PseudoVoigt')
               y=pseudov_curve(obj.center,obj.fwhm,obj.intensity,obj.n,x); 
            end
        end
    end    
end
