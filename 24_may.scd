SynthDef(\ding_sine, {
	|out, freq, amp, sustain|
	var sig, env;
	env = Env.linen(attackTime: 0.05, sustainTime: sustain/2, releaseTime: sustain/2, level: 0.2);
	sig = SinOsc.ar(freq.midicps, 0, amp);
		sig = sig * EnvGen.kr(env, doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2)
}).add;

x = PbindProxy.new;
y = PbindProxy.new;

~freqs = List[50, 51, 52];
x.set(\instrument, \ding_sine);
x.set(\freq, Pseq(~freqs, inf));
x.set(\dur, Pseq([0.5, 0.5, 0.2], inf));
x.play;

x.set(\freq, Pseq(~freqs-12, inf), \dur,  Pseq([0.5, 0.5, 0.2], inf));
// f.source = Pseq([, inf)
x.play;
Pkey
TempoClock.default.tempo = 2;

p = Pbindef(\lo, \instrument, \ding_sine, \time, Pkey(\delta));
q = Pbindef(\hi, \instrument, \ding_sine, \time, Pkey(\delta));
r = Pbindef(\chord, \instrument, \ding_sine, \time, Pkey(\delta));
p.quant = 1;
q.quant = 1;
r.quant = 1;
(p.play; q.play; r.play;);
Ptpar
p.set(\instrument, \ding_sine);

(
var pattern = Pseq([0.5, 0.3, 0.5, 0.1, 0.4, 1]*2, inf);
var p2 = Pseq([0.5, 0, 0, 0], inf);
Pbindef(\lo, \freq, Pseq([50, 55, 60, 61, 62],inf), \dur,  pattern);
Pbindef(\hi, \freq, Pseq([50, 55, 60, 67]-5,inf), \dur,  pattern);
Pbindef(\chord, \freq, Pseq([50, 55, 60, 52] + 5,inf), \dur,  pattern);
)
// f.source = Pseq([, inf)
y.play;
Pbindef(\x).quant = 1;
Pbindef(\x).play;
// [1, 0.1].asDict(class: Dictionary)
// x.set(\freq, Pseq([50, 51, 52] + 3, inf));
// Server.killAll;
Tdef(\x, {
	loop {
		x.play
	}
})

Pdefn(\x)