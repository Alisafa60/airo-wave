class AllergenInfo {
  final String displayName;
  final int value;
  final String category;

  AllergenInfo(this.displayName, this.value, this.category);
}

String getRecommendation(List<dynamic> allergiesData) {
  List<AllergenInfo> selectedAllergens = [];

  for (var entry in allergiesData) {
    for (var allergen in entry['plantInfo']) {
      String displayName = allergen['displayName'];
      int value = allergen['indexInfo']['value'];

      if (value != null && value > 0) {
        String category = allergen['indexInfo']['category'];
        selectedAllergens.add(AllergenInfo(displayName, value, category));
      }
    }
  }

  selectedAllergens.sort((a, b) => b.value.compareTo(a.value));
  if (selectedAllergens.isNotEmpty) {
    String recommendation = selectedAllergens.first.displayName;
    String color = getColor(selectedAllergens.first.category);
    return '$recommendation - $color';
  } else {
    return 'No significant allergens found';
  }
}

