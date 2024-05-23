const express = require('express');
const recordController = require('../controllers/recordController');
const router = express.Router();

router.get('/records/:phoneNumber', recordController.getRecordsByPhoneNumber);

router.post('/records', recordController.createRecord);

module.exports = router;