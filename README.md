# Memorisation strategies during RSVP

###### Julian Matthews, Jamin Wu, Vanessa Corneille, Jakob Hohwy, Jeroen van Boxtel, Naotsugu Tsuchiya

***

[**The paper that implements this code has been published in Attention, Perception, & Psychophysics. It is available here.**](https://link.springer.com/article/10.3758/s13414-018-1600-1)

> In visual search of natural scenes, differentiation of briefly fixated but task-irrelevant distractor items from incidental memory is often comparable to explicit memorization. However, many characteristics of incidental memory remain unclear, including the capacity for its conscious retrieval. Here, we examined incidental memory for faces in either upright or inverted orientation using Rapid Serial Visual Presentation (RSVP). Subjects were instructed to detect a target face in a sequence of 8–15 faces cropped from natural scene photographs (Experiment 1). If the target face was identified within a brief time window, the subject proceeded to an incidental memory task. Here, subjects used incidental memory to discriminate between a probe face (a distractor in the RSVP stream) and a novel, foil face. In Experiment 2 we reduced scene-related semantic coherency by intermixing faces from multiple scenes and contrasted incidental memory with explicit memory, a condition where subjects actively memorized each face from the sequence without searching for a target. In both experiments, we measured objective performance (Type 1 AUC) and metacognitive accuracy (Type 2 AUC), revealing sustained and consciously accessible incidental memory for upright and inverted faces. In novel analyses of face categories, we examined whether accuracy or metacognitive judgments are affected by shared semantic features (i.e., similarity in gender, race, age). Similarity enhanced the accuracy of incidental memory discriminations but did not influence metacognition. We conclude that incidental memory is sustained and consciously accessible, is not reliant on scene contexts, and is not enhanced by explicit memorization.

![alt text][exemplar]

## What is this?
Here we provide MATLAB code for our [psychophysical study of short-term incidental memory](https://psyarxiv.com/yscdu). Our task employs **Rapid Serial Visual Presentation** (RSVP) to contrast incidental and explicit memory for upright and inverted faces. We found incidental memory has sustained conscious access and is likely to arise as a natural consequence of perception.

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
