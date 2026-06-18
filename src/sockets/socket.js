const { Server } = require('socket.io');
const { verifyAccessToken } = require('../config/jwt');
const { PrismaClient } = require('@prisma/client');
const { createNotification } = require('../controllers/notification.controller');

const prisma = new PrismaClient();

// Map userId -> socketId
const onlineUsers = new Map();

const initSocket = (httpServer) => {
  const io = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
  });

  // Authentication middleware
  io.use((socket, next) => {
    try {
      const token = socket.handshake.auth?.token;
      if (!token) return next(new Error('Token manquant'));

      const decoded = verifyAccessToken(token);
      socket.userId = decoded.userId;
      next();
    } catch (error) {
      next(new Error('Token invalide'));
    }
  });

  io.on('connection', (socket) => {
    const userId = socket.userId;
    onlineUsers.set(userId, socket.id);
    console.log(`🟢 User connected: ${userId}`);

    // Broadcast online status
    socket.broadcast.emit('user_online', { userId });

    // ─── Join conversation room ──────────────────────────
    socket.on('join_conversation', (otherUserId) => {
      const room = getRoomId(userId, otherUserId);
      socket.join(room);
    });

    // ─── Send message ─────────────────────────────────────
    socket.on('send_message', async (data) => {
      try {
        const { receiverId, content } = data;

        const message = await prisma.message.create({
          data: {
            senderId: userId,
            receiverId,
            content,
          },
        });

        const room = getRoomId(userId, receiverId);

        // Emit to room (both users if joined)
        io.to(room).emit('new_message', message);

        // Also emit directly to receiver if online (in case not in room)
        const receiverSocketId = onlineUsers.get(receiverId);
        if (receiverSocketId) {
          io.to(receiverSocketId).emit('new_message', message);
        } else {
          // Receiver is offline — create a notification
          const sender = await prisma.user.findUnique({
            where: { id: userId },
            select: { firstName: true, lastName: true },
          });
          await createNotification({
            userId: receiverId,
            title: 'Nouveau message',
            body: `${sender?.firstName || ''} ${sender?.lastName || ''} vous a envoyé un message`,
            type: 'NEW_MESSAGE',
            data: { senderId: userId },
          });
        }
      } catch (error) {
        socket.emit('message_error', { error: error.message });
      }
    });

    // ─── Typing indicator ─────────────────────────────────
    socket.on('typing', ({ receiverId, isTyping }) => {
      const receiverSocketId = onlineUsers.get(receiverId);
      if (receiverSocketId) {
        io.to(receiverSocketId).emit('user_typing', {
          userId,
          isTyping,
        });
      }
    });

    // ─── Mark as read ──────────────────────────────────────
    socket.on('mark_read', async ({ senderId }) => {
      try {
        await prisma.message.updateMany({
          where: {
            senderId,
            receiverId: userId,
            isRead: false,
          },
          data: { isRead: true },
        });

        const senderSocketId = onlineUsers.get(senderId);
        if (senderSocketId) {
          io.to(senderSocketId).emit('messages_read', { readBy: userId });
        }
      } catch (error) {
        console.error('Mark read error:', error);
      }
    });

    // ─── Disconnect ────────────────────────────────────────
    socket.on('disconnect', () => {
      onlineUsers.delete(userId);
      socket.broadcast.emit('user_offline', { userId });
      console.log(`🔴 User disconnected: ${userId}`);
    });
  });

  return io;
};

// Helper: generate consistent room ID for two users
const getRoomId = (userId1, userId2) => {
  return [userId1, userId2].sort().join('_');
};

module.exports = { initSocket, onlineUsers };