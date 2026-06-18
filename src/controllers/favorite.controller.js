const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

// ─── Add to favorites ──────────────────────────────────────────

const addFavorite = async (req, res) => {
  try {
    const { targetId, targetType } = req.body;

    const validTypes = ['JOB', 'PROVIDER', 'COMPANY'];
    if (!targetId || !validTypes.includes(targetType)) {
      return res.status(400).json({
        success: false,
        message: 'targetId et targetType (JOB, PROVIDER, COMPANY) sont requis',
      });
    }

    const favorite = await prisma.favorite.upsert({
      where: {
        userId_targetId_targetType: {
          userId: req.user.id,
          targetId,
          targetType,
        },
      },
      update: {},
      create: {
        userId: req.user.id,
        targetId,
        targetType,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Ajouté aux favoris',
      data: { favorite },
    });
  } catch (error) {
    console.error('Add favorite error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'ajout aux favoris',
    });
  }
};

// ─── Remove from favorites ─────────────────────────────────────

const removeFavorite = async (req, res) => {
  try {
    const { targetId, targetType } = req.params;

    await prisma.favorite.deleteMany({
      where: {
        userId: req.user.id,
        targetId,
        targetType,
      },
    });

    return res.status(200).json({
      success: true,
      message: 'Retiré des favoris',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Get my favorites ───────────────────────────────────────────

const getMyFavorites = async (req, res) => {
  try {
    const { type } = req.query;

    const favorites = await prisma.favorite.findMany({
      where: {
        userId: req.user.id,
        ...(type && { targetType: type }),
      },
      orderBy: { createdAt: 'desc' },
    });

    // Enrich with job data if type is JOB
    const jobIds = favorites
      .filter((f) => f.targetType === 'JOB')
      .map((f) => f.targetId);

    let jobs = [];
    if (jobIds.length > 0) {
      jobs = await prisma.job.findMany({
        where: { id: { in: jobIds } },
      });
    }

    const enriched = favorites.map((fav) => {
      if (fav.targetType === 'JOB') {
        const job = jobs.find((j) => j.id === fav.targetId);
        return { ...fav, job };
      }
      return fav;
    });

    return res.status(200).json({
      success: true,
      data: { favorites: enriched },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Check if favorited ────────────────────────────────────────

const checkFavorite = async (req, res) => {
  try {
    const { targetId, targetType } = req.params;

    const favorite = await prisma.favorite.findUnique({
      where: {
        userId_targetId_targetType: {
          userId: req.user.id,
          targetId,
          targetType,
        },
      },
    });

    return res.status(200).json({
      success: true,
      data: { isFavorite: !!favorite },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

module.exports = { addFavorite, removeFavorite, getMyFavorites, checkFavorite };