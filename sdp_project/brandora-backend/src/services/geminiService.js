const { GoogleGenerativeAI } = require('@google/generative-ai');

const getClient = () => {
  if (!process.env.GEMINI_API_KEY) {
    throw new Error('GEMINI_API_KEY is not set');
  }
  return new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
};

const getGeminiCompletion = async (messages, options = {}) => {
  const genAI = getClient();
  const modelName = options.model || 'gemini-1.5-flash';
  const model = genAI.getGenerativeModel({ 
    model: modelName,
    generationConfig: options.parseJson ? { responseMimeType: "application/json" } : undefined
  });

  // Convert chat messages to standard prompt structure
  let prompt = '';
  messages.forEach(msg => {
    prompt += `${msg.role === 'system' ? 'System Instructions' : msg.role === 'user' ? 'User' : 'Assistant'}: ${msg.content}\n`;
  });
  prompt += 'Assistant: ';

  const result = await model.generateContent(prompt);
  const response = await result.response;
  const text = response.text();

  return {
    content: text,
    tokensUsed: 0 // Gemini doesn't return exact token count directly without separate API call
  };
};

module.exports = { getGeminiCompletion };
