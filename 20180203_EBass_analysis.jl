
using LibSndFile, SampledSignals, Plots
gr();

snd = load("20180203_electric_bass_open.flac");
x = snd.data;
fs = snd.samplerate;

snd

t = (0:length(x)-1) / fs;
plot(t, x,
    xlabel="Time (s)", ylabel="Amplitude",
    xticks=0:15:t[end],
    ylim=(-1, +1),
    legend=false)

xE1 = x[round(Int, 3.850*fs) : round(Int, 41.000*fs)];
tE1 = (0:length(xE1)-1) / fs;
plot(tE1, xE1,
    xlabel="Time (s)", ylabel="Amplitude",
    ylim=(-1, +1),
    legend=false)

plot(tE1, xE1,
    xlabel="Time (s)", ylabel="Amplitude",
    xlim=(2.7, 2.9),
    ylim=(-1, +1),
    legend=false)

yE1 = fft(xE1);
ampspecE1 = abs.(yE1[1:round(Int, length(yE1)/2+1)]);
ampspecE1[2:round(Int, length(ampspecE1)-1)] *= 2.0;
f = (0:length(ampspecE1)) / length(ampspecE1) * (fs / 2);
ampspecE1dB = 20 * log10.(ampspecE1);
plot(f, ampspecE1dB-maximum(ampspecE1dB),
    xlim=[0, 1500], ylim=[-75, 3],
    xlabel="Frequency [Hz]", ylabel="Power [dB]",
    title="Electric Bass (E1, 41 Hz)", legend=false)
