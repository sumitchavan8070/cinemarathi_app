import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:school_management/utils/constants/app_box_decoration.dart';
import 'package:school_management/utils/constants/app_colors.dart';

class CachedImageNetworkContainer extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final EdgeInsets? containerPadding;
  final Widget placeHolder;
  final Decoration? decoration;
  final BoxFit fit;
  final Color? color;
  final double? borderRadius;

  const CachedImageNetworkContainer({
    super.key,
    required this.url,
    this.height = 54,
    this.width = 54,
    this.containerPadding,
    required this.placeHolder,
    this.decoration,
    this.fit = BoxFit.fill,
    this.color,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      padding: containerPadding,
      height: height,
      width: width,
      decoration:
          decoration ??
          AppBoxDecoration.getBoxDecoration(
            showShadow: false,
            color: color ?? AppColors.white,
            borderRadius: borderRadius ?? 8,
          ),
      child: url != null || url?.isNotEmpty == true
          ? CachedNetworkImage(
              imageUrl: url!,
              fit: fit,
              placeholder: (context, url) {
                return placeHolder;
              },
              errorWidget: (context, url, error) {
                return placeHolder;
              },
            )
          : placeHolder,

      // child: (url != null && url!.isNotEmpty)
      //     ? CachedNetworkImage(
      //   imageUrl: url!,
      //   fit: fit,
      //   placeholder: (context, url) => placeHolder,
      //   errorWidget: (context, url, error) => placeHolder,
      // )
      //     : placeHolder,
    );
  }
}

Widget buildPlaceholder({
  required String? name,
  required BuildContext context,
  Color color = AppColors.primaryColor,
}) {
  final initial = name?.isNotEmpty == true ? name![0] : '';
  return Center(
    child: Text(initial, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: color)),
  );
}

Widget buildPlaceholderAsset({required String assetPath, BoxFit fit = BoxFit.fill}) {
  return Image.asset(fit: fit, assetPath);
}

Widget buildPlaceholderSVG({required String assetPath}) {
  return SvgPicture.asset(fit: BoxFit.fill, assetPath);
}

Widget buildPlaceholderIcon({required IconData icon}) {
  return Center(child: Icon(icon, size: 30));
}
