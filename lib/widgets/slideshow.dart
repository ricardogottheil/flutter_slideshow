import 'package:flutter/material.dart';
// import 'package:flutter_slideshow/models/slider_model.dart';
import 'package:provider/provider.dart';

class Slideshow extends StatelessWidget {
  final List<Widget> slides;
  final bool dotsUp;
  final Color bulletPrimaryColor;
  final Color bulletSecondaryColor;
  final double bulletPrimarySize;
  final double bulletSecondarySize;

  const Slideshow({
    required this.slides,
    this.dotsUp = false,
    this.bulletPrimaryColor = Colors.blue,
    this.bulletSecondaryColor = Colors.grey,
    this.bulletPrimarySize = 12,
    this.bulletSecondarySize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => new _SlideshowModel(),
        child: SafeArea(
          child: Center(
            child: Builder(
              builder: (BuildContext context) {
                Provider.of<_SlideshowModel>(context).bulletPrimaryColor =
                    this.bulletPrimaryColor;
                Provider.of<_SlideshowModel>(context).bulletSecondaryColor =
                    this.bulletSecondaryColor;
                Provider.of<_SlideshowModel>(context).bulletPrimarySize =
                    this.bulletPrimarySize;
                Provider.of<_SlideshowModel>(context).bulletSecondarySize =
                    this.bulletSecondarySize;

                return _CrearEstructuraSlideshow(
                    dotsUp: dotsUp, slides: slides);
              },
            ),
          ),
        ));
  }
}

class _CrearEstructuraSlideshow extends StatelessWidget {
  const _CrearEstructuraSlideshow({
    Key? key,
    required this.dotsUp,
    required this.slides,
  }) : super(key: key);

  final bool dotsUp;
  final List<Widget> slides;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      if (this.dotsUp) _Dots(this.slides.length),
      Expanded(child: _Slides(this.slides)),
      if (!this.dotsUp) _Dots(this.slides.length),
    ]);
  }
}

class _Dots extends StatelessWidget {
  final int totalSlides;

  const _Dots(
    this.totalSlides,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(this.totalSlides, (index) => _Dot(index)),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final int index;

  const _Dot(
    this.index,
  );

  @override
  Widget build(BuildContext context) {
    final slideshowModel = Provider.of<_SlideshowModel>(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: (slideshowModel.currentPage.round() == this.index) ? slideshowModel.bulletPrimarySize : slideshowModel.bulletSecondarySize,
      height: (slideshowModel.currentPage.round() == this.index) ? slideshowModel.bulletPrimarySize : slideshowModel.bulletSecondarySize,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: (slideshowModel.currentPage.round() == this.index)
            ? slideshowModel.bulletPrimaryColor
            : slideshowModel.bulletSecondaryColor,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _Slides extends StatefulWidget {
  final List<Widget> slides;

  const _Slides(this.slides);

  @override
  __SlidesState createState() => __SlidesState();
}

class __SlidesState extends State<_Slides> {
  final pageViewController = PageController();

  @override
  void initState() {
    super.initState();
    pageViewController.addListener(() {
      Provider.of<_SlideshowModel>(context, listen: false).currentPage =
          pageViewController.page!;
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageViewController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView(
        controller: pageViewController,
        children: widget.slides.map((slide) => _Slide(slide)).toList(),
      ),
    );
  }
}

class _Slide extends StatelessWidget {
  final Widget slide;

  const _Slide(this.slide);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(30),
      child: this.slide,
    );
  }
}

class _SlideshowModel with ChangeNotifier {
  double _currentPage = 0;
  Color _bulletPrimaryColor = Colors.blue;
  Color _bulletSecondaryColor = Colors.grey;
  double _bulletPrimarySize = 12;
  double _bulletSecondarySize = 12;

  double get currentPage => this._currentPage;
  Color get bulletPrimaryColor => this._bulletPrimaryColor;
  Color get bulletSecondaryColor => this._bulletSecondaryColor;
  double get bulletPrimarySize => this._bulletPrimarySize;
  double get bulletSecondarySize => this._bulletSecondarySize;

  set currentPage(double currentPage) {
    this._currentPage = currentPage;
    notifyListeners();
  }

  set bulletPrimaryColor(Color bulletPrimaryColor) {
    this._bulletPrimaryColor = bulletPrimaryColor;
  }

  set bulletSecondaryColor(Color bulletSecondaryColor) {
    this._bulletSecondaryColor = bulletSecondaryColor;
  }

  set bulletPrimarySize(double bulletPrimarySize) {
    this._bulletPrimarySize = bulletPrimarySize;
  }

  set bulletSecondarySize(double bulletSecondarySize) {
    this._bulletSecondarySize = bulletSecondarySize;
  }
}
