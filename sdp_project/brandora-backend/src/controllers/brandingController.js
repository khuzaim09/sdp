const BrandAsset = require('../models/BrandAsset');
const { callAI } = require('../services/aiProviderService');

// POST /branding/generate-names
const generateBrandNames = async (req, res) => {
  try {
    const { keywords, industry, tone = 'modern' } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are a branding naming expert. Return JSON only.' },
      { role: 'user', content: `Generate 10 brand name ideas for keywords: ${keywords.join(', ')} in the ${industry} industry. Tone: ${tone}.\nReturn JSON: { names: [{ name, tagline, concept_rationale }] }` }
    ], { maxTokens: 1000, parseJson: true });

    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /branding/color-palette
const suggestColorPalettes = async (req, res) => {
  try {
    const { business_name, industry, vibe } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are a UI/UX color specialist. Return JSON only.' },
      { role: 'user', content: `Suggest 3 color palettes for a brand named ${business_name} in ${industry}. Brand vibe: ${vibe}.\nReturn JSON: { palettes: [{ name, colors: [{ role (primary/secondary/accent/background), hex, description }], accessibility_check }] }` }
    ], { maxTokens: 1000, parseJson: true });

    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /branding/guidelines
const generateBrandGuidelines = async (req, res) => {
  try {
    const { business_name, industry, values = [] } = req.body;
    const userId = req.user.user_id;

    const result = await callAI([
      { role: 'system', content: 'You are a brand strategist. Return JSON only.' },
      { role: 'user', content: `Generate brand identity guidelines for ${business_name} in ${industry}. Core values: ${values.join(', ')}.\nReturn JSON: { mission_statement, brand_voice_attributes: [String], typography_rules: { heading_font, body_font, usage }, imagery_style, do_and_donts: { do: [String], dont: [String] } }` }
    ], { maxTokens: 1500, parseJson: true });

    const asset = await BrandAsset.create({
      userId,
      type: 'brand_guidelines',
      businessName: business_name,
      title: 'Brand Identity Guidelines',
      metadata: result
    });

    return res.status(200).json({ success: true, data: { asset_id: asset._id, ...result } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /branding/business-card
const generateBusinessCardTemplate = async (req, res) => {
  try {
    const { business_name, name, job_title, email, phone, website, color_theme } = req.body;
    const userId = req.user.user_id;

    const result = await callAI([
      { role: 'system', content: 'You are a graphic designer. Return JSON only.' },
      { role: 'user', content: `Generate a layout structure and prompt for a business card. Details: ${JSON.stringify(req.body)}.\nReturn JSON: { layout_style, alignment, colors: { primary, secondary, text }, typography: { name_font, detail_font }, prompt_for_dalle, preview_instructions }` }
    ], { maxTokens: 1000, parseJson: true });

    const asset = await BrandAsset.create({
      userId,
      type: 'business_card',
      businessName: business_name,
      title: `${name} - Business Card`,
      metadata: { ...req.body, ...result }
    });

    return res.status(200).json({ success: true, data: { asset_id: asset._id, ...result } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /branding/banner
const generateBannerTemplate = async (req, res) => {
  try {
    const { business_name, platform = 'facebook_cover', tagline, main_offer } = req.body;
    const userId = req.user.user_id;

    const result = await callAI([
      { role: 'system', content: 'You are a visual design expert. Return JSON only.' },
      { role: 'user', content: `Create a design concept and prompt for a banner for ${business_name} on ${platform}. Tagline: ${tagline}. Offer: ${main_offer}.\nReturn JSON: { banner_concept, dimensions, background_style, typography_layout, prompt_for_image_generator }` }
    ], { maxTokens: 1000, parseJson: true });

    const asset = await BrandAsset.create({
      userId,
      type: 'banner',
      businessName: business_name,
      title: `${platform} Banner Concept`,
      metadata: { ...req.body, ...result }
    });

    return res.status(200).json({ success: true, data: { asset_id: asset._id, ...result } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /branding/my-assets
const getMyAssets = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const assets = await BrandAsset.find({ userId, deletedAt: null }).sort({ createdAt: -1 }).lean();
    return res.status(200).json({ success: true, data: assets });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  generateBrandNames,
  suggestColorPalettes,
  generateBrandGuidelines,
  generateBusinessCardTemplate,
  generateBannerTemplate,
  getMyAssets
};
