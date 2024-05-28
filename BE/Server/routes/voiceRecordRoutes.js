require('dotenv').config();
const express = require('express');
const multer = require('multer');
const path = require('path');
const mongoose = require('mongoose');
const { ObjectID } = require('mongodb');
const { createModel } = require('mongoose-gridfs');
const { Readable } = require('stream');
const config = require('../config/key');
const bodyParser = require('body-parser');
const fs = require('fs');


const { saveFile } = require('../models/attachment');

const storage = multer.memoryStorage();
const upload = multer({ storage });

const router = express.Router();

router.get('/:trackID', (req, res) => {
    if (!ObjectID.isValid(req.params.trackID)) {
        return res.status(400).json({
            message: "Invalid trackID in URL parameter."
        });
    }

    Attachment.findById(req.params.trackID, (err, file) => {
        if (err || !file) {
            return res.status(404).json({
                message: "Cannot find file with that ID",
            });
        }
        
        res.set('content-type', file.contentType);
        res.set('accept-ranges', 'bytes');

        const reader = Attachment.read({ _id: ObjectID(req.params.trackID) });
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
    if (!ObjectID.isValid(req.params.trackID)) {
        return res.status(400).json({
            message: "Invalid trackID in URL parameter."
        });
    }

    Attachment.unlink({ _id: ObjectID(req.params.trackID) }, (err, file) => {
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

module.exports = router;