(
var rs = [
	// [0.25, 0.5, 2,6/2,8/3],
	// 1.2*[1/6, 1/3, 4/3,8/5,6/7],
	// [0.3, 1.6, 2.9, 3.2],
	[1, 3/4, 2, 3]
];
var ofs = [
	[-12, -5, 0, 4, 6, 7, 11],
	[-12, -7, -5, 0, 3, 2+12, 10],
	[-12, -7, -5, 0, 4, 1+12, 10],
	// [-12, 7, -5, 3, 3+12, 10],
	// [-10, 6, -3, 2, 5+12, 13],
];
var amps = [
	0.2, 0.3, 0.1, 0.4
];
var fs = [
	50, 45, 55, 60, 61, 59, 54,47 //52, 50, 48
];
var mels = [
	50,45,46,48,51
];
var detune_frac = [100, 90, 200, 110, 120];
var durs = [4, 1, 2, 1, 3, 5, 4, 0.5, 1, 6]*0.5;
var oscfreq = [0.1, 0.4, 0.5];

var lens = [
	1, 1, 1.5, 0.5, 0.1
];
var pols = [
	1,-1,-0.5, 0.5, -0.2, 0.2
];
SynthDef(\test123_a, {
	|out, freq = 220, sustain = 1, amp = 0.2, ratios = #[1, 1.5, 1.3], ofs, oscfreq=0.5, detune_frac=10, polarity=1|
	var sig, noised, pan;
	sig =
	SinOsc.ar((SinOsc.ar(oscfreq, 0, freq/detune_frac, freq) + ofs).midicps, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
	noised = Crackle.ar(2, SinOsc.ar(oscfreq, 0, 0.5 - amp, 0.5 - amp),0.5 - amp) + Crackle.ar(2, 1, 0)*sig;
	pan = Pan2.ar(noised, Line.kr(polarity,-1*polarity,4));
	Out.ar(out, pan)
}).add;

SynthDef(\melody, {
	|out, freq, sustain, amp|
	var sig;
	sig = SinOsc.ar(
		freq.midicps,
		0,
		amp
	) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: Done.freeSelf);
	Out.ar(out, sig ! 2)
}).add;

p = Pbind(
	\instrument, \test123_a,
	\freq, Pseq(fs, inf),
	\dur, Pseq(durs, inf),
	// \ratios, Pseq(rs, inf),
	\amp, Pseq(amps, inf),
	\ofs, Pseq(ofs, inf),
	\polarity, Pseq(pols, inf),
	\sustain, Pseq(durs, inf),
	\oscfreq, Pseq([0.1, 0.4, 0.5], inf),
	\detune_frac, Pseq(detune_frac, inf)
).play;

q = Pbind(
	\instrument, \melody,
	\freq, Pseq(mels + 12, inf),
	\dur, Pseq(lens, inf),
	\amp, 0.5
).play;

r = Pbind(
	\instrument, \melody,
	\freq, Pseq(fs - 24, inf),
	\dur, Pseq(lens, inf),
	\amp, 0.5
).play;
)
