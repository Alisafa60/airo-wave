List<Map<String, dynamic>> getRecommendations(Map<String, dynamic>? enviromentalData) {
  final List<Map<String, dynamic>> recommendations = [];

  if (enviromentalData != null &&
      enviromentalData.containsKey('environmentalData') &&
      enviromentalData['environmentalData'].containsKey('allergen_data') &&
      enviromentalData['environmentalData']['allergen_data'].containsKey('dailyInfo')) {
    final List<dynamic> dailyInfo = enviromentalData['environmentalData']['allergen_data']['dailyInfo'];

    for (final entry in dailyInfo) {
      final List<dynamic> plantInfo = entry['plantInfo'];

      for (final plant in plantInfo) {
        final bool inSeason = plant['inSeason'] ?? false;
        final num? rawValue = plant['indexInfo']?['value'];
        final int value = rawValue?.toInt() ?? 0;
        final String category = plant['indexInfo']?['category'] ?? '';

        if (inSeason && value > 0) {
          final String displayName = plant['displayName'] ?? '';
          final String color = getCategoryColor(category);

          recommendations.add({
            'displayName': displayName,
            'color': color,
          });
        }
      }
    }
  } else {
    print('No daily info');
  }

  return recommendations;
}

String getCategoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'very low':
    case 'low':
      return 'blue';
    case 'moderate':
    case 'high':
    case 'very high':
      return 'red';
    default:
      return 'black';
  }
}


