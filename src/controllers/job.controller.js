const { PrismaClient } = require('@prisma/client');
const { createNotification } = require('./notification.controller');

const prisma = new PrismaClient();

// ─── List Jobs ────────────────────────────────────────────────

const getJobs = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      search,
      type,
      category,
      location,
      status = 'OPEN',
    } = req.query;

    const skip = (Number(page) - 1) * Number(limit);

    const where = {
      status,
      ...(type && { type }),
      ...(category && { category }),
      ...(location && { location: { contains: location, mode: 'insensitive' } }),
      ...(search && {
        OR: [
          { title: { contains: search, mode: 'insensitive' } },
          { companyName: { contains: search, mode: 'insensitive' } },
          { description: { contains: search, mode: 'insensitive' } },
        ],
      }),
    };

    const [jobs, total] = await Promise.all([
      prisma.job.findMany({
        where,
        skip,
        take: Number(limit),
        orderBy: [
          { isSponsored: 'desc' },
          { createdAt: 'desc' },
        ],
      }),
      prisma.job.count({ where }),
    ]);

    return res.status(200).json({
      success: true,
      data: {
        jobs,
        pagination: {
          page: Number(page),
          limit: Number(limit),
          total,
          totalPages: Math.ceil(total / Number(limit)),
        },
      },
    });
  } catch (error) {
    console.error('Get jobs error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la récupération des offres',
    });
  }
};

// ─── Get Job by ID ────────────────────────────────────────────

const getJobById = async (req, res) => {
  try {
    const { id } = req.params;

    const job = await prisma.job.findUnique({
      where: { id },
      include: {
        author: {
          select: { id: true, firstName: true, lastName: true, photoUrl: true },
        },
        _count: {
          select: { applications: true },
        },
      },
    });

    if (!job) {
      return res.status(404).json({
        success: false,
        message: 'Offre introuvable',
      });
    }

    return res.status(200).json({
      success: true,
      data: { job },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Create Job ───────────────────────────────────────────────

const createJob = async (req, res) => {
  try {
    const {
      title,
      description,
      companyName,
      companyLogo,
      location,
      salary,
      type,
      category,
      isSponsored,
      expiresAt,
    } = req.body;

    if (!title || !description || !companyName || !location || !category) {
      return res.status(400).json({
        success: false,
        message: 'Champs requis manquants',
      });
    }

    const job = await prisma.job.create({
      data: {
        title,
        description,
        companyName,
        companyLogo,
        location,
        salary,
        type: type || 'CDI',
        category,
        isSponsored: isSponsored || false,
        authorId: req.user.id,
        expiresAt: expiresAt ? new Date(expiresAt) : null,
      },
    });

    return res.status(201).json({
      success: true,
      message: 'Offre créée avec succès',
      data: { job },
    });
  } catch (error) {
    console.error('Create job error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la création de l\'offre',
    });
  }
};

// ─── Update Job ───────────────────────────────────────────────

const updateJob = async (req, res) => {
  try {
    const { id } = req.params;

    const existing = await prisma.job.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Offre introuvable',
      });
    }

    if (existing.authorId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé',
      });
    }

    const job = await prisma.job.update({
      where: { id },
      data: req.body,
    });

    return res.status(200).json({
      success: true,
      message: 'Offre mise à jour',
      data: { job },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la mise à jour',
    });
  }
};

// ─── Delete Job ───────────────────────────────────────────────

const deleteJob = async (req, res) => {
  try {
    const { id } = req.params;

    const existing = await prisma.job.findUnique({ where: { id } });
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: 'Offre introuvable',
      });
    }

    if (existing.authorId !== req.user.id && req.user.role !== 'ADMIN') {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé',
      });
    }

    await prisma.job.delete({ where: { id } });

    return res.status(200).json({
      success: true,
      message: 'Offre supprimée',
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la suppression',
    });
  }
};

// ─── My Jobs (jobs posted by current user) ────────────────────

const getMyJobs = async (req, res) => {
  try {
    const jobs = await prisma.job.findMany({
      where: { authorId: req.user.id },
      orderBy: { createdAt: 'desc' },
      include: {
        _count: { select: { applications: true } },
      },
    });

    return res.status(200).json({
      success: true,
      data: { jobs },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Apply to Job ─────────────────────────────────────────────

const applyToJob = async (req, res) => {
  try {
    const { id: jobId } = req.params;
    const { coverLetter, cvUrl } = req.body;

    const job = await prisma.job.findUnique({ where: { id: jobId } });
    if (!job) {
      return res.status(404).json({
        success: false,
        message: 'Offre introuvable',
      });
    }

    const existing = await prisma.application.findUnique({
      where: {
        jobId_applicantId: {
          jobId,
          applicantId: req.user.id,
        },
      },
    });

    if (existing) {
      return res.status(400).json({
        success: false,
        message: 'Vous avez déjà postulé à cette offre',
      });
    }

    const application = await prisma.application.create({
      data: {
        jobId,
        applicantId: req.user.id,
        coverLetter,
        cvUrl,
      },
    });

    await prisma.job.update({
      where: { id: jobId },
      data: { applicationsCount: { increment: 1 } },
    });

    // Notify the job author
    await createNotification({
      userId: job.authorId,
      title: 'Nouvelle candidature',
      body: `${req.user.firstName} ${req.user.lastName} a postulé pour "${job.title}"`,
      type: 'NEW_APPLICATION',
      data: { jobId, applicationId: application.id },
    });

    return res.status(201).json({
      success: true,
      message: 'Candidature envoyée avec succès',
      data: { application },
    });
  } catch (error) {
    console.error('Apply error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de l\'envoi de la candidature',
    });
  }
};

// ─── Get My Applications ──────────────────────────────────────

const getMyApplications = async (req, res) => {
  try {
    const applications = await prisma.application.findMany({
      where: { applicantId: req.user.id },
      include: { job: true },
      orderBy: { createdAt: 'desc' },
    });

    return res.status(200).json({
      success: true,
      data: { applications },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Get Received Applications (for company's jobs) ───────────

const getReceivedApplications = async (req, res) => {
  try {
    const applications = await prisma.application.findMany({
      where: {
        job: { authorId: req.user.id },
      },
      include: {
        job: { select: { id: true, title: true, companyName: true } },
        applicant: {
          select: { id: true, firstName: true, lastName: true, photoUrl: true, email: true, phone: true },
        },
      },
      orderBy: { createdAt: 'desc' },
    });

    return res.status(200).json({
      success: true,
      data: { applications },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Update Application Status ─────────────────────────────────

const updateApplicationStatus = async (req, res) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['PENDING', 'REVIEWED', 'ACCEPTED', 'REJECTED'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({
        success: false,
        message: 'Statut invalide',
      });
    }

    const application = await prisma.application.findUnique({
      where: { id },
      include: { job: true },
    });

    if (!application) {
      return res.status(404).json({
        success: false,
        message: 'Candidature introuvable',
      });
    }

    if (application.job.authorId !== req.user.id) {
      return res.status(403).json({
        success: false,
        message: 'Non autorisé',
      });
    }

    const updated = await prisma.application.update({
      where: { id },
      data: { status },
    });

    // Notify the applicant
    const statusLabels = {
      REVIEWED: 'consultée',
      ACCEPTED: 'acceptée',
      REJECTED: 'refusée',
      PENDING: 'en attente',
    };
    await createNotification({
      userId: application.applicantId,
      title: 'Candidature mise à jour',
      body: `Votre candidature pour "${application.job.title}" a été ${statusLabels[status] || status}`,
      type: 'APPLICATION_STATUS',
      data: { applicationId: id, jobId: application.jobId, status },
    });

    return res.status(200).json({
      success: true,
      message: 'Statut mis à jour',
      data: { application: updated },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

module.exports = {
  getJobs,
  getJobById,
  createJob,
  updateJob,
  deleteJob,
  getMyJobs,
  applyToJob,
  getMyApplications,
  getReceivedApplications,
  updateApplicationStatus,
};