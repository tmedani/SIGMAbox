function uiFlash(ObjH, Property, Value)
% Direct attention to UI object by short flashing
% A property, e.g. the BackgroundColor, of an object is flashed twice
% to the new value and return to the original. E.g. this can be helpful
% to direct the user's attention to a specific UICONTROL in case of
% wrong input.
%
% uiFlash(ObjH, Property, Value)
% INPUT:
%   ObjH:  Handle of a graphic object, e.g. uicontrol, text, axes,
%          figure, etc. If ObjH is a vector of objects with equal type,
%          the properties are expected to be equal for all objects.
%   Property: The property as string, e.g. 'BackgroundColor', 'Color',
%          'Position', 'FontSize', 'String', etc.
%          The 'Value' property of UICONTROL objects cannot be changed.
%   Value: The property is changed temporarily to this value. If the value
%          is a double vector (colors, positions), an intermediate step is
%          inserted for a smooth change.
%
% EXAMPLES:
%   F = figure;
%   H = uicontrol(F, 'Style', 'togglebutton', 'String', 'Hello', ...
%                 'Position', [20, 20, 60, 20]);
%   A = axes; sphere; CamPos = get(A, 'CameraPosition'); L = light;
%   set(A, 'CameraViewAngleMode', 'manual');
%   CamPos = get(A, 'CameraPosition') .* [1.2, 1, 1.2]; drawnow;
%   pause(0.5); uiFlash(H, 'BackgroundColor', [1, 0, 0])
%   pause(0.5); uiFlash(H, 'FontSize', 14);
%   pause(0.5); uiFlash(H, 'String', '! Hello !');
%   pause(0.5); uiFlash(H, 'Position', [16, 16, 68, 28]);
%   pause(0.5); uiFlash(H, 'Position', [20, 30, 60, 20]);
%   pause(0.5); uiFlash(F, 'Color',    ones(1, 3));
%   pause(0.5); uiFlash(F, 'Position', get(F, 'Position') + [0, 20, 0, 0]);
%   pause(0.5); uiFlash(A, 'CameraPosition', CamPos);
%   pause(0.5); uiFlash(L, 'Visible', 'off');
%
% Tested: Matlab 6.5, 7.7, 7.8
% Author: Jan Simon, Heidelberg, (C) 2008-2009 J@n-Simon.De

% $JRev: R0j V:012 Sum:4EF2000E Date:14-Oct-2009 00:10:50 $
% $File: User\JSim\Published\uiFlash\uiFlash.m $
% History:
% 005: 02-Jun-2008 00:56, "WHILE datenum(clock)" instead of "PAUSE".
%      The PAUSE looks and feels slow if a property change initiate a redrawing
%      of a figure with many objects.
% 008: 04-Aug-2009 17:21, CPUTIME is even a better clock.
%      But PAUSE inside the WHILE block does not advance CPUTIME on R2008b.
% 009: 09-Oct-2009 10:04, Check inputs. New trial with PAUSE.
% 012: 14-Oct-2009 00:10, Published.

% Initialize: ==================================================================
try
   % Try to get an intermediate state for smooth optics:
   origValue = get(ObjH(1), Property);
   if isa(origValue, 'double') && isa(Value, 'double') && length(Value) > 1 ...
         && isequal(size(origValue), size(Value))
      halfValue = (Value + origValue) * 0.5;
   else  % No half of a string:
      halfValue = Value;
   end
   
catch  % Check inputs on problems only:
   if nargin ~= 3
      error(['JSim:Tools:', mfilename], '1 or 3 inputs required.');
   elseif isempty(ObjH) || not(all(ishandle(ObjH)))
      error(['JSim:Tools:', mfilename], ...
         '1st input must be an HG object handle.');
   elseif ischar(Property)
      error(['JSim:Tools:', mfilename], ...
         ['Cannot get property [', Property, '] from [', ...
            get(ObjH(1), 'Type'), '] object.']);
   else  % Unexpected problem:
      error(['JSim:Tools:', mfilename], lasterr);
   end
end

% Do the work: =================================================================
% Delay times for a harmonic view:
DelayList = [0.05, 0.2, 0.05, 0.1];
ValueList = {halfValue, Value, halfValue, origValue};

% Blink twice:
for Repeat = 1:2
   for iStep = 1:4
      % Change the property:
      iTime = cputime;
      set(ObjH, Property, ValueList{iStep});
      
      % Finish rendering before waiting and do not wait too long if the
      % rendering took a long time already:
      % NOTE: CPUTIME does not proceed during PAUSE in Matlab >= 2008.
      drawnow;
      pause(max(0.02, DelayList(iStep) - (cputime - iTime)));
   end
end

return;
