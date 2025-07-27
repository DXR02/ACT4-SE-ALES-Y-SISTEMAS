% gen_mensaje.m  ----------------------------------------------------------
%  Genera la se�al de mensaje m(t) = Am�sin(2?�fm�t)
%  Entradas:
%     cfg.Fs    -> frecuencia de muestreo (Hz)
%     cfg.t_end -> duraci�n de la simulaci�n (s)
%     cfg.Am    -> amplitud del mensaje
%     cfg.fm    -> frecuencia del mensaje (Hz)
%  Salidas:
%     t      -> vector de tiempo (0:1/Fs:t_end)
%     x_msg  -> se�al de mensaje m(t)
% ------------------------------------------------------------------------
function [t, x_msg] = gen_mensaje(cfg)
    t     = 0:1/cfg.Fs:cfg.t_end;        % Vector de tiempo
    x_msg = cfg.Am * sin(2*pi*cfg.fm*t); % Se�al mensaje
end
