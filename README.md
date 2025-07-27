# ACT4-SE-ALES-Y-SISTEMAS
Simulador de Modulación de Amplitud (AM) en MATLAB
1. Descripción General
Este proyecto consiste en un conjunto de scripts de MATLAB para la simulación y análisis de un sistema de comunicación por Modulación de Amplitud (AM) de doble banda lateral con portadora completa (DSB-FC).

El simulador modela el ciclo completo de una transmisión AM:

Generación de una señal de mensaje (tono sinusoidal) y una portadora.

Modulación de la portadora con la señal de mensaje.

Paso a través de un canal que puede introducir ruido, atenuación y distorsión.

Demodulación de la señal recibida para recuperar el mensaje original.

Análisis del rendimiento mediante métricas clave como la SNR y la THD.

El objetivo es visualizar y cuantificar los efectos del ruido, la atenuación, la distorsión por recorte (clipping) y los errores de fase en la demodulación sobre la calidad de la señal recuperada.

2. Características Principales
Simulación del Sistema
Modulador AM: Implementa la ecuación estándar s(t)=(A_c+m(t))
cos(2
pif_ct).

Canal de Comunicación:

Ruido Aditivo Blanco Gaussiano (AWGN): Permite añadir ruido con una Relación Señal/Ruido (SNR) configurable.

Atenuación: Simula la pérdida de potencia de la señal en el canal.

Distorsión no Lineal: Modela el recorte (clipping) de la señal cuando excede un umbral de amplitud, simulando la saturación de un amplificador.

Demodulador Coherente (Síncrono):

Recupera la señal multiplicando por una portadora local y aplicando un filtro paso bajo.

Permite introducir un error de fase en la portadora local para analizar su impacto en la amplitud de la señal demodulada.

Detector de Envolvente (Ideal): Utiliza la transformada de Hilbert para una demodulación no coherente ideal.

Análisis y Visualización
Dominio del Tiempo: Gráficas de la señal de mensaje, portadora, señal modulada (con y sin afectaciones) y señal demodulada.

Dominio de la Frecuencia: Análisis espectral mediante la Transformada Rápida de Fourier (FFT) para visualizar la portadora, las bandas laterales y la aparición de armónicos por distorsión.

Métricas de Rendimiento:

SNR de Salida: Calcula la relación señal/ruido en la señal recuperada.

Distorsión Armónica Total (THD): Cuantifica la distorsión introducida por el clipping.

3. Requisitos
MATLAB (versión R2020a o superior).

Signal Processing Toolbox™ (para funciones como fft, fir1, hilbert).

Communications Toolbox™ (para la función awgn).

4. Cómo Usar
Abrir MATLAB: Asegúrate de que todas las funciones y scripts del proyecto estén en el mismo directorio o en el path de MATLAB.

Configurar la Simulación: Abre el script principal (p.ej., simulador_am.m). Localiza la sección de parámetros de configuración, que usualmente está definida en una estructura (cfg).

Ajustar Parámetros: Modifica los valores en la estructura cfg para definir el escenario que deseas analizar.

% --- PARÁMETROS DE CONFIGURACIÓN ---
cfg.Fs = 50e3;       % Frecuencia de muestreo (Hz)
cfg.fm = 100;        % Frecuencia del mensaje (Hz)
cfg.fc = 1e3;        % Frecuencia de la portadora (Hz)
cfg.Am = 1;          % Amplitud del mensaje (V)
cfg.Ac = 2;          % Amplitud de la portadora (V)
cfg.snr_db = 10;     % SNR del canal (dB). Usa 'inf' para un canal sin ruido.
cfg.use_clipping = false; % Activar/desactivar distorsión por recorte
cfg.clip_thr = 1.5;  % Umbral de recorte (V)
cfg.fase_error_deg = 0; % Error de fase en demod. coherente (grados)

Ejecutar el Script: Corre el script principal desde la ventana de comandos de MATLAB o presionando el botón "Run".

Analizar los Resultados:

Las figuras generadas mostrarán las formas de onda y los espectros de las señales en cada etapa.

Los valores calculados (SNR de salida, THD) se mostrarán en la ventana de comandos.

5. Estructura del Código
El código está diseñado de forma modular para facilitar su lectura y mantenimiento. La estructura típica es:

Script Principal (simulador_am.m):

Define la estructura de configuración cfg.

Llama a las funciones modulares en secuencia.

Contiene la lógica para generar las gráficas y mostrar los resultados.

Funciones Auxiliares:

gen_mensaje(cfg, t): Genera la señal de mensaje.

modula_am(mensaje, portadora, cfg): Realiza la modulación AM.

canal_awgn(s_mod, cfg): Aplica ruido y atenuación.

demodula_coherente(s_rx, cfg, t): Implementa la demodulación síncrona.

calcula_thd(s_distorsionada, cfg): Calcula la distorsión armónica.

6. Autor
Daniel Rodríguez Ramos
