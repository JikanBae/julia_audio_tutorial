
samprate = 44100;

# Biquad Peaking Filter (fc=1000Hz, gain=12dB, Q=2, fs=44100)
B = [1.1417, -1.9797, 0.8583];
A = [1.0356, -1.9797, 0.9644];

# calculate frequency (using log-spaced range since we are going to use semilogx for plotting)
fL = 20;
fH = samprate/2;
f = 10 .^ range(log10(fL), stop=log10(fH), length=256);
ff = f / samprate * 2pi;
s = exp.(-1.0im * ff);   # convert from digital frequency

# calculate transfer function
H = (B[1] .+ B[2].*s .+ B[3].*s.*s) ./ (A[1] .+ A[2].*s .+ A[3].*s.*s);

using Plots
plot(f, 20*log10.(abs.(H)), xscale=:log10,
    xlabel="Frequency (Hz)", ylabel="Gain (dB)",
    xtick=([31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
        ["31.5", "63", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]),
    legend=false)

savefig("freqz_abs.pdf")

plot(f, angle.(H)*180/pi, xscale=:log10,
    xlabel="Frequency (Hz)", ylabel="Phase (angle)",
    xtick=([31.5, 63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
        ["31.5", "63", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]),
    legend=false)

savefig("freqz_phase.pdf")
