const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// ─── Create or update a review ─────────────────────────────────

const createReview = async (req, res) => {
  try {
    const { receiverId, rating, comment } = req.body;

    if (!receiverId || !rating) {
      return res.status(400).json({
        success: false,
        message: 'receiverId et rating sont requis',
      });
    }

    if (rating < 1 || rating > 5) {
      return res.status(400).json({
        success: false,
        message: 'La note doit être entre 1 et 5',
      });
    }

    if (receiverId === req.user.id) {
      return res.status(400).json({
        success: false,
        message: 'Vous ne pouvez pas vous évaluer vous-même',
      });
    }

    const receiver = await prisma.user.findUnique({ where: { id: receiverId } });
    if (!receiver) {
      return res.status(404).json({
        success: false,
        message: 'Utilisateur introuvable',
      });
    }

    const review = await prisma.review.upsert({
      where: {
        giverId_receiverId: {
          giverId: req.user.id,
          receiverId,
        },
      },
      update: { rating, comment },
      create: {
        giverId: req.user.id,
        receiverId,
        rating,
        comment,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Avis enregistré',
      data: { review },
    });
  } catch (error) {
    console.error('Create review error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'enregistrement de l\'avis',
    });
  }
};

// ─── Get reviews received by a user ────────────────────────────

const getUserReviews = async (req, res) => {
  try {
    const { userId } = req.params;

    const reviews = await prisma.review.findMany({
      where: { receiverId: userId },
      include: {
        giver: {
          select: { id: true, firstName: true, lastName: true, photoUrl: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    const avgRating = reviews.length > 0
      ? reviews.reduce((sum, r) => sum + r.rating, 0) / reviews.length
      : 0;

    return res.status(200).json({
      success: true,
      data: {
        reviews,
        averageRating: avgRating,
        totalReviews: reviews.length,
      },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Get reviews given by current user ─────────────────────────

const getMyGivenReviews = async (req, res) => {
  try {
    const reviews = await prisma.review.findMany({
      where: { giverId: req.user.id },
      include: {
        receiver: {
          select: { id: true, firstName: true, lastName: true, photoUrl: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return res.status(200).json({
      success: true,
      data: { reviews },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Delete a review ────────────────────────────────────────────

const deleteReview = async (req, res) => {
  try {
    const { id } = req.params;

    const review = await prisma.review.findUnique({ where: { id } });
    if (!review) {
      return res.status(404).json({
        success: false,
        message: 'Avis introuvable',
      });
    }

    if (review.giverId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé',
      });
    }

    await prisma.review.delete({ where: { id } });

    return res.status(200).json({
      success: true,
      message: 'Avis supprimé',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

module.exports = { createReview, getUserReviews, getMyGivenReviews, deleteReview };