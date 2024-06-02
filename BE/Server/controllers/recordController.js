const recordService = require('../service/recordService');

async function getRecordsByPhoneNumber(req, res) {
  try {
    const phoneNumber = req.params.phoneNumber;
    const records = await recordService.findByPhoneNumber(phoneNumber);
    if (records.length > 0) {
      res.json(records);
    } else {
      res.status(404).send('No records found for this phone number.');
    }
  } catch (error) {
    res.status(500).send(error.message);
  }
}

async function createRecord(req, res) {
  try {
    const recordData = req.body;
    const newRecord = await recordService.createRecord(recordData);
    res.status(201).json(newRecord);
  } catch (error) {
    res.status(500).send(error.message);
  }
}

module.exports = {
  getRecordsByPhoneNumber,
  createRecord
};
