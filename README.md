# Phoneme Tool
Phoneme tool is a tool for Garry's Mod that allows manipulation of face flexes with phonemes.

## Getting phonemes for ragdolls
By default, Phoneme Tool only supports TF2 HWM models, but you can extract phonemes from other models through Source Filmmaker. Copy the script from the sfm folder in this repo to SFM's *usermod\scripts\sfm\animset* folder. Then, open up SFM, create an animation set with the model you want to export phonemes from, right click it, and run the script from the rig menu. This will give you a file dialog where you select the file where to save the exported txt file. Once saved, move this txt file to *garrysmod/data/phonemetool*, and you should be able to use these phonemes with Phoneme Tool.