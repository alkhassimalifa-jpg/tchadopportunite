const { PrismaClient } = require('@prisma/client');
const { auth } = require('../config/firebase');
const { generateTokens, verifyRefreshToken } = require('../config/jwt');

const prisma = new PrismaClient();

// ─── Register ─────────────────────────────────────────────────

const register = async (req, res) => {
  try {
    const { firebaseToken, email, firstName, lastName, role, phone, preferredLanguage } = req.body;

    // Verify Firebase token
    const decodedToken = await auth.verifyIdToken(firebaseToken);
    const firebaseUid = decodedToken.uid;

    // Check if user already exists
    const existingUser = await prisma.user.findUnique({
      where: { email },
    });

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'Email déjà utilisé',
      });
    }

    // Create user
    const user = await prisma.user.create({
      data: {
        firebaseUid,
        email,
        firstName,
        lastName,
        phone,
        role: role || 'CLIENT',
        preferredLanguage: preferredLanguage || 'FR',
        profile: {
          create: {},
        },
      },
    });

    const tokens = generateTokens(user.id, user.role);

    return res.status(201).json({
      success: true,
      message: 'Compte créé avec succès',
      data: {
        user: formatUser(user),
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      },
    });
  } catch (error) {
    console.error('Register error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la création du compte',
      error: error.message,
    });
  }
};

// ─── Login ────────────────────────────────────────────────────

const login = async (req, res) => {
  try {
    const { firebaseToken } = req.body;

    // Verify Firebase token
    const decodedToken = await auth.verifyIdToken(firebaseToken);
    const firebaseUid = decodedToken.uid;

    // Find user
    const user = await prisma.user.findUnique({
      where: { firebaseUid },
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'Compte introuvable. Veuillez vous inscrire.',
      });
    }

    if (!user.isActive) {
      return res.status(403).json({
        success: false,
        message: 'Compte désactivé. Contactez le support.',
      });
    }

    const tokens = generateTokens(user.id, user.role);

    return res.status(200).json({
      success: true,
      message: 'Connexion réussie',
      data: {
        user: formatUser(user),
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      },
    });
  } catch (error) {
    console.error('Login error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur lors de la connexion',
      error: error.message,
    });
  }
};

// ─── Get Me ───────────────────────────────────────────────────

const getMe = async (req, res) => {
  try {
    const user = await prisma.user.findUnique({
      where: { id: req.user.id },
      include: { profile: true },
    });

    return res.status(200).json({
      success: true,
      data: { user: formatUser(user) },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};

// ─── Refresh Token ────────────────────────────────────────────

const refresh = async (req, res) => {
  try {
    const { refreshToken } = req.body;
    const decoded = verifyRefreshToken(refreshToken);

    const user = await prisma.user.findUnique({
      where: { id: decoded.userId },
    });

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Utilisateur introuvable',
      });
    }

    const tokens = generateTokens(user.id, user.role);

    return res.status(200).json({
      success: true,
      data: {
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      },
    });
  } catch (error) {
    return res.status(401).json({
      success: false,
      message: 'Token invalide',
    });
  }
};

// ─── Logout ───────────────────────────────────────────────────

const logout = async (req, res) => {
  return res.status(200).json({
    success: true,
    message: 'Déconnexion réussie',
  });
};

// ─── Helper ───────────────────────────────────────────────────

const formatUser = (user) => ({
  id: user.id,
  email: user.email,
  firstName: user.firstName,
  lastName: user.lastName,
  phone: user.phone,
  photoUrl: user.photoUrl,
  role: user.role,
  isVerified: user.isVerified,
  isPremium: user.isPremium,
  preferredLanguage: user.preferredLanguage,
  createdAt: user.createdAt,
});

module.exports = { register, login, getMe, refresh, logout };
