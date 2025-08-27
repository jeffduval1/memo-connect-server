const express = require('express');
const router = express.Router();
const cardsController = require('../controllers/cards.controller');


router.get('/', cardsController.getAll);
router.get('/:id', cardsController.getOne);
router.post('/', cardsController.create);
router.put('/:id', cardsController.update);
router.delete('/:id', cardsController.delete);

module.exports = router;
