% gen_portadora.m  --------------------------------------------------------
%  Genera la portadora c(t) = Ac·cos(2?·fc·t)
%  Entradas:
%     cfg.Ac -> amplitud de la portadora
%     cfg.fc -> frecuencia de la portadora (Hz)
%     t      -> vector de tiempo
%  Salida:
%     carr   -> señal portadora c(t)
% ------------------------------------------------------------------------
function carr = gen_portadora(cfg, t)
    carr = cfg.Ac * cos(2*pi*cfg.fc*t);  % Portadora
end
