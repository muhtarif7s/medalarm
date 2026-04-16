import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'custom_card.dart';

class LoadingShimmer extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const LoadingShimmer({
    super.key,
    this.width = double.infinity,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Shimmer.fromColors(
      baseColor: theme.colorScheme.surfaceContainerHighest,
      highlightColor: theme.colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LoadingShimmer(width: 120, height: 20),
          SizedBox(height: 8),
          LoadingShimmer(width: 80, height: 16),
          SizedBox(height: 16),
          LoadingShimmer(width: double.infinity, height: 40),
        ],
      ),
    );
  }
}

class LoadingTimeline extends StatelessWidget {
  const LoadingTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => const Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              LoadingShimmer(width: 60, height: 16),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LoadingShimmer(width: 150, height: 18),
                    SizedBox(height: 4),
                    LoadingShimmer(width: 100, height: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
