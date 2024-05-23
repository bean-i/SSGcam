require('dotenv').config();
const express = require('express');
const multer = require('multer');
const path = require('path');
const mongoose = require('mongoose');
const { ObjectId } = mongoose.Types;
const { createModel } = require('mongoose-gridfs');
const { Readable } = require('stream');
const config = require('../config/key');
const bodyParser = require('body-parser');
const fs = require('fs');

const { GridFSBucket } = require('mongodb');
const { saveFile } = require('../models/Attachment');
const { umask } = require('process');

const connection = mongoose.connection;
const storage = multer.memoryStorage();
const upload = multer({ storage });

const router = express.Router();

router.get('/:trackID', (req, res) => {
    if (!ObjectId.isValid(req.params.trackID)) {
        return res.status(400).json({
            message: "Invalid trackID in URL parameter."
        });
    }

    const Attachment = createModel({ modelName: 'Attachment', connection });

    Attachment.findById(req.params.trackID, (err, file) => {
        if (err || !file) {
            return res.status(404).json({
                message: "Cannot find file with that ID",
            });
        }
        
        res.set('content-type', file.contentType);
        res.set('accept-ranges', 'bytes');

        const reader = Attachment.read({ _id: ObjectId(req.params.trackID) });
        reader.on('data', (chunk) => {
            res.write(chunk);
        });
        reader.on('error', (err) => {
            console.log(err);
            res.status(404).json({
                message: "Cannot find files that have the ID",
            });
        });
        reader.on('close', () => {
            console.log("All Sent!");
            res.end();
        });
    });
});

router.post('/upload', upload.single('file'), async (req, res) => {
    try {
        const filePath = req.file.buffer;
        const fileName = req.file.originalname;

        const file = await saveFile(filePath, fileName);
        res.status(200).json({ message: 'File uploaded successfully', file });
    } catch (err) {
        res.status(500).json({ message: 'File upload failed', error: err.message });
    }
});

router.delete("/:trackID", (req, res) => {
    if (!ObjectId.isValid(req.params.trackID)) {
        return res.status(400).json({
            message: "Invalid trackID in URL parameter."
        });
    }

    const Attachment = createModel({ modelName: 'Attachment', connection });

    Attachment.unlink({ _id: ObjectId(req.params.trackID) }, (err, file) => {
        if (err) {
            console.log("Failed to delete\n" + err);
            return res.status(400).json({
                message: "Wrong Request",
                error: err.message,
            });
        }

        console.log('Deleted\n' + file);
        return res.status(200).json({
            message: "Successfully Deleted",
            file: file,
        });
    });
});

router.get('/file/:fileID', (req, res) => {
    try {
        const bucket = new GridFSBucket(connection.db, {
            bucketName: 'attachments'
        });

        const downloadStream = bucket.openDownloadStream(new ObjectId(req.params.fileID));

        res.set('Content-Type', 'audio/wav');

        downloadStream.on('error', () => {
            res.status(404).send('File not found');
        });

        downloadStream.pipe(res);
    } catch (err) {
        res.status(500).send(err.message);
    }
});

module.exports = router;