/// Multi-language support for English and Urdu
/// Urdu text is RTL (Right-to-Left)

enum AppLanguage { english, urdu }

class AppStrings {
  static Map<String, Map<AppLanguage, String>> get strings => {
    // General
    'app_name': {
      AppLanguage.english: 'Brandora',
      AppLanguage.urdu: 'برینڈورا',
    },
    'ai_marketing': {
      AppLanguage.english: 'AI Powered Digital Marketing',
      AppLanguage.urdu: 'اے آئی ڈیجیٹل مارکیٹنگ',
    },
    'hello': {
      AppLanguage.english: 'Hello',
      AppLanguage.urdu: 'ہیلو',
    },

    // Login Screen
    'welcome_back': {
      AppLanguage.english: 'Welcome Back',
      AppLanguage.urdu: 'خوش آمدید',
    },
    'sign_in_subtitle': {
      AppLanguage.english: 'Sign in to continue your marketing journey',
      AppLanguage.urdu: 'اپنے مارکیٹنگ سفر کو جاری رکھنے کے لیے لاگ ان کریں',
    },
    'email_or_username': {
      AppLanguage.english: 'Email or Username',
      AppLanguage.urdu: 'ای میل یا صارف نام',
    },
    'password': {
      AppLanguage.english: 'Password',
      AppLanguage.urdu: 'پاس ورڈ',
    },
    'forgot_password': {
      AppLanguage.english: 'Forgot Password?',
      AppLanguage.urdu: 'پاس ورڈ بھول گئے؟',
    },
    'sign_in': {
      AppLanguage.english: 'Sign In',
      AppLanguage.urdu: 'لاگ ان',
    },
    'no_account': {
      AppLanguage.english: "Don't have an account?",
      AppLanguage.urdu: 'اکاؤنٹ نہیں ہے؟',
    },
    'sign_up': {
      AppLanguage.english: 'Sign Up',
      AppLanguage.urdu: 'اکاؤنٹ بنائیں',
    },
    'invalid_credentials': {
      AppLanguage.english: 'Invalid credentials. Please try again.',
      AppLanguage.urdu: 'غلط معلومات۔ دوبارہ کوشش کریں۔',
    },

    // Signup Screen
    'create_account': {
      AppLanguage.english: 'Create Account',
      AppLanguage.urdu: 'اکاؤنٹ بنائیں',
    },
    'signup_subtitle': {
      AppLanguage.english: 'Join the future of digital marketing',
      AppLanguage.urdu: 'ڈیجیٹل مارکیٹنگ کے مستقبل میں شامل ہوں',
    },
    'full_name': {
      AppLanguage.english: 'Full Name',
      AppLanguage.urdu: 'پورا نام',
    },
    'email_address': {
      AppLanguage.english: 'Email Address',
      AppLanguage.urdu: 'ای میل ایڈریس',
    },
    'confirm_password': {
      AppLanguage.english: 'Confirm Password',
      AppLanguage.urdu: 'پاس ورڈ کی تصدیق',
    },
    'continue_btn': {
      AppLanguage.english: 'Continue',
      AppLanguage.urdu: 'جاری رکھیں',
    },
    'already_have_account': {
      AppLanguage.english: 'Already have an account?',
      AppLanguage.urdu: 'پہلے سے اکاؤنٹ ہے؟',
    },

    // Validation Messages
    'fill_all_fields': {
      AppLanguage.english: 'Please fill in all fields.',
      AppLanguage.urdu: 'براہ کرم تمام فیلڈز پُر کریں۔',
    },
    'invalid_email': {
      AppLanguage.english: 'Please enter a valid email address.',
      AppLanguage.urdu: 'براہ کرم درست ای میل درج کریں۔',
    },
    'password_too_short': {
      AppLanguage.english: 'Password must be at least 8 characters.',
      AppLanguage.urdu: 'پاس ورڈ کم از کم 8 حروف کا ہونا چاہیے۔',
    },
    'password_needs_uppercase': {
      AppLanguage.english: 'Password must contain at least one uppercase letter.',
      AppLanguage.urdu: 'پاس ورڈ میں کم از کم ایک بڑا حرف ہونا چاہیے۔',
    },
    'password_needs_number': {
      AppLanguage.english: 'Password must contain at least one number.',
      AppLanguage.urdu: 'پاس ورڈ میں کم از کم ایک نمبر ہونا چاہیے۔',
    },
    'passwords_dont_match': {
      AppLanguage.english: 'Passwords do not match!',
      AppLanguage.urdu: 'پاس ورڈ مماثل نہیں ہیں!',
    },
    'email_already_exists': {
      AppLanguage.english: 'This email is already registered.',
      AppLanguage.urdu: 'یہ ای میل پہلے سے رجسٹرڈ ہے۔',
    },
    'name_required': {
      AppLanguage.english: 'Name is required.',
      AppLanguage.urdu: 'نام ضروری ہے۔',
    },

    // Forgot Password
    'reset_password': {
      AppLanguage.english: 'Reset Password',
      AppLanguage.urdu: 'پاس ورڈ ری سیٹ کریں',
    },
    'reset_subtitle': {
      AppLanguage.english: 'Enter your email to receive a password reset link.',
      AppLanguage.urdu: 'پاس ورڈ ری سیٹ لنک حاصل کرنے کے لیے اپنا ای میل درج کریں۔',
    },
    'send_reset_link': {
      AppLanguage.english: 'Send Reset Link',
      AppLanguage.urdu: 'ری سیٹ لنک بھیجیں',
    },
    'reset_link_sent': {
      AppLanguage.english: 'Reset link sent to your email!',
      AppLanguage.urdu: 'ری سیٹ لنک آپ کی ای میل پر بھیج دیا گیا!',
    },

    // Subscription Plans
    'choose_plan': {
      AppLanguage.english: 'Choose Your Plan',
      AppLanguage.urdu: 'اپنا پلان منتخب کریں',
    },
    'subscription_plans': {
      AppLanguage.english: 'Subscription Plans',
      AppLanguage.urdu: 'سبسکرپشن پلانز',
    },
    'choose_plan_subtitle': {
      AppLanguage.english: 'Select the plan that fits your business needs',
      AppLanguage.urdu: 'اپنے کاروبار کی ضروریات کے مطابق پلان منتخب کریں',
    },
    'select_plan': {
      AppLanguage.english: 'Select Plan',
      AppLanguage.urdu: 'پلان منتخب کریں',
    },
    'selected': {
      AppLanguage.english: 'Selected ✓',
      AppLanguage.urdu: 'منتخب ✓',
    },
    'most_popular': {
      AppLanguage.english: 'MOST POPULAR',
      AppLanguage.urdu: 'سب سے مقبول',
    },
    'best_value': {
      AppLanguage.english: 'BEST VALUE',
      AppLanguage.urdu: 'بہترین قیمت',
    },
    'get_started': {
      AppLanguage.english: 'Get Started',
      AppLanguage.urdu: 'شروع کریں',
    },
    'please_select_plan': {
      AppLanguage.english: 'Please select a plan to continue.',
      AppLanguage.urdu: 'جاری رکھنے کے لیے پلان منتخب کریں۔',
    },

    // Plan Names
    'free_trial': {
      AppLanguage.english: 'Free Trial',
      AppLanguage.urdu: 'مفت ٹرائل',
    },
    'basic_plan': {
      AppLanguage.english: 'Basic Plan',
      AppLanguage.urdu: 'بنیادی پلان',
    },
    'business_plan': {
      AppLanguage.english: 'Business Plan',
      AppLanguage.urdu: 'بزنس پلان',
    },
    'pro_plan': {
      AppLanguage.english: 'Pro Plan',
      AppLanguage.urdu: 'پرو پلان',
    },

    // Plan Durations
    '7_days': {
      AppLanguage.english: '7 Days',
      AppLanguage.urdu: '7 دن',
    },
    '30_days': {
      AppLanguage.english: '30 Days',
      AppLanguage.urdu: '30 دن',
    },
    'yearly': {
      AppLanguage.english: 'Yearly',
      AppLanguage.urdu: 'سالانہ',
    },
    'lifetime': {
      AppLanguage.english: 'Lifetime',
      AppLanguage.urdu: 'ہمیشہ',
    },

    // Plan Descriptions
    'free_trial_desc': {
      AppLanguage.english: 'Try all features free for 7 days. No credit card required.',
      AppLanguage.urdu: '7 دن کے لیے تمام فیچرز مفت آزمائیں۔ کریڈٹ کارڈ کی ضرورت نہیں۔',
    },
    'basic_plan_desc': {
      AppLanguage.english: 'Essential tools to kickstart your digital marketing journey.',
      AppLanguage.urdu: 'اپنی ڈیجیٹل مارکیٹنگ کا آغاز کرنے کے لیے ضروری ٹولز۔',
    },
    'business_plan_desc': {
      AppLanguage.english: 'Advanced features for growing businesses with full analytics.',
      AppLanguage.urdu: 'بڑھتے ہوئے کاروبار کے لیے مکمل تجزیات کے ساتھ جدید فیچرز۔',
    },
    'pro_plan_desc': {
      AppLanguage.english: 'Unlimited access to everything, forever. One-time investment.',
      AppLanguage.urdu: 'ہمیشہ کے لیے سب کچھ تک لامحدود رسائی۔ ایک بار کی سرمایہ کاری۔',
    },

    // Language
    'language': {
      AppLanguage.english: 'Language',
      AppLanguage.urdu: 'زبان',
    },
    'english': {
      AppLanguage.english: 'English',
      AppLanguage.urdu: 'انگریزی',
    },
    'urdu': {
      AppLanguage.english: 'اردو',
      AppLanguage.urdu: 'اردو',
    },

    // Business Details
    'about_business': {
      AppLanguage.english: 'About Your Business',
      AppLanguage.urdu: 'آپ کے کاروبار کے بارے میں',
    },
    'business_subtitle': {
      AppLanguage.english: 'Tell us a bit about your brand so Brandora can tailor its AI suggestions.',
      AppLanguage.urdu: 'اپنے برانڈ کے بارے میں بتائیں تاکہ برینڈورا اپنی تجاویز تیار کر سکے۔',
    },
    'business_name': {
      AppLanguage.english: 'Business Name',
      AppLanguage.urdu: 'کاروبار کا نام',
    },
    'industry': {
      AppLanguage.english: 'Industry (e.g., Coffee Shop, Tech)',
      AppLanguage.urdu: 'صنعت (مثلاً کافی شاپ، ٹیک)',
    },
    'target_audience': {
      AppLanguage.english: 'Target Audience (e.g., Students, Pros)',
      AppLanguage.urdu: 'ہدف سامعین (مثلاً طلباء، پیشہ ور)',
    },
    'next': {
      AppLanguage.english: 'Next',
      AppLanguage.urdu: 'اگلا',
    },
    'step_1_of_2': {
      AppLanguage.english: 'Step 1 of 2',
      AppLanguage.urdu: 'مرحلہ 1 از 2',
    },
    'step_2_of_2': {
      AppLanguage.english: 'Step 2 of 2',
      AppLanguage.urdu: 'مرحلہ 2 از 2',
    },

    // Marketing Goals
    'your_goals': {
      AppLanguage.english: 'Your Goals',
      AppLanguage.urdu: 'آپ کے اہداف',
    },
    'goals_subtitle': {
      AppLanguage.english: 'What do you want to achieve with Brandora?',
      AppLanguage.urdu: 'آپ برینڈورا سے کیا حاصل کرنا چاہتے ہیں؟',
    },
    'increase_sales': {
      AppLanguage.english: 'Increase Sales',
      AppLanguage.urdu: 'فروخت بڑھائیں',
    },
    'brand_awareness': {
      AppLanguage.english: 'Brand Awareness',
      AppLanguage.urdu: 'برانڈ آگاہی',
    },
    'grow_social': {
      AppLanguage.english: 'Grow Social Media',
      AppLanguage.urdu: 'سوشل میڈیا بڑھائیں',
    },
    'generate_leads': {
      AppLanguage.english: 'Generate Leads',
      AppLanguage.urdu: 'لیڈز حاصل کریں',
    },
    'improve_seo': {
      AppLanguage.english: 'Improve SEO',
      AppLanguage.urdu: 'SEO بہتر بنائیں',
    },
    'create_content': {
      AppLanguage.english: 'Create Content',
      AppLanguage.urdu: 'مواد تخلیق کریں',
    },
    'see_plans': {
      AppLanguage.english: 'See Subscription Plans',
      AppLanguage.urdu: 'سبسکرپشن پلانز دیکھیں',
    },

    // Session
    'session_expired': {
      AppLanguage.english: 'Your session has expired. Please log in again.',
      AppLanguage.urdu: 'آپ کا سیشن ختم ہو گیا۔ دوبارہ لاگ ان کریں۔',
    },
    'another_device': {
      AppLanguage.english: 'You have been logged out because your account was accessed from another device.',
      AppLanguage.urdu: 'آپ لاگ آؤٹ ہو گئے کیونکہ آپ کا اکاؤنٹ دوسرے آلے سے استعمال ہوا۔',
    },
    'log_out': {
      AppLanguage.english: 'Log Out',
      AppLanguage.urdu: 'لاگ آؤٹ',
    },
    'account_created': {
      AppLanguage.english: 'Account created successfully!',
      AppLanguage.urdu: 'اکاؤنٹ کامیابی سے بن گیا!',
    },
    'analytics': {
      AppLanguage.english: 'Analytics',
      AppLanguage.urdu: 'تجزیات',
    },
    'marketing_planner': {
      AppLanguage.english: 'Marketing Planner',
      AppLanguage.urdu: 'مارکیٹنگ پلانر',
    },
    'social_automation': {
      AppLanguage.english: 'Social Automation',
      AppLanguage.urdu: 'سوشل میڈیا آٹومیشن',
    },
    'website_builder': {
      AppLanguage.english: 'Website Builder',
      AppLanguage.urdu: 'ویب سائٹ بلڈر',
    },
    'chat_history': {
      AppLanguage.english: 'Chat History',
      AppLanguage.urdu: 'چیٹ کی تاریخ',
    },
    'settings': {
      AppLanguage.english: 'Settings',
      AppLanguage.urdu: 'ترتیبات',
    },
    'ai_assistant': {
      AppLanguage.english: 'AI Assistant',
      AppLanguage.urdu: 'اے آئی اسسٹنٹ',
    },
    'dashboard': {
      AppLanguage.english: 'Dashboard',
      AppLanguage.urdu: 'ڈیش بورڈ',
    },
    'total_views': {
      AppLanguage.english: 'Total Views',
      AppLanguage.urdu: 'کل ویوز',
    },
    'engagement_rate': {
      AppLanguage.english: 'Engagement Rate',
      AppLanguage.urdu: 'انگیجمنٹ ریٹ',
    },
    'followers_growth': {
      AppLanguage.english: 'Followers Growth',
      AppLanguage.urdu: 'فالوورز کی گروتھ',
    },
    'generate_plan': {
      AppLanguage.english: 'Generate 30-Day Plan',
      AppLanguage.urdu: '30 دن کا منصوبہ بنائیں',
    },
    'post_generator': {
      AppLanguage.english: 'AI Post Generator',
      AppLanguage.urdu: 'اے آئی پوسٹ جنریٹر',
    },
    'hashtag_generator': {
      AppLanguage.english: 'Hashtag Generator',
      AppLanguage.urdu: 'ہیش ٹیگ جنریٹر',
    },
    'scheduler': {
      AppLanguage.english: 'Post Scheduler',
      AppLanguage.urdu: 'پوسٹ شیڈولر',
    },
    'publish_website': {
      AppLanguage.english: 'Generate Website Link',
      AppLanguage.urdu: 'ویب سائٹ لنک بنائیں',
    },
    'voice_input': {
      AppLanguage.english: 'Voice Input',
      AppLanguage.urdu: 'وائس ان پٹ',
    },
    'voice_output': {
      AppLanguage.english: 'Voice Output',
      AppLanguage.urdu: 'وائس آؤٹ پٹ',
    },
    'remaining_days': {
      AppLanguage.english: 'Remaining Days',
      AppLanguage.urdu: 'باقی دن',
    },
    'upgrade_plan': {
      AppLanguage.english: 'Upgrade Plan',
      AppLanguage.urdu: 'منصوبہ اپ گریڈ کریں',
    },
    'branding_tools': {
      AppLanguage.english: 'Branding Tools',
      AppLanguage.urdu: 'برینڈنگ ٹولز',
    },
    'ai_brand_generator': {
      AppLanguage.english: 'AI Brand Generator',
      AppLanguage.urdu: 'اے آئی برینڈ جنریٹر',
    },
    'brand_gen_subtitle': {
      AppLanguage.english: 'Describe your business to get names, taglines, and logos.',
      AppLanguage.urdu: 'نام، ٹیگ لائنز اور لوگو حاصل کرنے کے لیے اپنے کاروبار کی وضاحت کریں۔',
    },
    'generate_brand_id': {
      AppLanguage.english: 'Generate Brand Identity',
      AppLanguage.urdu: 'برانڈ کی شناخت بنائیں',
    },
    'generated_logos': {
      AppLanguage.english: 'Generated Logos',
      AppLanguage.urdu: 'بنائے گئے لوگو',
    },
    'color_palettes': {
      AppLanguage.english: 'Color Palettes',
      AppLanguage.urdu: 'رنگوں کی پیلیٹ',
    },
    'social_manager': {
      AppLanguage.english: 'Social Media Manager',
      AppLanguage.urdu: 'سوشل میڈیا مینیجر',
    },
    'edit_ai_post': {
      AppLanguage.english: 'Edit AI Post',
      AppLanguage.urdu: 'اے آئی پوسٹ ایڈٹ کریں',
    },
    'post_now': {
      AppLanguage.english: 'Post Now',
      AppLanguage.urdu: 'ابھی پوسٹ کریں',
    },
    'scheduled_for': {
      AppLanguage.english: 'Scheduled for',
      AppLanguage.urdu: 'کے لیے شیڈول کیا گیا',
    },
    'try_ai_wizard': {
      AppLanguage.english: 'Try AI Wizard',
      AppLanguage.urdu: 'اے آئی وزرڈ آزمائیں',
    },
    'marketing_campaign_desc': {
      AppLanguage.english: 'Generate a full marketing campaign in seconds!',
      AppLanguage.urdu: 'سیکنڈوں میں مکمل مارکیٹنگ مہم تیار کریں!',
    },
    'marketing_tools': {
      AppLanguage.english: 'Marketing Tools',
      AppLanguage.urdu: 'مارکیٹنگ ٹولز',
    },
    'ai_website_generation': {
      AppLanguage.english: 'AI Website Generation',
      AppLanguage.urdu: 'اے آئی ویب سائٹ جنریشن',
    },
    'ai_generation_description': {
      AppLanguage.english: 'Let our AI generate a complete landing page based on your brand profile in seconds.',
      AppLanguage.urdu: 'اے آئی کو سیکنڈوں میں اپنے برانڈ پروفائل کی بنیاد پر ایک مکمل لینڈنگ پیج بنانے دیں۔',
    },
    'generate_with_ai': {
      AppLanguage.english: 'Generate with AI',
      AppLanguage.urdu: 'اے آئی کے ساتھ بنائیں',
    },
    'select_a_template': {
      AppLanguage.english: 'Select a Template',
      AppLanguage.urdu: 'ٹیمپلیٹ منتخب کریں',
    },
    'modern_coffee_shop': {
      AppLanguage.english: 'Modern Coffee Shop',
      AppLanguage.urdu: 'جدید کافی شاپ',
    },
    'modern_coffee_shop_desc': {
      AppLanguage.english: 'Perfect for cafes and roasteries. Includes menu and booking sections.',
      AppLanguage.urdu: 'کیفے اور روسٹری کے لیے بہترین۔ مینو اور بکنگ سیکشنز شامل ہیں۔',
    },
    'creative_agency': {
      AppLanguage.english: 'Creative Agency',
      AppLanguage.urdu: 'تخلیقی ایجنسی',
    },
    'creative_agency_desc': {
      AppLanguage.english: 'Showcase your portfolio and services with a bold, creative layout.',
      AppLanguage.urdu: 'اپنے پورٹ فولیو اور خدمات کو ایک جرات مندانہ، تخلیقی لے آؤٹ کے ساتھ دکھائیں۔',
    },
    'tech_startup': {
      AppLanguage.english: 'Tech Startup',
      AppLanguage.urdu: 'ٹیک اسٹارٹ اپ',
    },
    'tech_startup_desc': {
      AppLanguage.english: 'Sleek and professional template for SaaS and tech products.',
      AppLanguage.urdu: 'SaaS اور ٹیک پروڈکٹس کے لیے چیکنا اور پیشہ ورانہ ٹیمپلیٹ۔',
    },
    'customize_selected_template': {
      AppLanguage.english: 'Customize Selected Template',
      AppLanguage.urdu: 'منتخب ٹیمپلیٹ کو حسب ضرورت بنائیں',
    },
    'edit_profile': {
      AppLanguage.english: 'Edit Profile',
      AppLanguage.urdu: 'پروفائل تبدیل کریں',
    },
    'notifications': {
      AppLanguage.english: 'Notifications',
      AppLanguage.urdu: 'اطلاعات',
    },
    'security': {
      AppLanguage.english: 'Security',
      AppLanguage.urdu: 'سیکیورٹی',
    },
    'help_support': {
      AppLanguage.english: 'Help & Support',
      AppLanguage.urdu: 'مدد اور تعاون',
    },
  };

  static String get(String key, AppLanguage language) {
    return strings[key]?[language] ?? key;
  }
}
