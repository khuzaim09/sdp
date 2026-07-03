// App constants & plan limits

const PLAN_CONFIG = {
  free_trial: {
    name: 'Free Trial',
    duration_days: 7,
    price: 0,
    ai_calls_per_day: 10,
    features: ['10 AI calls/day', 'Basic chatbot', 'Limited posts']
  },
  basic: {
    name: 'Basic',
    duration_days: 30,
    price: 350,
    ai_calls_per_day: 50,
    features: ['50 AI calls/day', 'Full chatbot', 'Post scheduling']
  },
  business: {
    name: 'Business',
    duration_days: 150,
    price: 2800,
    ai_calls_per_day: 200,
    features: ['200 AI calls/day', 'All features', 'Analytics', 'Website builder']
  },
  pro: {
    name: 'Pro',
    duration_days: 120,
    price: 1000,
    ai_calls_per_day: -1, // Unlimited
    features: ['Unlimited AI', 'Priority support', 'All current & future features']
  }
};

const SUPPORTED_PLATFORMS = ['instagram', 'facebook', 'twitter', 'linkedin'];

const LOGO_COLOR_THEMES = {
  professional: { primary: '#2C3E50', secondary: '#3498DB', text: '#FFFFFF' },
  vibrant:      { primary: '#E74C3C', secondary: '#F39C12', text: '#FFFFFF' },
  nature:       { primary: '#27AE60', secondary: '#2ECC71', text: '#FFFFFF' },
  luxury:       { primary: '#2C2C2C', secondary: '#F1C40F', text: '#F1C40F' },
  tech:         { primary: '#1A1A2E', secondary: '#16213E', text: '#0F3460' },
  pink:         { primary: '#E91E8C', secondary: '#FF6B6B', text: '#FFFFFF' },
  ocean:        { primary: '#006994', secondary: '#00B4D8', text: '#FFFFFF' },
  purple:       { primary: '#6C3483', secondary: '#A569BD', text: '#FFFFFF' }
};

module.exports = { PLAN_CONFIG, SUPPORTED_PLATFORMS, LOGO_COLOR_THEMES };
