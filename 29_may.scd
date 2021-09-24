(
SynthDef(\three_harmonics_lfo, {
	|out, freq, amp, sustain, lfo_freq=5|
	var lfo, env, env_gen, sig, h1, h2, all_h, final_sig, pan;
	freq = MouseX.kr(freq*0.8, freq*1.2);
	lfo = SinOsc.ar((100 - freq/50), 0,amp, amp);
	sig = SinOsc.ar([freq*2, freq, freq*3], 0, [7*lfo/10, lfo/5, lfo/10]);
/*	h1 = SinOsc.ar(freq*2, 0, lfo/5);
	h2 = SinOsc.ar(freq*3, 0, lfo/10);*/
	all_h = sig;// + h1 + h2;
	env = Env.linen(attackTime: 0.05, releaseTime: sustain, level: 0.2);
	env_gen = EnvGen.kr(env, doneAction: Done.freeSelf);
	final_sig = all_h*env_gen;
	pan = Splay.ar(final_sig, spread:MouseY.kr(0,1));
	Out.ar(out, pan)
}).add;
)

s.boot;
Pbindef(\a,
	\instrument, \three_harmonics_lfo,
	\dur, Pseq([10], inf),
	\amp, Pseq([0.4], inf),
).play;
Pbindef("abc",
	\instrument, \three_harmonics_lfo,
	\dur, Pseq([10], inf),
	\amp, Pseq([0.4], inf),
).play;

Pbindef("melody",
	\instrument, \three_harmonics_lfo,
	\amp, Pseq([0.4], inf),
);

Pbindef("abc", \freq, Pseq([
		[26, 38 , 52, 55, 60],
		[26, 38 , 52, 55, 60] - 8,
		[26, 38 , 52, 55, 60] - 6
].midicps, inf););

Pbindef(\a, \freq, Pseq([
		[26, 38 , 52, 55, 60],
		[26, 38 , 52, 55, 60] - 8,
		[26, 38 , 52, 55, 60] - 6
].midicps, inf);).play;
Pbindef(\a, \amp, 0.2);
Pbindef("abc", \amp, 0.2);
Pbindef("melody", \amp, 0.4);
Pbindef("melody", \freq, Pseq([38, 40, 42, 44, 46, 48].midicps, inf), \dur, Pseq([2, 1, 1, 1, 0.2, 0.2], inf)).play;
(
TempoClock.default.tempo = 2;

p = Pbindef(\lo, \instrument, \ding_sine, \time, Pkey(\delta), \amp, 0.3);
q = Pbindef(\hi, \instrument, \ding_sine, \time, Pkey(\delta), \amp, 0.3);
r = Pbindef(\chord, \instrument, \ding_sine, \time, Pkey(\delta), \amp, 0.3);
p.quant = 1;
q.quant = 1;
r.quant = 1;

// p.set(\instrument, \ding_sine);

var pattern = Pseq([0.5, 0.3, 0.5, 0.1, 0.4, 1]*2, inf);
var p2 = Pseq([0.5, 0, 0, 0], inf);
Pbindef(\lo, \freq, Pseq([50, 55, 60, 61, 62],inf), \dur,  pattern);
Pbindef(\hi, \freq, Pseq([50, 55, 60, 67]-5,inf), \dur,  pattern);
Pbindef(\chord, \freq, Pseq([50, 55, 60, 52] + 5,inf), \dur,  pattern);
(p.play; q.play; r.play;);

)
// f.s