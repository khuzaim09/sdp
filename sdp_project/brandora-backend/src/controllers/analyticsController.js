const Analytics = require('../models/Analytics');

const generateMockAnalytics = (userId) => {
  const rand = (min, max) => Math.floor(Math.random() * (max - min + 1)) + min;
  return {
    userId,
    period: new Date().toISOString().slice(0, 7),
    overview: {
      totalPosts: rand(15, 45),
      totalReach: rand(8000, 25000),
      totalEngagement: rand(1000, 5000),
      followersGrowth: rand(50, 300),
    },
    instagram: {
      followers: rand(800, 5000),
      posts: rand(8, 20),
      likes: rand(500, 3000),
      comments: rand(50, 500),
      reach: rand(4000, 15000),
      engagementRate: parseFloat((Math.random() * 5 + 1).toFixed(1)),
    },
    facebook: {
      followers: rand(500, 3000),
      posts: rand(5, 15),
      likes: rand(300, 2000),
      shares: rand(50, 300),
      reach: rand(2000, 8000),
      engagementRate: parseFloat((Math.random() * 4 + 1).toFixed(1)),
    },
    twitter: {
      followers: rand(200, 1500),
      tweets: rand(3, 10),
      retweets: rand(20, 200),
      likes: rand(100, 800),
      impressions: rand(1000, 5000),
    },
    weeklyGrowth: Array.from({ length: 7 }, () => rand(5, 50)),
    monthlyTrend: Array.from({ length: 30 }, () => rand(2, 30)),
  };
};

// GET /analytics
const getAnalytics = async (req, res) => {
  try {
    const userId = req.user.user_id;

    let analyticsData = await Analytics.findOne({ userId }).lean();

    if (analyticsData) {
      const updatedAt = new Date(analyticsData.updatedAt);
      const hoursSince = (Date.now() - updatedAt.getTime()) / (1000 * 60 * 60);

      // If cached data is fresh (less than 24 hours old), return it
      if (hoursSince < 24) {
        return res.status(200).json({ success: true, data: analyticsData, source: 'cached' });
      }
    }

    // Otherwise generate fresh mock data and save it
    const freshMock = generateMockAnalytics(userId);

    if (analyticsData) {
      analyticsData = await Analytics.findOneAndUpdate({ userId }, freshMock, { new: true }).lean();
    } else {
      analyticsData = await Analytics.create(freshMock);
    }

    return res.status(200).json({ success: true, data: analyticsData, source: 'generated' });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { getAnalytics };
