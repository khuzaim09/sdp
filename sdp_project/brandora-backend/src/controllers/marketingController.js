const MarketingPlan = require('../models/MarketingPlan');
const MarketingTask = require('../models/MarketingTask');
const { callAI } = require('../services/aiProviderService');

// GET /marketing/plans
const getMarketingPlans = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const plans = await MarketingPlan.find({ userId, deletedAt: null }).sort({ createdAt: -1 }).lean();
    return res.status(200).json({ success: true, data: plans });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /marketing/plans/:id
const getMarketingPlanById = async (req, res) => {
  try {
    const { id } = req.params;
    const userId = req.user.user_id;
    const plan = await MarketingPlan.findOne({ _id: id, userId, deletedAt: null }).lean();
    if (!plan) return res.status(404).json({ success: false, message: 'Marketing plan not found.' });

    return res.status(200).json({ success: true, data: plan });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /marketing/generate-tasks
const generateTasksForPlan = async (req, res) => {
  try {
    const { plan_id } = req.body;
    const userId = req.user.user_id;

    const plan = await MarketingPlan.findOne({ _id: plan_id, userId, deletedAt: null });
    if (!plan) return res.status(404).json({ success: false, message: 'Marketing plan not found.' });

    // Check if tasks already exist
    const existingTasksCount = await MarketingTask.countDocuments({ planId: plan_id, userId });
    if (existingTasksCount > 0) {
      const tasks = await MarketingTask.find({ planId: plan_id, userId }).sort({ dayNumber: 1 });
      return res.status(200).json({ success: true, message: 'Tasks already exist.', data: tasks });
    }

    // Call AI to generate 30 daily tasks
    const prompt = `Create a 30-day marketing task checklist for: ${plan.businessName} in ${plan.industry} industry. Target audience: ${plan.targetAudience}. Budget PKRs: ${plan.budget}. Language preference: ${plan.language}.
    For each day, write a specific, actionable, and context-relevant marketing task.
    Return JSON only: { tasks: [{ day_number, title, description, category (choose one from: content, social, seo, ads, email, analytics, other), priority (choose one from: low, medium, high) }] }`;

    const result = await callAI([
      { role: 'system', content: 'You are a growth marketer. Return JSON only.' },
      { role: 'user', content: prompt }
    ], { maxTokens: 3000, temperature: 0.7, parseJson: true });

    if (!result.tasks || !Array.isArray(result.tasks)) {
      throw new Error('Invalid AI response structure.');
    }

    const tasksToCreate = result.tasks.map(task => ({
      userId,
      planId: plan._id,
      title: task.title,
      description: task.description || '',
      category: task.category || 'other',
      priority: task.priority || 'medium',
      dayNumber: task.day_number,
      dueDate: new Date(Date.now() + (task.day_number - 1) * 24 * 60 * 60 * 1000)
    }));

    const createdTasks = await MarketingTask.insertMany(tasksToCreate);

    return res.status(201).json({
      success: true,
      message: '30-day marketing task list generated successfully!',
      data: createdTasks
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /marketing/tasks
const getTasks = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const { plan_id } = req.query;

    const query = { userId, deletedAt: null };
    if (plan_id) query.planId = plan_id;

    const tasks = await MarketingTask.find(query).sort({ dayNumber: 1, dueDate: 1 }).lean();
    return res.status(200).json({ success: true, data: tasks });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// PUT /marketing/tasks/:id/status
const updateTaskStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;
    const userId = req.user.user_id;

    if (!['pending', 'in_progress', 'completed', 'skipped'].includes(status)) {
      return res.status(400).json({ success: false, message: 'Invalid status value.' });
    }

    const task = await MarketingTask.findOneAndUpdate(
      { _id: id, userId },
      { status },
      { new: true }
    );

    if (!task) return res.status(404).json({ success: false, message: 'Task not found.' });

    return res.status(200).json({ success: true, message: 'Task status updated.', data: task });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /marketing/persona
const generateCustomerPersona = async (req, res) => {
  try {
    const { business_name, industry, description } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are a customer research expert. Return JSON only.' },
      { role: 'user', content: `Create 2 detailed customer personas for ${business_name} in ${industry} industry. Business details: ${description || ''}.\nReturn JSON: { personas: [{ name, age, occupation, income_bracket, pain_points (array), goals (array), preferred_channels (array), buying_behavior }] }` }
    ], { maxTokens: 1500, parseJson: true });

    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /marketing/strategy
const generateStrategy = async (req, res) => {
  try {
    const { business_name, industry, goals } = req.body;
    const result = await callAI([
      { role: 'system', content: 'You are a business strategist. Return JSON only.' },
      { role: 'user', content: `Create a marketing and business strategy for ${business_name} in ${industry} targeting goals: ${goals}.\nReturn JSON: { swot_analysis: { strengths (array), weaknesses (array), opportunities (array), threats (array) }, value_proposition, positioning_statement, acquisition_channels: [{ name, cost_efficiency, potential_impact }] }` }
    ], { maxTokens: 1500, parseJson: true });

    return res.status(200).json({ success: true, data: result });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = {
  getMarketingPlans,
  getMarketingPlanById,
  generateTasksForPlan,
  getTasks,
  updateTaskStatus,
  generateCustomerPersona,
  generateStrategy
};
