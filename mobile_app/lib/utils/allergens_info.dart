List<Map<String, dynamic>> getPlantType(Map<String, dynamic>? enviromentalData) {
  final List<Map<String, dynamic>> plantType = [];

  if (enviromentalData != null &&
      enviromentalData.containsKey('environmentalData') &&
      enviromentalData['environmentalData'].containsKey('allergen_data') &&
      enviromentalData['environmentalData']['allergen_data'].containsKey('dailyInfo')) {
    final List<dynamic> dailyInfo = enviromentalData['environmentalData']['allergen_data']['dailyInfo'];

    for (final entry in dailyInfo) {
      final List<dynamic> plantInfo = entry['plantInfo'];

      for (final plant in plantInfo) {
      final num? rawValue = plant['indexInfo']?['value'];
      final int value = rawValue?.toInt() ?? 0;
      final String category = plant['indexInfo']?['category'] ?? '';

      if (value > 0) {
        final String displayName = plant['displayName'] ?? '';
        final String color = getCategoryColor(category);

    plantType.add({
      'displayName': displayName,
      'color': color,
    });
  }
}
    }
  } 
  return plantType;
}

List<Map<String, dynamic>> getPollenType(Map<String, dynamic>? enviromentalData) {
  final List<Map<String, dynamic>> plantType = [];

  if (enviromentalData != null &&
      enviromentalData.containsKey('environmentalData') &&
      enviromentalData['environmentalData'].containsKey('allergen_data') &&
      enviromentalData['environmentalData']['allergen_data'].containsKey('dailyInfo')) {
    final List<dynamic> dailyInfo = enviromentalData['environmentalData']['allergen_data']['dailyInfo'];

    for (final entry in dailyInfo) {
      final List<dynamic> pollenType = entry['pollenTypeInfo'];

      for (final plant in pollenType) {
      final num? rawValue = plant['indexInfo']?['value'];
      final int value = rawValue?.toInt() ?? 0;
      final String category = plant['indexInfo']?['category'] ?? '';

      if (value > 0) {
        final String displayName = plant['displayName'] ?? '';
        final String color = getCategoryColor(category);

    plantType.add({
      'displayName': displayName,
      'color': color,
    });
  }
}
    }
  } 
  return plantType;
}

String getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'very low':
    case 'low':
      return 'blue';
    case 'moderate':
      return 'orange';
    case 'high':
    case 'very high':
      return 'red';
    default:
      return 'black';
  }
}


