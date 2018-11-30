using PortAudio

PortAudio.versioninfo()

devs = PortAudio.devices();
for d in devs
    println("$(d.idx): $(d.name) ($(d.hostapi)) $(d.maxinchans) in(s) / $(d.maxoutchans) out(s) at $(d.defaultsamplerate) Hz");
end

println(PortAudio.devnames())
