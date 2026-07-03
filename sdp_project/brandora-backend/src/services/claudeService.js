const Anthropic = require('@anthropic-ai/sdk');

const getClient = () => {
  if (!process.env.ANTHROPIC_API_KEY) {
    throw new Error('ANTHROPIC_API_KEY is not set');
  }
  return new Anthropic({ apiKey: process.env.ANTHROPIC_API_KEY });
};

const getClaudeCompletion = async (messages, options = {}) => {
  const anthropic = getClient();
  
  // Separate system prompt from user/assistant messages
  const systemMsg = messages.find(m => m.role === 'system');
  const userAndAssistantMsgs = messages.filter(m => m.role !== 'system');

  const payload = {
    model: options.model || 'claude-3-haiku-20240307',
    max_tokens: options.maxTokens || 1500,
    temperature: options.temperature || 0.7,
    messages: userAndAssistantMsgs.map(m => ({
      role: m.role === 'assistant' ? 'assistant' : 'user',
      content: m.content
    }))
  };

  if (systemMsg) {
    payload.system = systemMsg.content;
  }

  const response = await anthropic.messages.create(payload);

  return {
    content: response.content[0].text,
    tokensUsed: response.usage?.total_tokens || 0
  };
};

module.exports = { getClaudeCompletion };
