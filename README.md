![alt text][logo]
# Rapid Serial Visual Presentation
**ISSA2017 Psychophysics Hands-on Project**
## Coordinators
1. Nao Tsuchiya (Monash University)
2. Julian Matthews (Monash University)
3. Katsunori Miyahara (Rikkyo University)
4. Elizaveta Solomonova (University of Montreal)

## Outline
The aim of this hands-on project is to introduce two exemplar visual psychophysics paradigms. By experiencing what psychophysics tasks are like, students will be able to design their own experiment. Also, students will learn some basic analysis concepts: objective performance and [metacognitive sensitivity](http://www.sciencedirect.com/science/article/pii/S105381000090494X), each based on [signal detection theory](http://psycnet.apa.org/psycinfo/2004-19022-000). A broader aim is to consider what these behavioural techniques might tell us about consciousness and related processes (such as attention, memory and metacognition). 

Here we provide MATLAB code for building psychophysics experiments that employ **Rapid Serial Visual Presentation** (RSVP). Students are encouraged to modify this code to examine their own research questions in collaboration with the coordinators.

## You will need: 
1. **MATLAB**
2. [**Psychtoolbox**](http://psychtoolbox.org/)

## Description:
The experiment included in this repository employs RSVP to further explore our recent work on [incidental memory in visual search](https://www.ncbi.nlm.nih.gov/pubmed/27507869). Clone or download the repository to examine how it works. 

The critical m-files for running the experiment are in the [`scripts`](./scripts/run_experiment) subfolder.

## Methods:
A simple schematic of our 'incidental' RSVP task.

![methods]

Subjects are presented with a **target** face and, as their primary task, must respond with a mouse-click as soon as they see the target appear. To ensure subjects focus on this task we present an annoying flashing screen if they respond too early or more that ~700ms after the target face.

Following correct identification of the target, subjects discriminate between a **probe** face that had appeared in the preceding stream of images and an as-yet unseen **foil** face. A single mouse-click records both decision and confidence. An example of a correct report with confidence level of 4 is shown here.

Probes are selected from four positions or *lags* relative to the target: -1, -3, -5, and -7. The probe pictured here was five items prior to the target. 

![alt_text][avatar]

[methods]: ../master/methods-figure-RSVP.png

[logo]: https://raw.githubusercontent.com/julian-matthews/MoNoC-practice-experiment/master/MoNoC_minimal.png "Monash Neuroscience of Consciousness"

[avatar]: https://avatars0.githubusercontent.com/u/18410581?v=3&s=96 "I'm Julian"
