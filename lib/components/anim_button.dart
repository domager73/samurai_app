import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:just_audio/just_audio.dart';
import 'package:samurai_app/data/music_manager.dart';

class AnimButton extends StatefulWidget {
  const AnimButton(
      {this.player,
      this.onDown,
      required this.onTap,
      required this.child,
      this.shadowType = 0,
      this.disabled = false,
      super.key});

  final void Function()? onTap;
  final Widget? child;
  final int shadowType;
  final bool disabled;
  final Function? onDown;
  final AudioPlayer? player;

  @override
  State<AnimButton> createState() => _AnimButtonState();
}

class _AnimButtonState extends State<AnimButton> {
  bool _elevation = false;

  void _onTapDown(TapDownDetails t) {
    if (widget.onDown != null) {
      widget.onDown!;
    }

    setState(() {
      _elevation = true;
    });
  }

  void _onTapUp(TapUpDetails t) {
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        _elevation = false;
      });
    });
  }

  void _onTapCancel() {
    setState(() {
      _elevation = false;
    });
  }

  Future<void> _onTap() async {
    if (widget.player != null) {
      await widget.player!.play().then((value) async {
        await widget.player!.seek(const Duration(seconds: 0));
      });
    } else {
      await GetIt.I<MusicManager>()
          .menuSettingsSignWaterPlayer
          .play()
          .then((value) async {
        await GetIt.I<MusicManager>()
            .menuSettingsSignWaterPlayer
            .seek(const Duration(seconds: 0));
      });
    }

    Future.delayed(const Duration(milliseconds: 20), () {
      if (widget.onTap != null) {
        widget.onTap!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      overlayColor: MaterialStateProperty.all(
        Colors.transparent,
      ),
      onTap: widget.disabled ? null : _onTap,
      onTapDown: widget.disabled ? null : _onTapDown,
      onTapUp: widget.disabled ? null : _onTapUp,
      onTapCancel: widget.disabled ? null : _onTapCancel,
      child: AnimatedContainer(
          duration: Duration(milliseconds: !_elevation ? 1 : 20),
          curve: Curves.easeInOut,
          decoration: BoxDecorationCustom(
            borderRadius: BorderRadius.circular(8),
            shadowType: widget.shadowType,
            boxShadow: [
              BoxShadow(
                color: _elevation
                    ? const Color(0xFF00E3FF).withOpacity(0.5)
                    : Colors.transparent,
                blurRadius: 10.0,
              )
            ],
          ),
          child: widget.child),
    );
  }
}

class BoxDecorationCustom extends BoxDecoration {
  const BoxDecorationCustom({
    super.color,
    super.image,
    super.border,
    super.borderRadius,
    super.boxShadow,
    super.gradient,
    super.backgroundBlendMode,
    super.shape = BoxShape.rectangle,
    required this.shadowType,
  });

  final int shadowType;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    assert(onChanged != null || image == null);
    return _BoxDecorationPainterCustom(this, onChanged, shadowType: shadowType);
  }
}

/// An object that paints a [BoxDecoration] into a canvas.
class _BoxDecorationPainterCustom extends BoxPainter {
  _BoxDecorationPainterCustom(this._decoration, super.onChanged,
      {required this.shadowType})
      : assert(_decoration != null);

  final int shadowType;
  final BoxDecoration _decoration;

  Paint? _cachedBackgroundPaint;
  Rect? _rectForCachedBackgroundPaint;

  Paint _getBackgroundPaint(Rect rect, TextDirection? textDirection) {
    assert(rect != null);
    assert(
        _decoration.gradient != null || _rectForCachedBackgroundPaint == null);

    if (_cachedBackgroundPaint == null ||
        (_decoration.gradient != null &&
            _rectForCachedBackgroundPaint != rect)) {
      final Paint paint = Paint();
      if (_decoration.backgroundBlendMode != null) {
        paint.blendMode = _decoration.backgroundBlendMode!;
      }
      if (_decoration.color != null) {
        paint.color = _decoration.color!;
      }
      if (_decoration.gradient != null) {
        paint.shader = _decoration.gradient!
            .createShader(rect, textDirection: textDirection);
        _rectForCachedBackgroundPaint = rect;
      }
      _cachedBackgroundPaint = paint;
    }

    return _cachedBackgroundPaint!;
  }

  void _paintBox(
      Canvas canvas, Rect rect, Paint paint, TextDirection? textDirection) {
    switch (shadowType) {
      case 1:
        {
          final r = Path();
          final double gap = (rect.bottom - rect.top) / 2.4;
          r.addPolygon([
            Offset(rect.left + gap, rect.top),
            Offset(rect.right, rect.top),
            Offset(rect.right, rect.top),
            Offset(rect.right, rect.bottom - gap),
            Offset(rect.right, rect.bottom - 30),
            Offset(rect.right - gap, rect.bottom),
            Offset(rect.right - gap, rect.bottom),
            Offset(rect.left, rect.bottom),
            Offset(rect.left, rect.top - 30),
            Offset(rect.left, rect.top + gap),
            Offset(rect.left, rect.top + 30),
            Offset(rect.left + gap, rect.top)
          ], true);
          canvas.drawPath(r, paint);
          break;
        }
      case 2:
        {
          final Offset center = rect.center;
          final double radius = rect.shortestSide / 2.0;
          canvas.drawCircle(center, radius, paint);
          break;
        }
      default:
        {
          if (_decoration.borderRadius == null ||
              _decoration.borderRadius == BorderRadius.zero) {
            canvas.drawRect(rect, paint);
          } else {
            canvas.drawRRect(
                _decoration.borderRadius!.resolve(textDirection).toRRect(rect),
                paint);
          }
          break;
        }
    }
  }

  void _paintShadows(Canvas canvas, Rect rect, TextDirection? textDirection) {
    if (_decoration.boxShadow == null) {
      return;
    }
    for (final BoxShadow boxShadow in _decoration.boxShadow!) {
      final Paint paint = boxShadow.toPaint();
      final Rect bounds =
          rect.shift(boxShadow.offset).inflate(boxShadow.spreadRadius);
      _paintBox(canvas, bounds, paint, textDirection);
    }
  }

  void _paintBackgroundColor(
      Canvas canvas, Rect rect, TextDirection? textDirection) {
    if (_decoration.color != null || _decoration.gradient != null) {
      _paintBox(canvas, rect, _getBackgroundPaint(rect, textDirection),
          textDirection);
    }
  }

  DecorationImagePainter? _imagePainter;

  void _paintBackgroundImage(
      Canvas canvas, Rect rect, ImageConfiguration configuration) {
    if (_decoration.image == null) {
      return;
    }
    _imagePainter ??= _decoration.image!.createPainter(onChanged!);
    Path? clipPath;
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        final Rect square = Rect.fromCircle(center: center, radius: radius);
        clipPath = Path()..addOval(square);
        break;
      case BoxShape.rectangle:
        if (_decoration.borderRadius != null) {
          clipPath = Path()
            ..addRRect(_decoration.borderRadius!
                .resolve(configuration.textDirection)
                .toRRect(rect));
        }
        break;
    }
    _imagePainter!.paint(canvas, rect, clipPath, configuration);
  }

  @override
  void dispose() {
    _imagePainter?.dispose();
    super.dispose();
  }

  /// Paint the box decoration into the given location on the given canvas.
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration != null);
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    _paintShadows(canvas, rect, textDirection);
    _paintBackgroundColor(canvas, rect, textDirection);
    _paintBackgroundImage(canvas, rect, configuration);
    _decoration.border?.paint(
      canvas,
      rect,
      shape: _decoration.shape,
      borderRadius: _decoration.borderRadius?.resolve(textDirection),
      textDirection: configuration.textDirection,
    );
  }

  @override
  String toString() {
    return 'BoxPainter for $_decoration';
  }
}

class PresButton extends StatefulWidget {
  const PresButton(
      {this.player,
      required this.onTap,
      required this.child,
      required this.params,
      super.key,
      this.disabled = false});

  final void Function()? onTap;
  final Function child;
  final Map<String, dynamic> params;
  final bool disabled;
  final AudioPlayer? player;

  @override
  State<PresButton> createState() => _PresButtonState();
}

class _PresButtonState extends State<PresButton> {
  bool _elevation = false;

  void _onTapDown(TapDownDetails t) {
    setState(() {
      _elevation = true;
    });
  }

  void _onTapUp(TapUpDetails t) {
    Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        _elevation = false;
      });
    });
  }

  void _onTapCancel() {
    setState(() {
      _elevation = false;
    });
  }

  Future<void> _onTap() async {
    if (widget.player != null) {
      await widget.player!.play().then((value) async {
        await widget.player!.seek(const Duration(seconds: 0));
      });
    } else {
      await GetIt.I<MusicManager>()
          .menuSettingsSignWaterPlayer
          .play()
          .then((value) async {
        await GetIt.I<MusicManager>()
            .menuSettingsSignWaterPlayer
            .seek(const Duration(seconds: 0));
      });
    }

    if (widget.onTap != null) {
      Future.delayed(const Duration(milliseconds: 20), () {
        widget.onTap!();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        overlayColor: MaterialStateProperty.all(
          Colors.transparent,
        ),
        //splashColor: const Color(0xFF9E9E9E).withOpacity(0.5),
        //highlightColor: const Color(0xFF00E3FF).withOpacity(0.5),
        onTap: !widget.disabled ? _onTap : null,
        onTapDown: !widget.disabled ? _onTapDown : null,
        onTapUp: !widget.disabled ? _onTapUp : null,
        onTapCancel: _onTapCancel,
        child: AnimatedContainer(
          duration: Duration(milliseconds: !_elevation ? 1 : 20),
          curve: Curves.easeInOut,
          child:
              widget.child(context, widget.params, _elevation, widget.disabled),
        ));
  }
}

Widget menuBtn(BuildContext context, Map<String, dynamic> params, bool state,
    bool disabled) {
  const img = AssetImage('assets/pages/homepage/menu_icon.png');
  const imgPres = AssetImage('assets/pages/homepage/menu_icon_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Image(
      image: !state ? img : imgPres,
      width: 35 / 390 * params['width'],
    ),
  );
}

Widget loginBtn(BuildContext context, Map<String, dynamic> params, bool state,
    bool disabled,
    {String clan = 'water'}) {
  const img = AssetImage('assets/login_button.png');
  const imgPres = AssetImage('assets/login_button_pres.png');
  const imgDis = AssetImage('assets/login_button_dis.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);
  precacheImage(imgDis, context);

  return Stack(
    children: [
      Image(
        image: disabled
            ? imgDis
            : !state
                ? img
                : imgPres,
        width: params['width'] - params['width'] * 0.0,
        height: (params['width'] - params['width'] * 0.14) * 0.32,
      ),
      SizedBox(
        width: params['width'] - params['width'] * 0.04,
        height: (params['width'] - params['width'] * 0.14) * 0.32,
        child: Center(
          child: Text(
            params['text'],
            style: TextStyle(
              fontFamily: 'AmazObitaemOstrovItalic',
              fontSize: params['height'] * 0.025,
              letterSpacing: 3,
              color: const Color(0xFF0D1238),
              height: 0.98,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget backBtn(BuildContext context, Map<String, dynamic> params, bool state,
    bool disabled) {
  const img = AssetImage('assets/back_button.png');
  const imgPres = AssetImage('assets/back_button_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    height: params['width'] * 0.15,
    width: params['width'] * 0.15,
  );
}

Widget menuCloseBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/menu_pop_icon.png');
  const imgPres = AssetImage('assets/pages/homepage/menu_pop_icon_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    filterQuality: FilterQuality.high,
  );
}

Widget sendToWalletBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/craft/send_bt.png');
  const imgPres = AssetImage('assets/pages/homepage/craft/send_bt_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    filterQuality: FilterQuality.high,
  );
}

Widget waterHeartBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/craft/heart_water.png');
  const imgPres =
      AssetImage('assets/pages/homepage/craft/heart_water_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    fit: BoxFit.fitWidth,
    filterQuality: FilterQuality.high,
  );
}

Widget fireHeartBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/craft/heart_fire.png');
  const imgPres = AssetImage('assets/pages/homepage/craft/heart_fire_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    fit: BoxFit.fitWidth,
    filterQuality: FilterQuality.high,
  );
}

Widget waterChangeBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/craft/change_water.png');
  const imgPres =
      AssetImage('assets/pages/homepage/craft/change_water_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    fit: BoxFit.fitWidth,
    filterQuality: FilterQuality.high,
  );
}

Widget fireChangeBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/craft/change_fire.png');
  const imgPres =
      AssetImage('assets/pages/homepage/craft/change_fire_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    fit: BoxFit.fitWidth,
    filterQuality: FilterQuality.high,
  );
}

Widget menuWalletBtn(BuildContext context, Map<String, dynamic> params,
    bool state, bool disabled) {
  const img = AssetImage('assets/pages/homepage/wallet_icon.png');
  const imgPres = AssetImage('assets/pages/homepage/wallet_icon_pres.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);

  return Image(
    image: !state ? img : imgPres,
    width: 50 / 390 * params['width'],
    filterQuality: FilterQuality.high,
  );
}

Widget mintBtn(BuildContext context, Map<String, dynamic> params, bool state,
    bool disabled) {
  const img = AssetImage('assets/pages/homepage/mint/btn_mint_water.png');
  const imgPres =
      AssetImage('assets/pages/homepage/mint/btn_mint_water_pres.png');
  const imgDis = AssetImage('assets/pages/homepage/mint/btn_mint_fire_dis.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);
  precacheImage(imgDis, context);

  return Image(
    image: disabled ? imgDis : (!state ? img : imgPres),
    width: 50 / 390 * params['width'],
    filterQuality: FilterQuality.high,
  );
}

Widget mintBtn2(BuildContext context, Map<String, dynamic> params, bool state,
    bool disabled) {
  const img = AssetImage('assets/pages/homepage/mint/btn_mint_fire.png');
  const imgPres =
      AssetImage('assets/pages/homepage/mint/btn_mint_water_pres.png');
  const imgDis = AssetImage('assets/pages/homepage/mint/btn_mint_fire_dis.png');
  precacheImage(img, context);
  precacheImage(imgPres, context);
  precacheImage(imgDis, context);

  return Image(
    image: disabled ? imgDis : (!state ? img : imgPres),
    width: 50 / 390 * params['width'],
    filterQuality: FilterQuality.high,
  );
}
