import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/color_picker_service.dart';

class ColorInfoCard extends StatefulWidget {
  final Color color;

  const ColorInfoCard({
    super.key,
    required this.color,
  });

  @override
  State<ColorInfoCard> createState() =>
      _ColorInfoCardState();
}

class _ColorInfoCardState extends State<ColorInfoCard> {
  final PageController _pageController =
      PageController();

  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _copyText(
    BuildContext context,
    String text,
    String label,
  ) async {
    await Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('$label copied'),
        duration:
            const Duration(seconds: 2),
      ),
    );
  }


  Widget _buildFormatPage(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme =
        Theme.of(context);

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,

      children: [
        Text(
          label,

          style:
              theme.textTheme.labelLarge,
        ),

        const SizedBox(height: 12),

        InkWell(
          borderRadius:
              BorderRadius.circular(16),

          onTap: () => _copyText(
            context,
            value,
            label,
          ),

          child: Card(
            elevation: 0,

            color:
                theme.colorScheme
                    .surfaceContainerHighest,

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),

              child: Row(
                mainAxisSize:
                    MainAxisSize.min,

                children: [
                  Text(
                    value,

                    style:
                        theme.textTheme
                            .titleMedium,
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Icon(
                    Icons.copy,
                    size: 18,
                    color:
                        theme.colorScheme
                            .onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final scheme =
        Theme.of(context).colorScheme;


    final hex =
        ColorPickerService.getHex(
          widget.color,
        );

    final rgb =
        ColorPickerService.getRgb(
          widget.color,
        );

    final hsv =
        ColorPickerService.getHsv(
          widget.color,
        );

    final hsl =
        ColorPickerService.getHsl(
          widget.color,
        );


    final pages = [
      _buildFormatPage(
        context,
        label: 'HEX',
        value: hex,
      ),

      _buildFormatPage(
        context,
        label: 'RGB',
        value: rgb,
      ),

      _buildFormatPage(
        context,
        label: 'HSV',
        value: hsv,
      ),

      _buildFormatPage(
        context,
        label: 'HSL',
        value: hsl,
      ),
    ];


    return Column(
      children: [

        Container(
          width: 120,
          height: 120,

          decoration: BoxDecoration(
            color:
                widget.color,

            borderRadius:
                BorderRadius.circular(28),

            border: Border.all(
              color:
                  scheme.outlineVariant,
              width: 1,
            ),

            boxShadow: [
              BoxShadow(
                blurRadius: 12,
                color:
                    Colors.black
                        .withValues(
                          alpha: 0.12,
                        ),
              ),
            ],
          ),
        ),


        const SizedBox(
          height: 20,
        ),


        SizedBox(
          height: 110,

          child: PageView.builder(
            controller:
                _pageController,

            itemCount:
                pages.length,

            onPageChanged:
                (index) {
              setState(() {
                _currentPage =
                    index;
              });
            },

            itemBuilder:
                (context, index) {
              return pages[index];
            },
          ),
        ),


        const SizedBox(
          height: 8,
        ),


        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,

          children:
              List.generate(
            pages.length,
            (index) {
              return AnimatedContainer(
                duration:
                    const Duration(
                  milliseconds: 200,
                ),

                margin:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 4,
                ),

                width:
                    _currentPage == index
                        ? 20
                        : 8,

                height:
                    8,

                decoration:
                    BoxDecoration(
                  color:
                      _currentPage ==
                              index
                          ? scheme.primary
                          : scheme
                              .outlineVariant,

                  borderRadius:
                      BorderRadius
                          .circular(
                    8,
                  ),
                ),
              );
            },
          ),
        ),


        const SizedBox(
          height: 12,
        ),


        Text(
          'Swipe to view formats • Tap value to copy',

          style:
              Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(
                    color:
                        scheme
                            .onSurfaceVariant,
                  ),
        ),
      ],
    );
  }
}