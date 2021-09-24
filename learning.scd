(
var midis = ([
	50//, 57, 65, 60]
] + 23 - (12*2));
var durs = [
	0.5, 0.5, 0.5, 0.5
]*5;
var amps = [
	0.1,0,0, 0, 0
];
SynthDef(\squelchy_bass, {
	|out, freq, sustain, amp|

	var signal, env;

	signal = SinOsc.ar(
		freq.midicps,
		0,
		amp
	);
	env = Env.perc(attackTime: 0.05, releaseTime: sustain, level: 0.2);
	signal = signal * EnvGen.kr(env, doneAction: Done.freeSelf);
	Out.ar(out, signal ! 2)
}).add;

// t = Tuning.et(17);
// Pbind(\scale, Scale.chromatic(t), \degree, Pseq((0..15) ++ (15..0) ++ [\rest], 1), \dur, 0.25).play;

// {SinOsc.ar(t.at([-10, 0,2,3,9, 11])*220, 0, 0.2) ! 2}.play;

// t.at([0,3]);


p = Pbind(
	\instrument, \squelchy_bass,
	\freq, Pseq(midis, inf),
	\dur, Pseq(durs, inf),
	\amp, Pseq(amps, inf)
).play;
)
// s=Server.local.boot;
// Server.default.options.outDevice = ServerOptions.outDevices.at(1);
// Server.default.options.outDevice_(ServerOptions.outDevices.at(1));