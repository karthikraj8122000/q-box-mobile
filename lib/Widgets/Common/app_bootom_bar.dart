import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_page/Widgets/Common/app_colors.dart';
import 'dart:math' as math;

import 'package:badges/badges.dart' as b;
import 'package:qr_page/Widgets/Common/app_text.dart';

const double _kActiveFontSize = 14.0;
const double _kBottomMargin = 8.0;

enum AppBottomBarFabLocation { end, center }

class AppBottomBar extends StatefulWidget {
  AppBottomBar({
    Key? key,

    required this.items,
    this.onTap,
    this.currentIndex = 0,
    required this.opacity,
    this.iconSize = 24.0,
    this.borderRadius,
    this.elevation,
    this.backgroundColor,
    this.hasNotch = false,
    this.hasInk = false,
    this.inkColor,
    this.colorTween,
    this.fabLocation,
    this.tilesPadding = EdgeInsets.zero,
  })  : assert(items.length >= 2),
        assert(
        items.every((AppBottomBarItem item) => item.title.isNotEmpty) == true,
        'Every item must have a non-null title',
        ),
        assert(0 <= currentIndex! && currentIndex < items.length),
        assert(iconSize != null),
        super(key: key);

  final List<AppBottomBarItem> items;
  final ValueChanged<int?>? onTap;
  final int? currentIndex;
  final double? iconSize;
  final double opacity;
  final BorderRadius? borderRadius;
  final double? elevation;
  final Color? backgroundColor;
  final bool hasNotch;
  final bool hasInk;
  final AppBottomBarFabLocation? fabLocation;
  final Color? inkColor;
  final ColorTween? colorTween;
  final EdgeInsets tilesPadding;

  @override
  BottomNavigationBarState createState() => BottomNavigationBarState();
}

class _BottomNavigationTile extends StatelessWidget {
  const _BottomNavigationTile(
      this.item,
      this.opacity,
      this.animation,
      this.iconSize, {
        this.onTap,
        this.colorTween,
        this.flex,
        this.selected = false,
        this.indexLabel,
        this.ink = false,
        this.inkColor,
        this.padding,
      });

  final AppBottomBarItem item;
  final Animation<double> animation;
  final double iconSize;
  final VoidCallback? onTap;
  final ColorTween? colorTween;
  final double? flex;
  final bool selected;
  final String? indexLabel;
  final double opacity;
  final bool ink;
  final Color? inkColor;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = item.backgroundColor ?? AppColors.mintGreen;

    int size;
    Widget label;

    // size = (flex! * 1000.0).round();
    label = _Label(
      animation: animation,
      item: item,
      color: backgroundColor,
    );

    return IntrinsicHeight(
      child: Semantics(
        container: true,
        header: true,
        selected: selected,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: padding!,
              child: InkResponse(
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(50),
                  left: Radius.circular(50),
                ),
                containedInkWell: true,
                onTap: onTap,
                // splashColor: ink ? inkColor ?? Theme.of(context).splashColor : Colors.transparent,
                // highlightColor: Colors.transparent,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.mintGreen.withOpacity(0.2) : Colors.transparent,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(50),
                      left: Radius.circular(50),
                    ),
                    boxShadow: [], // This removes any shadow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      _TileIcon(
                        colorTween: colorTween ?? ColorTween(),
                        animation: animation,
                        iconSize: iconSize,
                        selected: selected,
                        item: item,
                      ),
                      AnimatedCrossFade(
                        alignment: const Alignment(0, 0),
                        firstChild: label,
                        secondChild: Container(),
                        duration: const Duration(milliseconds: 200),
                        sizeCurve: Curves.fastOutSlowIn,
                        firstCurve: Curves.fastOutSlowIn,
                        secondCurve: Curves.fastOutSlowIn.flipped,
                        crossFadeState: selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Semantics(
              label: indexLabel,
            )
          ],
        ),
      ),
    );
  }
}

class _TileIcon extends StatelessWidget {
  const _TileIcon({
    Key? key,
    required this.colorTween,
    required this.animation,
    required this.iconSize,
    required this.selected,
    required this.item,
  }) : super(key: key);

  final ColorTween colorTween;
  final Animation<double> animation;
  final double iconSize;
  final bool selected;
  final AppBottomBarItem item;

  @override
  Widget build(BuildContext context) {

    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1.0,
      child: b.Badge(
        showBadge: item.showBadge,
        badgeContent: item.badge,
        // badgeColor: item.badgeColor,
        // animationType: b.BadgeAnimationType.fade,
        child: IconTheme(
          data: IconThemeData(
            color: selected ? AppColors.mintGreen : AppColors.black,
            size: iconSize,
          ),
          child: selected ? item.activeIcon! : item.icon,
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({
    Key? key,
    required this.animation,
    required this.item,
    required this.color,
  }) : super(key: key);

  final Animation<double> animation;
  final AppBottomBarItem item;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Use the title directly as a string
    return AppText(
      text: item.title,
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: AppColors.mintGreen,
    );
  }
}

class BottomNavigationBarState extends State<AppBottomBar> with TickerProviderStateMixin {
  late List<AnimationController> _controllers = <AnimationController>[];
  late List<CurvedAnimation> _animations;
  Color? _backgroundColor;
  ValueListenable<ScaffoldGeometry>? geometryListenable;
  bool fabExists = false;
  AppBottomBar? holder;
  Animatable<double>? _flexTween;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    geometryListenable = Scaffold.geometryOf(context);
    _flexTween = widget.hasNotch ? Tween<double>(begin: 1.15, end: 2.0) : Tween<double>(begin: 1.15, end: 1.75);
  }

  void _resetState() {
    for (AnimationController controller in _controllers) {
      controller.dispose();
    }

    _controllers = List<AnimationController>.generate(widget.items.length, (int index) {
      return AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      )..addListener(_rebuild);
    });
    _animations = List<CurvedAnimation>.generate(widget.items.length, (int index) {
      return CurvedAnimation(
        parent: _controllers[index],
        curve: Curves.fastOutSlowIn,
        reverseCurve: Curves.fastOutSlowIn.flipped,
      );
    });
    _controllers[widget.currentIndex!].value = 1.0;
    _backgroundColor = widget.items[widget.currentIndex!].backgroundColor;
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    for (AnimationController controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  double _evaluateFlex(Animation<double> animation) => _flexTween!.evaluate(animation);

  @override
  void didUpdateWidget(AppBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items.length != oldWidget.items.length) {
      _resetState();
      return;
    }

    if (widget.currentIndex != oldWidget.currentIndex) {
      _controllers[oldWidget.currentIndex!].reverse();
      _controllers[widget.currentIndex!].forward();

      if (widget.fabLocation == AppBottomBarFabLocation.center) {
        AppBottomBarItem currentItem = widget.items[oldWidget.currentIndex!];
        AppBottomBarItem nextItem = widget.items[widget.currentIndex!];

        widget.items[0] = nextItem;
        widget.items[widget.currentIndex!] = currentItem;
        _controllers[oldWidget.currentIndex!].reverse();
        _controllers[widget.currentIndex!].forward();
        // widget.currentIndex = 0;
        _resetState();
      }
    } else {
      if (_backgroundColor != widget.items[widget.currentIndex!].backgroundColor) {
        _backgroundColor = widget.items[widget.currentIndex!].backgroundColor;
      }
    }
  }

  List<Widget> _createTiles() {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < widget.items.length; i += 1) {
      children.add(
        _BottomNavigationTile(
          widget.items[i],
          widget.opacity,
          _animations[i],
          widget.iconSize!,
          colorTween: widget.colorTween,
          onTap: () {
            if (widget.onTap != null) widget.onTap!(i);
          },
          flex: _evaluateFlex(_animations[i]),
          selected: i == widget.currentIndex,
          indexLabel: localizations.tabLabel(tabIndex: i + 1, tabCount: widget.items.length),
          ink: widget.hasInk,
          inkColor: widget.inkColor,
          padding: widget.tilesPadding,
        ),
      );
    }
    if (widget.fabLocation == AppBottomBarFabLocation.center) {
      children.insert(1, const Spacer(flex: 1500));
    }
    return children;
  }

  Widget _createContainer(List<Widget> tiles) {
    return DefaultTextStyle.merge(
      overflow: TextOverflow.ellipsis,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: tiles,
      ),
    );
  }

  Widget _inner(double additionalBottomPadding) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: kBottomNavigationBarHeight + additionalBottomPadding),
        child: Material(
          type: MaterialType.transparency,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: additionalBottomPadding, right: widget.fabLocation == AppBottomBarFabLocation.end ? 72 : 0),
            child: MediaQuery.removePadding(
              context: context,
              removeBottom: true,
              child: _createContainer(_createTiles()),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasDirectionality(context));
    assert(debugCheckHasMaterialLocalizations(context));
    final double additionalBottomPadding = math.max(MediaQuery.of(context).padding.bottom - _kBottomMargin, 0.0);
    return Semantics(
        explicitChildNodes: true,
        child: widget.hasNotch
            ? PhysicalShape(
          elevation: widget.elevation ?? 0.0,
          color: widget.backgroundColor ?? AppColors.white,
          clipper: _BubbleBottomBarClipper(
            shape: const CircularNotchedRectangle(),
            geometry: geometryListenable!,
            notchMargin: 8,
          ),
          child: _inner(additionalBottomPadding),
        )
            : Material(
          elevation: widget.elevation ?? 8.0,
          color: widget.backgroundColor ?? AppColors.white,
          borderRadius: BorderRadius.zero,
          child: _inner(additionalBottomPadding),
        ));
  }
}

class AppBottomBarItem {
  const AppBottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.title, // Make title required
    this.showBadge = false,
    this.badgeColor = AppColors.black,
    this.badge,
    this.backgroundColor,
    this.iconColor,
    this.titleColor,
  });

  final Icon icon;
  final Widget? activeIcon;
  final String title; // Change to String instead of Widget?
  final bool showBadge;
  final Color badgeColor;
  final Widget? badge;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? titleColor;
}

class _BubbleBottomBarClipper extends CustomClipper<Path> {
  const _BubbleBottomBarClipper({
    required this.geometry,
    required this.shape,
    required this.notchMargin,
  }) : super(reclip: geometry);

  final ValueListenable<ScaffoldGeometry> geometry;
  final NotchedShape shape;
  final double notchMargin;

  @override
  Path getClip(Size size) {
    final Rect? button = geometry.value.floatingActionButtonArea?.translate(
      0.0,
      geometry.value.bottomNavigationBarTop! * -1.0,
    );

    return shape.getOuterPath(Offset.zero & size, button?.inflate(notchMargin));
  }

  @override
  bool shouldReclip(_BubbleBottomBarClipper oldClipper) {
    return oldClipper.geometry != geometry || oldClipper.shape != shape || oldClipper.notchMargin != notchMargin;
  }
}
