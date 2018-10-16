
using Plots, DSP

function biquad_peak_rbj(fc, dBgain, Q=1/sqrt(2), samprate=44100)
    A = sqrt(10^(dBgain/20));
    w = 2 * pi * fc / samprate;
    s = sin(w);
    c = cos(w);
    a = s / (2 * Q/A);

    b0 =  1 + a*A;
    b1 = -2 * c;
    b2 =  1 - a*A;
    a0 =  1 + a/A;
    a1 = -2 * c;
    a2 =  1 - a/A;

    return Biquad(b0/a0, b1/a0, b2/a0, a1/a0, a2/a0);
end

fs = 44100
fltr = biquad_peak_rbj(1000, +12, 2.0, fs)

f = 10 .^ range(log10(20), stop=log10(20000), length=256)
rsp = freqz(fltr, f, fs)

plot(f, 20*log10.(abs.(rsp)), linewidth=2,
    xlabel="Frequency (Hz)", ylabel="Gain (dB)",
    xscale=:log10, xlim=(50, 20000), ylim=(-12.5, +12.5),
    xticks=([63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
        ["63", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]),
    yticks=(-12:3:12),
    legend=false)

plot(f, angle.(rsp) * 180/pi, linewidth=2,
    xlabel="Frequency (Hz)", ylabel="Phase (degree)",
    xscale=:log10, xlim=(50, 20000), ylim=(-185,185),
    xticks=([63, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
        ["63", "125", "250", "500", "1k", "2k", "4k", "8k", "16k"]),
    yticks=(-180:30:180),
    legend=false)
