const SocialPost = require('../models/SocialPost');
const { v4: uuidv4 } = require('uuid');

// POST /social/create-post
const createPost = async (req, res) => {
  try {
    const { platform, content, hashtags = [], media_url = '' } = req.body;
    const userId = req.user.user_id;

    const post = await SocialPost.create({
      userId,
      platform,
      content,
      hashtags,
      mediaUrl: media_url,
      status: 'draft',
    });

    return res.status(201).json({
      success: true,
      message: 'Post saved as draft!',
      data: { post_id: post._id, status: 'draft' },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /social/schedule-post
const schedulePost = async (req, res) => {
  try {
    const { post_id, scheduled_time } = req.body;
    const userId = req.user.user_id;

    const post = await SocialPost.findOne({ _id: post_id, userId });
    if (!post) {
      return res.status(404).json({ success: false, message: 'Post not found.' });
    }

    post.scheduledTime = new Date(scheduled_time);
    post.status = 'scheduled';
    await post.save();

    return res.status(200).json({
      success: true,
      message: 'Post scheduled successfully! ✅',
      data: { post_id: post._id, scheduled_time, status: 'scheduled' },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// POST /social/publish-post (Simulated)
const publishPost = async (req, res) => {
  try {
    const { post_id } = req.body;
    const userId = req.user.user_id;

    const post = await SocialPost.findOne({ _id: post_id, userId });
    if (!post) {
      return res.status(404).json({ success: false, message: 'Post not found.' });
    }

    post.status = 'published';
    post.isPublished = true;
    post.publishedAt = new Date();
    post.platformResponse = { post_url: `https://instagram.com/p/${uuidv4().slice(0, 10)}` };
    await post.save();

    return res.status(200).json({
      success: true,
      message: '🚀 Post published successfully! (Simulated)',
      data: { post_id: post._id, status: 'published', platform_response: post.platformResponse },
    });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

// GET /social/posts
const getPosts = async (req, res) => {
  try {
    const userId = req.user.user_id;
    const posts = await SocialPost.find({ userId, deletedAt: null })
      .sort({ createdAt: -1 })
      .limit(50)
      .lean();

    return res.status(200).json({ success: true, data: { posts } });
  } catch (error) {
    return res.status(500).json({ success: false, message: error.message });
  }
};

module.exports = { createPost, schedulePost, publishPost, getPosts };
