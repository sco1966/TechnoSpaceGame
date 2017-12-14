s.boot;
(
SynthDef.new("tutorial-args", { arg freq = 440, out = 0; var sound;

	sound =SinOsc.ar(freq, 0, 0.2);

	    Out.ar(out,Pan2.ar(sound));
	//Pan2.ar(sound);
}).add;
)
s.scope; // scope so you can see the effect
x = Synth.new("tutorial-args");
x.set("freq", 660);
x.set("freq", 880, "out", 1);
x.free;

SynthDef("help-Pan2", { Out.ar(0, Pan2.ar(PinkNoise.ar(0.4), FSinOsc.kr(21), 0.3)) }).play;

(
var winenv;
// a custom envelope
winenv = Env([0, 1, 0], [0.2, 0.2], [4, -4]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, envbuf;
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    freqdev = BrownNoise.kr(MouseY.kr(0, 400));
    env = EnvGen.kr(
        Env([0, 1, 0], [0.2, 0.5], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
    Out.ar(0,
		        GrainFM.ar(2, Impulse.kr(10), 0.1, 666+ freqdev,LFNoise1.kr.range(40, 70),
            pan, envbuf) * env)
    }).add;

)

x = Synth.new("fm_grain_test");
x = Synth(\fm_grain_test, [\envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);