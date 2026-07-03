const express = require('express');
const router = express.Router();
const {
  getProfile,
  updateProfile,
  uploadProfileImage,
  changePassword,
  updateNotificationSettings,
  deleteAccount
} = require('../controllers/userController');
const { authMiddleware } = require('../middleware/authMiddleware');
const upload = require('../middleware/uploadMiddleware');
const { updateProfileValidator, notificationSettingsValidator, changePasswordValidator } = require('../validators/userValidator');
const validate = require('../middleware/validate');

router.use(authMiddleware);

router.get('/profile', getProfile);
router.put('/profile', updateProfileValidator, validate, updateProfile);
router.post('/upload-image', upload.single('profileImage'), uploadProfileImage);
router.post('/change-password', changePasswordValidator, validate, changePassword);
router.put('/notifications', notificationSettingsValidator, validate, updateNotificationSettings);
router.delete('/delete', deleteAccount);

module.exports = router;
