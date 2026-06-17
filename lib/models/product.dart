enum ProductBonusType { streakProtector, xpBoost, gemMultiplier, luckBoost }

class ProductBonus {
  final ProductBonusType type;
  final int quantity;
  final String label;

  const ProductBonus({
    required this.type,
    required this.quantity,
    required this.label,
  });
}

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final int gems;
  final List<ProductBonus> bonuses;
  final String? badge;
  final double? discount;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.gems,
    this.bonuses = const [],
    this.badge,
    this.discount,
  });

  double get pricePerGem => price / gems;

  bool get isBundle => bonuses.isNotEmpty;

  bool get hasStreakProtector =>
      bonuses.any((b) => b.type == ProductBonusType.streakProtector);
}

const allProducts = [
  Product(
    id: 'gems_50',
    title: '50 Gemas',
    description: 'Gemas para potenciar tu aprendizaje',
    price: 5.00,
    gems: 50,
  ),
  Product(
    id: 'gems_100',
    title: '100 Gemas',
    description: 'Gemas para potenciar tu aprendizaje',
    price: 9.00,
    gems: 100,
    discount: 0.10,
    badge: 'Oferta',
  ),
  Product(
    id: 'gems_200',
    title: '200 Gemas',
    description: 'Gemas para potenciar tu aprendizaje',
    price: 16.00,
    gems: 200,
    discount: 0.20,
    badge: 'Popular',
  ),
  Product(
    id: 'gems_500',
    title: '500 Gemas',
    description: 'Gemas para potenciar tu aprendizaje',
    price: 35.00,
    gems: 500,
    discount: 0.30,
    badge: 'Mejor oferta',
  ),
  Product(
    id: 'gems_1000',
    title: '1000 Gemas',
    description: 'Gemas para potenciar tu aprendizaje',
    price: 60.00,
    gems: 1000,
    discount: 0.40,
    badge: 'Ultra',
  ),
  Product(
    id: 'bundle_protector',
    title: 'Pack Protegido',
    description: '100 gemas + 1 protector de racha',
    price: 12.00,
    gems: 100,
    bonuses: [
      ProductBonus(
        type: ProductBonusType.streakProtector,
        quantity: 1,
        label: '1 Protector de racha',
      ),
    ],
    discount: 0.20,
    badge: 'Protector',
  ),
  Product(
    id: 'bundle_xp',
    title: 'Pack Impulso',
    description: '200 gemas + 1 Boost de XP',
    price: 20.00,
    gems: 200,
    bonuses: [
      ProductBonus(
        type: ProductBonusType.xpBoost,
        quantity: 1,
        label: '1 Boost de XP (2x en tu próxima lección)',
      ),
    ],
    badge: 'Impulso',
  ),
  Product(
    id: 'bundle_multiplier',
    title: 'Pack Fortuna',
    description: '300 gemas + 1 Multiplicador de Gemas',
    price: 28.00,
    gems: 300,
    bonuses: [
      ProductBonus(
        type: ProductBonusType.gemMultiplier,
        quantity: 1,
        label: '1 Multiplicador de Gemas (2x en cofres)',
      ),
    ],
    badge: 'Fortuna',
  ),
  Product(
    id: 'bundle_luck',
    title: 'Pack Suerte',
    description: '250 gemas + 1 Boost de Suerte',
    price: 24.00,
    gems: 250,
    bonuses: [
      ProductBonus(
        type: ProductBonusType.luckBoost,
        quantity: 1,
        label: '1 Boost de Suerte (2x en cofres legendarios)',
      ),
    ],
    badge: 'Suerte',
  ),
];
