const Record = require('../models/Record');

async function findByPhoneNumber(phoneNumber) {
  try {
    const records = await Record.find({ rc_fd_num : phoneNumber });
    return records;
  } catch (error) {
    throw error;
  }
}

async function createRecord(data) {
  const record = new Record(data);
  try {
    await record.save();
    return record;
  } catch (error) {
    throw error;
  }
}

module.exports = {
  findByPhoneNumber,
  createRecord
};
