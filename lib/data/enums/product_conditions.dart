import 'package:easy_localization/easy_localization.dart';

enum ProductConditions { veryGood, good, fair }

extension ProductConditionsExtension on ProductConditions {
  static ProductConditions fromString(String value) {
    switch (value) {
      case "Very Good":
        return ProductConditions.veryGood;
      case "Good":
        return ProductConditions.good;
      case "Fair":
        return ProductConditions.fair;
      case "Vrlo dobro":
        return ProductConditions.veryGood;
      case "Dobro":
        return ProductConditions.good;
      case "Zadovoljavajuće":
        return ProductConditions.fair;
      default:
        return ProductConditions.good;
    }
  }

  String toDbValue() {
    switch (this) {
      case ProductConditions.veryGood:
        return "condition_very_good".tr();
      case ProductConditions.good:
        return "condition_good".tr();
      case ProductConditions.fair:
        return "condition_fair".tr();
    }
  }
}
