const nodemailer = require('nodemailer');

const getTransporter = () => {
  // If SMTP environment variables are placeholders or missing, return null
  const isMock = !process.env.SMTP_USER || 
                 process.env.SMTP_USER === 'your_email@gmail.com' ||
                 !process.env.SMTP_PASS ||
                 process.env.SMTP_PASS === 'your_app_password_here';

  if (isMock) {
    return null;
  }

  return nodemailer.createTransport({
    host: process.env.SMTP_HOST || 'smtp.gmail.com',
    port: parseInt(process.env.SMTP_PORT || '587'),
    secure: process.env.SMTP_PORT === '465', // true for 465, false for other ports
    auth: {
      user: process.env.SMTP_USER,
      pass: process.env.SMTP_PASS,
    },
  });
};

const sendEmail = async ({ to, subject, text, html }) => {
  try {
    const transporter = getTransporter();

    if (!transporter) {
      console.log(`\n📧 [SIMULATED EMAIL SENT]`);
      console.log(`   To: ${to}`);
      console.log(`   Subject: ${subject}`);
      console.log(`   Text: ${text || 'No text content'}`);
      console.log(`   Html: ${html ? 'HTML content provided' : 'None'}\n`);
      return { success: true, message: 'Email sent (simulated)' };
    }

    const mailOptions = {
      from: `"${process.env.APP_NAME || 'Brandora'}" <${process.env.SMTP_USER}>`,
      to,
      subject,
      text,
      html,
    };

    const info = await transporter.sendMail(mailOptions);
    console.log(`✅ Email sent via Nodemailer: ${info.messageId}`);
    return { success: true, message: 'Email sent successfully', messageId: info.messageId };
  } catch (error) {
    console.error('❌ Failed to send email:', error.message);
    return { success: false, error: error.message };
  }
};

module.exports = { sendEmail };
