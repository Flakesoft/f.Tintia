import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('empty'),
      children: [
        Icon(
          Icons.colorize,
          size: 96,
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),

        const SizedBox(
          height: 16,
        ),

        Text(
          'Select an image to begin',
          style: Theme.of(context)
              .textTheme
              .titleMedium,
        ),

        const SizedBox(
          height: 4,
        ),

        Text(
          'Choose an image and tap anywhere to inspect its colors.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
