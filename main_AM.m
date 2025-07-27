% main_AM.m  -------------------------------------------------------------
%  Script maestro: ejecuta la simulación y genera figuras.
%  Pasos:
%   (1) Definir cfg
%   (2) Generar mensaje
%   (3) Modulación AM
%   (4) Figuras base (mensaje, portadora, AM + espectro)
%   (5) Barrido de SNR (att=1)
%   (6) Barrido de atenuación (SNR=20 dB)
%   (7) Clipping
%   (8) (Opcional) Demodulación coherente
% ------------------------------------------------------------------------
clear; clc; close all;

%% (1) Configuración ------------------------------------------------------
cfg = struct( ...
    'Fs',      50e3, ...   % Hz
    'fm',      100 , ...   % Hz (mensaje)
    'fc',      1e3 , ...   % Hz (portadora)
    'Am',      1   , ...   % amplitud mensaje
    'Ac',      2   , ...   % amplitud portadora
    't_end',   0.1 , ...   % s
    'clip_thr',1.5 ...     % umbral clipping
);

snr_vec   = [Inf 20 10 5];     % dB
atten_vec = [1.0 0.5 0.1];      % lineal
pow = @(x) mean(x.^2);          % potencia media (sin toolboxes)

%% (2) Generación de mensaje ---------------------------------------------
[t, x_msg] = gen_mensaje(cfg);

%% (3) Modulación AM ------------------------------------------------------
[s_mod, m_idx] = modula_am(cfg, x_msg, t);
fprintf('Índice de modulación = %.2f (%.0f%%)\n', m_idx, m_idx*100);

%% (4) Figuras base -------------------------------------------------------
% Mensaje
figure('Name','Mensaje');
plot(t, x_msg); grid on;
title('Señal de mensaje m(t)'); xlabel('Tiempo (s)'); ylabel('Amplitud');

% Portadora (solo para visualización)
carr = gen_portadora(cfg, t);
figure('Name','Portadora');
plot(t(1:1000), carr(1:1000)); grid on;
title('Portadora c(t) (zoom)'); xlabel('Tiempo (s)'); ylabel('Amplitud');

% Señal AM (zoom para ver la envolvente)
figure('Name','AM (zoom)');
plot(t(1:1000), s_mod(1:1000)); grid on;
title('Señal AM s(t) (zoom)'); xlabel('Tiempo (s)'); ylabel('Amplitud');

% Espectro de s(t)
N = numel(s_mod);
X = fft(s_mod);                      % FFT (comparación simple)
f = (0:N-1)*(cfg.Fs/N);
P = abs(X)/N;                        % magnitud normalizada
P1 = P(1:floor(N/2)); f1 = f(1:floor(N/2));
figure('Name','Espectro AM');
plot(f1, 20*log10(P1+eps)); grid on; xlim([0 2e3]);
title('Espectro de magnitud de s(t)'); xlabel('Frecuencia (Hz)'); ylabel('Magnitud (dB)');

%% (5) Barrido de SNR (att=1) --------------------------------------------
disp('--- Barrido de SNR (att=1) ---');
for snr = snr_vec
    s_rx   = canal_ruido(cfg, s_mod, snr, 1, false);
    noise  = s_rx - s_mod;                     % referencia: señal ideal sin ruido
    snrOut = 10*log10( pow(s_mod) / pow(noise) );
    fprintf('SNR_in = %4g dB  ->  SNR_out = %5.2f dB\n', snr, snrOut);
end

%% (6) Barrido de atenuación (SNR=20 dB) ---------------------------------
disp('--- Barrido de atenuación (SNR=20 dB) ---');
for att = atten_vec
    s_rx   = canal_ruido(cfg, s_mod, 20, att, false);
    ref    = att * s_mod;                       % referencia ideal atenuada
    noise  = s_rx - ref;
    snrOut = 10*log10( pow(ref) / pow(noise) );
    fprintf('Att = %4.1f  ->  SNR_out = %5.2f dB\n', att, snrOut);
end

%% (7) Clipping -----------------------------------------------------------
disp('--- Clipping ---');
s_rx_clip = canal_ruido(cfg, s_mod, Inf, 1, true);

% (Opcional) THD si está disponible
if exist('thd','file') == 2
    thd_val = thd(s_rx_clip, cfg.Fs);
    fprintf('THD con clipping: %.2f %%\n', thd_val);
else
    fprintf('THD no calculada (función thd no disponible).\n');
end

% Comparación temporal (zoom)
figure('Name','Original vs Clipping (zoom)');
plot(t(1:1000), s_mod(1:1000), 'b-', t(1:1000), s_rx_clip(1:1000), 'r--'); grid on;
legend('Original','Con clipping'); xlabel('Tiempo (s)'); ylabel('Amplitud');
title('Señal original vs. con clipping');

%% (8) (Opcional) Demodulación coherente ---------------------------------
% phi_error = 30; % grados
% x_rec = demod_sinc(cfg, s_rx_clip, phi_error);
% figure('Name','Demod coherente (30°)');
% plot(t, x_msg, 'b-', t, x_rec, 'r--'); grid on;
% legend('Mensaje original','Demod coherente 30°'); xlabel('Tiempo (s)'); ylabel('Amplitud');
