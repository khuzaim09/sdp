const SupportTicket = require('../models/SupportTicket');

// GET /help/faq
const getFAQs = async (req, res) => {
  const faqs = [
    { q: 'What is Brandora?', a: 'Brandora is an AI-powered digital marketing assistant tailored to help startups and small businesses create branding, generate marketing plans, build simple websites, and schedule posts.' },
    { q: 'How does the free trial work?', a: 'The free trial gives you 7 days of access to basic features with up to 10 AI generation calls per day.' },
    { q: 'Can I connect my social media accounts?', a: 'Yes, Brandora allows you to connect Instagram, Facebook, Twitter, and LinkedIn to schedule and publish posts directly.' },
    { q: 'How do I cancel my subscription?', a: 'You can cancel auto-renewal at any time under Settings > Subscription.' },
    { q: 'Is my data secure?', a: 'Absolutely. We use industry-standard encryption protocols (like HTTPS and JWT authentication) and your credentials are stored securely.' }
  ];
  return res.status(200).json({ success: true, data: faqs });
};

// POST /help/tickets
const createTicket = async (req, res) => {
  try {
    const { subject, description, category = 'general', priority = 'medium' } = req.body;
    const userId = req.user.user_id;

    const ticket = await SupportTicket.create({
      userId,
      subject,
      description,
      category,
      priority,
      status: 'open',
      messages: [{ sender: 'user', content: description, createdAt: new Date() }]
    });

    return res.status(201).json({ success: true, message: 'Support ticket created successfully!', data: ticket });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /help/tickets
const getMyTickets = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const tickets = await SupportTicket.find({ userId, deletedAt: null }).sort({ createdAt: -1 }).lean();
    return res.status(200).json({ success: true, data: tickets });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /help/tickets/:id
const getTicketById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user_id;

    const ticket = await SupportTicket.findOne({ _id: id, userId, deletedAt: null }).lean();
    if (!ticket) return res.status(404).json({ success: false, message: 'Ticket not found.' });

    return res.status(200).json({ success: true, data: ticket });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /help/tickets/:id/reply
const replyToTicket = async (req, res) => {
  try {
    const { id } = req.params;
    const { content } = req.body;
    const userId = req.user.user_id;

    const ticket = await SupportTicket.findOne({ _id: id, userId, deletedAt: null });
    if (!ticket) return res.status(404).json({ success: false, message: 'Ticket not found.' });

    ticket.messages.push({ sender: 'user', content, createdAt: new Date() });
    ticket.status = 'open'; // Re-open if solved or in-progress
    await ticket.save();

    return res.status(200).json({ success: true, message: 'Reply sent successfully!', data: ticket });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /help/feedback
const submitFeedback = async (req, res) => {
  try {
    const { message, rating = 5 } = req.body;
    // Store feedback in a system log/analytics or print to console for development
    console.log(`💬 User Feedback received: Rating: ${rating}/5, Message: "${message}"`);
    return res.status(200).json({ success: true, message: 'Thank you for your feedback!' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /help/contact
const submitContactForm = async (req, res) => {
  try {
    const { name, email, message } = req.body;
    console.log(`✉️ Contact Form submission from ${name} (${email}): "${message}"`);
    return res.status(200).json({ success: true, message: 'Your message has been sent. We will get back to you soon!' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getFAQs,
  createTicket,
  getMyTickets,
  getTicketById,
  replyToTicket,
  submitFeedback,
  submitContactForm
};
