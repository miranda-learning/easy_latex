import '../enums.dart';
import '../nodes/__export.dart';
import '../util/__export.dart';
import 'render_context.dart';

class LineBreaksHandler {
  static const List<String> arrowLineBreaks = ['\u21d2', '\u21d4']; // =>, <=>
  static const List<String> equationLineBreaks = [
    '=',
    '\u2248',
    '\u224a',
    '\u21d4'
  ]; // =, ≈, ≊, ⇔
  static const List<String> arithmeticLineBreaks = ['+', '-', ':', '÷', '±'];

  static EntryNode addLineBreaks(
      EntryNode entryNode, RenderContext renderContext, double maxWidth) {
    if (entryNode.size.width <= maxWidth) return entryNode;

    List<LatexRenderNode> lines = List.from(entryNode.lines);

    /// split at equal-signs, arithmetic signs and brackets
    int i = 0;
    while (i < lines.length) {
      LatexRenderNode node = lines[i];
      i++;
      if (node is! GroupNode || node.children.length <= 1)
        continue; // TODO bracket terms are currently considered as single term, that cannot be split.

      node.performLayout(renderContext);
      if (node.size.width < maxWidth) continue;

      double totalWidth = node.children[0].size.width + node.spacings[0];
      for (var j = 1; j < node.children.length; j++) {
        // step through all children and check where line break should be performed
        totalWidth += node.children[j].size.width + node.spacings[j];

        // check if old totalWidth < parentWidth and new totalWidth > parentWidth
        if (totalWidth > maxWidth) {
          List<LatexRenderNode> nextLineChildren = node.children.sublistSafe(j);
          node.children.removeRange(j, node.children.length);
          if (i == lines.lastIndex) {
            lines.add(GroupNode(nextLineChildren, BracketType.none));
          } else {
            lines.insert(i, GroupNode(nextLineChildren, BracketType.none));
          }
          break;
        }
      }
    }

    entryNode.lines.clear();
    entryNode.lines.addAll(lines);
    return entryNode;
  }

  /// TODO
  /// + und = werden immer am Zeilenanfang und Zeilenende gesetzt.
  static (EntryNode, MultiLineTextAlign?) addSmartLineBreaks(
      EntryNode entryNode, RenderContext renderContext, double maxWidth) {
    if (entryNode.size.width <= maxWidth) return (entryNode, null);

    List<LatexRenderNode> lines = [];

    // if width of entryNode is longer than maxWidth of parent, split node at all arrows, (=>, <=>)
    MultiLineTextAlign? textAlign;
    for (var node in entryNode.lines) {
      if (node is GroupNode &&
          node.children.length > 1 &&
          node.size.width > maxWidth) {
        List<GroupNode> splitNodes = _splitAtArrows(node);
        if (splitNodes.length > 1) textAlign = MultiLineTextAlign.left;
        lines.addAll(splitNodes);
      } else {
        lines.add(node);
      }
    }

    /// split at equal-signs, arithmetic signs and brackets
    int i = 0;
    while (i < lines.length) {
      LatexRenderNode node = lines[i];
      i++;
      if (node is! GroupNode || node.children.length <= 1)
        continue; // TODO bracket terms are currently considered as single term, that cannot be split.

      node.performLayout(renderContext);
      if (node.size.width < maxWidth) continue;

      double totalWidth = node.children[0].size.width + node.spacings[0];
      for (var j = 1; j < node.children.length; j++) {
        // step through all children and check where line break should be performed
        totalWidth += node.children[j].size.width + node.spacings[j];

        // check if old totalWidth < parentWidth and new totalWidth > parentWidth
        if (totalWidth > maxWidth) {
          // search for preferred line breaks
          int breakpoint = _findPreferredLineBreak(node.children, j);
          if (breakpoint == 1 && i > 0)
            continue; // ignore if there is only 1 node, because this is most likely =, +, - from previous line break

          // split text and create new line
          List<LatexRenderNode> nextLineChildren =
              node.children.sublistSafe(breakpoint);
          node.children.removeRange(breakpoint, node.children.length);
          if (i == lines.lastIndex) {
            lines.add(GroupNode(nextLineChildren, BracketType.none));
          } else {
            lines.insert(i, GroupNode(nextLineChildren, BracketType.none));
          }
          break;
        }
      }
    }

    entryNode.lines.clear();
    entryNode.lines.addAll(lines);
    return (entryNode, textAlign);
  }

  static List<GroupNode> _splitAtArrows(GroupNode groupNode) {
    // if width of entryNode is longer than maxWidth of parent, split node at every arrow

    List<int> breakpoints = [0];

    int openCurlies = 0;
    int openSquares = 0;
    int openDoubleSquares = 0;
    int openRounds = 0;

    int i = 0;
    while (i < groupNode.children.length) {
      LatexRenderNode node = groupNode.children[i];
      i++;

      if (node is BracketNode) {
        switch (node.bracketType) {
          case BracketType.none:
            break;
          case BracketType.curly:
            openCurlies += node.bracketOrientation.isLeft ? 1 : -1;
            break;
          case BracketType.square:
            openSquares += node.bracketOrientation.isLeft ? 1 : -1;
            break;
          case BracketType.doubleSquare:
            openDoubleSquares += node.bracketOrientation.isLeft ? 1 : -1;
            break;
          case BracketType.round:
            openRounds += node.bracketOrientation.isLeft ? 1 : -1;
            break;
        }
        continue;
      }
      if (i == 0 ||
          openCurlies != 0 ||
          openSquares != 0 ||
          openDoubleSquares != 0 ||
          openRounds != 0) continue;

      // arrows
      if (node is TextNode && arrowLineBreaks.contains(node.text)) {
        breakpoints.add(i - 1);

        // add extra space between arrow and equation/term, if there isn't already an extra space
        LatexRenderNode? nextNode =
            groupNode.children.length > i ? groupNode.children[i] : null;
        if (nextNode is! TextNode ||
            !nextNode.text.startsWith('\u2001') &&
                !nextNode.text.startsWith('\u00a0')) {
          node.text += '\u2001';
        }
      }
    }
    breakpoints.add(groupNode.children.length);

    List<GroupNode> newGroups = [];
    for (var i = 1; i < breakpoints.length; i++) {
      newGroups.add(GroupNode(
          groupNode.children.sublistSafe(breakpoints[i - 1], breakpoints[i]),
          BracketType.none));
    }

    return newGroups;
  }

  static int _findPreferredLineBreak(
      List<LatexRenderNode> nodes, int ogBreakpoint) {
    int openCurlies = 0;
    int openSquares = 0;
    int openDoubleSquares = 0;
    int openRounds = 0;

    int equationBreakpoint = 0;
    int arithmeticBreakpoint = 0;
    int bracketBreakpoint = 0;

    LatexRenderNode? copiedEquationNode;
    LatexRenderNode? copiedArithmeticNode;

    for (var i = 0; i < ogBreakpoint; i++) {
      LatexRenderNode node = nodes[i];
      if (node is SupSubNode && node.parent is BracketNode)
        node = node.parent!; // )², )_i

      if (node is BracketNode) {
        switch (node.bracketType) {
          case BracketType.none:
            break;
          case BracketType.curly:
            openCurlies += node.bracketOrientation.isLeft ? 1 : -1;
            break;
          case BracketType.square:
            openSquares += node.bracketOrientation.isLeft ? 1 : -1;
            break;
          case BracketType.doubleSquare:
            openDoubleSquares += node.bracketOrientation.isLeft ? 1 : -1;
            break;
          case BracketType.round:
            openRounds += node.bracketOrientation.isLeft ? 1 : -1;
            break;
        }
      }
      if (i == 0 ||
          openCurlies != 0 ||
          openSquares != 0 ||
          openDoubleSquares != 0 ||
          openRounds != 0) continue;

      if (node is TextNode && equationLineBreaks.contains(node.text)) {
        // =
        equationBreakpoint = i;
        copiedEquationNode = node.copy();
      } else if (node is TextNode && arithmeticLineBreaks.contains(node.text)) {
        // +,-,:
        arithmeticBreakpoint = i;
        copiedArithmeticNode = node.copy();
      } else if (node is BracketNode && nodes[i + 1] is BracketNode) {
        // split between ) and (
        bracketBreakpoint = i;
      }
    }

    // The order in which line breaks are set:
    //   1. equal-signs
    //   2. arithmetic operators (+,-, etc.)
    //   3. between 2 brackets )(
    // However, if the equal-sign is at the beginning, arithmetic operators or brackets are preferred.
    double equationSplitLength =
        nodes.sublistSafe(0, equationBreakpoint).sumDouble((e) => e.size.width);
    double arithmeticSplitLength = nodes
        .sublistSafe(0, arithmeticBreakpoint)
        .sumDouble((e) => e.size.width);
    double bracketSplitLength =
        nodes.sublistSafe(0, bracketBreakpoint).sumDouble((e) => e.size.width);

    // bracket
    if (bracketBreakpoint > 0 &&
        bracketSplitLength * 0.5 > equationSplitLength &&
        bracketSplitLength * 0.7 > equationSplitLength) {
      return bracketBreakpoint + 1;
    }

    // arithmetic
    if (arithmeticBreakpoint > 0 &&
        arithmeticSplitLength * 0.7 > equationSplitLength) {
      nodes.insert(arithmeticBreakpoint, copiedArithmeticNode!);
      return arithmeticBreakpoint + 1;
    }

    // equation
    if (equationBreakpoint > 0) {
      nodes.insert(equationBreakpoint, copiedEquationNode!);
      return equationBreakpoint + 1;
    }

    return ogBreakpoint;
  }
}
