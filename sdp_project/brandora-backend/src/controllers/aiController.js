const BusinessIdea = require('../models/BusinessIdea');
const MarketingPlan = require('../models/MarketingPlan');
const { callAI } = require('../services/aiProviderService');
const { generateHashtags } = require('../utils/hashtagGenerator');

// POST /ai/generate-business
const generateBusiness = async (req, res) => {
  try {
    const { industry, budget, location = 'Pakistan', language = 'en' } = req.body;
    const userId = req.user.user_id;
    const langInstruction = language === 'ur' ? 'Respond entirely in Urdu language.' : 'Respond in English.';

    const result = await callAI([
      { role: 'system', content: `You are a business consultant specializing in Pakistani market. ${langInstruction} Return response as valid JSON only.` },
      { role: 'user', content: `Generate 3 business ideas for industry: ${industry}, budget: PKR ${budget}, location: ${location}.\nReturn JSON: { ideas: [{ title, description, investment_required, potential_revenue, pros, cons, first_steps }] }` },
    ], { maxTokens: 1500, temperature: 0.8, parseJson: true });

    // Save to DB
    await BusinessIdea.create({ userId, industry, budget, location, language, ideas: result.ideas || [] });

    return res.status(200).json({ success: true, message: 'Business ideas generated!', data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-post
const generatePost = async (req, res) => {
  try {
    const { business_name, product, platform, tone = 'engaging', language = 'en' } = req.body;
    const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';

    const result = await callAI([
      { role: 'system', content: `You are a social media marketing expert for Pakistani brands. ${langInstruction} Return JSON only.` },
      { role: 'user', content: `Create a ${platform} post for: ${business_name}, product: ${product}, tone: ${tone}.\nReturn JSON: { caption, hashtags (array of 10), emoji_suggestions, call_to_action, best_posting_time }` },
    ], { maxTokens: 800, temperature: 0.9, parseJson: true });

    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-plan
const generatePlan = async (req, res) => {
  try {
    const { business_name, industry, target_audience, budget, language = 'en' } = req.body;
    const userId = req.user.user_id;
    const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';

    const planData = await callAI([
      { role: 'system', content: `You are a marketing strategist for Pakistani SMBs. ${langInstruction} Return JSON only.` },
      { role: 'user', content: `Create a 3-month marketing plan for: ${business_name}, industry: ${industry}, audience: ${target_audience}, budget: PKR ${budget}.\nReturn JSON: { executive_summary, target_market, marketing_channels, content_strategy, budget_allocation, kpis, monthly_timeline }` },
    ], { maxTokens: 2000, temperature: 0.7, parseJson: true });

    const plan = await MarketingPlan.create({
      userId, businessName: business_name, industry, targetAudience: target_audience || '', budget: budget || '', language, planData, status: 'generated',
    });

    return res.status(200).json({ success: true, message: 'Marketing plan generated and saved!', data: { plan_id: plan._id, ...planData } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-hashtags
const generateHashtagsEndpoint = async (req, res) => {
  try {
    const { keywords, platform = 'instagram', count = 15 } = req.body;
    const hashtags = generateHashtags(keywords, platform, count);
    return res.status(200).json({ success: true, data: { hashtags, count: hashtags.length, platform } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-caption
const generateCaption = async (req, res) => {
  try {
    const { business_name, product, platform, tone = 'engaging', language = 'en' } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are a social media caption expert. Return JSON only.' },
      { role: 'user', content: `Write 3 ${platform} captions for ${business_name} about ${product}. Tone: ${tone}.\nReturn JSON: { captions: [{ text, emojis, cta }] }` },
    ], { maxTokens: 600, parseJson: true });
    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-seo
const generateSeo = async (req, res) => {
  try {
    const { business_name, industry, website_url = '', language = 'en' } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are an SEO expert. Return JSON only.' },
      { role: 'user', content: `Generate SEO recommendations for ${business_name} in ${industry}.\nReturn JSON: { meta_title, meta_description, keywords (array), content_recommendations, technical_tips }` },
    ], { maxTokens: 1000, parseJson: true });
    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-email
const generateEmail = async (req, res) => {
  try {
    const { business_name, purpose, audience = 'customers', language = 'en' } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are an email marketing expert. Return JSON only.' },
      { role: 'user', content: `Write a marketing email for ${business_name}. Purpose: ${purpose}. Audience: ${audience}.\nReturn JSON: { subject_line, preview_text, body_html, cta_text, tips }` },
    ], { maxTokens: 1000, parseJson: true });
    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-blog
const generateBlog = async (req, res) => {
  try {
    const { topic, business_name, industry = '', tone = 'informative', language = 'en' } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are a professional blog writer. Return JSON only.' },
      { role: 'user', content: `Write a blog post about "${topic}" for ${business_name}. Industry: ${industry}. Tone: ${tone}.\nReturn JSON: { title, meta_description, introduction, sections: [{ heading, content }], conclusion, tags }` },
    ], { maxTokens: 2000, parseJson: true });
    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /ai/generate-ad-copy
const generateAdCopy = async (req, res) => {
  try {
    const { business_name, product, platform = 'facebook', budget = '', language = 'en' } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are an advertising copywriter. Return JSON only.' },
      { role: 'user', content: `Create ad copy for ${business_name} product: ${product}, platform: ${platform}.\nReturn JSON: { headline, primary_text, description, cta, target_audience_suggestion }` },
    ], { maxTokens: 600, parseJson: true });
    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { generateBusiness, generatePost, generatePlan, generateHashtagsEndpoint, generateCaption, generateSeo, generateEmail, generateBlog, generateAdCopy };
