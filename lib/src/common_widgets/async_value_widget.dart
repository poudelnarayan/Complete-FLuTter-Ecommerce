import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget(
      {super.key,
      required this.value,
      required this.dataBuilder,
      this.shimmerWidget});
  final AsyncValue<T> value;
  final Widget Function(T) dataBuilder;
  final Widget? shimmerWidget;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: dataBuilder,
      loading: () => shimmerWidget != null
          ? Padding(
              padding: const EdgeInsets.all(20),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                enabled: true,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      shimmerWidget!,
                      // Add more widgets here if needed
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
      error: (error, _) => Center(
        child: ErrorMessageWidget(
          error.toString(),
        ),
      ),
    );
  }
}

/// Sliver equivalent of [AsyncValueWidget]
class AsyncValueSliverWidget<T> extends StatelessWidget {
  const AsyncValueSliverWidget(
      {super.key, required this.value, required this.dataBuilder});
  final AsyncValue<T> value;
  final Widget Function(T) dataBuilder;

  @override
  Widget build(BuildContext context) {
    return value.when(
      data: dataBuilder,
      loading: () => const SliverToBoxAdapter(
          child: Center(child: CircularProgressIndicator())),
      error: (e, st) => SliverToBoxAdapter(
        child: Center(child: ErrorMessageWidget(e.toString())),
      ),
    );
  }
}
