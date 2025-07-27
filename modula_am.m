% modula_am.m  -----------------------------------------------------------
%  Modulaci�n AM (DSB con portadora):
%     s(t) = [Ac + x_msg(t)] � cos(2?�fc�t)
%  Entradas:
%     cfg.Ac  -> amplitud de portadora
%     cfg.Am  -> amplitud del mensaje (para m_idx)
%     x_msg   -> se�al de mensaje
%     t       -> vector de tiempo
%  Salidas:
%     s_mod -> se�al AM modulada
%     m_idx -> �ndice de modulaci�n (Am/Ac)
% ------------------------------------------------------------------------
function [s_mod, m_idx] = modula_am(cfg, x_msg, t)
    m_idx = cfg.Am / cfg.Ac;                        % �ndice te�rico
    s_mod = (cfg.Ac + x_msg) .* cos(2*pi*cfg.fc*t); % AM con portadora
end
