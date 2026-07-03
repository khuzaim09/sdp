const User = require('../models/User');
const Payment = require('../models/Payment');
const Subscription = require('../models/Subscription');

// Aggregation: User growth over time (monthly signup counts)
const getUserGrowthPipeline = async () => {
  return User.aggregate([
    {
      $group: {
        _id: {
          year: { $year: '$createdAt' },
          month: { $month: '$createdAt' }
        },
        count: { $sum: 1 }
      }
    },
    { $sort: { '_id.year': 1, '_id.month': 1 } }
  ]);
};

// Aggregation: Monthly revenue from payments
const getRevenuePipeline = async () => {
  return Payment.aggregate([
    { $match: { status: 'completed' } },
    {
      $group: {
        _id: {
          year: { $year: '$createdAt' },
          month: { $month: '$createdAt' }
        },
        totalRevenue: { $sum: '$amount' },
        transactionCount: { $sum: 1 }
      }
    },
    { $sort: { '_id.year': 1, '_id.month': 1 } }
  ]);
};

// Aggregation: Subscription plan distributions
const getSubscriptionDistribution = async () => {
  return Subscription.aggregate([
    { $match: { status: 'active' } },
    {
      $group: {
        _id: '$planType',
        count: { $sum: 1 },
        totalValue: { $sum: '$pricePaid' }
      }
    }
  ]);
};

module.exports = {
  getUserGrowthPipeline,
  getRevenuePipeline,
  getSubscriptionDistribution
};
