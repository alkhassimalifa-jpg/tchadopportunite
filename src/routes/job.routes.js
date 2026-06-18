const express = require('express');
const router = express.Router();
const {
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
} = require('../controllers/job.controller');
const { authenticate, authorize } = require('../middlewares/auth.middleware');

// Specific routes FIRST (before /:id)
router.get('/me/posted', authenticate, getMyJobs);
router.get('/me/applications', authenticate, getMyApplications);
router.get('/me/received-applications', authenticate, getReceivedApplications);
router.patch('/applications/:id/status', authenticate, updateApplicationStatus);

// Public routes
router.get('/', getJobs);
router.get('/:id', getJobById);

// Protected routes
router.post('/', authenticate, authorize('COMPANY', 'CLIENT', 'PROVIDER', 'ADMIN'), createJob);
router.put('/:id', authenticate, updateJob);
router.delete('/:id', authenticate, deleteJob);
router.post('/:id/apply', authenticate, applyToJob);

module.exports = router;