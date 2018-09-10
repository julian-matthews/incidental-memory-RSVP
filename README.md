# Memorisation strategies during Rapid Serial Visual Presentation

A summary of our design and core finding:
![alt text][exemplar]

## What is this?
Here we provide MATLAB code for our [psychophysics study of incidental memory](https://psyarxiv.com/yscdu). Our task employs **Rapid Serial Visual Presentation** (RSVP) to contrast incidental and explicit memory for upright and inverted faces. We found incidental memory has sustained conscious access and is likely to arise as a natural consequence of perception.

## You will need: 
1. **MATLAB**
2. [**Psychtoolbox**](http://psychtoolbox.org/)

## Getting started:

The critical m-files for running the experiment are in the [`scripts`](./scripts/run_experiment) subfolder.

## Methods:
A simplified schematic of our *incidental* RSVP task:

![methods]

Subjects are presented with a **target** face and, as their primary task, must respond with a mouse-click as soon as they see the target appear. To ensure subjects focus on this task we present an annoying flashing screen if they respond too early or more that ~700ms after the target face.

Following correct identification of the target, subjects discriminate between a **probe** face that had appeared in the preceding stream of images and an as-yet unseen **foil** face. A single mouse-click records both decision and confidence. An example of a correct report with confidence level of 4 is shown here.

Probes are selected from four positions or *lags* relative to the target: -1, -3, -5, and -7. The probe pictured here was five items prior to the target. 

![alt_text][avatar]

[methods]: ../master/methods-figure-RSVP.png

[exemplar]: https://cogphillab.files.wordpress.com/2018/09/rsvp-example2.gif

[avatar]: https://avatars0.githubusercontent.com/u/18410581?v=3&s=96 "I'm Julian"
