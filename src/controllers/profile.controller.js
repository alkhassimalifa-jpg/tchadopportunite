const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// ─── Get my profile ────────────────────────────────────────────

const getMyProfile = async (req, res) => {
  try {
    const profile = await prisma.profile.findUnique({
      where: { userId: req.user.id },
    });

    return res.status(200).json({
      success: true,
      data: { profile },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Update my profile ─────────────────────────────────────────

const updateMyProfile = async (req, res) => {
  try {
    const {
      bio, skills, city, address, latitude, longitude,
      availability, hourlyRate, category, experience, website,
      firstName, lastName, phone,
    } = req.body;

    // Update user basic info if provided
    if (firstName || lastName || phone) {
      await prisma.user.update({
        where: { id: req.user.id },
        data: {
          ...(firstName && { firstName }),
          ...(lastName && { lastName }),
          ...(phone !== undefined && { phone }),
        },
      });
    }

    const profile = await prisma.profile.upsert({
      where: { userId: req.user.id },
      update: {
        ...(bio !== undefined && { bio }),
        ...(skills !== undefined && { skills }),
        ...(city !== undefined && { city }),
        ...(address !== undefined && { address }),
        ...(latitude !== undefined && { latitude }),
        ...(longitude !== undefined && { longitude }),
        ...(availability !== undefined && { availability }),
        ...(hourlyRate !== undefined && { hourlyRate }),
        ...(category !== undefined && { category }),
        ...(experience !== undefined && { experience }),
        ...(website !== undefined && { website }),
      },
      create: {
        userId: req.user.id,
        bio, skills: skills || [], city, address, latitude, longitude,
        availability: availability ?? true, hourlyRate, category, experience, website,
      },
    });

    return res.status(200).json({
      success: true,
      message: 'Profil mis à jour',
      data: { profile },
    });
  } catch (error) {
    console.error('Update profile error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la mise à jour du profil',
    });
  }
};

// ─── Get my stats (for providers) ───────────────────────────────

const getMyStats = async (req, res) => {
  try {
    const userId = req.user.id;

    const [applicationsCount, reviewsCount, avgRating] = await Promise.all([
      prisma.application.count({ where: { applicantId: userId } }),
      prisma.review.count({ where: { receiverId: userId } }),
      prisma.review.aggregate({
        where: { receiverId: userId },
        _avg: { rating: true },
      }),
    ]);

    return res.status(200).json({
      success: true,
      data: {
        stats: {
          applicationsCount,
          reviewsCount,
          averageRating: avgRating._avg.rating || 0,
        },
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

module.exports = { getMyProfile, updateMyProfile, getMyStats };