% canal_ruido.m  ---------------------------------------------------------
%  Canal simple con atenuación, AWGN y clipping.
%  Entradas:
%     cfg.clip_thr -> umbral de clipping (|x|>thr se recorta)
%     s_in         -> señal de entrada
%     snr_db       -> SNR objetivo en dB (Inf => sin ruido)
%     att          -> factor de atenuación (lineal)
%     do_clip      -> true/false aplica clipping
%  Salida:
%     s_rx         -> señal a la salida del canal
% ------------------------------------------------------------------------
function s_rx = canal_ruido(cfg, s_in, snr_db, att, do_clip)
    % 1) Atenuación
    s_rx = att * s_in;

    % 2) Ruido AWGN (si procede)
    if isfinite(snr_db)
        if exist('awgn','file') == 2
            % Communications Toolbox presente
            s_rx = awgn(s_rx, snr_db, 'measured');
        else
            % Fallback manual sin toolbox
            Ps = mean(s_rx.^2);                 % potencia de la señal
            Pn = Ps / (10^(snr_db/10));         % potencia de ruido deseada
            s_rx = s_rx + sqrt(Pn) * randn(size(s_rx));
        end
    end

    % 3) Clipping (no linealidad dura)
    if do_clip
        thr  = cfg.clip_thr;
        s_rx = max(min(s_rx, thr), -thr);
    end
end
