import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

class CustomWidget extends StatefulWidget {
  const CustomWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  bool _isHover = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (event) {
        setState(() => _isHover = true);
      },
      onExit: (event) {
        setState(() => _isHover = false);
      },
      child: Material(
        elevation: _isHover ? 2 : 10,
        child: AnimatedContainer(
          curve: Curves.linear,
          duration: const Duration(milliseconds: 100),
          height: 100,
          padding:
              _isHover ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
          margin: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: _isHover ? colorScheme.secondary : colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Custom Widget',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: _isHover
                      ? colorScheme.onSecondary
                      : colorScheme.onPrimary,
                ),
          ),
        ),
      ),
    );
  }
}

class CustomMixWidget extends StatelessWidget {
  const CustomMixWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = StyleMix(
      height(100),
      animation(),
      marginVertical(10),
      elevation(10),
      rounded(10),
      backgroundColor($M3Color.primary),
      textStyle(as: $M3Text.bodyMedium),
      textStyle(color: $M3Color.onPrimary),
      onHover(
        elevation(2),
        padding(20),
        backgroundColor($M3Color.secondary),
        textStyle(color: $M3Color.onSecondary),
      ),
    );

    return StyledContainer(
      style: style,
      child: const StyledText('Custom Widget'),
    );
  }
}
