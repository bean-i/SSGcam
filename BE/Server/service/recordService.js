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
    const savedRecord = await record.save();
    console.log(savedRecord);
    console.log('위험 레벨:', savedRecord.rc_fd_level_str); 
    return savedRecord;
  } catch (error) {
    throw error;
  }
}

// async function createRecord(data) {
//   const record = new Record(data);
//   try {
//     await record.save();
//     return record;
//   } catch (error) {
//     throw error;
//   }
// }

module.exports = {
  findByPhoneNumber,
  createRecord
};
