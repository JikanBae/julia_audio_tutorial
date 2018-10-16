
using FileIO, LibSndFile, FFTW

using Plots
pyplot();

snd = load("recorder.flac")

fs = snd.samplerate;
x = snd.data[1:round(Int, 2*fs)];
t = (0 : length(x)-1) / fs;

plt = plot(t, x,
    ylim=(-1, +1),
    xlabel="Time (s)", ylabel="Amplitude", title="Alto Recorder",
    legend=false);
display(plt)

X = fft(x) / length(x);
X = X[1 : round(Int, length(X)/2+1)];
X[2:end-1] *= 2;
f = range(0, stop=fs/2, length=length(X));

magX = 20*log10.(abs.(X));
magX .-= maximum(magX);
plot(f, magX,
    xlim=(0, 10000), ylim=(-80, 10),
    xlabel="Frequency (Hz)", ylabel="Power (dB)", title="Power Spectrum",
    legend=false)

y = 20*log10.(abs.(rfft(magX)));
y .-= maximum(y);
t = range(0, stop=1, length=length(y));
plot(t, y, xlim=(0, 1/100),
    xlabel="Time (s)", title="Cepstrum", legend=false)

fo = 520;
an_txt = [];
for n=1:20
    push!(an_txt, (n*fo, -4n+10, string(n)))
end
plot(f, magX,
    xlim=(0, 10000), ylim=(-80, 10),
    xlabel="Frequency (Hz)", ylabel="Power (dB)", title="Power Spectrum",
    legend=false,
    annotation=an_txt)

plot(f[2:end], magX[2:end],
    xscale=:log10
    , xlim=(20, 20000),
    xticks=([31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
            ["31.5", "63", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]),
    legend=false)
