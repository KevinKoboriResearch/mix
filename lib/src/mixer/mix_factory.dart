import 'package:flutter/material.dart';
import 'package:mix/mix.dart';
import 'package:mix/src/attributes/common/attribute.dart';
import 'package:mix/src/attributes/dynamic/variant.attributes.dart';
import 'package:mix/src/attributes/helpers/helper.utils.dart';
import 'package:mix/src/helpers/utils.dart';
import 'package:mix/src/mixer/mixer.dart';

/// Defines a mix
class Mix<T extends Attribute> {
  final BoxAttributes? boxAttribute;
  final TextAttributes? textAttribute;
  final SharedAttributes? sharedAttribute;
  final IconAttributes? iconAttribute;
  final FlexAttributes? flexAttribute;
  final List<DynamicAttribute> dynamicAttributes;
  final List<TokenRefAttribute> tokenAttributes;
  final List<DirectiveAttribute> directiveAttributes;

  const Mix._({
    this.boxAttribute,
    this.textAttribute,
    this.sharedAttribute,
    this.iconAttribute,
    this.flexAttribute,
    this.directiveAttributes = const [],
    this.dynamicAttributes = const [],
    this.tokenAttributes = const [],
  });

  /// Define mix with parameters
  factory Mix([
    T? p1,
    T? p2,
    T? p3,
    T? p4,
    T? p5,
    T? p6,
    T? p7,
    T? p8,
    T? p9,
    T? p10,
    T? p11,
    T? p12,
  ]) {
    final params = <T>[];
    if (p1 != null) params.add(p1);
    if (p2 != null) params.add(p2);
    if (p3 != null) params.add(p3);
    if (p4 != null) params.add(p4);
    if (p5 != null) params.add(p5);
    if (p6 != null) params.add(p6);
    if (p7 != null) params.add(p7);
    if (p8 != null) params.add(p8);
    if (p9 != null) params.add(p9);
    if (p10 != null) params.add(p10);
    if (p11 != null) params.add(p11);
    if (p12 != null) params.add(p12);

    return Mix.fromList(params);
  }

  factory Mix.fromList(List<T> attributes) {
    final combined = spreadNestedAttributes(attributes);
    BoxAttributes? boxAttributes;
    IconAttributes? iconAttributes;
    FlexAttributes? flexAttributes;
    SharedAttributes? sharedAttributes;
    TextAttributes? textAttributes;

    final dynamicAttributes = <DynamicAttribute>[];
    final directiveAttributes = <DirectiveAttribute>[];
    final tokenRefAttributes = <TokenRefAttribute>[];

    for (final attribute in combined) {
      if (attribute is DynamicAttribute) {
        dynamicAttributes.add(attribute);
      }

      if (attribute is DirectiveAttribute) {
        directiveAttributes.add(attribute);
      }

      if (attribute is TokenRefAttribute) {
        tokenRefAttributes.add(attribute);
      }

      if (attribute is SharedAttributes) {
        sharedAttributes ??= const SharedAttributes();
        sharedAttributes = sharedAttributes.merge(attribute);
      }

      if (attribute is TextAttributes) {
        textAttributes ??= const TextAttributes();
        textAttributes = textAttributes.merge(attribute);
      }

      if (attribute is BoxAttributes) {
        boxAttributes ??= const BoxAttributes();
        boxAttributes = boxAttributes.merge(attribute);
      }

      if (attribute is IconAttributes) {
        iconAttributes ??= const IconAttributes();
        iconAttributes = iconAttributes.merge(attribute);
      }

      if (attribute is FlexAttributes) {
        flexAttributes ??= const FlexAttributes();
        flexAttributes = flexAttributes.merge(attribute);
      }
    }

    return Mix._(
      boxAttribute: boxAttributes,
      textAttribute: textAttributes,
      dynamicAttributes: dynamicAttributes,
      sharedAttribute: sharedAttributes,
      directiveAttributes: directiveAttributes,
      iconAttribute: iconAttributes,
      flexAttribute: flexAttributes,
      tokenAttributes: tokenRefAttributes,
    );
  }

  List<T> get attributes {
    final attributes = <Attribute>[];

    if (boxAttribute != null) attributes.add(boxAttribute!);
    if (textAttribute != null) attributes.add(textAttribute!);
    if (iconAttribute != null) attributes.add(iconAttribute!);
    if (sharedAttribute != null) attributes.add(sharedAttribute!);
    if (flexAttribute != null) attributes.add(flexAttribute!);
    if (directiveAttributes.isNotEmpty) attributes.addAll(directiveAttributes);
    if (dynamicAttributes.isNotEmpty) attributes.addAll(dynamicAttributes);
    if (tokenAttributes.isNotEmpty) attributes.addAll(tokenAttributes);

    return attributes.whereType<T>().toList();
  }

  Mix<T> getVariant(Symbol variant) {
    final variantsTypes = attributes.whereType<VariantAttribute<T>>();

    final variants =
        variantsTypes.where((element) => element.variant == variant);

    final newAttributes = variants.expand((e) => e.attributes).toList();

    return addAll(newAttributes);
  }

  Mix copyWith({
    BoxAttributes? box,
    TextAttributes? text,
    SharedAttributes? shared,
    IconAttributes? icon,
    FlexAttributes? flex,
    List<DynamicAttribute> dynamicProps = const [],
    List<DirectiveAttribute> directives = const [],
    List<TokenRefAttribute> tokens = const [],
  }) {
    return Mix._(
      dynamicAttributes: dynamicProps..addAll(dynamicProps),
      directiveAttributes: directives..addAll(directives),
      tokenAttributes: tokens..addAll(tokens),
      boxAttribute: box?.merge(box) ?? box,
      textAttribute: text?.merge(text) ?? text,
      sharedAttribute: shared?.merge(shared) ?? shared,
      iconAttribute: icon?.merge(icon) ?? icon,
      flexAttribute: flex?.merge(flex) ?? flex,
    );
  }

  Mix merge(Mix other) {
    return copyWith(
      box: other.boxAttribute,
      text: other.textAttribute,
      icon: other.iconAttribute,
      shared: other.sharedAttribute,
      dynamicProps: other.dynamicAttributes,
      tokens: other.tokenAttributes,
      directives: other.directiveAttributes,
      flex: other.flexAttribute,
    );
  }

  /// Merges many mixes into one
  static Mix<T> combineAll<T extends Attribute>(List<Mix<T>> mixes) {
    final attributes = mixes.expand((element) => element.attributes).toList();
    return Mix.fromList(attributes);
  }

  /// Merges many mixes into one
  static Mix<T> combine<T extends Attribute>([
    Mix<T>? mix1,
    Mix<T>? mix2,
    Mix<T>? mix3,
    Mix<T>? mix4,
    Mix<T>? mix5,
    Mix<T>? mix6,
  ]) {
    final list = <T>[];
    if (mix1 != null) list.addAll(mix1.attributes);
    if (mix2 != null) list.addAll(mix2.attributes);
    if (mix3 != null) list.addAll(mix3.attributes);
    if (mix4 != null) list.addAll(mix4.attributes);
    if (mix5 != null) list.addAll(mix5.attributes);
    if (mix6 != null) list.addAll(mix6.attributes);

    return Mix.fromList(list);
  }

  /// Chooses mix based on condition
  static Mix chooser<T extends Attribute>({
    required bool condition,
    required Mix<T> trueMix,
    required Mix<T> falseMix,
  }) {
    if (condition) {
      return trueMix;
    } else {
      return falseMix;
    }
  }

  Mixer build(BuildContext context) {
    return Mixer.build(context, this);
  }

  /// Used for const constructor widgets
  static const Mix constant = Mix._();
}

extension MixExtension<T extends Attribute> on Mix<T> {
  /// Adds more properties to a mix
  PositionalParamFn<T, Mix<T>> get add {
    return WrapFunction(addAll).withPositionalToList;
  }

  Mix<T> addAll(List<T> attributes) {
    return Mix.fromList([...this.attributes, ...attributes]);
  }

  Mix mix(Mix mix) {
    return Mix.combineAll([this, mix]);
  }

  Mix maybeMix(Mix? mix) {
    if (mix == null) return this;
    return Mix.combineAll([this, mix]);
  }

  Box box({
    required Widget child,
    Mix? mix,
  }) {
    final mx = Mix.combine(this, mix);
    return Box(mix: mx, child: child);
  }

  HBox row({
    Mix? mix,
    required List<Widget> children,
  }) {
    final mx = Mix.combine(this, mix);
    return HBox(mx, children: children);
  }

  TextMix text(
    String text, {
    Mix? mix,
    Key? key,
  }) {
    final mx = Mix.combine(this, mix);
    return TextMix(mx, text: text, key: key);
  }

  VBox column({
    Mix? mix,
    required List<Widget> children,
  }) {
    final mx = Mix.combine(this, mix);
    return VBox(mx, children: children);
  }

  IconMix icon(
    IconData icon, {
    Mix? mix,
    String? semanticLabel,
  }) {
    final mx = Mix.combine(this, mix);
    return IconMix(
      mx,
      icon: icon,
      semanticLabel: semanticLabel,
    );
  }
}
