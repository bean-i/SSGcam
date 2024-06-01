const config = require('../config/key');
const mongoose = require('mongoose');
const { GridFSBucket } = require('mongodb');

const connection = mongoose.connection;

const saveFile = (fileBuffer, fileName) => {
    return new Promise((resolve, reject) => {
        const bucket = new GridFSBucket(connection.db, {
            bucketName: 'attachments'
        });

        const uploadStream = bucket.openUploadStream(fileName, {
            contentType: 'audio/wav', 
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