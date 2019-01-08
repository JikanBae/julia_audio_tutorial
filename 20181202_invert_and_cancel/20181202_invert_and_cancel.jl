
using FileIO: load, save
import LibSndFile
using Plots
pyplot();

run(`afinfo birdland_original.wav`)

sndorg = load("birdland_original.wav")

run(`afconvert -f mp4f birdland_original.wav -o birdland.mp4`);

run(`afinfo birdland.mp4`);

run(`afconvert -f WAVE -d LEI16 birdland.mp4 birdland_aac.wav`);

run(`afinfo birdland_aac.wav`);

sndaac = load("birdland_aac.wav")

sndmp3 = load("birdland_mp3.wav")

xorg = sndorg.data[:,1];
xaac = sndaac.data[:,1];
fs = sndorg.samplerate;
t = (0 : length(xorg)-1) / fs;

snddif = sndorg - sndaac

sndorg - sndmp3
