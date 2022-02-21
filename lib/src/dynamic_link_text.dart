// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

abstract class SmartTextElement {}

/// Represents an element containing a link
class LinkElement extends SmartTextElement {
  final String url;

  LinkElement(this.url);

  @override
  String toString() {
    return 'LinkElement: $url';
  }
}

/// Represents an element containing a hastag
class HashTagElement extends SmartTextElement {
  final String tag;

  HashTagElement(this.tag);

  @override
  String toString() {
    return 'HashTagElement: $tag';
  }
}

/// Represents an element containing a @
class UserTagElement extends SmartTextElement {
  final String tag;

  UserTagElement(this.tag);

  @override
  String toString() {
    return 'HashTagElement: $tag';
  }
}

/// Represents an element containing text
class TextElement extends SmartTextElement {
  final String text;

  TextElement(this.text);

  @override
  String toString() {
    return 'TextElement: $text';
  }
}

final _linkRegex = RegExp(
    r'(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)',
    caseSensitive: false);
final _tagRegex = RegExp(r'\B#\w*[a-zA-Z]+\w*', caseSensitive: false);
final _userTagRegex = RegExp(r'\B@\w*[a-zA-Z]+\w*', caseSensitive: false);

/// Turns [text] into a list of [SmartTextElement]
List<SmartTextElement> _smartify(String text) {
  final sentences = text.split('\n');
  var span = <SmartTextElement>[];
  for (String sentence in sentences) {
    final words = sentence.split(' ');
    for (String word in words) {
      if (_linkRegex.hasMatch(word)) {
        span.add(LinkElement(word));
      } else if (_tagRegex.hasMatch(word)) {
        span.add(HashTagElement(word));
      } else if (_userTagRegex.hasMatch(word)) {
        span.add(UserTagElement(word));
      } else {
        span.add(TextElement(word));
      }
      span.add(TextElement(' '));
    }
    if (words.isNotEmpty) {
      span.removeLast();
    }
    span.add(TextElement('\n'));
  }
  if (sentences.isNotEmpty) {
    span.removeLast();
  }
  return span;
}

/// Callback with URL to open
typedef StringCallback = Function(String url);

/// Turns URLs into links
class DynamicLinkText extends StatelessWidget {
  /// Text to be linkified
  final String? text;

  /// Style for non-link text
  final TextStyle? style;

  /// Style of link text
  final TextStyle? linkStyle;

  /// Style of HashTag text
  final TextStyle? tagStyle;

  /// Callback for tapping a link
  final StringCallback? onOpen;

  /// Callback for tapping a hashtag
  final StringCallback? onTagClick;

  /// Callback for tapping a user tag
  final StringCallback? onUserTagClick;

  const DynamicLinkText(
      {Key? key,
      this.text,
      this.style,
      this.linkStyle,
      this.tagStyle,
      this.onOpen,
      this.onTagClick,
      this.onUserTagClick})
      : super(key: key);

  /// Raw TextSpan builder for more control on the RichText
  TextSpan _buildTextSpan({
    String? text,
    TextStyle? style,
    TextStyle? linkStyle,
    TextStyle? tagStyle,
    StringCallback? onOpen,
    StringCallback? onTagClick,
    StringCallback? onUserTagClick,
  }) {
    void _onOpen(String url) {
      if (onOpen != null) {
        onOpen(url);
      }
    }

    void _onTagClick(String tag) {
      if (onTagClick != null) {
        onTagClick(tag);
      }
    }

    void _onUserTagClick(String userTag) {
      if (onUserTagClick != null) {
        onUserTagClick(userTag);
      }
    }

    final elements = _smartify(text!);

    return TextSpan(
        children: elements.map<TextSpan>((element) {
      if (element is TextElement) {
        return TextSpan(
          text: element.text,
          style: style,
        );
      } else if (element is LinkElement) {
        return LinkTextSpan(
          text: element.url,
          style: linkStyle!,
          onPressed: () => _onOpen(element.url),
        );
      } else if (element is HashTagElement) {
        return LinkTextSpan(
          text: element.tag,
          style: tagStyle!,
          onPressed: () => _onTagClick(element.tag),
        );
      } else if (element is UserTagElement) {
        return LinkTextSpan(
          text: element.tag,
          style: tagStyle!,
          onPressed: () => _onUserTagClick(element.tag),
        );
      } else {
        return LinkTextSpan(
          text: '',
          style: tagStyle!,
          onPressed: () => _onUserTagClick(''),
        );
      }
    }).toList());
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      softWrap: true,
      text: _buildTextSpan(
          text: text,
          style: Theme.of(context).textTheme.bodyText2!.merge(style),
          linkStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(style)
              .copyWith(
                color: Colors.blueAccent,
                decoration: TextDecoration.underline,
              )
              .merge(linkStyle),
          tagStyle: Theme.of(context)
              .textTheme
              .bodyText2!
              .merge(style)
              .copyWith(
                color: Colors.blueAccent,
              )
              .merge(linkStyle),
          onOpen: onOpen,
          onTagClick: onTagClick,
          onUserTagClick: onUserTagClick),
    );
  }
}

class LinkTextSpan extends TextSpan {
  LinkTextSpan({TextStyle? style, VoidCallback? onPressed, String? text})
      : super(
          style: style,
          text: text,
          recognizer: TapGestureRecognizer()..onTap = onPressed,
        );
}
