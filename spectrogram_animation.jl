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

using Printf


function make_animation(filename, framesize, zero_pad_to, FPS)
  snd = load(filename);
  fs = snd.samplerate;
  x = vec(snd.data);
  xx = zeros((length(x) + framesize));
  xx[1:length(x)] = x;
  w = hanning(framesize);
  
  framestep = convert(Int, fs/FPS);
  zz = SharedArray{Float64}(floor(Int, length(xx)/framestep), round(Int, max(nextpow(2, framesize), zero_pad_to)/2+1));
  @sync @distributed for n = 1:floor(Int, length(x)/framestep)
    xxx = xx[(n-1)*framestep+1 : (n-1)*framestep+framesize];
    z = zeros(max(nextpow(2, framesize), zero_pad_to));
    z[1:framesize] = xxx .* w;
    y = FFTW.fft(z) / length(z);
    y[2:round(Int, length(y)/2)] *= 2.0;
    y = y[1:round(Int, length(y)/2+1)];
    zz[n, :] = abs.(y);
  end
  zmax = 20*log10.(maximum(zz));
  t = range(0, stop=length(xx)-1, length=size(zz, 1)) / fs;
  f = range(0, stop=fs/2, length=size(zz, 2));
  
  anim = @animate for n=1:size(zz, 1)
    zframe = 20*log10.(zz[n, :]);
    plot(f, zframe .- zmax,
         xlim=(0, 1500), ylim=(-75, 3),
         xlabel="Frequency (Hz)", ylabel="Power (dB)",
         #title=sprintf("%s t=%.2fsec", filename, round(t[n]*100)/100),
         legend=false)
  end
  gif(anim, "$(filename)_$(round(Int, fs/framestep))fps.gif", fps=round(Int, fs/framestep));
end


filename = "electric_bass.flac"
framesize = 2^14;
zero_pad_to = 2^18;
FPS = 15;
make_animation(filename, framesize, zero_pad_to, FPS);
