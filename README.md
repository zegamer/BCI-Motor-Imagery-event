# BCI-Motor-Imagery-event

BCI Motor Imagery is a program made by 2 students for a course at the University of Twente. This program identifies the EEG signals corresponding to motor imagery. We used BCI competition 4 Dataset 2A ([link]) for this purpose. Although the dataset classifies 4 different events - left hand, right hand, feet and tongue, we used only the left and right hand classes and removed the rest. The description for this dataset can be found [here] and you can also download it at this [web-link], under "Four class motor imagery (001-2014)".

### Todo

The program is still under construction and these are the tasks that need to be completed.
- [x] ~~Pre-process data (no artefact, left/right hand classes only, data structuring)~~
- [x] ~~CSP transformation~~
- [x] ~~Condense data to train an Ensemble/NNet~~
- [ ] Stream chunks of data to simulate online BCI


## Licence

The code is **open source** under MIT Licence.  
Check licence file in the repository.

For further questions, you can reach at m.v.konda@student.utwente.nl

[link]: <http://www.bbci.de/competition/iv/#dataset2a>
[web-link]: <http://bnci-horizon-2020.eu/database/data-sets>
[here]: <http://bnci-horizon-2020.eu/database/data-sets/001-2014/description.pdf>
