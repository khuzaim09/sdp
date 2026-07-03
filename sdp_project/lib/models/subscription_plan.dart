class SubscriptionPlan {
  final String id;
  final String name;
  final String nameKey;
  final double price;
  final String duration;
  final String durationKey;
  final String description;
  final String descriptionKey;
  final List<String> features;
  final bool isPopular;
  final bool isBestValue;
  final String iconName;
  final int daysLimit;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.nameKey,
    required this.price,
    required this.duration,
    required this.durationKey,
    required this.description,
    required this.descriptionKey,
    required this.features,
    required this.daysLimit,
    this.isPopular = false,
    this.isBestValue = false,
    this.iconName = 'star',
  });

  String get priceDisplay {
    if (price == 0) return 'FREE';
    return '\$${price.toStringAsFixed(price.truncateToDouble() == price ? 0 : 2)}';
  }

  /// Pre-built subscription plans
  static List<SubscriptionPlan> get allPlans => [
    SubscriptionPlan(
      id: 'free_trial',
      name: 'Free Trial',
      nameKey: 'free_trial',
      price: 0,
      duration: '7 Days',
      durationKey: '7_days',
      description: 'Try all features free for 7 days. No credit card required.',
      descriptionKey: 'free_trial_desc',
      iconName: 'rocket',
      daysLimit: 7,
      features: [
        'Basic AI Chat',
        'Limited Logo Generation',
        'Community Support',
        '1 Social Media Account',
      ],
    ),
    SubscriptionPlan(
      id: 'basic',
      name: 'Basic Plan',
      nameKey: 'basic_plan',
      price: 3.5,
      duration: '1 Month',
      durationKey: '1_month',
      description: 'Essential tools to kickstart your digital marketing journey.',
      descriptionKey: 'basic_plan_desc',
      iconName: 'flash',
      daysLimit: 30,
      features: [
        'Advanced AI Chat',
        'Full Branding Suite',
        'Email Support',
        '3 Social Media Accounts',
        'Basic Analytics',
      ],
    ),
    SubscriptionPlan(
      id: 'pro',
      name: 'Pro Plan',
      nameKey: 'pro_plan',
      price: 10,
      duration: '4 Months',
      durationKey: '4_months',
      description: 'Unlimited access to everything, forever. One-time investment.',
      descriptionKey: 'pro_plan_desc',
      iconName: 'crown',
      isBestValue: true,
      daysLimit: 120,
      features: [
        'Everything in Business',
        'Custom API Access',
        'Dedicated Manager',
        'White-label Solutions',
        'Priority AI Processing',
        'Custom Integrations',
        'Lifetime Updates',
      ],
    ),
    SubscriptionPlan(
      id: 'business',
      name: 'Business Plan',
      nameKey: 'business_plan',
      price: 28,
      duration: '5 Months',
      durationKey: '5_months',
      description: 'Advanced features for growing businesses with full analytics.',
      descriptionKey: 'business_plan_desc',
      iconName: 'business',
      isPopular: true,
      daysLimit: 150,
      features: [
        'Social Media Manager',
        'Website Builder',
        'Priority Support',
        'Unlimited Accounts',
        'Full Analytics Dashboard',
        'SEO Tools',
      ],
    ),
  ];
}
