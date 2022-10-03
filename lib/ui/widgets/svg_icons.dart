import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const String _kakaoIcon = 'assets/icons/kakaoIcon.svg';
const String _appleWhiteIcon = 'assets/icons/appleWhiteIcon.svg';
const String _appleBlackIcon = 'assets/icons/appleBlackIcon.svg';
const String _googleIcon = 'assets/icons/googleIcon.svg';
const String _homeIcon = "assets/icons/homeIcon.svg";
const String _locationIcon = "assets/icons/locationIcon.svg";
const String _pointIcon = "assets/icons/pointIcon.svg";
const String _profileIcon = "assets/icons/profileIcon.svg";
const String _coloredHomeIcon = "assets/icons/coloredHomeIcon.svg";
const String _coloredLocationIcon = "assets/icons/coloredLocationIcon.svg";
const String _coloredPointIcon = "assets/icons/coloredPointIcon.svg";
const String _coloredProfileIcon = "assets/icons/coloredProfileIcon.svg";
const String _filterIcon = "assets/icons/filterIcon.svg";
const String _commentIcon = "assets/icons/commentIcon.svg";
const String _numberedListIcon = "assets/icons/numberedListIcon.svg";
const String _mediaIcon = "assets/icons/mediaIcon.svg";
const String _excalamationIcon = "assets/icons/exclamationIcon.svg";
const String _calendarIcon = "assets/icons/calendarIcon.svg";
const String _searchCharacter = "assets/characters/searchCharacter.svg";
const String _failCharacter = "assets/characters/failCharacter.svg";

class KakaoIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const KakaoIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _kakaoIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class AppleWhiteIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const AppleWhiteIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _appleWhiteIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class AppleBlackIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const AppleBlackIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _appleBlackIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class GoogleIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const GoogleIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _googleIcon,
      width: width,
      height: height,
      color: color,
    );
  }
}

class HomeIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final bool colored;
  const HomeIcon({
    Key? key,
    this.width,
    this.height,
    this.colored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      colored ? _coloredHomeIcon : _homeIcon,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class LocationIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final bool colored;
  const LocationIcon({
    Key? key,
    this.width,
    this.height,
    this.colored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      colored ? _coloredLocationIcon : _locationIcon,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class PointIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final bool colored;
  const PointIcon({
    Key? key,
    this.width,
    this.height,
    this.colored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      colored ? _coloredPointIcon : _pointIcon,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class ProfileIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final bool colored;
  const ProfileIcon({
    Key? key,
    this.width,
    this.height,
    this.colored = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      colored ? _coloredProfileIcon : _profileIcon,
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}

class FilterIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const FilterIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _filterIcon,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class CommentIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const CommentIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _commentIcon,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class NumberedListIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const NumberedListIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _numberedListIcon,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class MediaIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const MediaIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _mediaIcon,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class ExclamationIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const ExclamationIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _excalamationIcon,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class CalendarIcon extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const CalendarIcon({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _calendarIcon,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class SearchCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const SearchCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _searchCharacter,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}

class FailCharacter extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  const FailCharacter({
    Key? key,
    this.width,
    this.height,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _failCharacter,
      width: width,
      height: height,
      color: color,
      fit: BoxFit.contain,
    );
  }
}
