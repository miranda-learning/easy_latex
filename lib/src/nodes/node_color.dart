import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'node.dart';
import 'node_group.dart';
import 'node_number.dart';
import 'node_text.dart';

/// \color[ff00ff00]{}
class ColorNode extends LatexRenderNode {

	Map<String, Color> get colorMap => {
		'apricot': Color(0xffFBB982),
		'aquamarine': Color(0xff00B5BE),
		'bittersweet': Color(0xffC04F17),
		'black': Color(0xff221E1F),
		'blue': Color(0xff2D2F92),
		'bluegreen': Color(0xff00B3B8),
		'blueviolet': Color(0xff473992),
		'brickred': Color(0xffB6321C),
		'brown': Color(0xff792500),
		'burntorange': Color(0xffF7921D),
		'cadetblue': Color(0xff74729A),
		'carnationpink': Color(0xffF282B4),
		'cerulean': Color(0xff00A2E3),
		'cornflowerblue': Color(0xff41B0E4),
		'cyan': Color(0xff00AEEF),
		'dandelion': Color(0xffFDBC42),
		'darkorchid': Color(0xffA4538A),
		'emerald': Color(0xff00A99D),
		'forestgreen': Color(0xff009B55),
		'fuchsia': Color(0xff8C368C),
		'goldenrod': Color(0xffFFDF42),
		'gray': Color(0xff949698),
		'green': Color(0xff00A64F),
		'greenyellow': Color(0xffDFE674),
		'junglegreen': Color(0xff00A99A),
		'lavender': Color(0xffF49EC4),
		'limegreen': Color(0xff8DC73E),
		'magenta': Color(0xffEC008C),
		'mahogany': Color(0xffA9341F),
		'maroon': Color(0xffAF3235),
		'melon': Color(0xffF89E7B),
		'midnightblue': Color(0xff006795),
		'mulberry': Color(0xffA93C93),
		'navyblue': Color(0xff006EB8),
		'olivegreen': Color(0xff3C8031),
		'orange': Color(0xffF58137),
		'orangered': Color(0xffED135A),
		'orchid': Color(0xffAF72B0),
		'peach': Color(0xffF7965A),
		'periwinkle': Color(0xff7977B8),
		'pinegreen': Color(0xff008B72),
		'plum': Color(0xff92268F),
		'processblue': Color(0xff00B0F0),
		'purple': Color(0xff99479B),
		'rawsienna': Color(0xff974006),
		'red': Color(0xffED1B23),
		'redorange': Color(0xffF26035),
		'redviolet': Color(0xffA1246B),
		'rhodamine': Color(0xffEF559F),
		'royalblue': Color(0xff0071BC),
		'royalpurple': Color(0xff613F99),
		'rubinered': Color(0xffED017D),
		'salmon': Color(0xffF69289),
		'seagreen': Color(0xff3FBC9D),
		'sepia': Color(0xff671800),
		'skyblue': Color(0xff46C5DD),
		'springgreen': Color(0xffC6DC67),
		'tan': Color(0xffDA9D76),
		'tealblue': Color(0xff00AEB3),
		'thistle': Color(0xffD883B7),
		'turquoise': Color(0xff00B4CE),
		'violet': Color(0xff58429B),
		'violetred': Color(0xffEF58A0),
		'white': Color(0xffFFFFFF),
		'wildstrawberry': Color(0xffEE2967),
		'yellow': Color(0xffFFF200),
		'yellowgreen': Color(0xff98CC70),
		'yelloworange': Color(0xffFAA21A),
	};

	late final Color color;


	ColorNode(LatexRenderNode child) {
		String str = '';
		if (child is GroupNode) {
			for (var c in child.children) {
				if (c is TextNode) {
					str += c.text.toLowerCase();
				} else if (c is NumberNode) {
					str += c.text;
				}
			}
		} else if (child is TextNode) {
			str += child.text.toLowerCase();
		} else if (child is NumberNode) {
			str += child.text;
		}

		Color? color = colorMap[str];
		if (color != null) {
			this.color = color;
		} else {
			int? colorCode = int.tryParse('0xFF' + str);
			this.color = Color(colorCode ?? 0xff000000);
		}
	}


	@override
	void paint(Canvas canvas, double start, double baseline) {}


	@override
	String toString() => toStringWithIndent('');

	@override
	String toStringWithIndent(String indent) {
		String str = '$indent$runtimeType: w: ${size.width}, h: ${size.height}, '
			'baseline: ${baselineOffset.toStringAsFixed(2)}, color: $color';
		return str;
	}
}