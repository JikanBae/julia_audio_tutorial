
using FileIO: load
import LibSndFile
using Plots
pyplot();

snd = load("recorder.flac")

"""
    rms(x)

Calculate signal RMS.
"""
function rms(x)
  sqrt(sum(x.^2) / length(x))
end

"""
    rms_moving(x, samprate, window_size=8192, hop_size=1024)

Calculate running RMS.
"""
function rms_moving(x, samprate, window_size=8192, hop_size=1024)
    num_frames = ceil(Int, (length(x) + window_size-1) / hop_size);
    xx = [x ; zeros(2 * window_size)];
    rmss = zeros(num_frames);
    for n=1:num_frames
        xxx = xx[hop_size*(n-1)+1 : hop_size*(n-1)+window_size];
        rmss[n] = rms(xxx);
    end
    t = ((0:num_frames-1) * hop_size) / samprate;
    return (rmss, t);
end

rmss, t = rms_moving(snd.data, snd.samplerate);
plot(t, 10*log10.(rmss.^2),
    xlabel="Time (s)", ylabel="Amplitude (dBFS_rms)", legend=false)
