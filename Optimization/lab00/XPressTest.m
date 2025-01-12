% To use XPress (running mosel files) it's enough to
% add to the search path a directory with this command:
% addpath(fullfile(getenv('XPRESSDIR'),'/matlab'))
% Note: it is reset every time Matlab is restarted.
% Use "savepath" to make it permanent

% Set covering problem: select the minimal 
% number of rows of M having at least one 
% "1" for each column.

M=[1 0 0 1 0 0 0;
   0 0 1 0 1 0 1;
   0 1 0 0 1 0 1;
   1 0 0 1 0 1 0;
   0 1 1 0 0 1 0;
   ];

moselexec('XPressTest.mos')

x

