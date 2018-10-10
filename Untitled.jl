
using FFTW, DSP
using FileIO: load, save
import LibSndFile
using Plots

x = range(-20, stop=+20, length=1001);
plot(x, sinc.(x), legend=false, ylim=(-2, 2))
plot!(x, 1 ./ x, linestyle=:dot)
plot!(x, sin.(pi* x), linestyle=:dot)

?sinc
