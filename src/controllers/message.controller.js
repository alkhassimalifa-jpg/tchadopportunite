const { PrismaClient } = require('@prisma/client');
 
const prisma = new PrismaClient();
 
// ─── Get conversations list ───────────────────────────────────
 
const getConversations = async (req, res) => {
  try {
    const userId = req.user.id;
 
    // Get all messages involving the user
    const messages = await prisma.message.findMany({
      where: {
        OR: [{ senderId: userId }, { receiverId: userId }],
      },
      orderBy: { createdAt: 'desc' },
      include: {
        sender: {
          select: { id: true, firstName: true, lastName: true, photoUrl: true },
        },
        receiver: {
          select: { id: true, firstName: true, lastName: true, photoUrl: true },
        },
      },
    });
 
    // Group by conversation partner
    const conversationsMap = new Map();
 
    for (const msg of messages) {
      const partnerId = msg.senderId === userId ? msg.receiverId : msg.senderId;
      const partner = msg.senderId === userId ? msg.receiver : msg.sender;
 
      if (!conversationsMap.has(partnerId)) {
        conversationsMap.set(partnerId, {
          partner,
          lastMessage: msg,
          unreadCount: 0,
        });
      }
 
      if (msg.receiverId === userId && !msg.isRead) {
        conversationsMap.get(partnerId).unreadCount += 1;
      }
    }
 
    const conversations = Array.from(conversationsMap.values());
 
    return res.status(200).json({
      success: true,
      data: { conversations },
    });
  } catch (error) {
    console.error('Get conversations error:', error);
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};
 
// ─── Get messages with a specific user ────────────────────────
 
const getMessages = async (req, res) => {
  try {
    const userId = req.user.id;
    const { otherUserId } = req.params;
    const { page = 1, limit = 50 } = req.query;
 
    const skip = (Number(page) - 1) * Number(limit);
 
    const messages = await prisma.message.findMany({
      where: {
        OR: [
          { senderId: userId, receiverId: otherUserId },
          { senderId: otherUserId, receiverId: userId },
        ],
      },
      orderBy: { createdAt: 'desc' },
      skip,
      take: Number(limit),
    });
 
    return res.status(200).json({
      success: true,
      data: { messages: messages.reverse() },
    });
  } catch (error) {
    return res.status(500).json({
      success: false,
      message: 'Erreur serveur',
    });
  }
};
 
module.exports = { getConversations, getMessages };
 