# Local grouping and ornamentation reduction #

| **If you use this program for research purposes, please cite the following reference in your resulting publications:**  Olivier Lartillot, An integrative computational modelling of music structure apprehension. Proceedings, ICMPC-APSCOM 2014 Joint Conference: International Conference on Music Perception and Cognition. ed. / Moo Kyoung Song. Yonsei University, 2014. p. 80-86. http://vbn.aau.dk/en/persons/olivier-lartillot(2aa5961a-82e1-4e8e-8676-7ec8bf240f54)/publications.html |
|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|

## Local grouping ##

```
mus.score(...,'Group')
```
When `mus.score` is called with the option `'Group'`, local grouping is performed.

For the moment, only local grouping in the time domain have been conceived and integrated to the module.

In the time domain, local grouping aggregates in a purely hierarchical fashion. Each group is characterized by the maximal temporal distance between successive notes. Smaller groups are related to short temporal distances while larger group that contains other groups are related to longer temporal distances.

Let's analyse this French folk song, called "Au clair de la lune":
![https://miningsuite.googlecode.com/svn/wiki/auclairdelalune_score.png](https://miningsuite.googlecode.com/svn/wiki/auclairdelalune_score.png)

Below is the local grouping, obtained using the command:
```
mus.score('auclairdelalune.mid','Group','Spell')
```
![https://miningsuite.googlecode.com/svn/wiki/auclair_group.png](https://miningsuite.googlecode.com/svn/wiki/auclair_group.png)

The piece starts with four eighth-notes followed by a fourth-note. These first 5 notes (with successive pitches C,C,C,D,E) form a local group related to the rhythmic value of eighth-note. This 5-note local group is followed by an isolated fourth-note (D) and a second 5-note local group (C,E,D,D,C). Since these 11 notes end with a half-note, they form altogether a higher-level local group related to the rhythmic value of fourth-note. The grouping is the same for the three other phrases, as they present the same rhythmic configuration.

## Local group head ##

By definition, a time-based local group terminates with a note that is followed by a duration (before the next note) that is significantly longer than the temporal distance between notes within the group. As such, the local group can be perceived as a phrase that terminates with a concluding note that has a more structural importance. This hypothesis might not be always valid, in particular in the presence of particular accentuations at particular notes within the group. But in more general case, it seems to offer some general interest. Following this observation, we propose to formalize this hierarchy of notes in local groups by associating with each local group a main note, or “head” to follow the GTTM's Time-Span Reduction terminology, which would in the simple case be the last note of the group, circled in red in the score representation. The other notes can be considered as “subordinate events” or – why not – as the “tail” of the group.

Local group head is shown with a red line that spans from the attack of the note to the end of the local group.

For instance, in the example above, the first 5-note local group (C,C,C,D,E) terminates with the longer note E, becoming the head of the group.

## Passing notes ##

Within a local group, all notes do not have the same importance. A monotonous and uniform conjunct melodic motion is a series of notes such that:
  * inter-pitch intervals between success notes are all of 1 or 2 semi-tones and in the same direction (up or down),
  * inter-onset intervals between successive notes are very similar,
  * no note is particularly accentuated.
In such configuration, the intermediary notes form passing notes: these subordinate elements play mainly a role of filling the interval gap between the starting and ending points of the line. For that reason, these intermediary notes are generally not perceived as note that play a more global role outside that particular melodic line.

Intermediary notes are shown in grey in the graphical representation. For the example below, in the first local group, in the ascending movement (C,D,E), note D plays a simple role of passing note between notes C and E. The longer descending movement around time 12 seconds (D,C,B,A,G) features a series of passing notes.

```
mus.score('auclairdelalune.mid','Group','Passing','Spell')
```
![https://miningsuite.googlecode.com/svn/wiki/auclair_passing.png](https://miningsuite.googlecode.com/svn/wiki/auclair_passing.png)

## "Broderies" ##

When subordinate events in a local group have same pitch than the final note of the group, they all form a single note – a “meta-note", which becomes the actual head of the group. The subordinate events of the groups can be considered as forming an ornament – such as a cambiata or a trill – of the group's head.

For instance, in the figure, the second 5-note local group (C,E,D,D,C) ends with pitch C, which already appears at the beginning of the group, thus the two occurrences of pitch C form a meta-note, which is highlighted by a red rectangle. The local group develops a broderie around that main note C.

## Syntagmatic network ##

Melodic “reduction” is commonly understood as a process of eliminating the ornamentation (here, the subordinate elements) from the music surface in order to keep the deeper structure (on various hierarchical levels) made of the more important notes. Our conception of melodic reduction, however, does not impose such reduction of information, but on the contrary, integrates the deeper structure information within the music surface. More precisely, the surface is formalized as a chain of connections between successive notes, i.e., a chain of syntagmatic connections, or a syntagmatic chain, following Saussure (1916)'s terminology. The deeper structure can be represented by adding new syntagmatic connections between successive elements in the deeper hierarchical levels. We obtain hence a syntagmatic network presenting a set of possible alternative syntagmatic chains. Formalized heuristics rule this construction of syntagmatic chains, as shown below.

The head of any local group is syntagmatically connected to the most recent note preceding the group that is not a passing note, as well as to the head of any local group closed by that note. For instance, in the figure, the first 3 notes are C#, D and C#. The second and third notes form a local group, with head C#. This head is then syntagmatically connected to the previous note, i.e., the first C#. Similarly, the head of any local group is syntagmatically connected to the note succeeding the group.

In a series of passing note, there is a direct syntagmatic connection between the notes just before and after that series. For instance in Figure 3, in the longer descending movement around time 12 seconds (D,C,B,A,G), there is a direct connection between the start (D) and ending (G) notes of this line.

A syntagmatic chain of notes of same pitch form a single meta-note whose time onset is set at the first note. This meta-note can be syntagmatically connected to any note following the meta-note. For instance, in the figure, we mentioned the syntagmatic connection between the first and third note. Having same pitch, these two notes form a single meta-note. This formalizes the cambiata around pitch C# materialized by the first 3 notes.

The syntagmatic network is graphically represented in yellow.

## Reference ##

More details about the model in this paper:
Olivier Lartillot, An integrative computational modelling of music structure apprehension. Proceedings, ICMPC-APSCOM 2014 Joint Conference: International Conference on Music Perception and Cognition. ed. / Moo Kyoung Song. Yonsei University, 2014. p. 80-86. http://vbn.aau.dk/en/persons/olivier-lartillot(2aa5961a-82e1-4e8e-8676-7ec8bf240f54)/publications.html