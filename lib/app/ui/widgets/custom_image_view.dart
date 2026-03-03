// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class ImageSize {
//   const ImageSize({
//     this.alignment,
//     this.dimension,
//     this.height,
//     this.width,
//     this.shouldClip = false,
//   });

//   final Alignment? alignment;
//   final double? dimension;
//   final double? height;
//   final double? width;
//   final bool shouldClip;

//   Widget? _makeWidgetCompatible(Widget? child) {
//     var temp = child;
//     if (alignment != null) {
//       temp = Align(alignment: alignment!, child: child);
//     }

//     if (dimension != null) {
//       return SizedBox.square(dimension: dimension, child: temp);
//     } else if (height != null || width != null) {
//       return SizedBox(height: height, width: width, child: temp);
//     }

//     return temp;
//   }
// }

// typedef LoaderBuilder = Widget Function(double progress);

// class ImageView extends StatelessWidget {
//   const ImageView(
//     this.imagePath, {
//     super.key,
//     this.color,
//     this.errorWidget,
//     this.decoration,
//     this.alignment,
//     this.fit = BoxFit.cover,
//     this.inner,
//     this.outer,
//     this.loaderBuilder,
//   });

//   final AlignmentGeometry? alignment;

//   final BoxFit fit;

//   final String? imagePath;

//   final ImageSize? inner;
//   final ImageSize? outer;

//   final Widget? errorWidget;

//   final Color? color;

//   final Decoration? decoration;

//   final LoaderBuilder? loaderBuilder;

//   @override
//   Widget build(BuildContext context) {
//     final type = imagePath?.imageType;
//     var widget = type == null
//         ? null
//         : switch (type) {
//             ImageType.svg => _SvgIcon(imagePath!, color: color, fit: fit),
//             ImageType.asset => ImageAsset(
//               imagePath!,
//               color: color,
//               fit: fit,
//               errorWidget: errorWidget,
//               loaderBuilder: loaderBuilder,
//             ),
//             ImageType.network => ImageNetwork(
//               imagePath!,
//               color: color,
//               fit: fit,
//               errorWidget: errorWidget,
//               loaderBuilder: loaderBuilder,
//             ),
//             ImageType.file => ImageFile(
//               imagePath!,
//               color: color,
//               fit: fit,
//               errorWidget: errorWidget,
//             ),
//           };

//     widget = inner?._makeWidgetCompatible(widget) ?? widget;

//     if (inner?.shouldClip ?? false) {
//       widget = _checkBoundaries(widget, decoration);
//     }
//     widget = outer?._makeWidgetCompatible(widget) ?? widget;

//     if (outer?.shouldClip ?? false) {
//       widget = _checkBoundaries(widget, decoration);
//     }

//     widget = _checkBoundaries(widget, decoration);

//     if (decoration == null) {
//       return widget ?? const SizedBox();
//     }

//     return DecoratedBox(decoration: decoration!, child: widget);
//   }

//   Widget? _checkBoundaries(Widget? widget, Decoration? decoration) {
//     switch (decoration) {
//       case final BoxDecoration _:
//         if (decoration.shape == BoxShape.circle) {
//           return ClipOval(child: widget);
//         } else if (decoration.borderRadius != null) {
//           return ClipRRect(borderRadius: decoration.borderRadius!, child: widget);
//         }
//       case final ShapeDecoration _:
//         return ClipPath(
//           clipper: ShapeBorderClipper(shape: decoration.shape),
//           child: widget,
//         );

//       default:
//     }

//     return widget;
//   }
// }

// class ImageFile extends Image {
//   ImageFile(String assetName, {super.key, super.color, super.fit, Widget? errorWidget})
//     : super(
//         image: FileImage(File(assetName)),
//         loadingBuilder: (context, child, loadingProgress) {
//           if (loadingProgress == null) {
//             return child;
//           }

//           double? progress;

//           if (loadingProgress.expectedTotalBytes != null) {
//             progress = loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!;
//             return AppProgressIndicator(value: progress);
//           }

//           return const AppProgressIndicator();
//         },
//         errorBuilder: (context, error, stackTrace) {
//           return errorWidget ?? const Icon(Icons.error);
//         },
//       );
// }

// class ImageNetwork extends CachedNetworkImage {
//   ImageNetwork(
//     String imageUrl, {
//     super.key,
//     super.color,
//     super.fit,
//     Widget? errorWidget,
//     LoaderBuilder? loaderBuilder,
//   }) : super(
//          imageUrl: imageUrl,
//          progressIndicatorBuilder: (context, url, progress) {
//            return loaderBuilder?.call(
//                  (progress.downloaded / (progress.totalSize ?? 0)).clamp(0, 1),
//                ) ??
//                const Center(child: AppProgressIndicator());
//          },

//          errorWidget: (context, url, error) => errorWidget ?? const Icon(Icons.error),
//        );
// }

// class AppProgressIndicator extends CircularProgressIndicator {
//   const AppProgressIndicator({
//     super.key,
//     super.value,
//     super.strokeCap = StrokeCap.round,
//     super.strokeWidth = 2,
//     super.color,
//   });
// }

// class ImageAsset extends Image {
//   ImageAsset(
//     String assetName, {
//     super.key,
//     super.color,
//     super.fit,
//     Widget? errorWidget,
//     LoaderBuilder? loaderBuilder,
//   }) : super(
//          image: AssetImage(assetName),
//          loadingBuilder: (context, child, loadingProgress) {
//            if (loadingProgress == null) {
//              return child;
//            }

//            double? progress;

//            if (loadingProgress.expectedTotalBytes != null) {
//              progress = loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!;
//              return loaderBuilder?.call(progress) ?? AppProgressIndicator(value: progress);
//            }

//            return const AppProgressIndicator();
//          },
//          errorBuilder: (context, error, stackTrace) {
//            return errorWidget ?? const Icon(Icons.error);
//          },
//        );
// }

// class _SvgIcon extends SvgPicture {
//   _SvgIcon(
//     String assetName, {
//     AssetBundle? bundle,
//     String? package,
//     SvgTheme? theme,
//     Color? color,
//     super.fit,
//   }) : super(
//          SvgAssetLoader(assetName, packageName: package, assetBundle: bundle, theme: theme),
//          colorFilter: color == null ? null : ColorFilter.mode(color, BlendMode.srcIn),
//        );
// }

// extension ImageTypeExtension on String {
//   ImageType get imageType {
//     if (startsWith('http')) {
//       return ImageType.network;
//     }
//     if (endsWith('.svg')) {
//       return ImageType.svg;
//     }
//     if (startsWith('asset')) {
//       return ImageType.asset;
//     }
//     return ImageType.file;
//   }
// }

// enum ImageType { svg, asset, network, file }
