require('dotenv').config();
const http = require('http');
const app = require('./src/app');
const { initSocket } = require('./src/sockets/socket');
const { PrismaClient } = require('@prisma/client');
 
const prisma = new PrismaClient();
const PORT = process.env.PORT || 3000;
 
const httpServer = http.createServer(app);
initSocket(httpServer);
 
const startServer = async () => {
  try {
    await prisma.$connect();
    console.log('✅ Base de données connectée');
 
    httpServer.listen(PORT, () => {
      console.log(`🚀 Serveur démarré sur http://localhost:${PORT}`);
      console.log(`📡 API disponible sur http://localhost:${PORT}/api`);
      console.log(`💬 Socket.io activé`);
      console.log(`🌍 Environnement: ${process.env.NODE_ENV}`);
    });
  } catch (error) {
    console.error('❌ Erreur de démarrage:', error);
    process.exit(1);
  }
};
 
startServer();
 
process.on('SIGINT', async () => {
  await prisma.$disconnect();
  console.log('👋 Serveur arrêté');
  process.exit(0);
});