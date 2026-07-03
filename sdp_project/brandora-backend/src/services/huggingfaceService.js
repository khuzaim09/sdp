const axios = require('axios');

const HF_API_URL = 'https://api-inference.huggingface.co/models/mistralai/Mistral-7B-Instruct-v0.1';

const generateWithHuggingFace = async (prompt) => {
  try {
    const response = await axios.post(
      HF_API_URL,
      {
        inputs: prompt,
        parameters: { max_new_tokens: 500, temperature: 0.7 }
      },
      {
        headers: { Authorization: `Bearer ${process.env.HUGGINGFACE_API_KEY}` }
      }
    );
    return response.data[0]?.generated_text || 'AI response unavailable.';
  } catch (error) {
    console.error('HuggingFace fallback error:', error.message);
    return 'AI service temporarily unavailable. Please try again.';
  }
};

module.exports = { generateWithHuggingFace };
