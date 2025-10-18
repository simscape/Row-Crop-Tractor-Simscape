function sm_tractor_row_crop_config_solver(mdl,solverType)
% sm_tractor_row_crop_config_solver(mdl,solverType)
%   Configure solver
%
%   mdl           Name of Simulink model
%   solverType    'variable' or 'fixed'
%
% Copyright 2021-2024 The MathWorks, Inc.

switch (lower(solverType))
    case 'variable'
        set_param(mdl,'SolverName','ode23t');
        set_param([mdl '/Tractor'],'popup_local_solver','No');
    case 'fixed'
        set_param(mdl,'SolverName','ode3');
        set_param([mdl '/Tractor'],'popup_local_solver','Yes');
end