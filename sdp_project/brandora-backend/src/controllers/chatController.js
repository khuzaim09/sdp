const ChatSession = require('../models/ChatSession');
const Message = require('../models/Message');
const { v4: uuidv4 } = require('uuid');
const { callAI } = require('../services/aiProviderService');

const SYSTEM_PROMPT_EN = `You are Brandora AI — a friendly, knowledgeable digital marketing assistant specialized in helping Pakistani entrepreneurs and small businesses grow online. You help with: marketing strategies, social media content, business ideas, branding, SEO tips, and digital marketing in Pakistan context. Be concise, practical, and encouraging.`;
const SYSTEM_PROMPT_UR = `آپ Brandora AI ہیں — ایک دوستانہ اور ماہر ڈیجیٹل مارکیٹنگ اسسٹنٹ جو پاکستانی کاروباریوں کی مدد کرتے ہیں۔ اردو میں جواب دیں۔`;

// POST /chat/new
const createNewChat = async (req, res) => {
  try {
    const { language = 'en' } = req.body;
    const userId = req.user.user_id;

    const welcomeMsg =
      language === 'ur'
        ? 'السلام علیکم! میں Brandora AI ہوں۔ آپ کی کاروباری ترقی میں کس طرح مدد کر سکتا ہوں؟ 🚀'
        : "Hello! I'm Brandora AI, your digital marketing assistant. How can I help grow your business today? 🚀";

    const chatSession = await ChatSession.create({
      userId,
      title: 'New Conversation',
      language,
      totalMessages: 1,
    });

    await Message.create({
      chatSessionId: chatSession._id,
      role: 'assistant',
      content: welcomeMsg,
      tokensUsed: 0,
    });

    return res.status(201).json({
      success: true,
      message: 'Chat session created!',
      data: { chat_id: chatSession._id, welcome_message: welcomeMsg, language },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /chat/message
const sendMessage = async (req, res) => {
  try {
    const { message, chat_id, language = 'en' } = req.body;
    const userId = req.user.user_id;

    let chatSession;

    if (chat_id) {
      chatSession = await ChatSession.findOne({ _id: chat_id, userId });
      if (!chatSession) {
        return res.status(404).json({ success: false, message: 'Chat not found.' });
      }
    } else {
      chatSession = await ChatSession.create({
        userId,
        title: message.slice(0, 50),
        language,
        totalMessages: 0,
      });
    }

    // Get last 10 messages for context
    const recentMessages = await Message.find({ chatSessionId: chatSession._id })
      .sort({ createdAt: -1 })
      .limit(10)
      .lean();

    const history = recentMessages.reverse().map((m) => ({ role: m.role, content: m.content }));
    const systemPrompt = language === 'ur' ? SYSTEM_PROMPT_UR : SYSTEM_PROMPT_EN;

    // Call AI with fallback
    let aiResponse, tokensUsed = 0;
    try {
      const result = await callAI(
        [{ role: 'system', content: systemPrompt }, ...history, { role: 'user', content: message }],
        { maxTokens: 800, temperature: 0.7 }
      );
      aiResponse = result.content;
      tokensUsed = result.tokensUsed || 0;
    } catch (e) {
      aiResponse = 'AI service temporarily unavailable. Please try again.';
    }

    // Save messages
    const userMsg = await Message.create({
      chatSessionId: chatSession._id,
      role: 'user',
      content: message,
      tokensUsed: 0,
    });

    const aiMsg = await Message.create({
      chatSessionId: chatSession._id,
      role: 'assistant',
      content: aiResponse,
      tokensUsed,
    });

    // Update session
    chatSession.totalMessages += 2;
    chatSession.updatedAt = new Date();
    await chatSession.save();

    return res.status(200).json({
      success: true,
      data: {
        chat_id: chatSession._id,
        user_message: { message_id: userMsg._id, role: 'user', content: message, timestamp: userMsg.createdAt },
        ai_response: { message_id: aiMsg._id, role: 'assistant', content: aiResponse, timestamp: aiMsg.createdAt, tokens_used: tokensUsed },
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /chat/history
const getChatHistory = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const chats = await ChatSession.find({ userId, deletedAt: null })
      .sort({ updatedAt: -1 })
      .limit(20)
      .lean();

    // Get last message for each chat
    const chatList = await Promise.all(
      chats.map(async (chat) => {
        const lastMsg = await Message.findOne({ chatSessionId: chat._id }).sort({ createdAt: -1 }).lean();
        return {
          chat_id: chat._id,
          title: chat.title,
          language: chat.language,
          total_messages: chat.totalMessages,
          last_message: lastMsg?.content?.slice(0, 80) || '',
          updated_at: chat.updatedAt,
        };
      })
    );

    return res.status(200).json({ success: true, data: { chats: chatList } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /chat/:chatId
const getChat = async (req, res) => {
  try {
    const { chatId } = req.params;
    const chatSession = await ChatSession.findOne({ _id: chatId, userId: req.user.user_id });
    if (!chatSession) {
      return res.status(404).json({ success: false, message: 'Chat not found.' });
    }

    const messages = await Message.find({ chatSessionId: chatId }).sort({ createdAt: 1 }).lean();

    return res.status(200).json({
      success: true,
      data: {
        chat_id: chatSession._id,
        title: chatSession.title,
        language: chatSession.language,
        total_messages: chatSession.totalMessages,
        messages: messages.map((m) => ({
          message_id: m._id,
          role: m.role,
          content: m.content,
          tokens_used: m.tokensUsed,
          timestamp: m.createdAt,
        })),
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// DELETE /chat/:chatId
const deleteChat = async (req, res) => {
  try {
    const { chatId } = req.params;
    const chatSession = await ChatSession.findOne({ _id: chatId, userId: req.user.user_id });
    if (!chatSession) {
      return res.status(404).json({ success: false, message: 'Chat not found.' });
    }

    chatSession.deletedAt = new Date();
    await chatSession.save();
    await Message.deleteMany({ chatSessionId: chatId });

    return res.status(200).json({ success: true, message: 'Chat deleted successfully.' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { createNewChat, sendMessage, getChatHistory, getChat, deleteChat };
