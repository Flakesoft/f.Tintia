import 'package:flutter/material.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('loading'),
      children: [
        Icon(
          Icons.hourglass_top,
          size: 72,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),

        const SizedBox(
          height: 20,
        ),

        Text(
          'Loading image...',
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),
      ],
    );
  }
}
