const generateHashtags = (keywords, platform = 'instagram', count = 15) => {
  const baseHashtags = keywords.map(k => `#${k.replace(/\s+/g, '').toLowerCase()}`);

  const platformTags = {
    instagram: ['#instadaily', '#instagood', '#photooftheday', '#trending', '#pakistan', '#viral'],
    facebook: ['#facebook', '#facebookmarketing', '#socialmedia', '#business', '#pakistan'],
    twitter: ['#trending', '#viral', '#pakistan', '#business', '#marketing'],
    linkedin: ['#business', '#marketing', '#entrepreneur', '#pakistan', '#growth']
  };

  const combined = [...new Set([...baseHashtags, ...(platformTags[platform] || [])])].slice(0, count);
  return combined;
};

module.exports = { generateHashtags };
