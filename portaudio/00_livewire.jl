using PortAudio

blsz = 256;
inChans = 1;
outChans = 1;
stream = PortAudioStream("Sonic Port VX", inChans, outChans,
                         blocksize=blsz, synced=true);
# stream = PortAudioStream("Fireface UC Mac (22946606)", 1, 1;
#                          blocksize=5blsz, synced=true);

while true
    
end
