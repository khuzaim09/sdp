const Subscription = require('../models/Subscription');
const Payment = require('../models/Payment');
const User = require('../models/User');
const { v4: uuidv4 } = require('uuid');
const { PLAN_CONFIG } = require('../config/constants');

// GET /subscription/plans
const getPlans = async (req, res) => {
  return res.status(200).json({
    success: true,
    data: {
      plans: [
        { id: 'free_trial', name: 'Free Trial', price: 0, duration: '7 days', features: PLAN_CONFIG.free_trial.features },
        { id: 'basic', name: 'Basic', price: 350, duration: '30 days', features: PLAN_CONFIG.basic.features },
        { id: 'business', name: 'Business', price: 2800, duration: '150 days', features: PLAN_CONFIG.business.features },
        { id: 'pro', name: 'Pro', price: 1000, duration: '120 days', features: PLAN_CONFIG.pro.features },
      ],
    },
  });
};

// POST /subscription/upgrade
const upgradePlan = async (req, res) => {
  try {
    const { plan_type, card_number, card_name } = req.body;
    const userId = req.user.user_id;

    if (!PLAN_CONFIG[plan_type]) {
      return res.status(400).json({ success: false, message: 'Invalid plan.' });
    }

    const config = PLAN_CONFIG[plan_type];
    const startDate = new Date();
    const endDate = config.duration_days
      ? new Date(startDate.getTime() + config.duration_days * 24 * 60 * 60 * 1000)
      : null;

    // Mark old subscriptions as superseded
    await Subscription.updateMany(
      { userId, status: 'active' },
      { status: 'superseded' }
    );

    const transactionId = `txn_${uuidv4().slice(0, 12)}`;

    // Create new subscription
    const subscription = await Subscription.create({
      userId,
      planType: plan_type,
      pricePaid: config.price,
      startDate,
      endDate,
      status: 'active',
      paymentMethod: 'card',
      transactionId,
    });

    // Create payment record
    await Payment.create({
      userId,
      subscriptionId: subscription._id,
      amount: config.price,
      method: 'card',
      status: 'completed',
      transactionId,
    });

    // Update user plan
    await User.findByIdAndUpdate(userId, { plan: plan_type });

    return res.status(200).json({
      success: true,
      message: `🎉 Successfully upgraded to ${plan_type} plan!`,
      data: {
        plan: plan_type,
        transaction_id: transactionId,
        expires: endDate ? endDate.toISOString() : 'Never (Lifetime)',
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /subscription/status
const getStatus = async (req, res) => {
  try {
    const userId = req.user.user_id;

    const subscription = await Subscription.findOne({ userId, status: 'active' })
      .sort({ createdAt: -1 })
      .lean();

    if (!subscription) {
      return res.status(200).json({ success: true, data: { status: 'no_subscription', plan_type: 'free_trial' } });
    }

    const now = new Date();
    const isExpired = subscription.endDate ? now > subscription.endDate : false;

    if (isExpired) {
      await Subscription.findByIdAndUpdate(subscription._id, { status: 'expired' });
      await User.findByIdAndUpdate(userId, { plan: 'expired' });
    }

    return res.status(200).json({
      success: true,
      data: {
        subscription_id: subscription._id,
        plan_type: subscription.planType,
        price_paid: subscription.pricePaid,
        start_date: subscription.startDate,
        end_date: subscription.endDate,
        status: isExpired ? 'expired' : subscription.status,
        is_expired: isExpired,
        days_remaining: subscription.endDate
          ? Math.max(0, Math.ceil((subscription.endDate - now) / (1000 * 60 * 60 * 24)))
          : null,
      },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getPlans, upgradePlan, getStatus };
