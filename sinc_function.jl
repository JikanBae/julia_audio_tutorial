
using FFTW, DSP
using FileIO: load, save
import LibSndFile
using Plots

x = range(-10, stop=+10, length=1001);
plot(x, sinc.(x), ylim=(-1.5, 1.5), legend=false)
plot!(x, 1 ./ x, linestyle=:dot)
plot!(x, sin.(pi* x), linestyle=:dot)

savefig("sinc_function.pdf")
savefig("sinc_function.png")
