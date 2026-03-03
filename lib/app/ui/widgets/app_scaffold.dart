import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/ui/widgets/build_any.dart';
import 'package:real_time_chat/app/ui/widgets/common_back_button.dart';
import 'package:real_time_chat/app/utils/theme/app_system_ui_overlay_style.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.showAppBar = true,
    this.appBarColor,
    this.title,
    this.titleWidget,
    this.showBackBtn = true,
    this.action,
    this.onTapBackBtn,
    this.showDivider = false,
    this.paddingTop,
    this.backgroundColor,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  final WidgetBuilder body;
  final String? title;
  final Widget? titleWidget;
  final Color? appBarColor;
  final bool showBackBtn;
  final Function? onTapBackBtn;
  final Widget? action;
  final bool showAppBar;
  final bool showDivider;
  final double? paddingTop;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    final style = ShadTheme.of(context).textTheme;
    return DarkSystemUiOverlayStyle(
      child: Scaffold(
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
        body: Column(
          children: [
            if (showAppBar)
              Container(
                height: 70 + MediaQuery.of(context).padding.top,
                width: .infinity,
                color: appBarColor ?? Colors.transparent,
                child: Stack(
                  children: [
                    Align(
                      alignment: .bottomCenter,
                      child: Padding(
                        padding: const .symmetric(horizontal: 20),
                        child:
                            titleWidget ??
                            Row(
                              spacing: 10,
                              mainAxisAlignment: title == null ? .spaceBetween : .center,
                              children: [
                                if (showBackBtn) CommonBackButton(onTapBackBtn: () => (onTapBackBtn ?? Get.back)()) else const SizedBox(height: 45, width: 45),
                                if (title != null)
                                  Expanded(
                                    child: Text(title!, style: style.h3, textAlign: .center),
                                  ),
                                SizedBox(height: 45, width: 45, child: action),
                              ],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            if (showDivider)
              Align(
                alignment: .bottomCenter,
                child: Divider(height: 1, color: ShadTheme.of(context).colorScheme.border),
              ),

            Expanded(
              child: BuilderAny(
                builder: (context, data) {
                  final of = MediaQuery.of(context);
                  return MediaQuery(
                    data: of.copyWith(padding: of.padding.copyWith(top: paddingTop ?? 0)),
                    child: body(context),
                  );
                },
                child: Builder(builder: body),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
