const fs = require('fs');
const path = require('path');
const { v4: uuidv4 } = require('uuid');

const uploadFile = async (filePath, buffer, contentType = 'image/png') => {
  const uploadsDir = path.join(__dirname, '../../uploads');
  const fullPath = path.join(uploadsDir, filePath);
  
  // Ensure the target directory exists
  const dir = path.dirname(fullPath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  fs.writeFileSync(fullPath, buffer);

  // Return download URL matching local server structure
  const downloadUrl = `/uploads/${filePath}`;
  
  return {
    storage_url: filePath,
    download_url: downloadUrl
  };
};

module.exports = { uploadFile };
