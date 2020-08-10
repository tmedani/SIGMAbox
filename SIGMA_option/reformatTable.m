function reformatTable(hTable,fig)
% Examples:
%    reformatTable with no input argument formats the current axes with focus.
%    reformatTable(axisHandle) formats Figure specified as input handle
if nargin == 0
      fig = gcf;
      hTable = get(gcf,'children');
      warning(['No input arguments specified to REFORMATTABLE. Formatting Figure ',num2str(gcf),' by default.']); 
end
try
      hTableExtent = get(hTable,'Extent');
      %hTablePosition = get(hTable,'Position');
      set(hTable,'Position',[20 00 round(1*hTableExtent(3)) round(1*hTableExtent(4))]);
      set(fig,'position',[400 400 round(1.03*hTableExtent(3)) round(1.5*hTableExtent(4))]);
catch ME
      error('FIGURE with UITABLE not open or in focus. Please ensure UITABLE is created');
end