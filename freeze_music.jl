
using FileIO, LibSndFile, SampledSignals
include("/Users/marui/Dropbox/_julia/audioutil.jl");

filename = "guitar.flac";
snd = load(filename)

x = snd.data[:,1];
fs = snd.samplerate;
y = freeze(x);

snd_out = SampleBuf(map(PCM16Sample, normalize_signal(y)), fs)

save("freeze_music_output.flac", snd_out);
