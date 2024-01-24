List<Map<String, dynamic>> getPlantType(Map<String, dynamic>? enviromentalData) {
  final List<Map<String, dynamic>> plantType = [];

  final List<dynamic>? dailyInfoList =
      enviromentalData?['environmentalData']?['allergen_data']?['dailyInfo'];

  if (dailyInfoList != null) {
    for (final entry in dailyInfoList) {
      final List<dynamic>? plantInfoList = entry?['plantInfo'];

      if (plantInfoList != null) {
        for (final plant in plantInfoList) {
          final Map<String, dynamic>? indexInfo = plant?['indexInfo'];
          final num? rawValue = indexInfo?['value'];
          final int value = rawValue?.toInt() ?? 0;
          final String category = indexInfo?['category'] ?? '';

          if (value > 0) {
            final String displayName = plant?['displayName'] ?? '';
            final String color = getCategoryColor(category);

            plantType.add({
              'displayName': displayName,
              'color': color,
            });
          }
        }
      }
    }
  }

  return plantType;
}

List<Map<String, dynamic>> getPollenType(Map<String, dynamic>? enviromentalData) {
  final List<Map<String, dynamic>> plantType = [];

  final List<dynamic>? dailyInfoList =
      enviromentalData?['environmentalData']?['allergen_data']?['dailyInfo'];

  if (dailyInfoList != null) {
    for (final entry in dailyInfoList) {
      final List<dynamic>? pollenTypeList = entry?['pollenTypeInfo'];

      if (pollenTypeList != null) {
        for (final plant in pollenTypeList) {
          final Map<String, dynamic>? indexInfo = plant?['indexInfo'];
          final num? rawValue = indexInfo?['value'];
          final int value = rawValue?.toInt() ?? 0;
          final String category = indexInfo?['category'] ?? '';

          if (value > 0) {
            final String displayName = plant?['displayName'] ?? '';
            final String color = getCategoryColor(category);

            plantType.add({
              'displayName': displayName,
              'color': color,
            });
          }
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
      return 'secondaryColor';
    case 'moderate':
      return 'primaryColor';
    case 'high':
    case 'very high':
      return 'red';
    default:
      return 'black';
  }
}


