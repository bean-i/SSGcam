// const mongoose = require('mongoose');
const config = require('../config/key');
// const gridfs = require('mongoose-gridfs');
// const connectionString = 'your_mongodb_connection_string';

// // MongoDB 연결
// mongoose.connect(config.mongoURI);

// mongoose.connection.on('connected', () => {
//     console.log('MongoDB에 성공적으로 연결되었습니다.');

//     // MongoDB 연결이 성공적으로 이루어진 후에 Attachment 모델 생성
//     const Attachment = createModel({
//         modelName: 'VoiceRecordings',
//         connection: mongoose.connection
//     });
//     // 모델을 다른 파일에서 사용할 수 있도록 내보냄
//     module.exports = Attachment;
// });

// mongoose.connection.on('error', (err) => {
//     console.error('MongoDB 연결 에러:', err);
// });

// const connection = mongoose.connection;

// const attachment = gridfs({
//     collection: "VoiceRecordings",
//     model: 'Attatchment',
//     mongooseConnection: connection
// });

// const saveFile = (filePath, fileName) => {
//     return new Promise((resolve, reject) => {
//         const writeStream = attachment.write(
//             {
//                 filename: fileName,
//                 contentType: 'audio/wav',
//                 metadata: {
//                     description: 'Voice file'
//                 }
//             },
//             fs.createReadStream(filePath)
//         );

//         writeStream.on('finish', (file) => {
//             fs.unlink(filePath, (err) => {
//                 if (err) {
//                      console.error('Error deleting temporary file', err);
//                 }
//             });
//             resolve(file);
//         });

//         writeStream.on('error', (err) => {
//             reject(err);
//         });
//     });
// };

// module.exports = {
//     saveFile
// };

const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');

const connection = mongoose.connection;

const saveFile = (fileBuffer, fileName) => {
    return new Promise((resolve, reject) => {
        const bucket = new GridFSBucket(connection.db, {
            bucketName: 'attachments'
        });

        const uploadStream = bucket.openUploadStream(fileName, {
            contentType: 'audio/wav', // adjust according to your file type
            metadata: {
                description: 'Voice file'
            }
        });

        uploadStream.end(fileBuffer);

        uploadStream.on('finish', (file) => {
            resolve(file);
        });

        uploadStream.on('error', (err) => {
            reject(err);
        });
    });
};

module.exports = {
    saveFile
};
