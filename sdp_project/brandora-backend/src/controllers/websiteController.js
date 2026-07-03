const Website = require('../models/Website');
const { callAI } = require('../services/aiProviderService');

// POST /website/generate
const generateWebsite = async (req, res) => {
  try {
    const { business_name, business_idea, industry = '', language = 'en' } = req.body;
    const userId = req.user.user_id;
    const langInstruction = language === 'ur' ? 'Respond in Urdu.' : 'Respond in English.';

    const websiteContent = await callAI([
      { role: 'system', content: `You are a web copywriter for Pakistani businesses. ${langInstruction} Return JSON only.` },
      { role: 'user', content: `Generate complete website content for: ${business_name}, idea: ${business_idea}, industry: ${industry || 'General'}.\nReturn JSON: { homepage: { headline, subheadline, hero_description, cta_text, features: [{title, description}] }, about_us: { title, story, mission, team_description }, products: [{ name, description, price_range, highlights }], contact: { email, tagline } }` },
    ], { maxTokens: 1500, parseJson: true });

    const publicUrl = `https://brandora.app/${userId.toString().slice(0, 8)}`;
    const website = await Website.create({
      userId, businessName: business_name, businessIdea: business_idea, industry, publicUrl, content: websiteContent, status: 'generated',
    });

    return res.status(200).json({
      success: true, message: '🌐 Website content generated!',
      data: { website_id: website._id, public_url: publicUrl, content: websiteContent },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /website/my-websites
const getMyWebsites = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const websites = await Website.find({ userId, deletedAt: null }).sort({ createdAt: -1 }).lean();
    return res.status(200).json({ success: true, data: websites });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { generateWebsite, getMyWebsites };
