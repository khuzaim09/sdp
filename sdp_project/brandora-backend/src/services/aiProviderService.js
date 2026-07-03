const { getChatCompletion } = require('./openaiService');
const { getGeminiCompletion } = require('./geminiService');
const { getClaudeCompletion } = require('./claudeService');
const { generateWithHuggingFace } = require('./huggingfaceService');

// Helper to sanitize json string from AI code block formatting
const cleanJsonResponse = (content) => {
  if (typeof content !== 'string') return content;
  return content.replace(/```json|```/g, '').trim();
};

const callAI = async (messages, options = {}) => {
  const providers = [
    { name: 'OpenAI', fn: getChatCompletion, apiKey: process.env.OPENAI_API_KEY },
    { name: 'Gemini', fn: getGeminiCompletion, apiKey: process.env.GEMINI_API_KEY },
    { name: 'Claude', fn: getClaudeCompletion, apiKey: process.env.ANTHROPIC_API_KEY }
  ];

  for (const provider of providers) {
    if (provider.apiKey && provider.apiKey !== 'your_api_key_here' && !provider.apiKey.includes('your_openai_key')) {
      try {
        console.log(`🤖 Attempting completion with ${provider.name}...`);
        const result = await provider.fn(messages, options);
        
        let finalContent = result.content;
        if (options.parseJson) {
          finalContent = cleanJsonResponse(finalContent);
          try {
            // Validate JSON
            JSON.parse(finalContent);
          } catch (jsonErr) {
            console.warn(`⚠️ ${provider.name} JSON validation failed, retrying fallback...`);
            continue;
          }
        }
        
        console.log(`✅ Completion successful with ${provider.name}`);
        return {
          content: options.parseJson ? JSON.parse(finalContent) : finalContent,
          tokensUsed: result.tokensUsed || 0,
          provider: provider.name
        };
      } catch (err) {
        console.error(`❌ ${provider.name} failed:`, err.message);
      }
    }
  }

  // Final fallback to Hugging Face if all paid providers fail or keys are missing
  console.log('🤖 Attempting completion with Hugging Face (free fallback)...');
  try {
    // Construct single prompt from messages
    let prompt = '';
    messages.forEach(msg => {
      prompt += `${msg.role === 'system' ? 'System Instructions' : msg.role === 'user' ? 'User' : 'Assistant'}: ${msg.content}\n`;
    });
    prompt += 'Assistant: ';

    const resultText = await generateWithHuggingFace(prompt);
    let finalContent = resultText;
    if (options.parseJson) {
      finalContent = cleanJsonResponse(finalContent);
    }
    
    return {
      content: options.parseJson ? JSON.parse(finalContent) : finalContent,
      tokensUsed: 0,
      provider: 'HuggingFace'
    };
  } catch (hfErr) {
    console.error('❌ HuggingFace fallback failed:', hfErr.message);
    throw new Error('All AI providers, including fallbacks, failed. Please check your API keys and configuration.');
  }
};

module.exports = { callAI };
