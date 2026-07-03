const OpenAI = require('openai');
const axios = require('axios');
const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const getClient = () => {
  if (!process.env.OPENAI_API_KEY) {
    throw new Error('OPENAI_API_KEY is not set');
  }
  return new OpenAI({ apiKey: process.env.OPENAI_API_KEY });
};

// General completion wrapper
const getChatCompletion = async (messages, options = {}) => {
  const openai = getClient();
  const completion = await openai.chat.completions.create({
    model: options.model || 'gpt-4o-mini',
    messages,
    max_tokens: options.maxTokens || 1500,
    temperature: options.temperature || 0.7,
    response_format: options.parseJson ? { type: 'json_object' } : undefined,
  });
  return {
    content: completion.choices[0].message.content,
    tokensUsed: completion.usage?.total_tokens || 0,
  };
};

// Generate Business Ideas
const generateBusinessIdeas = async ({ industry, budget, location = 'Pakistan', language = 'en' }) => {
  const langInstruction = language === 'ur' ? 'Respond entirely in Urdu language.' : 'Respond in English.';
  const messages = [
    { role: 'system', content: `You are a business consultant specializing in the Pakistani market. ${langInstruction} Return response as valid JSON only.` },
    { role: 'user', content: `Generate 3 business ideas for industry: ${industry}, budget: PKR ${budget}, location: ${location}.\nReturn JSON: { ideas: [{ title, description, investment_required, potential_revenue, pros, cons, first_steps }] }` }
  ];
  const res = await getChatCompletion(messages, { parseJson: true });
  return JSON.parse(res.content);
};

// Generate Social Media Post
const generateSocialPost = async ({ business_name, product, platform, tone = 'engaging', language = 'en' }) => {
  const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';
  const messages = [
    { role: 'system', content: `You are a social media marketing expert for Pakistani brands. ${langInstruction} Return JSON only.` },
    { role: 'user', content: `Create a ${platform} post for: ${business_name}, product: ${product}, tone: ${tone}.\nReturn JSON: { caption, hashtags (array of 10), emoji_suggestions, call_to_action, best_posting_time }` }
  ];
  const res = await getChatCompletion(messages, { parseJson: true });
  return JSON.parse(res.content);
};

// Generate Marketing Plan
const generateMarketingPlan = async ({ business_name, industry, target_audience, budget, language = 'en' }) => {
  const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';
  const messages = [
    { role: 'system', content: `You are a marketing strategist for Pakistani SMBs. ${langInstruction} Return JSON only.` },
    { role: 'user', content: `Create a 3-month marketing plan for: ${business_name}, industry: ${industry}, audience: ${target_audience}, budget: PKR ${budget}.\nReturn JSON: { executive_summary, target_market, marketing_channels, content_strategy, budget_allocation, kpis, monthly_timeline }` }
  ];
  const res = await getChatCompletion(messages, { maxTokens: 2000, parseJson: true });
  return JSON.parse(res.content);
};

// Generate Website Content
const generateWebsiteContent = async ({ business_name, business_idea, industry, language = 'en' }) => {
  const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';
  const messages = [
    { role: 'system', content: `You are a web copywriter for Pakistani businesses. ${langInstruction} Return JSON only.` },
    { role: 'user', content: `Generate complete website content for: ${business_name}, idea: ${business_idea}, industry: ${industry}.\nReturn JSON: { homepage: { headline, subheadline, hero_description, cta_text, features: [{title, description}] }, about_us: { title, story, mission, team_description }, products: [{ name, description, price_range, highlights }], contact: { email, tagline } }` }
  ];
  const res = await getChatCompletion(messages, { maxTokens: 2000, parseJson: true });
  return JSON.parse(res.content);
};

// Generate Image (DALL-E 3)
const generateImageDalle = async (prompt, saveSubfolder = 'branding') => {
  const openai = getClient();
  const response = await openai.images.generate({
    model: 'dall-e-3',
    prompt: prompt,
    n: 1,
    size: '1024x1024',
  });

  const tempUrl = response.data[0].url;

  // Download image and save locally
  const imageResponse = await axios({
    url: tempUrl,
    responseType: 'stream',
  });

  const uploadsDir = path.join(__dirname, `../../uploads/${saveSubfolder}`);
  if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir, { recursive: true });
  }

  const fileName = `ai_${uuidv4().slice(0, 8)}.png`;
  const filePath = path.join(uploadsDir, fileName);

  const writer = fs.createWriteStream(filePath);
  imageResponse.data.pipe(writer);

  return new Promise((resolve, reject) => {
    writer.on('finish', () => resolve(fileName));
    writer.on('error', reject);
  });
};

module.exports = {
  getChatCompletion,
  generateBusinessIdeas,
  generateSocialPost,
  generateMarketingPlan,
  generateWebsiteContent,
  generateImageDalle,
};
