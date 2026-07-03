const Logo = require('../models/Logo');
const { v4: uuidv4 } = require('uuid');
const { LOGO_COLOR_THEMES } = require('../config/constants');
const fs = require('fs');
const path = require('path');

// Generate SVG logo string
const generateSVG = (initials, businessName, theme, shape, fontSize) => {
  const SIZE = 500;
  const shortName = businessName.length > 15 ? businessName.slice(0, 15) + '...' : businessName;

  let bgShape = '';
  if (shape === 'circle') {
    bgShape = `<circle cx="${SIZE/2}" cy="${SIZE/2}" r="${SIZE/2}" fill="${theme.primary}"/>`;
  } else if (shape === 'rounded') {
    bgShape = `<rect x="0" y="0" width="${SIZE}" height="${SIZE}" rx="60" fill="${theme.primary}"/>`;
  } else {
    bgShape = `<rect x="0" y="0" width="${SIZE}" height="${SIZE}" fill="${theme.primary}"/>`;
  }

  return `<?xml version="1.0" encoding="UTF-8"?>
<svg xmlns="http://www.w3.org/2000/svg" width="${SIZE}" height="${SIZE}" viewBox="0 0 ${SIZE} ${SIZE}">
  ${bgShape}
  <circle cx="${SIZE*0.75}" cy="${SIZE*0.25}" r="${SIZE*0.15}" fill="${theme.secondary}" opacity="0.4"/>
  <text x="${SIZE/2}" y="${SIZE/2}" font-family="Arial, sans-serif" font-size="${fontSize}" font-weight="bold" fill="${theme.text}" text-anchor="middle" dominant-baseline="central">${initials}</text>
  <text x="${SIZE/2}" y="${SIZE*0.82}" font-family="Arial, sans-serif" font-size="28" font-weight="bold" fill="${theme.text}" text-anchor="middle" opacity="0.8">${shortName.toUpperCase()}</text>
</svg>`;
};

// POST /logo/generate
const generateLogo = async (req, res) => {
  try {
    const { business_name, color_theme = 'professional', shape = 'circle', font_style = 'bold' } = req.body;
    const userId = req.user.user_id;
    if (!business_name) return res.status(400).json({ success: false, message: 'business_name required.' });

    const theme = LOGO_COLOR_THEMES[color_theme] || LOGO_COLOR_THEMES.professional;

    // Extract initials
    const words = business_name.trim().split(' ');
    const initials = words.length >= 2 ? (words[0][0] + words[1][0]).toUpperCase() : business_name.slice(0, 2).toUpperCase();
    const fontSize = initials.length === 1 ? 160 : 130;

    // Generate SVG
    const svgContent = generateSVG(initials, business_name, theme, shape, fontSize);
    const buffer = Buffer.from(svgContent, 'utf-8');

    // Save to local filesystem
    const uploadsDir = path.join(__dirname, '../../uploads/logos');
    if (!fs.existsSync(uploadsDir)) {
      fs.mkdirSync(uploadsDir, { recursive: true });
    }

    const fileName = `logo_${uuidv4().slice(0, 8)}.svg`;
    const filePath = path.join(uploadsDir, fileName);
    fs.writeFileSync(filePath, buffer);

    const downloadUrl = `${req.protocol}://${req.get('host')}/uploads/logos/${fileName}`;

    const logo = await Logo.create({
      userId,
      businessName: business_name,
      initials,
      colorTheme: color_theme,
      backgroundColor: theme.primary,
      fontStyle: font_style,
      shape,
      svgContent,
      downloadUrl,
    });

    return res.status(200).json({
      success: true,
      message: '🎨 Logo generated!',
      data: {
        logo_id: logo._id,
        download_url: downloadUrl,
        initials,
        color_theme,
        shape,
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /logo/my-logos
const getMyLogos = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const logos = await Logo.find({ userId, deletedAt: null }).sort({ createdAt: -1 }).lean();
    return res.status(200).json({ success: true, data: logos });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { generateLogo, getMyLogos };
