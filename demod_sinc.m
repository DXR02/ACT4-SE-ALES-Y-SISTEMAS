% demod_sinc.m  ----------------------------------------------------------
%  Demodulación coherente AM con posible error de fase ? (grados).
%  Entradas: cfg.{fc,Fs,fm,t_end}, s_rx, phi_deg
%  Salida:   x_lp (mensaje recuperado)
% ------------------------------------------------------------------------
function x_lp = demod_sinc(cfg, s_rx, phi_deg)
    phi = deg2rad(phi_deg);
    t   = 0:1/cfg.Fs:cfg.t_end;

    % Multiplicación síncrona
    x_demod = 2 * s_rx .* cos(2*pi*cfg.fc*t + phi);

    % Pasa-bajos: fir1 si está disponible; si no, media móvil
    if exist('fir1','file') == 2
        Wn = (cfg.fm * 2) / cfg.Fs;   % borde ? 2·fm
        h  = fir1(128, Wn);
        x_lp = filter(h, 1, x_demod);
    else
        N  = max(1, round(cfg.Fs/(5*cfg.fm)));
        b  = ones(1,N)/N;
        x_lp = filter(b, 1, x_demod);
    end
end
