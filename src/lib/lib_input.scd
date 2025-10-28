(
~s1 = "CM";
~s2 = "Bbmin7/Db";
~s3 = "F#Maj7(add9add#11addb13)/A#";
~s4 = "Ebmin6(b9)/Gb";

~parseInputSymbol = { |symbol|
	var root, bass = nil, ext;
	var start, end, base;
	// 1. Check is it's a symbol, if so turn into string
	if (symbol.isKindOf(Symbol)) {
		symbol = symbol.asString;
	};

	if (~noteNames[0].includes(symbol[0].asSymbol).not.postln) {
		Error("Not a valid root note.\n").throw;
	};

	// get root
	if ((symbol[1] == $#) || (symbol[1] == $b).postln) {
		root   = symbol[0..1];
		symbol = symbol[2..];
	} {
		root   = symbol[0];
		symbol = symbol[1..];
	};
	"symbol: %".format(symbol).postln;
	"root: %".format(root).postln;

	if (symbol.includes($/)) {
		symbol = symbol.split($/);
		bass   = symbol[1];
		symbol = symbol[0];
	};
	"symbol: %".format(symbol).postln;
	"bass: %".format(bass).postln;

	if (symbol.includes($()) {
		start  = symbol.indexOf($();
		end    = symbol.indexOf($));
		ext    = symbol[(start + 1)..(end - 1)];
		symbol = symbol.split($()[0];

		if (ext.contains("add")) {
			ext = ext.replace("add", " ");
			ext = ext[1..].split($ ).postln;
		} {
			ext = [ext];
		}
	};
	"symbol: %".format(symbol).postln;
	"ext: %".format(ext).postln;
	base = symbol;

	"\nDATA:".postln;
	"base: %".format(base).postln;
	"root: %".format(root).postln;
	"bass: %".format(bass).postln;
	"ext:  %".format(ext).postln;

};

~parseInputSymbol.(~s4)
)
~noteNames[0].includes('B')


(
~dict = Dictionary[
	['a', 'b'] -> [1, 2, 3],
	'c' -> [4, 5, 6]
];

~ref = 'c';

~dict.keysValuesDo { |k, v|

	if (k.isArray) {
		"k.includes(~ref): %".format(k.includes(~ref)).postln;
	}
};
)
(
~str = "b13#9m11";
~s = ~str.findRegexp("(9|11|13|.9|.11|.13)").asSet.collect { |i| i[1] }
)
(
~removeAdd = { |str|
	str = str.replace("add", " ")[1..];
	str.split($ );
};
~str = "addd9add#10";
~removeAdd.(~str);
//~str.findRegexp("(9|11|13|)").asSet.collect { |i| if (i[1].notNil) {i[1]}}
)

(
~str = "C#7min6(b9#11)";
~s = ~str.findRegexp("([\(\)])").asSet;
)

(
~str = "Ebmin7/G#";
~s = ~str.findRegexp("([A-G][#b]|[A-G])$").asSet.collect { |n| n[1] }.asArray.first;
)
(
~str = "EbMaj(#11b913)/Bb";
~s = ~str.findRegexp("(9|11|13|.9|.11|.13)").asSet.collect { |n| n[1] };
)
(
~str = "Fb#3o5M7M9#11b13";
~s = ~str.findRegexp("(3|5|7|9|11|13|.3|.5|.7|.9|.11|.13)").asSet.collect { |n| n[1] };
)
~s
(
~sortDegrees = { |arr|
	var temp = Array.fill(arr.size, [0]);

	arr = arr.asArray;
	"arr.size: %".format(arr.size).postln;
	arr.reverseDo { |n, i|
		"n: %".format(n).postln;
		case
		{ n.contains("13") } { temp[arr.size - (i + 1)] = n }
		{ n.contains("11") } { temp[arr.size - (i + 1)] = n }
		{ n.contains($9) }   { temp[arr.size - (i + 1)] = n }
		{ n.contains($7) }   { temp[arr.size - (i + 1)] = n }
		{ n.contains($5) }   { temp[arr.size - (i + 1)] = n }
		{ n.contains($3) }   { temp[arr.size - (i + 1)] = n }
	};
	temp;
};
~sortDegrees.(~s);
)

(
~str = "A#9sus4(add9add11addb13)";
~root = ~str.findRegexp("^([A-G][#b]|[A-G])").asSet.collect { |n| n[1] }.asArray.postln;
~str.replaceRegexp("(%)".format(~root), "").postln;
//~s = ~str.replaceRegexp("([\(\)(add)])", "").postln;
//~base = ~s.findRegexp("(.[Ss]us[24])").asSet.collect { |n| n[1] }.asArray.postln;
//~s
)

(
~str = "Cmin7(((9))/Eb";
~str.findAllRegexp("[A-G]|[A-G][#b]");
"/$".matchRegexp(~str);
"[/]([A-G]|[A-G][#b])$".matchRegexp(~str);
//"([\(\)])".matchRegexp.(~str);
~p = ~str.findRegexp("\(([^()]*)\)").asSet;

// case
// {~p.size == 1 && ~p[0] == "("} {
// 	"Missing ')'".postln;
// }
// {~p.size == 1 && ~p[0] == ")"} {
// 	"Missing '('".postln;
// }
)
// Cmin6
// Cminb6
// C6
// CMaj6
// C76
// C7Maj6

(
~symbolIsValid = { |symbol|

	~rootIsValid.()
	~bassIsValid.()
	~extensionsAreValid.()
};
)
(
// Test for special chords
~str = "sus2";
"^([Ss]us|[Nn][ea]|[Gg][er]|[Ff]r|[Ii]t)|(6|9|11|13)$".matchRegexp(~str);
)









