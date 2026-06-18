const { PrismaClient } = require('@prisma/client');
const { uploadToCloudinary } = require('../config/cloudinary');

const prisma = new PrismaClient();

// ─── Upload profile photo ──────────────────────────────────────

const uploadProfilePhoto = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'Aucune image fournie',
      });
    }

    const result = await uploadToCloudinary(
      req.file.buffer,
      'tchadopportunite/profiles'
    );

    // Update user photoUrl
    const user = await prisma.user.update({
      where: { id: req.user.id },
      data: { photoUrl: result.secure_url },
    });

    return res.status(200).json({
      success: true,
      message: 'Photo mise à jour avec succès',
      data: {
        photoUrl: result.secure_url,
        publicId: result.public_id,
      },
    });
  } catch (error) {
    console.error('Upload photo error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'upload de la photo',
    });
  }
};

// ─── Upload CV PDF ─────────────────────────────────────────────

const uploadCV = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: 'Aucun fichier fourni',
      });
    }

    const cloudinary = require('../config/cloudinary').cloudinary;

    const result = await new Promise((resolve, reject) => {
      const stream = cloudinary.uploader.upload_stream(
        {
          folder: 'tchadopportunite/cvs',
          resource_type: 'raw',
          format: 'pdf',
        },
        (error, result) => {
          if (error) reject(error);
          else resolve(result);
        }
      );
      stream.end(req.file.buffer);
    });

    return res.status(200).json({
      success: true,
      message: 'CV uploadé avec succès',
      data: {
        cvUrl: result.secure_url,
        publicId: result.public_id,
      },
    });
  } catch (error) {
    console.error('Upload CV error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'upload du CV',
    });
  }
};

module.exports = { uploadProfilePhoto, uploadCV };