
using FileIO: load, save
import LibSndFile
using Plots
pyplot();

sndorg = load("birdland_original.wav")

sndaac = load("birdland_aac.wav")

sndmp3 = load("birdland_mp3.wav")

xorg = sndorg.data[:,1];
xaac = sndaac.data[:,1];
fs = sndorg.samplerate;
t = (0 : length(xorg)-1) / fs;

snddif = sndorg - sndaac

sndorg - sndmp3
