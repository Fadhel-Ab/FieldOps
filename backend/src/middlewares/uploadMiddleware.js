const multer = require("multer");

/* const storage = multer.memoryStorage({ for none buffer
    destination: (req, file, cb) => {
        cb(null, "uploads/");
    },

    filename: (req, file, cb) => {
        cb(null, Date.now() + "-" + file.originalname);
    }
}); */
const storage = multer.memoryStorage();

const upload = multer({
     limits: { fileSize: 5 * 1024 * 1024 }, // 5 MB limit
    storage:storage,
    fileFilter: function (req, file, cb) {
    
    if (!file.originalname.match(/\.(jpg|jpeg|png)$/i)) {
      return cb(new Error('Only image files are allowed!'));
    }
    cb(null, true);
  }
});

module.exports = upload;