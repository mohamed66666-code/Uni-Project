import '../models/meal.dart';

class RestaurantService {
  List<Meal> getAvailableMeals() {
    return [
      Meal(
        id: '1',
        title: 'وجبة غداء (دجاج + أرز)',
        description: 'صدر دجاج مشوي مع أرز بسمتي وسلطة',
        price: 45.0,
      ),
      Meal(
        id: '2',
        title: 'وجبة لحم',
        description: 'قطع لحم بالبطاطس مع أرز وخبز',
        price: 60.0,
      ),
    ];
  }
}
