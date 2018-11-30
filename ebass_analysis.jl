
using Plots
pyplot();
using Images

using FileIO: load, save, loadstreaming, savestreaming
import LibSndFile
using SampledSignals
#SampledSignals.embed_javascript();

using DSP
using FFTW
using Statistics

using Distributed, SharedArrays

snd = load("electric_bass.flac");
fs = snd.samplerate;
x = snd.data;

snd

t = (0:length(x)-1) / fs;
plot(t, x,
    xlabel="Time (s)", ylabel="Amplitude",
    xticks=0:10:t[end],
    ylim=(-1, +1),
    legend=false)

xE1 = x[round(Int, 3.850*fs) : round(Int, 38.960*fs)];
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
plot(f, ampspecE1dB .- maximum(ampspecE1dB),
    xlim=[0, 1500], ylim=[-75, 3],
    xlabel="Frequency [Hz]", ylabel="Power [dB]",
    title="Electric Bass (E1, 41 Hz)", legend=false)

framesize = 2^14;
framestep = convert(Int, fs/15); #2^10;
Nmax = 2^18;

xx = zeros((length(xE1) + framesize));
xx[1:length(xE1)] = xE1;
w = hanning(framesize);

zz = SharedArray{Float64}(floor(Int, length(xx)/framestep), round(Int, max(nextpow(2, framesize), Nmax)/2+1));
@sync @distributed for n = 1:floor(Int, length(xE1)/framestep)
    xxx = xx[(n-1)*framestep+1 : (n-1)*framestep+framesize];
    z = zeros(max(nextpow(2, framesize), Nmax));
    z[1:framesize] = xxx .* w;
    y = FFTW.fft(z) / length(z);
    y[2:round(Int, length(y)/2)] *= 2.0;
    y = y[1:round(Int, length(y)/2+1)];
    zz[n, :] = abs.(y);
end
t = range(0, stop=length(xx)-1, length=size(zz, 1)) / fs;
f = range(0, stop=fs/2, length=size(zz, 2));

size(zz)

zf_dB = 20*log10.(mean(zz, dims=1)');
plot(f, zf_dB .- maximum(zf_dB),
    xlim=(0, 1500), ylim=(-75, 3),
    xlabel="Frequency (Hz)", ylabel="Power (dB)",
    title="Electric Bass (E1, 41 Hz)", legend=false)

zt_dB = 20*log10.(mean(zz, dims=2));
plot(t, zt_dB .- maximum(zt_dB),
    ylim=(-75, 3),
    xlabel="Time (s)", ylabel="Power (dB)",
    title="Electric Bass (E1, 41 Hz)", legend=false)

heatmap(t, f, 20*log10.(zz' .+ eps()), xlabel="Time (s)", ylabel="Frequency (Hz)", ylim=(0,1500))

savefig("ebass_heatmap.png")

zmax = 20*log10.(maximum(zz));

anim = @animate for n=1:size(zz, 1)
    zframe = 20*log10.(zz[n, :]);
    plot(f, zframe .- zmax,
        xlim=(0, 1500), ylim=(-75, 3),
        xlabel="Frequency (Hz)", ylabel="Power (dB)",
        title="Electric Bass (E1, 41 Hz), t=$(round(t[n]*10)/10) sec", legend=false)
end
gif(anim, "ebass_15fps.gif", fps=15)

gif(anim, "ebass_$(round(Int, fs/framestep))fps.gif", fps=round(Int, fs/framestep))

fs/framestep
